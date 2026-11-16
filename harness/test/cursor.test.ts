import { test } from "node:test";
import assert from "node:assert/strict";
import { mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { RateLimitError, AuthenticationError, CursorAgentError } from "@cursor/sdk";
import {
  classifyCursorError,
  createCursorDriver,
  cursorAsk,
  cursorPluginRpc,
  cursorVersions,
  installCursorPluginForTest,
  toolCallToAccessRequest,
  withCursorHome,
  writeCursorHooks,
} from "../src/drivers/cursor.ts";
import type { PluginSource } from "../src/project.ts";
import type { Scenario } from "../src/scenario.ts";

test("toolCallToAccessRequest maps shell, read, write, url, and other", () => {
  assert.deepEqual(toolCallToAccessRequest("shell", { command: "rm -rf /" }), { kind: "shell", command: "rm -rf /" });
  assert.deepEqual(toolCallToAccessRequest("read", { path: "/p/a.md" }), { kind: "read", path: "/p/a.md" });
  assert.deepEqual(toolCallToAccessRequest("edit", { path: "/p/a.md" }), { kind: "write", path: "/p/a.md" });
  assert.deepEqual(toolCallToAccessRequest("webFetch", { url: "https://example.com" }), { kind: "url", url: "https://example.com" });
  assert.equal(toolCallToAccessRequest("semSearch", {}).kind, "other");
});

test("classifyCursorError maps rate-limit, no-access, allowance, and retryable", () => {
  assert.equal(classifyCursorError(new RateLimitError("slow down")), "rate-limit");
  assert.equal(classifyCursorError(new AuthenticationError("Invalid API key")), "no-access");
  assert.equal(classifyCursorError(new CursorAgentError("busy", { isRetryable: true })), "rate-limit");
  assert.equal(classifyCursorError(new Error("premium request quota exceeded")), "allowance");
  assert.equal(classifyCursorError(new Error("mystery")), "unclassified");
});

test("cursorVersions reports the installed SDK and local runtime", () => {
  const v = cursorVersions();
  assert.match(v.sdk, /^\d+\.\d+\.\d+$/);
  assert.equal(v.runtime, "local");
});

test("PluginRpc install copies the plugin and shared checks cover success, short, warning, disabled", async () => {
  const home = mkdtempSync(join(tmpdir(), "cursor-install-"));
  const src = mkdtempSync(join(tmpdir(), "cursor-plugin-"));
  try {
    mkdirSync(join(src, "skills", "a"), { recursive: true });
    mkdirSync(join(src, "skills", "b"), { recursive: true });
    mkdirSync(join(src, ".cursor-plugin"), { recursive: true });
    writeFileSync(join(src, ".cursor-plugin", "plugin.json"), JSON.stringify({ name: "highway" }));
    const plugin: PluginSource = { dir: src, name: "highway", skills: 2 };
    const ok = await installCursorPluginForTest(home, plugin, "/work/project");
    assert.equal(ok.ok, true);
    if (ok.ok) assert.match(ok.summary, /installed plugin highway \(2 skills\)/);

    const shortHome = mkdtempSync(join(tmpdir(), "cursor-short-"));
    const short = await installCursorPluginForTest(shortHome, { ...plugin, skills: 16 }, "/p");
    assert.equal(short.ok, false);
    if (!short.ok) assert.match(short.message, /2 of 16 skills/);
    rmSync(shortHome, { recursive: true, force: true });

    const rpc = cursorPluginRpc(home);
    const listed = await rpc.list();
    assert.ok(listed.plugins.some((p) => p.name === "highway" && p.enabled));
  } finally {
    rmSync(home, { recursive: true, force: true });
    rmSync(src, { recursive: true, force: true });
  }
});

test("writeCursorHooks writes hooks.json under the agent home", () => {
  const home = mkdtempSync(join(tmpdir(), "cursor-hooks-"));
  try {
    writeCursorHooks(home, "/work/project", [join(home, ".cursor", "plugins", "local", "highway")]);
    const hooks = JSON.parse(readFileSync(join(home, ".cursor", "hooks.json"), "utf8")) as { hooks: Record<string, unknown> };
    assert.ok(hooks.hooks.beforeShellExecution);
    assert.ok(hooks.hooks.preToolUse);
  } finally {
    rmSync(home, { recursive: true, force: true });
  }
});

test("withCursorHome restores HOME after the callback", async () => {
  const prev = process.env.HOME;
  const home = mkdtempSync(join(tmpdir(), "cursor-home-"));
  try {
    await withCursorHome(home, async () => {
      assert.equal(process.env.HOME, home);
    });
    assert.equal(process.env.HOME, prev);
  } finally {
    rmSync(home, { recursive: true, force: true });
  }
});

test("cursorAsk uses tools: [] and a throwaway home via the fake API", async () => {
  const seen: unknown[] = [];
  const ask = cursorAsk("key", "composer-2", {
    create: async () => {
      throw new Error("create should not run for prompt ask");
    },
    prompt: async (message, options) => {
      seen.push({ message, options });
      return { id: "r1", status: "finished", result: "ok" };
    },
  });
  const text = await ask("hello");
  assert.equal(text, "ok");
  const opts = (seen[0] as { options: { tools: unknown[]; local: { cwd: string; settingSources: string[] } } }).options;
  assert.deepEqual(opts.tools, []);
  assert.deepEqual(opts.local.settingSources, []);
  assert.ok(opts.local.cwd.includes("harness-cursor-judge-"));
});

test("createCursorDriver maps a one-turn fake SDK run through the reply loop", async () => {
  const scenario: Scenario = {
    file: "fake.md",
    id: "fake-cursor",
    skill: "help",
    through: [],
    fixture: "empty",
    smoke: true,
    web: false,
    open: "hi",
    replies: [],
    writes: [],
    expects: [],
    covers: [],
    reaches: [],
    shows: [],
  };
  const home = mkdtempSync(join(tmpdir(), "cursor-drive-"));
  const project = mkdtempSync(join(tmpdir(), "cursor-proj-"));
  const src = mkdtempSync(join(tmpdir(), "cursor-plug-"));
  mkdirSync(join(src, "skills", "s1"), { recursive: true });
  mkdirSync(join(src, ".cursor-plugin"), { recursive: true });
  writeFileSync(join(src, ".cursor-plugin", "plugin.json"), JSON.stringify({ name: "highway" }));
  const logs: string[] = [];
  try {
    const driver = createCursorDriver({
      create: async (options) => {
        assert.equal((options as { local: { settingSources: string[] } }).local.settingSources[0], "plugins");
        assert.ok(Array.isArray((options as { tools: string[] }).tools));
        assert.ok(!(options as { tools: string[] }).tools.includes("shell"));
        return {
          agentId: "agent-1",
          async send(message: string) {
            assert.equal(message, "hi");
            return {
              id: "run-1",
              agentId: "agent-1",
              status: "running",
              async *stream() {
                yield { type: "assistant", message: { role: "assistant", content: [{ type: "text", text: "done" }] } };
                yield {
                  type: "tool_call",
                  name: "shell",
                  status: "running",
                  args: { command: "echo hi" },
                };
              },
              wait: async () => ({ id: "run-1", status: "finished" as const }),
              supports: () => true,
              unsupportedReason: () => undefined,
              conversation: async () => [],
              cancel: async () => undefined,
              onDidChangeStatus: () => () => undefined,
            };
          },
          [Symbol.asyncDispose]: async () => undefined,
        } as never;
      },
      prompt: async () => ({ id: "x", status: "finished" as const }),
    });
    const outcome = await driver({
      scenario,
      projectDir: project,
      agentHome: home,
      readRoots: [join(home, ".cursor", "plugins", "local", "highway")],
      plugin: { dir: src, name: "highway", skills: 1 },
      key: "cursor_test_key_abcdefghijklmnopqrstuvwxyz",
      model: "composer-2",
      maxTurns: 5,
      timeoutMs: 30_000,
      pickFallback: async () => undefined,
      raw: () => undefined,
      log: (e) => logs.push(`${e.role}:${e.text}`),
    });
    assert.equal(outcome.outcome, "ended");
    assert.ok(logs.some((l) => l.startsWith("system:installed plugin highway")));
    assert.ok(logs.some((l) => l.includes("rejected shell")));
  } finally {
    rmSync(home, { recursive: true, force: true });
    rmSync(project, { recursive: true, force: true });
    rmSync(src, { recursive: true, force: true });
  }
});

test("effects-based failure when a forbidden shell tool_call completes", async () => {
  const scenario: Scenario = {
    file: "fake.md",
    id: "fake-effects",
    skill: "help",
    through: [],
    fixture: "empty",
    smoke: true,
    web: false,
    open: "hi",
    replies: [],
    writes: [],
    expects: [],
    covers: [],
    reaches: [],
    shows: [],
  };
  const home = mkdtempSync(join(tmpdir(), "cursor-fx-"));
  const project = mkdtempSync(join(tmpdir(), "cursor-fxp-"));
  const src = mkdtempSync(join(tmpdir(), "cursor-fxpl-"));
  mkdirSync(join(src, "skills", "s1"), { recursive: true });
  mkdirSync(join(src, ".cursor-plugin"), { recursive: true });
  writeFileSync(join(src, ".cursor-plugin", "plugin.json"), JSON.stringify({ name: "highway" }));
  try {
    const driver = createCursorDriver({
      create: async () =>
        ({
          agentId: "a",
          async send() {
            return {
              id: "r",
              agentId: "a",
              status: "running",
              async *stream() {
                yield { type: "tool_call", name: "shell", status: "completed", args: { command: "id" } };
                yield { type: "assistant", message: { role: "assistant", content: [{ type: "text", text: "oops" }] } };
              },
              wait: async () => ({ id: "r", status: "finished" as const }),
              supports: () => true,
              unsupportedReason: () => undefined,
              conversation: async () => [],
              cancel: async () => undefined,
              onDidChangeStatus: () => () => undefined,
            };
          },
          [Symbol.asyncDispose]: async () => undefined,
        }) as never,
      prompt: async () => ({ id: "x", status: "finished" as const }),
    });
    const outcome = await driver({
      scenario,
      projectDir: project,
      agentHome: home,
      readRoots: [join(home, ".cursor", "plugins", "local", "highway")],
      plugin: { dir: src, name: "highway", skills: 1 },
      key: "k",
      model: "composer-2",
      maxTurns: 3,
      timeoutMs: 30_000,
      pickFallback: async () => undefined,
      raw: () => undefined,
      log: () => undefined,
    });
    assert.equal(outcome.outcome, "error");
    assert.match(outcome.error?.message ?? "", /storage invariant/);
  } finally {
    rmSync(home, { recursive: true, force: true });
    rmSync(project, { recursive: true, force: true });
    rmSync(src, { recursive: true, force: true });
  }
});
