# Research: Behavioral Test Harness

## R1. Runtime and build

- **Decision**: Node 24 LTS runs the TypeScript sources directly through native type stripping.
  `tsc --noEmit` type-checks. Dependencies: `@github/copilot-sdk` and dev `typescript`. Tests use
  `node --test`.
- **Rationale**: No build step, no bundler, and one runtime dependency. Node 24 strips erasable
  TypeScript without a flag, so `node harness/src/cli.ts` runs as written.
- **Alternatives considered**: `tsx` or `ts-node` (another dependency); compiling to `dist/` (a
  build step and stale output); Node 22 (type stripping flagged).
- **Constraint taken on**: erasable syntax only (no enums, namespaces, or parameter properties),
  and imports name `.ts` files. `tsconfig.json` sets `erasableSyntaxOnly` and
  `allowImportingTsExtensions`.

## R2. Copilot SDK driver

- **Decision**: One `CopilotClient` per attempt with `baseDirectory` set to a temporary Copilot home
  and `gitHubToken` from the environment. One session with `model`, `workingDirectory` set to the
  test project, `enableSessionStore: false`, `enableSessionTelemetry: false`,
  `onPermissionRequest`, and `onUserInputRequest`. Turns use `sendAndWait`.
- **Rationale**: The SDK README (github/copilot-sdk, nodejs) documents each of these options. The SDK
  bundles the runtime, so no separate CLI install is needed. A temporary `baseDirectory` keeps
  personal skills, memory, and saved approvals out (FR-007).
- **Permission policy (FR-008)**: `read` and `write` are approved only for paths inside the test
  project. `shell`, `memory`, `mcp`, `custom-tool`, `hook`, and unknown kinds are rejected with
  feedback. `url` is approved only when the scenario sets `web: yes`. Every rejection is recorded.
- **Spike unknowns (User Story 1)**: whether `/highway-codify ...` invokes the skill, whether
  `.github/copilot-instructions.md` loads, and how usage is reported. The driver records the raw
  usage events it sees, and the README records the spike result.

## R3. Turn loop and reply matching

- **Decision**: After each `sendAndWait`, the driver reads the last assistant message. Replies are
  consumed in file order: the first unused reply whose `ask:` text appears in the message (or whose
  `ask-pattern:` matches) is sent. With no match, the fallback runs only when the message asks
  something (it contains `?`): the judge model, in its own session, sees only that message and the
  unused replies with their questions, and answers a reply number or `none`. `none` fails the
  scenario as an unmatched question. A message that asks nothing ends the conversation. `ask_user`
  requests go through the same matcher.
- **Rationale**: Ordered consumption lets one question (such as **What would you add, correct, or
  remove?**) get different replies at different points.
- **Normalization**: Matching ignores `**` emphasis, collapses whitespace, and ignores case.

## R4. Scenario format

- **Decision**: Plain `key: value` lines, `#` comments, repeated keys for lists, ` :: ` separating
  an assertion's path from its argument. See [contracts/scenario-format.md](contracts/scenario-format.md).
- **Rationale**: Bash reads it with `awk`, and the runner reads it with a few lines of TypeScript
  (FR-015, FR-015a).

## R5. Coverage identity

- **Decision**: A bullet is a line starting `- ` directly under `## Verification` or
  `## Error Handling`. Its id is the first 12 hex digits of SHA-256 over its text with runs of
  spaces and tabs collapsed and ends trimmed. A tag carries the hash and the text it was written
  against: `covers: <hash> <text>`. Treatments in `harness/coverage/treatments.txt` use the same
  shape.
- **Rationale**: Keeping the text on the tag gives the side-by-side report its "old text" with no
  separate ledger. `harness/bin/inventory.sh` is the only implementation, and the runner calls it.
- **Steps and reply kinds**: Steps are the `### ` headings under `## Procedure`. A scenario declares
  `reaches: <step>` and tags replies with a kind (`say: [accept] ...`). The report reads both.

## R6. Path map

