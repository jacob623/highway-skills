import { existsSync, readFileSync } from "node:fs";
import { dirname, isAbsolute, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import type { Options } from "./args.ts";

export const HARNESS_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..");
export const REPO_ROOT = resolve(HARNESS_DIR, "..");

export interface FileConfig {
  model: string;
  parallel: number;
  maxTurns: number;
  timeoutMinutes: number;
  transcripts: string;
}

export interface Config {
  model: string;
  judgeModel: string;
  judge: boolean;
  parallel: number;
  maxTurns: number;
  timeoutMs: number;
  transcripts: string;
  token?: string;
  env: Record<string, string | undefined>;
}

export function readFileConfig(file = join(HARNESS_DIR, "harness.config.json")): FileConfig {
  const raw = JSON.parse(readFileSync(file, "utf8")) as Partial<FileConfig>;
  if (typeof raw.model !== "string" || raw.model === "") throw new Error(`${file}: "model" must name a model id`);
  return {
    model: raw.model,
    parallel: raw.parallel ?? 4,
    maxTurns: raw.maxTurns ?? 40,
    timeoutMinutes: raw.timeoutMinutes ?? 20,
    transcripts: raw.transcripts ?? "harness/runs",
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

export function resolveToken(env: Record<string, string | undefined>): string | undefined {
  return env.COPILOT_GITHUB_TOKEN || env.GITHUB_TOKEN || undefined;
}

export function resolveConfig(options: Options, file: FileConfig, env: Record<string, string | undefined>): Config {
  const model = options.model ?? file.model;
  const transcripts = options.transcripts ?? file.transcripts;
  return {
    model,
    judgeModel: options.judgeModel ?? model,
    judge: !options.noJudge,
    parallel: options.parallel ?? file.parallel,
    maxTurns: options.maxTurns ?? file.maxTurns,
    timeoutMs: (options.timeout ?? file.timeoutMinutes) * 60_000,
    transcripts: isAbsolute(transcripts) ? transcripts : resolve(REPO_ROOT, transcripts),
    token: resolveToken(env),
    env,
  };
}
