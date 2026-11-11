import { EXAMPLES, GROUP_ORDER, SWITCHES, type Switch } from "./switches.ts";

export interface Options {
  smoke: boolean;
  changedSince?: string;
  paths: string[];
  skills: string[];
  model?: string;
  judgeModel?: string;
  noJudge: boolean;
  parallel?: number;
  maxTurns?: number;
  timeout?: number;
  transcripts?: string;
  promote?: string;
  help: boolean;
}

export type ParseResult = { ok: true; options: Options } | { ok: false; error: string };

export const USAGE_POINTER = "Run with --help for usage.";

const TARGETED = ["--changed-since", "--paths", "--skills"] as const;

function find(token: string): Switch | undefined {
  return SWITCHES.find((s) => s.name === token || s.alias === token);
}

export function parseArgs(argv: readonly string[]): ParseResult {
  const options: Options = { smoke: false, paths: [], skills: [], noJudge: false, help: false };
  const seen: string[] = [];

  for (let i = 0; i < argv.length; i++) {
    const token = argv[i];
    const eq = token.startsWith("--") ? token.indexOf("=") : -1;
    const name = eq > 0 ? token.slice(0, eq) : token;
    const sw = find(name);
    if (!sw) return { ok: false, error: `Unknown switch: ${token}` };
    if (sw.value === "none" && eq > 0) return { ok: false, error: `${sw.name} takes no value` };

    let value: string | undefined;
    if (sw.value !== "none") {
      value = eq > 0 ? token.slice(eq + 1) : argv[++i];
      if (value === undefined || value === "" || (eq < 0 && value.startsWith("--"))) {
        return { ok: false, error: `${sw.name} needs ${sw.arg}` };
      }
    }
    if (!seen.includes(sw.name)) seen.push(sw.name);

    switch (sw.name) {
      case "--smoke":
        options.smoke = true;
        break;
      case "--no-judge":
        options.noJudge = true;
        break;
      case "--help":
        options.help = true;
        break;
      case "--changed-since":
        options.changedSince = value;
        break;
      case "--paths":
        options.paths.push(...splitList(value!));
        break;
      case "--skills":
        options.skills.push(...splitList(value!));
        break;
      case "--model":
        options.model = value;
        break;
      case "--judge-model":
        options.judgeModel = value;
        break;
      case "--transcripts":
        options.transcripts = value;
        break;
      case "--promote":
        options.promote = value;
        break;
      case "--parallel":
      case "--max-turns":
      case "--timeout": {
        const n = Number(value);
        if (!/^\d+$/.test(value!) || n < 1) return { ok: false, error: `${sw.name} needs a positive whole number, got ${value}` };
        if (sw.name === "--parallel") options.parallel = n;
        else if (sw.name === "--max-turns") options.maxTurns = n;
        else options.timeout = n;
        break;
      }
    }
  }

  if (options.help) return { ok: true, options };

  const targeted = TARGETED.filter((t) => seen.includes(t));
  for (const alone of ["--smoke", "--promote"]) {
    if (!seen.includes(alone)) continue;
    const others = [...targeted, ...(alone === "--smoke" && seen.includes("--promote") ? ["--promote"] : [])];
    if (others.length > 0) {
      return { ok: false, error: `${alone} cannot be used with ${others.join(", ")}. Use ${alone} alone.` };
    }
  }
  return { ok: true, options };
}

function splitList(value: string): string[] {
  return value
    .split(",")
    .map((v) => v.trim())
    .filter((v) => v !== "");
}

export function helpText(): string {
  const lines = ["Usage: node harness/src/cli.ts [switches]", "", "With no selection switch, the full suite runs: the chain, then every scenario.", ""];
  const label = (s: Switch): string => [s.name, s.alias].filter(Boolean).join(", ") + (s.arg ? ` ${s.arg}` : "");
  const width = Math.max(...SWITCHES.map((s) => label(s).length));
  for (const group of GROUP_ORDER) {
    const members = SWITCHES.filter((s) => s.group === group);
    if (members.length === 0) continue;
    lines.push(`${group}:`);
    for (const s of members) {
      const def = s.def === "-" ? "" : ` (default: ${s.def})`;
      lines.push(`  ${label(s).padEnd(width)}  ${s.usage}${def}`);
    }
    lines.push("");
  }
  lines.push("Examples:");
  for (const example of EXAMPLES) lines.push(`  ${example}`);
  lines.push("");
  lines.push("Exit codes: 0 every gated check passed or nothing was selected; 1 a gated check failed;");
  lines.push("2 the run could not start, a switch was invalid, or a rate limit or allowance stopped it.");
  return lines.join("\n");
}
