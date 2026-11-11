import { readFileSync } from "node:fs";

export const REPLY_KINDS = ["accept", "edit", "question", "unknown", "decline", "select"] as const;
export type ReplyKind = (typeof REPLY_KINDS)[number];

export const ASSERTIONS = ["exists", "absent", "heading", "field", "row", "contains", "template"] as const;
export type Assertion = (typeof ASSERTIONS)[number];

export type ReplyKey = { type: "text"; text: string } | { type: "pattern"; pattern: string };

export interface Reply {
  key: ReplyKey;
  say: string;
  kind?: ReplyKind;
  line: number;
}

export interface Expectation {
  assertion: Assertion;
  path: string;
  argument?: string;
  line: number;
}

export interface Cover {
  hash: string;
  text: string;
  line: number;
}

export interface Scenario {
  file: string;
  id: string;
  skill: string;
  through: string[];
  fixture: string;
  chain?: number;
  smoke: boolean;
  web: boolean;
  open: string;
  replies: Reply[];
  writes: string[];
  expects: Expectation[];
  covers: Cover[];
  reaches: string[];
}

export class ScenarioError extends Error {
  readonly file: string;
  readonly line: number;
  constructor(file: string, line: number, message: string) {
    super(`${file}:${line}: ${message}`);
    this.file = file;
    this.line = line;
  }
}

const SINGLE_KEYS = new Set(["id", "skill", "fixture", "chain", "smoke", "web", "open"]);
const LIST_KEYS = new Set(["through", "ask", "ask-pattern", "say", "writes", "expect", "covers", "reaches"]);

export function parseScenario(text: string, file: string): Scenario {
  const single = new Map<string, { value: string; line: number }>();
  const through: string[] = [];
  const replies: Reply[] = [];
  const writes: string[] = [];
  const expects: Expectation[] = [];
  const covers: Cover[] = [];
  const reaches: string[] = [];
  let pendingKey: { key: ReplyKey; line: number } | undefined;

  const lines = text.split(/\r?\n/);
  lines.forEach((raw, index) => {
    const line = index + 1;
    if (/^\s*$/.test(raw) || /^\s*#/.test(raw)) return;
    const match = /^([a-z][a-z-]*):(.*)$/.exec(raw);
    if (!match) throw new ScenarioError(file, line, `not a "key: value" line: ${raw}`);
    const key = match[1];
    const value = match[2].trim();

    if (SINGLE_KEYS.has(key)) {
      if (single.has(key)) throw new ScenarioError(file, line, `"${key}" appears more than once`);
      single.set(key, { value, line });
      return;
    }
    if (!LIST_KEYS.has(key)) throw new ScenarioError(file, line, `unknown key "${key}"`);

    switch (key) {
      case "through":
        through.push(value);
        break;
      case "ask":
      case "ask-pattern":
        if (pendingKey) throw new ScenarioError(file, line, `"${key}" follows a key with no "say"`);
        if (key === "ask-pattern") {
          try {
            new RegExp(value, "i");
          } catch {
            throw new ScenarioError(file, line, `"ask-pattern" is not a valid pattern: ${value}`);
          }
          pendingKey = { key: { type: "pattern", pattern: value }, line };
        } else {
          pendingKey = { key: { type: "text", text: value }, line };
        }
        break;
      case "say": {
        if (!pendingKey) throw new ScenarioError(file, line, `"say" has no "ask" or "ask-pattern" before it`);
        const kindMatch = /^\[([a-z]+)\]\s*(.*)$/.exec(value);
        let kind: ReplyKind | undefined;
        let say = value;
        if (kindMatch) {
          if (!(REPLY_KINDS as readonly string[]).includes(kindMatch[1])) {
            throw new ScenarioError(file, line, `unknown reply kind "[${kindMatch[1]}]"`);
          }
          kind = kindMatch[1] as ReplyKind;
          say = kindMatch[2];
        }
        replies.push({ key: pendingKey.key, say, kind, line: pendingKey.line });
        pendingKey = undefined;
        break;
      }
      case "writes":
        writes.push(value);
        break;
      case "expect":
        expects.push(parseExpectation(value, file, line));
        break;
      case "covers": {
        const coverMatch = /^([0-9a-f]{12})\s+(.+)$/.exec(value);
        if (!coverMatch) throw new ScenarioError(file, line, `"covers" needs a 12-hex hash and the bullet text`);
        covers.push({ hash: coverMatch[1], text: coverMatch[2], line });
        break;
      }
      case "reaches":
        reaches.push(value);
        break;
    }
  });

  if (pendingKey) throw new ScenarioError(file, pendingKey.line, `key has no "say" after it`);

  const required = (key: string): string => {
    const entry = single.get(key);
    if (!entry || entry.value === "") throw new ScenarioError(file, 1, `missing "${key}"`);
    return entry.value;
  };
  const flag = (key: string): boolean => {
    const entry = single.get(key);
    if (!entry) return false;
    if (entry.value !== "yes" && entry.value !== "no") {
      throw new ScenarioError(file, entry.line, `"${key}" must be yes or no`);
    }
    return entry.value === "yes";
  };

  let chain: number | undefined;
  const chainEntry = single.get("chain");
  if (chainEntry) {
    chain = Number(chainEntry.value);
    if (!Number.isInteger(chain) || chain < 1 || chain > 6) {
      throw new ScenarioError(file, chainEntry.line, `"chain" must be 1 to 6`);
    }
  }

  return {
    file,
    id: required("id"),
    skill: required("skill"),
    through,
    fixture: required("fixture"),
    chain,
    smoke: flag("smoke"),
    web: flag("web"),
    open: required("open"),
    replies,
    writes,
    expects,
    covers,
    reaches,
  };
}

function parseExpectation(value: string, file: string, line: number): Expectation {
  const [head, ...rest] = value.split(" :: ");
  const argument = rest.length > 0 ? rest.join(" :: ").trim() : undefined;
  const parts = head.trim().split(/\s+/);
  if (parts.length !== 2) throw new ScenarioError(file, line, `"expect" needs "<assertion> <path>[ :: <argument>]"`);
  const [assertion, path] = parts;
  if (!(ASSERTIONS as readonly string[]).includes(assertion)) {
    throw new ScenarioError(file, line, `unknown assertion "${assertion}"`);
  }
  const needsArgument = !["exists", "absent"].includes(assertion);
  if (needsArgument && !argument) throw new ScenarioError(file, line, `"${assertion}" needs an argument after " :: "`);
  if (!needsArgument && argument) throw new ScenarioError(file, line, `"${assertion}" takes no argument`);
  return { assertion: assertion as Assertion, path, argument, line };
}

export function readScenario(file: string): Scenario {
  return parseScenario(readFileSync(file, "utf8"), file);
}

/** An anchored regex for a `writes:` or `expect` glob: `**` crosses folders, `*` and `?` stay in one. */
export function globToRegExp(glob: string): RegExp {
  let out = "^";
  for (let i = 0; i < glob.length; ) {
    const c = glob[i];
    if (c === "*" && glob[i + 1] === "*") {
      if (glob[i + 2] === "/") {
        out += "(?:.*/)?";
        i += 3;
      } else {
        out += ".*";
        i += 2;
      }
      continue;
    }
    if (c === "*") out += "[^/]*";
    else if (c === "?") out += "[^/]";
    else if (".+()[]{}|^$\\".includes(c)) out += "\\" + c;
    else out += c;
    i++;
  }
  return new RegExp(out + "$");
}

export function matchesAny(path: string, globs: readonly string[]): boolean {
  return globs.some((glob) => globToRegExp(glob).test(path));
}
