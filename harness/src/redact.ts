export const REDACTED = "[REDACTED]";

const SECRET_NAME = /TOKEN|KEY|SECRET/i;
const SECRET_PATTERNS: readonly RegExp[] = [
  /gh[pousr]_[A-Za-z0-9]{20,}/g,
  /github_pat_[A-Za-z0-9_]{20,}/g,
  /sk-[A-Za-z0-9_-]{16,}/g,
];
const MIN_SECRET_LENGTH = 8;

export type Redactor = (text: string) => string;

/** Values of environment variables whose names contain TOKEN, KEY, or SECRET. */
export function secretValues(env: Record<string, string | undefined>): string[] {
  const values = new Set<string>();
  for (const [name, value] of Object.entries(env)) {
    if (value && value.length >= MIN_SECRET_LENGTH && SECRET_NAME.test(name)) values.add(value);
  }
  return [...values].sort((a, b) => b.length - a.length);
}

export function createRedactor(env: Record<string, string | undefined>, extra: readonly string[] = []): Redactor {
  const values = [...secretValues(env), ...extra.filter((v) => v.length >= MIN_SECRET_LENGTH)];
  return (text: string): string => {
    let out = text;
    for (const value of values) out = out.split(value).join(REDACTED);
    for (const pattern of SECRET_PATTERNS) out = out.replace(pattern, REDACTED);
    return out;
  };
}

/** Caps text to a number of lines and characters per line, marking what was cut. */
export function cap(text: string, maxLines: number, maxChars: number): string {
  const lines = text.split("\n");
  const kept = lines.slice(-maxLines).map((line) => (line.length > maxChars ? line.slice(0, maxChars - 1) + "…" : line));
  if (lines.length > maxLines) kept.unshift(`… ${lines.length - maxLines} earlier lines cut`);
  return kept.join("\n");
}
