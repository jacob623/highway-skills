import { createHash } from "node:crypto";
import { spawnSync } from "node:child_process";
import { readdirSync, readFileSync } from "node:fs";
import { join, relative, sep } from "node:path";
import { HARNESS_DIR } from "./config.ts";
import { globToRegExp, matchesAny, type Expectation } from "./scenario.ts";

export type Snapshot = Map<string, string>;

export interface SnapshotDiff {
  created: string[];
  changed: string[];
  deleted: string[];
}

export interface CheckFailure {
  check: string;
  path: string;
  expected: string;
  actual: string;
  line?: number;
}

/** Every file under root, keyed by slash-separated relative path, valued by SHA-256. */
export function snapshot(root: string): Snapshot {
  const out: Snapshot = new Map();
  const walk = (dir: string): void => {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const full = join(dir, entry.name);
      if (entry.isDirectory()) walk(full);
      else if (entry.isFile() || entry.isSymbolicLink()) {
        const rel = relative(root, full).split(sep).join("/");
        out.set(rel, createHash("sha256").update(readFileSync(full)).digest("hex"));
      }
    }
  };
  walk(root);
  return out;
}

export function diffSnapshots(before: Snapshot, after: Snapshot): SnapshotDiff {
  const created: string[] = [];
  const changed: string[] = [];
  const deleted: string[] = [];
  for (const [path, hash] of after) {
    const old = before.get(path);
    if (old === undefined) created.push(path);
    else if (old !== hash) changed.push(path);
  }
  for (const path of before.keys()) if (!after.has(path)) deleted.push(path);
  return { created: created.sort(), changed: changed.sort(), deleted: deleted.sort() };
}

export function changedPaths(diff: SnapshotDiff): string[] {
  return [...diff.created, ...diff.changed, ...diff.deleted].sort();
}

/** FR-029: every created, changed, or deleted file must match a `writes:` glob. */
export function storageInvariant(diff: SnapshotDiff, writes: readonly string[]): CheckFailure[] {
  const outside = changedPaths(diff).filter((path) => !matchesAny(path, writes));
  if (outside.length === 0) return [];
  return [
    {
      check: "storage",
      path: writes.length > 0 ? writes.join(", ") : "(no writes: patterns)",
      expected: "only files matching writes: change",
      actual: outside.join(", "),
    },
  ];
}

export function writesNothing(diff: SnapshotDiff): CheckFailure[] {
  const all = changedPaths(diff);
  return all.length === 0 ? [] : [{ check: "writes-nothing", path: "-", expected: "no file changes", actual: all.join(", ") }];
}

export const EXPERIENCE_SKILL = "highway-experience";

/** FR-010: highway-experience must be activated before the first output the person sees. */
export function experienceInvariant(skillsBeforeOutput: readonly string[]): CheckFailure[] {
  if (skillsBeforeOutput.includes(EXPERIENCE_SKILL)) return [];
  return [
    {
      check: "experience",
      path: EXPERIENCE_SKILL,
      expected: `${EXPERIENCE_SKILL} activated before the first output`,
      actual: skillsBeforeOutput.length > 0 ? skillsBeforeOutput.join(", ") : "no skill",
    },
  ];
}

function matchingFiles(files: Iterable<string>, glob: string): string[] {
  const re = globToRegExp(glob);
  return [...files].filter((f) => re.test(f)).sort();
}

function fieldPresent(content: string, name: string, value: string): boolean {
  const n = name.trim().toLowerCase();
  const v = value.trim().toLowerCase();
  return content.split(/\r?\n/).some((raw) => {
    const line = raw.trim().replace(/^-\s+/, "");
    const m = /^(?:\*\*([^*]+?):?\*\*:?|([^:*][^:]*?):)\s*(.*)$/.exec(line);
    if (!m) return false;
    const key = (m[1] ?? m[2] ?? "").replace(/:$/, "").trim().toLowerCase();
    return key === n && m[3].trim().replace(/^`|`$/g, "").toLowerCase() === v;
  });
}

function hasLine(content: string, line: string): boolean {
  return content.split(/\r?\n/).some((l) => l.trimEnd() === line.trimEnd());
}

function rowPresent(content: string, text: string): boolean {
  return content.split(/\r?\n/).some((l) => l.trim().startsWith("|") && l.includes(text));
}

export function runTemplateCheck(template: string, file: string): string[] {
  const result = spawnSync("bash", [join(HARNESS_DIR, "bin", "template-check.sh"), template, file], { encoding: "utf8" });
  if (result.status === 0) return [];
  const lines = (result.stdout + result.stderr).trim().split("\n").filter(Boolean);
  return lines.length > 0 ? lines : [`template-check exited ${result.status}`];
}

/** Runs one `expect:` assertion against the finished project. */
export function runExpectation(projectDir: string, files: Iterable<string>, exp: Expectation): CheckFailure | undefined {
  const matches = matchingFiles(files, exp.path);
  const fail = (expected: string, actual: string): CheckFailure => ({
    check: exp.assertion,
    path: exp.path,
    expected,
    actual,
    line: exp.line,
  });

  if (exp.assertion === "absent") return matches.length === 0 ? undefined : fail("no file", matches.join(", "));
  if (matches.length === 0) return fail("a file matching the path", "no file");
  if (exp.assertion === "exists") return undefined;

  const arg = exp.argument ?? "";
  for (const rel of matches) {
    const full = join(projectDir, rel);
    if (exp.assertion === "template") {
      const missing = runTemplateCheck(arg, full);
      if (missing.length > 0) return fail(`the structure of ${arg}`, `${rel}: ${missing.join("; ")}`);
      continue;
    }
    const content = readFileSync(full, "utf8");
    if (exp.assertion === "heading" && !hasLine(content, arg)) return fail(`line "${arg}"`, `${rel} has no such line`);
    if (exp.assertion === "contains" && !content.includes(arg)) return fail(`text "${arg}"`, `${rel} does not contain it`);
    if (exp.assertion === "row" && !rowPresent(content, arg)) return fail(`a table row with "${arg}"`, `${rel} has none`);
    if (exp.assertion === "field") {
      const eq = arg.indexOf("=");
      const name = eq >= 0 ? arg.slice(0, eq) : arg;
      const value = eq >= 0 ? arg.slice(eq + 1) : "";
      if (!fieldPresent(content, name, value)) return fail(`field ${name}: ${value}`, `${rel} has no such field value`);
    }
  }
  return undefined;
}
