import { existsSync, readFileSync } from "node:fs";
import { dirname, isAbsolute, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import type { Agent, Registry } from "./agents.ts";
import type { Options } from "./args.ts";

export const HARNESS_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..");
export const REPO_ROOT = resolve(HARNESS_DIR, "..");

export interface FileConfig {
  agent?: string;
  models: Record<string, string>;
  judge?: { agent?: string; model?: string };
  parallel: number;
  maxTurns: number;
  timeoutMinutes: number;
}

export interface Config {
  agent: string;
  model: string;
  key?: string;
  keyName?: string;
  judgeAgent: string;
  judgeModel: string;
  /** False with --no-judge: no verdicts. The reply fallback still runs when the judge key is present. */
  judge: boolean;
  judgeKey?: string;
  parallel: number;
  maxTurns: number;
  timeoutMs: number;
  /** Set only by --transcripts: the folder that receives the run folder. */
  transcripts?: string;
  verbose: boolean;
  env: Record<string, string | undefined>;
}

const CONFIG_NAME = "harness.config.json";

export function readFileConfig(file = join(HARNESS_DIR, CONFIG_NAME)): FileConfig {
  const raw = JSON.parse(readFileSync(file, "utf8")) as Record<string, unknown>;
  if ("model" in raw) throw new Error(`${CONFIG_NAME}: "model" is replaced by "models", a map from agent id to model id`);
  if ("transcripts" in raw) throw new Error(`${CONFIG_NAME}: "transcripts" is removed; pass --transcripts <dir> to write a run folder`);
  const models = raw.models ?? {};
  if (typeof models !== "object" || models === null || Array.isArray(models) || Object.values(models).some((m) => typeof m !== "string" || m === "")) {
    throw new Error(`${CONFIG_NAME}: "models" must map each agent id to a model id`);
  }
  if (raw.agent !== undefined && typeof raw.agent !== "string") throw new Error(`${CONFIG_NAME}: "agent" must name an agent`);
  const judge = raw.judge;
  if (judge !== undefined && (typeof judge !== "object" || judge === null || Array.isArray(judge))) {
    throw new Error(`${CONFIG_NAME}: "judge" must hold "agent" and "model"`);
  }
  return {
    agent: raw.agent as string | undefined,
    models: models as Record<string, string>,
    judge: judge as FileConfig["judge"],
    parallel: (raw.parallel as number | undefined) ?? 4,
    maxTurns: (raw.maxTurns as number | undefined) ?? 40,
    timeoutMinutes: (raw.timeoutMinutes as number | undefined) ?? 20,
  };
}

/** Parses KEY=VALUE lines; `#` comments, `export ` prefixes, and surrounding quotes are allowed. */
export function parseDotEnv(text: string): Record<string, string> {
  const out: Record<string, string> = {};
  for (const raw of text.split(/\r?\n/)) {
    const line = raw.trim();
    if (line === "" || line.startsWith("#")) continue;
    const match = /^(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$/.exec(line);
    if (!match) continue;
    let value = match[2].trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    out[match[1]] = value;
  }
  return out;
}

export function loadEnv(envFile = join(HARNESS_DIR, ".env"), processEnv: NodeJS.ProcessEnv = process.env): Record<string, string | undefined> {
  const fromFile = existsSync(envFile) ? parseDotEnv(readFileSync(envFile, "utf8")) : {};
  return { ...fromFile, ...processEnv };
}

/** The first of the agent's key variables with a value, and that value. */
export function keyOf(agent: Pick<Agent, "keys">, env: Record<string, string | undefined>): { name: string; value: string } | undefined {
  for (const name of agent.keys) {
    const value = env[name];
    if (value) return { name, value };
  }
  return undefined;
}

/** Merges switches over the file and checks every setting before any scenario starts (R6). */
export function resolveConfig(options: Options, file: FileConfig, env: Record<string, string | undefined>, agents: Registry): Config {
  const registered = [...agents.keys()].join(", ");
  const agentId = options.agent ?? file.agent;
  if (!agentId) throw new Error(`${CONFIG_NAME}: "agent" must name the agent under test`);
  const agent = agents.get(agentId);
  if (!agent) throw new Error(`unknown agent "${agentId}"; registered agents: ${registered}`);
  const model = options.model ?? file.models[agentId];
  if (!model) throw new Error(`no model for agent "${agentId}": add models.${agentId} to ${CONFIG_NAME}, or pass --model`);

  if (!file.judge && (options.judgeAgent === undefined || options.judgeModel === undefined)) {
    throw new Error(`${CONFIG_NAME}: "judge" must name the judge's agent and model`);
  }
  const judgeAgentId = options.judgeAgent ?? file.judge?.agent;
  if (!judgeAgentId) throw new Error(`${CONFIG_NAME}: "judge.agent" must name the judge's agent`);
  const judgeModel = options.judgeModel ?? file.judge?.model;
  if (!judgeModel) throw new Error(`${CONFIG_NAME}: "judge.model" must name the judge's model`);
  const judgeAgent = agents.get(judgeAgentId);
  if (!judgeAgent) throw new Error(`unknown judge agent "${judgeAgentId}"; registered agents: ${registered}`);
  if (!judgeAgent.ask) throw new Error(`judge agent "${judgeAgentId}" offers no one-shot question; choose another judge agent`);

  const key = keyOf(agent, env);
  const judgeKey = keyOf(judgeAgent, env);
  if (!options.noJudge && judgeAgentId !== agentId && !judgeKey) {
    throw new Error(`no key for judge agent "${judgeAgentId}": set ${judgeAgent.keys[judgeAgent.keys.length - 1]} in harness/.env, or pass --no-judge`);
  }

  const transcripts = options.transcripts;
  return {
    agent: agentId,
    model,
    key: key?.value,
    keyName: key?.name,
    judgeAgent: judgeAgentId,
    judgeModel,
    judge: !options.noJudge,
    judgeKey: judgeKey?.value,
    parallel: options.parallel ?? file.parallel,
    maxTurns: options.maxTurns ?? file.maxTurns,
    timeoutMs: (options.timeout ?? file.timeoutMinutes) * 60_000,
    transcripts: transcripts === undefined ? undefined : isAbsolute(transcripts) ? transcripts : resolve(REPO_ROOT, transcripts),
    verbose: options.verbose,
    env,
  };
}