- **Decision**: `harness/bin/path-map.sh <path>...` prints `<path>\t<kind>\t<target>\t<reason>`:
  - `.highway/skills/<id>/...` selects skill `<id>`. Generated agent copies
    (`<agent tree>/skills/<id>/...`) and `AGENTS.md` select nothing (spec User Story 2,
    scenario 5); their source under `.highway/` selects instead.
  - A template, library, or governance file named in a `SKILL.md` selects each skill naming it.
  - A path in `harness/selection/shared.txt`, or under `harness/src/` or `harness/package*.json`,
    selects the smoke set.
  - `harness/scenarios/...` selects that scenario. `harness/fixtures/...` selects the scenarios
    starting from that fixture.
  - Everything else (generated catalog, tools, tests, specs, constitutions) selects nothing.
- **Unmapped check (FR-025)**: Each shipped file under `.highway/library/templates/` and
  `.highway/governance/` must map to a skill or be shared. Other shipped trees map by rule.
- **Deleted paths**: The runner resolves a path missing from the working tree by reading the
  target branch's `SKILL.md` files with `git show <ref>:<path>`.

## R7. Fixtures

- **Decision**: Stage fixtures are full project snapshots (no `.highway/`, which comes from the
  distribution). An overlay names its stage in `overlay.txt` and adds or replaces files. A
  `.delete` file lists paths to remove. `harness/fixtures/templates.map` maps project paths to
  output templates.
- **Template check (FR-014)**: For each mapped file, every frontmatter key in the template's
  `File Frontmatter` fence and every table header row and `## ` heading in its body or catalog
  fence must appear in the fixture file. Headings the template says may be omitted are skipped.
- **Seed content**: The stage fixtures are hand-written from the templates for one worked example,
  "Northwind Outfitters", and are replaced by promoted chain output after the first full run.

## R8. Checks and invariants

- **File assertions (FR-028)**: `exists`, `absent`, `heading`, `field`, `row`, `contains`, and
  `template` (structural check against a named template).
- **Storage invariant (FR-029)**: The project tree is hashed before and after. Every created,
  changed, or deleted file must match a `writes:` glob. Rejected shell, memory, and outside-write
  requests also fail it.
- **Invariants usable as coverage treatments**: `storage`, `no-shell`, and `writes-nothing` (no
  change at all). A treatment names one of them.

## R9. Judge

- **Decision**: A new session with the judge model receives the redacted normalized transcript, the
  scenario's written files (capped), and the covered bullets. It returns one JSON line per bullet:
  `{"hash","verdict","evidence","reason"}`. A `met` verdict without evidence becomes `not met`.
  Verdicts never change the exit code.

## R10. Failure output and redaction

- **Decision**: Fixed failure kinds with fixed likely causes. See
  [contracts/failure-output.md](contracts/failure-output.md). Redaction replaces the values of
  environment variables whose names contain `TOKEN`, `KEY`, or `SECRET`, plus `gh[pousr]_…`,
  `github_pat_…`, and `sk-…` patterns, with `[REDACTED]`, before anything is written or printed.

## R11. Rate limits

- **Decision**: An SDK error whose message or code names a rate limit (`429`, `rate limit`) retries
  the same request after 5, 20, and 60 seconds. A persistent limit, or an error naming premium
  requests or quota, stops new scenarios and exits 2 (FR-036b).

## R12. Evaluating the new checks against the tree (D3.4)

Recorded before the checks were wired into the suite:

| Check | Expected verdict on the committed tree |
|---|---|
| harness-placement | PASS once the manifest and `.gitignore` entries land |
| harness-scenarios | PASS on the committed scenarios; FAIL on each seeded probe |
| harness-fixtures | PASS on the five stage fixtures and overlays |
| harness-coverage | PASS once every highway-codify bullet is treated |
| harness-path-map | PASS; no shipped template or governance file is unmapped |
| harness-switches | PASS once README lists every switch |

Existing tests: no existing fixture is read by the new checks, so no existing verdict changes.
