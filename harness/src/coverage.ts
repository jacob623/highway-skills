import { spawnSync } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { HARNESS_DIR } from "./config.ts";
import { REPLY_KINDS, type Scenario } from "./scenario.ts";

export const GATED_SKILLS: readonly string[] = ["highway-codify"];
export const TREATMENTS_FILE = join(HARNESS_DIR, "coverage", "treatments.txt");

export interface InventoryItem {
  skill: string;
  kind: "step" | "verification" | "error";
  id: string;
  text: string;
}

export interface Treatment {
  skill: string;
  hash: string;
  type: "invariant" | "waiver";
  detail: string;
  text: string;
}

export function readInventory(): InventoryItem[] {
  const result = spawnSync("bash", [join(HARNESS_DIR, "bin", "inventory.sh")], { encoding: "utf8" });
  if (result.status !== 0) throw new Error(`inventory.sh failed: ${result.stderr}`);
  return result.stdout
    .split("\n")
    .filter(Boolean)
    .map((line) => {
      const [skill, kind, id, text] = line.split("\t");
      return { skill, kind: kind as InventoryItem["kind"], id, text };
    });
}

export function parseTreatments(text: string): Treatment[] {
  const out: Treatment[] = [];
  for (const line of text.split(/\r?\n/)) {
    if (line.trim() === "" || line.startsWith("#")) continue;
    const sep = line.indexOf(" :: ");
    if (sep < 0) continue;
    const [type, skill, hash, ...detail] = line.slice(0, sep).trim().split(/\s+/);
    if (type !== "invariant:" && type !== "waiver:") continue;
    out.push({ skill, hash, type: type === "invariant:" ? "invariant" : "waiver", detail: detail.join(" "), text: line.slice(sep + 4) });
  }
  return out;
}

export function readTreatments(file = TREATMENTS_FILE): Treatment[] {
  return existsSync(file) ? parseTreatments(readFileSync(file, "utf8")) : [];
}

function cell(text: string): string {
  return text.replace(/\|/g, "\\|");
}

/** FR-018: per skill, each bullet's treatment, reply kinds exercised, and steps reached. */
export function coverageSection(inventory: readonly InventoryItem[], scenarios: readonly Scenario[], treatments: readonly Treatment[]): string {
  const lines = ["## Coverage", ""];
  const skills = [...new Set(inventory.map((i) => i.skill))];
  for (const skill of skills) {
    const mine = scenarios.filter((s) => s.skill === skill || s.through.includes(skill));
    const tags = new Map<string, string[]>();
    for (const s of mine) for (const c of s.covers) tags.set(c.hash, [...(tags.get(c.hash) ?? []), s.id]);
    const bullets = inventory.filter((i) => i.skill === skill && i.kind !== "step");
    const known = new Set(bullets.map((b) => b.id));
    const rows: string[] = [];
    let covered = 0;
    const uncovered: InventoryItem[] = [];
    for (const b of bullets) {
      const t = treatments.find((x) => x.skill === skill && x.hash === b.id);
      let treatment: string;
      if (tags.has(b.id)) treatment = `scenario: ${tags.get(b.id)!.join(", ")}`;
      else if (t) treatment = `${t.type}: ${t.detail}`;
      else treatment = "UNCOVERED";
      if (treatment === "UNCOVERED") uncovered.push(b);
      else covered++;
      rows.push(`| ${b.id} | ${b.kind} | ${cell(treatment)} | ${cell(b.text)} |`);
    }
    const gated = GATED_SKILLS.includes(skill);
    lines.push(`### ${skill}${gated ? " (gated)" : ""}`, "", `${covered} of ${bullets.length} bullets treated.`, "");

    const kinds = new Set(mine.flatMap((s) => s.replies.map((r) => r.kind).filter(Boolean)));
    const missingKinds = REPLY_KINDS.filter((k) => !kinds.has(k));
    lines.push(`Reply kinds exercised: ${[...kinds].join(", ") || "none"}${missingKinds.length ? `; not exercised: ${missingKinds.join(", ")}` : ""}.`);
    const steps = inventory.filter((i) => i.skill === skill && i.kind === "step").map((i) => i.id);
    const reached = new Set(mine.flatMap((s) => s.reaches));
    const notReached = steps.filter((s) => !reached.has(s));
    lines.push(`Steps reached: ${steps.filter((s) => reached.has(s)).join(", ") || "none"}.`);
    lines.push(`Steps not reached: ${notReached.join(", ") || "none"}.`, "");

    const unknown = [
      ...mine.flatMap((s) => s.covers.filter((c) => !known.has(c.hash)).map((c) => ({ hash: c.hash, text: c.text, where: s.id }))),
      ...treatments.filter((t) => t.skill === skill && !known.has(t.hash)).map((t) => ({ hash: t.hash, text: t.text, where: "treatments.txt" })),
    ];
    if (uncovered.length > 0 && unknown.length > 0) {
      lines.push("Reworded or removed bullets (new text beside old tags):", "", "| New bullet | Old tag |", "|---|---|");
      const n = Math.max(uncovered.length, unknown.length);
      for (let i = 0; i < n; i++) {
        const a = uncovered[i] ? `${uncovered[i].id} ${uncovered[i].text}` : "";
        const b = unknown[i] ? `${unknown[i].hash} ${unknown[i].text} (${unknown[i].where})` : "";
        lines.push(`| ${cell(a)} | ${cell(b)} |`);
      }
      lines.push("");
    }
    lines.push("| Hash | Kind | Treatment | Bullet |", "|---|---|---|---|", ...rows, "");
  }
  return lines.join("\n");
}
