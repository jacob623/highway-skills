import { test } from "node:test";
import assert from "node:assert/strict";
import { mkdirSync, mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { PermissionRequest, PermissionRequestResult } from "@github/copilot-sdk";
import { installPlugin, permissionPolicy as decide, type AccessDecision, type PluginRpc } from "../src/driver.ts";
import { skillName, toAccessRequest, toPermissionResult } from "../src/drivers/copilot.ts";
import type { PluginSource } from "../src/project.ts";

const PLUGIN: PluginSource = { dir: "/repo/highway-agent-plugin", name: "highway", skills: 16 };

const native = (fields: Record<string, unknown>): PermissionRequest => fields as unknown as PermissionRequest;
const read = (path: string): PermissionRequest => native({ kind: "read", path });
const write = (fileName: string): PermissionRequest => native({ kind: "write", fileName });

/** A Copilot request through the neutral policy and back, as the driver decides it. */
function permissionPolicy(request: PermissionRequest, projectDir: string, web: boolean, readRoots: readonly string[] = []): AccessDecision & { result: PermissionRequestResult } {
  const decision = decide(toAccessRequest(request), projectDir, web, readRoots);
  return { ...decision, result: toPermissionResult(decision) };
}

test("every Copilot request kind gets the same decision, rejection, summary, and feedback as before the neutral request", () => {
  const work = mkdtempSync(join(tmpdir(), "harness-driver-"));
  try {
    const project = join(work, "project");
    mkdirSync(project, { recursive: true });
    const inside = join(project, "a.md");
    const outside = join(work, "elsewhere.md");
    const shellFeedback = "Shell commands are not available in this session. Highway skills read and write files only.";
    const cases: [PermissionRequest, boolean, PermissionRequestResult, string, { kind: string; detail: string; fatal: boolean } | undefined][] = [
      [native({ kind: "read", path: inside }), false, { kind: "approve-once" }, `approved read: ${inside}`, undefined],
      [native({ kind: "read", path: "x", resolvedPath: inside }), false, { kind: "approve-once" }, `approved read: ${inside}`, undefined],
      [native({ kind: "read", path: outside }), false, { kind: "reject", feedback: "Reads outside the project are not available in this session." }, `rejected read: ${outside}`, { kind: "read", detail: outside, fatal: false }],
      [native({ kind: "write", fileName: inside }), false, { kind: "approve-once" }, `approved write: ${inside}`, undefined],
      [native({ kind: "write", fileName: outside }), false, { kind: "reject", feedback: "Writes outside the project are not available in this session." }, `rejected outside-write: ${outside}`, { kind: "outside-write", detail: outside, fatal: true }],
      [native({ kind: "shell", fullCommandText: "ls -la" }), false, { kind: "reject", feedback: shellFeedback }, "rejected shell: ls -la", { kind: "shell", detail: "ls -la", fatal: true }],
      [native({ kind: "shell", intention: "list files" }), false, { kind: "reject", feedback: shellFeedback }, "rejected shell: list files", { kind: "shell", detail: "list files", fatal: true }],
      [native({ kind: "memory", fact: "likes tea" }), false, { kind: "reject", feedback: "Memory is not available in this session." }, "rejected memory: likes tea", { kind: "memory", detail: "likes tea", fatal: true }],
      [native({ kind: "url", url: "https://example.com" }), false, { kind: "reject", feedback: "Web access is not available in this session." }, "rejected url: https://example.com", { kind: "url", detail: "https://example.com", fatal: false }],
      [native({ kind: "url", url: "https://example.com" }), true, { kind: "approve-once" }, "approved url: https://example.com", undefined],
      [native({ kind: "mcp", toolName: "deploy" }), false, { kind: "reject", feedback: "This tool is not available in this session." }, "rejected mcp: deploy", { kind: "mcp", detail: "deploy", fatal: false }],
      [native({ kind: "custom-tool", intention: "publish" }), false, { kind: "reject", feedback: "This tool is not available in this session." }, "rejected custom-tool: publish", { kind: "custom-tool", detail: "publish", fatal: false }],
      [native({ kind: "hook" }), false, { kind: "reject", feedback: "This tool is not available in this session." }, "rejected hook: hook", { kind: "hook", detail: "hook", fatal: false }],
    ];
    for (const [request, web, result, summary, rejection] of cases) {
      const decision = permissionPolicy(request, project, web);
      assert.deepEqual(decision.result, result, summary);
      assert.equal(decision.summary, summary);
      assert.deepEqual(decision.rejection, rejection, summary);
    }
  } finally {
    rmSync(work, { recursive: true, force: true });
  }
});

test("a request of kind other is rejected, named by its native kind", () => {
  const decision = decide({ kind: "other", tool: "computer", detail: "click" }, "/p", true);
  assert.equal(decision.approved, false);
  assert.deepEqual(decision.rejection, { kind: "computer", detail: "click", fatal: false });
  assert.equal(decision.feedback, "This tool is not available in this session.");
});

test("reads are approved in the project and in a read root; writes only in the project", () => {
  const work = mkdtempSync(join(tmpdir(), "harness-driver-"));
  try {
    const project = join(work, "project");
    const installed = join(work, "home", "installed-plugins");
    const skill = join(installed, "_direct", "highway-x", "skills", "highway-help", "SKILL.md");
    mkdirSync(project, { recursive: true });
    mkdirSync(join(installed, "_direct"), { recursive: true });

    assert.equal(permissionPolicy(read(join(project, "a.md")), project, false, [installed]).result.kind, "approve-once");
    assert.equal(permissionPolicy(read(skill), project, false, [installed]).result.kind, "approve-once");

    const noRoot = permissionPolicy(read(skill), project, false);
    assert.equal(noRoot.result.kind, "reject");
    assert.deepEqual(noRoot.rejection, { kind: "read", detail: skill, fatal: false });

    const outside = permissionPolicy(read(join(work, "home", "config.json")), project, false, [installed]);
    assert.deepEqual(outside.result, {
      kind: "reject",
      feedback: "Reads are available inside the project and the installed plugin only. Check that the path was copied exactly.",
    });

    const pluginWrite = permissionPolicy(write(skill), project, false, [installed]);
    assert.equal(pluginWrite.result.kind, "reject");
    assert.deepEqual(pluginWrite.rejection, { kind: "outside-write", detail: skill, fatal: true });
  } finally {
    rmSync(work, { recursive: true, force: true });
  }
});

interface FakeState {
  installs: { source: string; workingDirectory?: string }[];
  enables: string[][];
}

function fakeRpc(
  result: Awaited<ReturnType<PluginRpc["install"]>> | Error,
  listed: { name: string; enabled: boolean }[] = [],
): { rpc: PluginRpc; state: FakeState } {
  const state: FakeState = { installs: [], enables: [] };
  const rpc: PluginRpc = {
    install: async (params) => {
      state.installs.push(params);
      if (result instanceof Error) throw result;
      return result;
    },
    enable: async ({ names }) => {
      state.enables.push(names);
    },
    list: async () => ({ plugins: listed }),
  };
  return { rpc, state };
}

test("a complete install from the build's folder succeeds and notes the deprecation warning", async () => {
  const { rpc, state } = fakeRpc({ plugin: { name: "highway", enabled: true }, skillsInstalled: 16, deprecationWarning: "Direct installs are deprecated." });
  const outcome = await installPlugin(rpc, PLUGIN, "/work/project");
  assert.deepEqual(outcome, { ok: true, summary: "installed plugin highway (16 skills)", notes: ["Direct installs are deprecated."] });
  assert.deepEqual(state.installs, [{ source: PLUGIN.dir, workingDirectory: "/work/project" }]);
  assert.deepEqual(state.enables, []);
});

test("a disabled install is enabled, and fails when it stays disabled", async () => {
  const enabled = fakeRpc({ plugin: { name: "highway", enabled: false }, skillsInstalled: 16 }, [{ name: "highway", enabled: true }]);
  assert.equal((await installPlugin(enabled.rpc, PLUGIN, "/p")).ok, true);
  assert.deepEqual(enabled.state.enables, [["highway"]]);

  const stuck = fakeRpc({ plugin: { name: "highway", enabled: false }, skillsInstalled: 16 }, [{ name: "highway", enabled: false }]);
  const outcome = await installPlugin(stuck.rpc, PLUGIN, "/p");
  assert.equal(outcome.ok, false);
  if (!outcome.ok) assert.match(outcome.message, /still disabled/);
});

test("a throw, a short skill count, or a manifest warning fails the install, naming each", async () => {
  const thrown = await installPlugin(fakeRpc(new Error("manifest not found")).rpc, PLUGIN, "/p");
  assert.deepEqual(thrown, { ok: false, message: "plugin highway: the install failed: manifest not found" });

  const short = await installPlugin(
    fakeRpc({ plugin: { name: "highway", enabled: true }, skillsInstalled: 15, warnings: ["unknown field homepageUrl ignored"] }).rpc,
    PLUGIN,
    "/p",
  );
  assert.deepEqual(short, { ok: false, message: "plugin highway: 15 of 16 skills installed; warning: unknown field homepageUrl ignored" });
});

test("a plugin skill reported as <plugin>:<skill> is named by its skill", () => {
  assert.equal(skillName({ name: "highway:highway-experience", pluginName: "highway" }), "highway-experience");
  assert.equal(skillName({ name: "highway-experience", pluginName: "highway" }), "highway-experience");
  assert.equal(skillName({ name: "other:highway-help" }), "other:highway-help");
});
