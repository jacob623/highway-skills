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

/** F3: the fallback may spend only the earliest unused reply, so a later question's reply is never spent early. */
export function nextUnused(replies: readonly Reply[], used: ReadonlySet<number>): number[] {
  const index = replies.findIndex((_, i) => !used.has(i));
  return index >= 0 ? [index] : [];
}

/**
 * What to do after the agent's message: send a keyed reply, ask the fallback whether the next
 * unused reply answers it (the message asks something but no key appears), or end the conversation.
 */
export function decide(message: string, replies: readonly Reply[], used: ReadonlySet<number>): ReplyDecision {
  const index = findReply(message, replies, used);
  if (index !== undefined) return { type: "reply", index };
  if (!asksSomething(message)) return { type: "end" };
  return { type: "fallback", candidates: nextUnused(replies, used) };
}

/** F3: the reply already given to this question in the attempt, compared after normalization. */
export function spentReply(question: string, answered: ReadonlyMap<string, string>): string | undefined {
  return answered.get(normalize(question));
}

/** F17: the turn's text after the last question answered inside it; that question is not judged again. */
export function textAfterAnswers(messages: readonly string[], answeredAt: number): string {
  return messages.slice(answeredAt).join("\n\n");
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
