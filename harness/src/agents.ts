import { join } from "node:path";
import type { Classifier, Driver } from "./driver.ts";
import { classifyCodexError, codexAsk, codexDriver, codexVersions, pluginDirUnderHome } from "./drivers/codex.ts";
import { classifyCopilotError, copilotAsk, copilotDriver, copilotVersions } from "./drivers/copilot.ts";
import { classifyCursorError, cursorAsk, cursorDriver, cursorVersions } from "./drivers/cursor.ts";
import type { Ask } from "./judge.ts";

/** Everything the runner needs from one agent; a driver spec adds one entry (FR-006). */
export interface Agent {
  id: string;
  /** The service name used in messages. */
  service: string;
  /** Key variables, read in order; the last is the one a person sets. */
  keys: readonly string[];
  driver: Driver;
  /** A one-shot question with no tools, in its own throwaway home; a judge agent needs one. */
  ask?: (key: string, model: string) => Ask;
  classify: Classifier;
  /** The folders under an agent home where the installed plugin sits. */
  readRoots: (home: string) => string[];
  versions: () => { sdk: string; runtime: string };
}

export type Registry = ReadonlyMap<string, Agent>;

export const AGENTS: Registry = new Map<string, Agent>([
  [
    "copilot",
    {
      id: "copilot",
      service: "Copilot",
      keys: ["COPILOT_GITHUB_TOKEN", "GITHUB_TOKEN"],
      driver: copilotDriver,
      ask: copilotAsk,
      classify: classifyCopilotError,
      readRoots: (home) => [join(home, "installed-plugins")],
      versions: copilotVersions,
    },
  ],
  [
    "cursor",
    {
      id: "cursor",
      service: "Cursor",
      keys: ["CURSOR_API_KEY"],
      driver: cursorDriver,
      ask: cursorAsk,
      classify: classifyCursorError,
      readRoots: (home) => [join(home, ".cursor", "plugins", "local", "highway")],
      versions: cursorVersions,
    },
  ],
  [
    "codex",
    {
      id: "codex",
      service: "Codex",
      keys: ["OPENAI_API_KEY", "CODEX_API_KEY"],
      driver: codexDriver,
      ask: codexAsk,
      classify: classifyCodexError,
      readRoots: (home) => [pluginDirUnderHome(home)],
      versions: codexVersions,
    },
  ],
]);

export { keyOf } from "./config.ts";

export function agentIds(registry: Registry): string {
  return [...registry.keys()].join(", ");
}
