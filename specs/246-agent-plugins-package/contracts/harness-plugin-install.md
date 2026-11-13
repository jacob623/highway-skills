# Contract: the harness plugin install

## Run start (`project.ts` `buildPlugin`)

1. It runs `bash framework/generate-agent-plugin.sh --check` from the repository root. On a
   non-zero exit, it returns `{ ok: false, tail }`, where `tail` holds the DRIFT lines and the
   rebuild instruction. The runner reports `build-failed` and exits 2 (FR-014), and no scenario
   runs.
2. It creates `<workRoot>/base` as an empty folder. Each test project is that base plus its
   fixture, so it holds no `.github/skills/` (FR-013).
3. It returns `{ ok: true, dir: <base>, plugin: { dir: <repo>/highway-agent-plugin, skills: <n> } }`,
   where `n` is the number of `skills/*/SKILL.md` files in the plugin.

## Per attempt (`driver.ts`)

1. The client starts with `baseDirectory: <attempt home>`, `useLoggedInUser: false`, and the token.
2. It calls `client.rpc.plugins.install({ source: plugin.dir, workingDirectory: projectDir })`.
3. If the plugin is not enabled, it calls `client.rpc.plugins.enable({ names: [plugin name] })`.
4. It logs one `system` entry: `installed plugin highway (<k> skills)`, plus the deprecation
   warning when one is present.
5. The attempt ends with outcome `error` and kind `plugin-install`, with no session started, when
   any of these happens:
   - the install throws;
   - `k` is not `n`;
   - `warnings` is not empty;
   - the plugin is still disabled.
6. Otherwise it creates the session as before.

## Permission policy

`permissionPolicy(request, projectDir, web, readRoots)`. The driver passes
`readRoots = [<attempt home>/installed-plugins]`.

- A `read` is approved when it is inside the project or inside a read root.
- A `write` is approved only inside the project. A write in a read root is an `outside-write`,
  which is fatal.
- Paths are compared after `realpath`, so `/var` and `/private/var` agree.

## Failure kind

`plugin-install` is added to `FAILURE_KINDS`. It is not in `EXIT_2_KINDS`, so the run continues and
the scenario fails. Its likely cause reads: "The plugin did not install or load from
highway-agent-plugin/. The attempt's transcript names what the install reported."

## Unchanged

The following are unchanged:

- scenario files and fixtures;
- the fixture check, which still rejects any agent skill folder in a fixture;
- the judge and its own temporary home;
- the reports;
- the model configuration (`gpt-5.6-luna`).
