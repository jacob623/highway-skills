import { test } from "node:test";
import assert from "node:assert/strict";
import { existsSync, mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import {
  answerAskUserQuestion,
  classifyClaudeError,
  CLAUDE_BASH_DENY_MESSAGE,
  CLAUDE_LOCAL_GUIDANCE,
  claudeAsk,
  claudePluginRpc,
  claudeVersions,
  createClaudeDriver,
  installClaudePluginForTest,
  normalizeClaudePluginPath,
  prepareClaudeAgentHome,
  skillIdFromClaudeTool,
  toolToAccessRequest,
  type ClaudeApi,
  type ClaudeStreamMessage,
} from "../src/drivers/claude.ts";
import { EXPERIENCE_SKILL } from "../src/checks.ts";
import { permissionPolicy } from "../src/driver.ts";
import type { PluginSource } from "../src/project.ts";
import type { Scenario } from "../src/scenario.ts";

test("toolToAccessRequest maps Claude tools to neutral requests", () => {
  assert.deepEqual(toolToAccessRequest("Read", { file_path: "/p/a.md" }), { kind: "read", path: "/p/a.md" });
  assert.deepEqual(toolToAccessRequest("Write", { file_path: "/p/b.md" }), { kind: "write", path: "/p/b.md" });
  assert.deepEqual(toolToAccessRequest("Edit", { file_path: "/p/c.md" }), { kind: "write", path: "/p/c.md" });
  assert.deepEqual(toolToAccessRequest("Glob", { pattern: "**/*.md" }), { kind: "read", path: "." });
  assert.deepEqual(toolToAccessRequest("Grep", { path: "/p" }), { kind: "read", path: "/p" });
  assert.deepEqual(toolToAccessRequest("Bash", { command: "ls" }), { kind: "shell", command: "ls" });
  assert.deepEqual(toolToAccessRequest("WebFetch", { url: "https://x" }), { kind: "url", url: "https://x" });
  assert.equal(toolToAccessRequest("TodoWrite", {}).kind, "other");
});

test("permissionPolicy via mapping: project/plugin allow; Bash and outside write deny", () => {
  const project = "/work/project";
  const roots = ["/tmp/agent/plugins/highway"];
  assert.equal(permissionPolicy(toolToAccessRequest("Read", { file_path: "/work/project/a.md" }), project, false, roots).approved, true);
  assert.equal(
    permissionPolicy(toolToAccessRequest("Write", { file_path: "/work/project/out.md" }), project, false, roots).approved,
    true,
  );
  assert.equal(
    permissionPolicy(
      toolToAccessRequest("Read", { file_path: "/tmp/agent/plugins/highway/skills/highway-experience/SKILL.md" }),
      project,
      false,
      roots,
    ).approved,
    true,
  );
  assert.equal(permissionPolicy(toolToAccessRequest("Bash", { command: "npm test" }), project, false, roots).approved, false);
  assert.equal(permissionPolicy(toolToAccessRequest("Bash", { command: "npm test" }), project, false, roots).rejection?.fatal, true);
  assert.equal(
    permissionPolicy(toolToAccessRequest("Write", { file_path: "/etc/passwd" }), project, false, roots).approved,
    false,
  );
  assert.equal(permissionPolicy(toolToAccessRequest("WebFetch", { url: "https://x" }), project, false, roots).approved, false);
  assert.equal(permissionPolicy(toolToAccessRequest("WebFetch", { url: "https://x" }), project, true, roots).approved, true);
});

test("skillIdFromClaudeTool and normalizeClaudePluginPath", () => {
  assert.equal(skillIdFromClaudeTool("Skill", { skill: "highway-experience" }), "highway-experience");
  assert.equal(skillIdFromClaudeTool("Skill", { command: "/highway:highway-request" }), "highway-request");
  assert.equal(
    skillIdFromClaudeTool("Read", { file_path: "/x/plugins/highway/skills/highway-adr/SKILL.md" }),
    "highway-adr",
  );
  const readRoot = "/tmp/agent/plugins/highway";
  assert.equal(
    normalizeClaudePluginPath("/proj/plugins/highway/skills/highway-experience/SKILL.md", readRoot),
    join(readRoot, "skills/highway-experience/SKILL.md"),
  );
});

test("classifyClaudeError maps rate-limit, no-access, allowance", () => {
  assert.equal(classifyClaudeError(new Error("HTTP 429 Too Many Requests")), "rate-limit");
  assert.equal(classifyClaudeError(new Error("overloaded_error")), "rate-limit");
  assert.equal(classifyClaudeError(new Error("401 Unauthorized invalid api key")), "no-access");
  assert.equal(classifyClaudeError(new Error("billing quota exceeded")), "allowance");
  assert.equal(classifyClaudeError(new Error("mystery")), "unclassified");
});

test("claudeVersions reports the installed SDK and cli runtime", () => {
  const v = claudeVersions();
  assert.match(v.sdk, /^\d+\.\d+\.\d+$/);
  assert.equal(v.runtime, "cli");
});

test("PluginRpc install copies the plugin and shared checks cover success and short count", async () => {
  const home = mkdtempSync(join(tmpdir(), "claude-install-"));
  const src = mkdtempSync(join(tmpdir(), "claude-plugin-"));
  const project = mkdtempSync(join(tmpdir(), "claude-proj-"));
  try {
    mkdirSync(join(src, ".claude-plugin"), { recursive: true });
    writeFileSync(join(src, ".claude-plugin", "plugin.json"), JSON.stringify({ name: "highway" }));
    mkdirSync(join(src, "skills", "highway-a"), { recursive: true });
    mkdirSync(join(src, "skills", "highway-b"), { recursive: true });
    const plugin: PluginSource = { name: "highway", dir: src, skills: 2 };
    const ok = await installClaudePluginForTest(home, plugin, project);
    assert.equal(ok.ok, true);
    if (ok.ok) assert.match(ok.summary, /2 skills/);
    const short: PluginSource = { name: "highway", dir: src, skills: 16 };
    const fail = await installClaudePluginForTest(home, short, project);
    assert.equal(fail.ok, false);
    if (!fail.ok) assert.match(fail.message, /2 of 16/);
    const listed = await claudePluginRpc(home).list();
    assert.equal(listed.plugins[0]?.name, "highway");
    assert.equal(listed.plugins[0]?.enabled, true);
  } finally {
    rmSync(home, { recursive: true, force: true });
    rmSync(src, { recursive: true, force: true });
    rmSync(project, { recursive: true, force: true });
  }
});

test("prepareClaudeAgentHome writes throwaway .claude/CLAUDE.md Local-mode guidance", () => {
  const home = mkdtempSync(join(tmpdir(), "claude-guide-"));
  try {
    prepareClaudeAgentHome(home);
    const path = join(home, ".claude", "CLAUDE.md");
    assert.equal(existsSync(path), true);
    const body = readFileSync(path, "utf8");
    assert.equal(body, CLAUDE_LOCAL_GUIDANCE);
    assert.match(body, /Read/);
    assert.match(body, /Write/);
    assert.match(body, /Edit/);
    assert.match(body, /Glob/);
    assert.match(body, /Grep/);
    assert.match(body, /Bash/i);
    assert.match(body, /highway-experience/);
  } finally {
    rmSync(home, { recursive: true, force: true });
  }
});

test("drive sessions append Local-mode guidance via systemPrompt; settingSources empty; home file supporting", async () => {
  const home = mkdtempSync(join(tmpdir(), "claude-src-"));
  const project = mkdtempSync(join(tmpdir(), "claude-srcp-"));
  const src = mkdtempSync(join(tmpdir(), "claude-srcpl-"));
  try {
    mkdirSync(join(src, ".claude-plugin"), { recursive: true });
    writeFileSync(join(src, ".claude-plugin", "plugin.json"), JSON.stringify({ name: "highway" }));
    for (let i = 0; i < 16; i++) mkdirSync(join(src, "skills", `highway-s${i}`), { recursive: true });
    let seenSources: unknown;
    let seenPrompt: unknown;
    const api: ClaudeApi = {
      query: ({ options }) => {
        seenSources = options?.settingSources;
        seenPrompt = options?.systemPrompt;
        return (async function* () {
          yield {
            type: "assistant",
            session_id: "s",
            message: { content: [{ type: "text", text: "ok" }] },
          };
          yield { type: "result", subtype: "success", result: "ok", session_id: "s" };
        })();
      },
    };
    const driver = createClaudeDriver(api);
    const out = await driver({
      scenario: scenarioStub({ open: "go" }),
      projectDir: project,
      agentHome: home,
      readRoots: [join(home, "plugins", "highway")],
      plugin: { name: "highway", dir: src, skills: 16 },
      key: "k",
      model: "claude-haiku-5-5",
      maxTurns: 5,
      timeoutMs: 10_000,
      pickFallback: async () => undefined,
      raw: () => undefined,
      log: () => undefined,
    });
    assert.equal(out.outcome, "ended");
    assert.deepEqual(seenSources, []);
    assert.deepEqual(seenPrompt, { type: "preset", preset: "claude_code", append: CLAUDE_LOCAL_GUIDANCE });
    assert.match(CLAUDE_LOCAL_GUIDANCE, /Read/);
    assert.match(CLAUDE_LOCAL_GUIDANCE, /Bash/i);
    assert.equal(readFileSync(join(home, ".claude", "CLAUDE.md"), "utf8"), CLAUDE_LOCAL_GUIDANCE);

    let askSources: unknown;
    let askPrompt: unknown;
    const askApi: ClaudeApi = {
      query: ({ options }) => {
        askSources = options?.settingSources;
        askPrompt = options?.systemPrompt;
        return (async function* () {
          yield { type: "result", subtype: "success", result: "ask-ok", session_id: "a1" };
        })();
      },
    };
    assert.equal(await claudeAsk("key", "claude-haiku-5-5", askApi)("hi"), "ask-ok");
    assert.deepEqual(askSources, []);
    assert.equal(askPrompt, undefined);
  } finally {
    rmSync(home, { recursive: true, force: true });
    rmSync(project, { recursive: true, force: true });
    rmSync(src, { recursive: true, force: true });
  }
});

test("claudeAsk uses throwaway home and no plugins via the fake API", async () => {
  let seen: { cwd?: string; plugins?: unknown; tools?: unknown; settingSources?: unknown } = {};
  const api: ClaudeApi = {
    query: ({ options }) => {
      seen = {
        cwd: options?.cwd,
        plugins: options?.plugins,
        tools: options?.tools,
        settingSources: options?.settingSources,
      };
      return (async function* () {
        yield { type: "result", subtype: "success", result: "ok", session_id: "s1" } satisfies ClaudeStreamMessage;
      })();
    },
  };
  const ask = claudeAsk("key", "claude-haiku-5-5", api);
  assert.equal(await ask("hello"), "ok");
  assert.ok(seen.cwd);
  assert.deepEqual(seen.settingSources, []);
  assert.deepEqual(seen.tools, []);
  assert.equal(seen.plugins, undefined);
});

function fakeMessages(msgs: ClaudeStreamMessage[]): ClaudeApi {
  const queue = [...msgs];
  return {
    query: () => {
      const batch = queue.length ? [queue.shift()!] : [{ type: "result", subtype: "success", result: "done", session_id: "s" }];
      return (async function* () {
        for (const m of batch) yield m;
      })();
    },
  };
}

function scenarioStub(partial: Partial<Scenario>): Scenario {
  const base: Scenario = {
    file: "t.md",
    id: "t",
    skill: "highway-request",
    through: [],
    fixture: "",
    smoke: true,
    web: false,
    open: "go",
    replies: [],
    writes: ["**/*"],
    expects: [],
    covers: [],
    reaches: [],
    shows: [],
  };
  return { ...base, ...partial };
}

test("driver maps Read of experience SKILL.md into skillsBeforeOutput", async () => {
  const home = mkdtempSync(join(tmpdir(), "claude-drive-"));
  const project = mkdtempSync(join(tmpdir(), "claude-proj-"));
  const src = mkdtempSync(join(tmpdir(), "claude-plug-"));
  try {
    mkdirSync(join(src, ".claude-plugin"), { recursive: true });
    writeFileSync(join(src, ".claude-plugin", "plugin.json"), JSON.stringify({ name: "highway" }));
    for (let i = 0; i < 16; i++) mkdirSync(join(src, "skills", `highway-s${i}`), { recursive: true });
    const skillPath = join(home, "plugins", "highway", "skills", "highway-experience", "SKILL.md");
    const api: ClaudeApi = {
      query: ({ options }) => {
        return (async function* () {
          if (options?.canUseTool) {
            await options.canUseTool("Read", { file_path: skillPath }, {
              signal: new AbortController().signal,
              toolUseID: "1",
              requestId: "1",
            });
          }
          yield {
            type: "assistant",
            session_id: "sess-1",
            message: { content: [{ type: "text", text: "All set." }] },
          } satisfies ClaudeStreamMessage;
          yield { type: "result", subtype: "success", result: "All set.", session_id: "sess-1", usage: { input_tokens: 1, output_tokens: 2 } };
        })();
      },
    };
    const driver = createClaudeDriver(api);
    const out = await driver({
      scenario: scenarioStub({ open: "go" }),
      projectDir: project,
      agentHome: home,
      readRoots: [join(home, "plugins", "highway")],
      plugin: { name: "highway", dir: src, skills: 16 },
      key: "k",
      model: "claude-haiku-5-5",
      maxTurns: 5,
      timeoutMs: 10_000,
      pickFallback: async () => undefined,
      raw: () => undefined,
      log: () => undefined,
    });
    assert.equal(out.outcome, "ended");
    assert.ok(out.skillsBeforeOutput.includes(EXPERIENCE_SKILL));
  } finally {
    rmSync(home, { recursive: true, force: true });
    rmSync(project, { recursive: true, force: true });
    rmSync(src, { recursive: true, force: true });
  }
});

test("driver denies Bash through canUseTool and records rejection", async () => {
  const home = mkdtempSync(join(tmpdir(), "claude-bash-"));
  const project = mkdtempSync(join(tmpdir(), "claude-bashp-"));
  const src = mkdtempSync(join(tmpdir(), "claude-bashpl-"));
  try {
    mkdirSync(join(src, ".claude-plugin"), { recursive: true });
    writeFileSync(join(src, ".claude-plugin", "plugin.json"), JSON.stringify({ name: "highway" }));
    for (let i = 0; i < 16; i++) mkdirSync(join(src, "skills", `highway-s${i}`), { recursive: true });
    const api: ClaudeApi = {
      query: ({ options }) => {
        return (async function* () {
          const decision = await options?.canUseTool?.("Bash", { command: "npm test" }, {
            signal: new AbortController().signal,
            toolUseID: "1",
            requestId: "1",
          });
          assert.equal(decision?.behavior, "deny");
          if (decision && "message" in decision) {
            assert.match(String(decision.message), /Read/);
            assert.match(String(decision.message), /Bash/i);
            assert.equal(decision.message, CLAUDE_BASH_DENY_MESSAGE);
          }
          yield {
            type: "assistant",
            session_id: "s",
            message: { content: [{ type: "text", text: "Done without shell." }] },
          };
          yield { type: "result", subtype: "success", result: "Done without shell.", session_id: "s" };
        })();
      },
    };
    const driver = createClaudeDriver(api);
    const out = await driver({
      scenario: scenarioStub({ open: "go" }),
      projectDir: project,
      agentHome: home,
      readRoots: [join(home, "plugins", "highway")],
      plugin: { name: "highway", dir: src, skills: 16 },
      key: "k",
      model: "claude-haiku-5-5",
      maxTurns: 5,
      timeoutMs: 10_000,
      pickFallback: async () => undefined,
      raw: () => undefined,
      log: () => undefined,
    });
    assert.equal(out.outcome, "ended");
    assert.ok(out.rejected.some((r) => r.kind === "shell"));
  } finally {
    rmSync(home, { recursive: true, force: true });
    rmSync(project, { recursive: true, force: true });
    rmSync(src, { recursive: true, force: true });
  }
});

test("assistant Bash tool_use without canUseTool does not false-trigger effects backup", async () => {
  const home = mkdtempSync(join(tmpdir(), "claude-fx-"));
  const project = mkdtempSync(join(tmpdir(), "claude-fxp-"));
  const src = mkdtempSync(join(tmpdir(), "claude-fxpl-"));
  try {
    mkdirSync(join(src, ".claude-plugin"), { recursive: true });
    writeFileSync(join(src, ".claude-plugin", "plugin.json"), JSON.stringify({ name: "highway" }));
    for (let i = 0; i < 16; i++) mkdirSync(join(src, "skills", `highway-s${i}`), { recursive: true });
    const api = fakeMessages([
      {
        type: "assistant",
        session_id: "s",
        message: {
          content: [
            { type: "tool_use", name: "Bash", input: { command: "rm -rf /" } },
            { type: "text", text: "continuing" },
          ],
        },
      },
      { type: "result", subtype: "success", result: "continuing", session_id: "s" },
    ]);
    const driver = createClaudeDriver(api);
    const out = await driver({
      scenario: scenarioStub({ open: "go" }),
      projectDir: project,
      agentHome: home,
      readRoots: [join(home, "plugins", "highway")],
      plugin: { name: "highway", dir: src, skills: 16 },
      key: "k",
      model: "claude-haiku-5-5",
      maxTurns: 5,
      timeoutMs: 10_000,
      pickFallback: async () => undefined,
      raw: () => undefined,
      log: () => undefined,
    });
    // Permission decisions happen in canUseTool; a bare tool_use block is not "completed".
    assert.equal(out.outcome, "ended");
    assert.equal(out.error, undefined);
  } finally {
    rmSync(home, { recursive: true, force: true });
    rmSync(project, { recursive: true, force: true });
    rmSync(src, { recursive: true, force: true });
  }
});

test("answerAskUserQuestion fills answers from scripted replies", () => {
  const used = new Set<number>();
  const replies = [{ key: { type: "text" as const, text: "Which mode?" }, say: "Local" }];
  const filled = answerAskUserQuestion(
    {
      questions: [
        {
          question: "Which mode?",
          options: [
            { label: "Local", description: "local" },
            { label: "Remote", description: "remote" },
          ],
        },
      ],
    },
    replies,
    used,
  );
  assert.ok(filled);
  assert.equal((filled!.updatedInput.answers as Record<string, string>)["Which mode?"], "Local");
  assert.deepEqual([...used], [0]);
});

test("AskUserQuestion answered on-session; unmatched text question uses reply loop", async () => {
  const home = mkdtempSync(join(tmpdir(), "claude-q-"));
  const project = mkdtempSync(join(tmpdir(), "claude-qp-"));
  const src = mkdtempSync(join(tmpdir(), "claude-qpl-"));
  try {
    mkdirSync(join(src, ".claude-plugin"), { recursive: true });
    writeFileSync(join(src, ".claude-plugin", "plugin.json"), JSON.stringify({ name: "highway" }));
    for (let i = 0; i < 16; i++) mkdirSync(join(src, "skills", `highway-s${i}`), { recursive: true });
    let turns = 0;
    const api: ClaudeApi = {
      query: ({ prompt, options }) => {
        turns++;
        return (async function* () {
          if (turns === 1 && options?.canUseTool) {
            const decision = await options.canUseTool(
              "AskUserQuestion",
              {
                questions: [
                  {
                    question: "Which mode?",
                    options: [
                      { label: "Local", description: "l" },
                      { label: "Remote", description: "r" },
                    ],
                  },
                ],
              },
              { signal: new AbortController().signal, toolUseID: "1", requestId: "1" },
            );
            assert.equal(decision?.behavior, "allow");
            // Same turn still surfaces a text question for the reply loop.
            yield {
              type: "assistant",
              session_id: "s",
              message: { content: [{ type: "text", text: "Mode set. What is your name?" }] },
            };
            yield { type: "result", subtype: "success", result: "Mode set. What is your name?", session_id: "s" };
            return;
          }
          assert.match(prompt, /Ada/);
          yield {
            type: "assistant",
            session_id: "s",
            message: { content: [{ type: "text", text: "Thanks Ada." }] },
          };
          yield { type: "result", subtype: "success", result: "Thanks Ada.", session_id: "s" };
        })();
      },
    };
    const driver = createClaudeDriver(api);
    const out = await driver({
      scenario: scenarioStub({
        open: "start",
        replies: [
          { key: { type: "text", text: "Which mode?" }, say: "Local", line: 1 },
          { key: { type: "text", text: "What is your name?" }, say: "Ada", line: 2 },
        ],
      }),
      projectDir: project,
      agentHome: home,
      readRoots: [join(home, "plugins", "highway")],
      plugin: { name: "highway", dir: src, skills: 16 },
      key: "k",
      model: "claude-haiku-5-5",
      maxTurns: 10,
      timeoutMs: 10_000,
      pickFallback: async () => undefined,
      raw: () => undefined,
      log: () => undefined,
    });
    assert.equal(out.outcome, "ended");
    assert.ok(out.usedReplies.includes(0));
    assert.ok(out.usedReplies.includes(1));
    assert.equal(turns, 2);
  } finally {
    rmSync(home, { recursive: true, force: true });
    rmSync(project, { recursive: true, force: true });
    rmSync(src, { recursive: true, force: true });
  }
});
