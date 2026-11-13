import { test } from "node:test";
import assert from "node:assert/strict";
import { mkdirSync, mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { PermissionRequest } from "@github/copilot-sdk";
import { installPlugin, permissionPolicy, skillName, type PluginRpc } from "../src/driver.ts";
import type { PluginSource } from "../src/project.ts";

const PLUGIN: PluginSource = { dir: "/repo/highway-agent-plugin", name: "highway", skills: 16 };

const read = (path: string): PermissionRequest => ({ kind: "read", path }) as unknown as PermissionRequest;
const write = (fileName: string): PermissionRequest => ({ kind: "write", fileName }) as unknown as PermissionRequest;

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
