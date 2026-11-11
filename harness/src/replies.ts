import type { Reply } from "./scenario.ts";

/** Ignores `**` emphasis, case, and runs of whitespace. */
export function normalize(text: string): string {
  return text.replace(/\*\*/g, "").replace(/\s+/g, " ").trim().toLowerCase();
}

export function keyMatches(reply: Reply, message: string): boolean {
  if (reply.key.type === "text") return normalize(message).includes(normalize(reply.key.text));
  return new RegExp(reply.key.pattern, "im").test(message.replace(/\*\*/g, ""));
}

export function keyText(reply: Reply): string {
  return reply.key.type === "text" ? reply.key.text : `/${reply.key.pattern}/`;
}

/** Index of the first unused reply whose key appears in the message, in file order. */
export function findReply(message: string, replies: readonly Reply[], used: ReadonlySet<number>): number | undefined {
  for (let i = 0; i < replies.length; i++) {
    if (!used.has(i) && keyMatches(replies[i], message)) return i;
  }
  return undefined;
}

export function asksSomething(message: string): boolean {
  return message.includes("?");
}

export type ReplyDecision =
  | { type: "reply"; index: number }
  | { type: "fallback"; candidates: number[] }
  | { type: "end" };

/**
 * What to do after the agent's message: send a keyed reply, ask the fallback to pick among the
 * unused replies (the message asks something but no key appears), or end the conversation.
 */
export function decide(message: string, replies: readonly Reply[], used: ReadonlySet<number>): ReplyDecision {
  const index = findReply(message, replies, used);
  if (index !== undefined) return { type: "reply", index };
  if (!asksSomething(message)) return { type: "end" };
  const candidates = replies.map((_, i) => i).filter((i) => !used.has(i));
  return { type: "fallback", candidates };
}

/** The last question-like sentence of a message, for warnings and failure output. */
export function lastQuestion(message: string): string {
  const lines = message
    .split("\n")
    .map((l) => l.trim())
    .filter((l) => l.includes("?"));
  const line = lines.length > 0 ? lines[lines.length - 1] : message.trim().split("\n").pop() ?? "";
  return line.length > 200 ? line.slice(0, 199) + "…" : line;
}
