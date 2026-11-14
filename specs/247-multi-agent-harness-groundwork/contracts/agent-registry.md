# Contract: Agent registry and drivers

## What a new driver supplies

A driver spec adds `harness/src/drivers/<id>.ts` and one entry in `AGENTS` in
`harness/src/agents.ts`. Nothing else in `harness/src/` changes.

The driver file exports:

1. A `Driver`: `(options: DriveOptions) => Promise<DriveResult>`. It:
   - starts the agent with `options.agentHome` as its configuration home and `options.projectDir`
     as its working folder;
   - installs the plugin through a `PluginRpc` adapter and the shared `installPlugin`. A failure
     returns outcome `error` with kind `plugin-install`;
   - maps each native permission request to an `AccessRequest`, decides it with `permissionPolicy`
     (passing `options.readRoots`), records rejections, and maps the decision back;
   - logs transcript entries (`user`, `agent` once at the end of each turn, `question`, `answer`,
     `permission` with the decision summary, `skill` as `invoked <name>`, and `system`);
   - wraps calls in `withRateLimit` and `retryServiceError` with its own classifier;
   - throws `RunStop("no-access")` when the service refuses the key.
2. A classifier: `(error) => FailureKind`.
3. Optionally, a one-shot ask factory `(key, model) => Ask`, which runs in its own throwaway home
   with no tools, no plugin, and no project.
4. A version reader: `() => { sdk, runtime }`.

The registry entry adds `id`, `service`, `keys`, and `readRoots(home)`.

## Runner obligations

The runner:

- imports no driver;
- takes the driver, keys, classifier, read roots, versions, and ask from the selected entry;
- creates and removes the agent home for each attempt;
- passes `readRoots(agentHome)`;
- snapshots the project after each `agent` entry, for `files:`.

## Copilot entry

| Field | Value |
|---|---|
| `id` | `copilot` |
| `service` | `Copilot` |
| `keys` | `COPILOT_GITHUB_TOKEN`, `GITHUB_TOKEN` |
| `readRoots(home)` | `[<home>/installed-plugins]` |
| `versions()` | SDK package version and the bundled CLI version |
| `ask` | `copilotAsk` |
| `classify` | `classifyCopilotError` (-32603 service error, 429 rate limit, premium-request allowance, 401/403 no access) |
