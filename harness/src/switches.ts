export type SwitchGroup = "Selection" | "Agent" | "Execution" | "Output" | "Fixtures" | "Help";
export type SwitchValue = "none" | "string" | "list" | "positive";

export interface Switch {
  name: string;
  alias?: string;
  arg?: string;
  value: SwitchValue;
  group: SwitchGroup;
  def: string;
  usage: string;
}

// One switch per line. The parser, the help text, and harness-switches.test.sh all read this list.
export const SWITCHES: readonly Switch[] = [
  { name: "--smoke", value: "none", group: "Selection", def: "off", usage: "Run one smoke scenario per skill" },
  { name: "--changed-since", arg: "<ref>", value: "string", group: "Selection", def: "-", usage: "Run scenarios affected by files changed since <ref>" },
  { name: "--paths", arg: "<files>", value: "list", group: "Selection", def: "-", usage: "Run scenarios affected by these comma-separated paths" },
  { name: "--skills", arg: "<ids>", value: "list", group: "Selection", def: "-", usage: "Run scenarios for these comma-separated skill ids" },
  { name: "--agent", arg: "<id>", value: "string", group: "Agent", def: "harness.config.json agent", usage: "Agent under test" },
  { name: "--model", arg: "<id>", value: "string", group: "Agent", def: "harness.config.json models entry", usage: "Model for the agent under test" },
  { name: "--judge-agent", arg: "<id>", value: "string", group: "Agent", def: "harness.config.json judge.agent", usage: "Agent for the judge and the reply fallback" },
  { name: "--judge-model", arg: "<id>", value: "string", group: "Agent", def: "harness.config.json judge.model", usage: "Model for the judge and the reply fallback" },
  { name: "--no-judge", value: "none", group: "Agent", def: "off", usage: "Skip the judge" },
  { name: "--parallel", arg: "<n>", value: "positive", group: "Execution", def: "4", usage: "Scenarios run at once" },
  { name: "--max-turns", arg: "<n>", value: "positive", group: "Execution", def: "40", usage: "Turn limit per attempt" },
  { name: "--timeout", arg: "<minutes>", value: "positive", group: "Execution", def: "20", usage: "Time limit per attempt, in minutes" },
  { name: "--transcripts", arg: "<dir>", value: "string", group: "Output", def: "-", usage: "Write a run folder (transcripts, reports, candidate snapshots) under <dir>" },
  { name: "--verbose", value: "none", group: "Output", def: "off", usage: "Add approved permission requests and usage to the run log" },
  { name: "--promote", arg: "<run folder>", value: "string", group: "Fixtures", def: "-", usage: "Replace stage fixtures with a run's candidate snapshots" },
  { name: "--help", alias: "-h", value: "none", group: "Help", def: "-", usage: "Print this help and exit 0" },
];

export const GROUP_ORDER: readonly SwitchGroup[] = ["Selection", "Agent", "Execution", "Output", "Fixtures", "Help"];

export const EXAMPLES: readonly string[] = [
  "node harness/src/cli.ts --smoke",
  "node harness/src/cli.ts --changed-since origin/main",
  "node harness/src/cli.ts --skills highway-codify",
  "node harness/src/cli.ts --smoke > specs/<spec>/harness/smoke.log",
  'node harness/src/cli.ts --skills highway-codify --transcripts "$TMPDIR/harness" --verbose',
];
