# Research: Open Findings

Resolves Technical Context unknowns for F18, F20, F23, and F28.

## R1. F18 skill wording (Example Realization Matrix)

- **Decision**: Edit `skills/highway-discovery/references/options.md` only. Immediately after the existing keep-every-heading / keep-header-row bullet, add: under `## Example Realization Matrix`, keep its header row even when there are no examples; write `None` after that header. Bump highway-discovery metadata version MINOR (`5.8.0` → `5.9.0`). Regenerate agent trees and the plugin so shipped copies match. Do not change templates.
- **Rationale**: F18’s Proposed resolution names that file and that sentence. Spec 244’s general bullet was not enough; Luna still replaces the table with bare `None` when the template placeholder says “or `None`”. Closing F18 still requires live smokes to clear the template check (clarification).
- **Alternatives considered**: Changing `assets/discovery-record.md` (findings forbid template changes for this case). Editing only the plugin copy (Correspondence Gate requires source + regenerate). Closing F18 on skill text alone (rejected in clarify).

## R2. F23 `shows:` backticks

- **Decision**: In `showsFailures` (`harness/src/checks.ts`), strip backtick characters the same way emphasis markers are stripped today (remove `` ` `` runs before whitespace collapse). Add a unit test that proves `` `highway-codify-config` `` matches plain `shows:` text and that different words still fail. No scenario or skill change. README `shows` row may note backticks alongside emphasis.
- **Rationale**: Matches F23 Proposed resolution and existing emphasis-normalization pattern. Edge case: do not strip fence semantics specially; removing backtick characters from both sides is enough for inline code without inventing fence parsing.
- **Alternatives considered**: Teaching the skill to avoid backticks (findings forbid). Matching after markdown parse (overkill). Leaving fences as a special case (unnecessary if both sides lose backticks).

## R3. F28 `contains-any` case

- **Decision**: In `runExpectation` for `contains-any`, compare with case folding (`toLowerCase` on both sides). Leave `contains` case-sensitive. Unit test for capitalized match vs lowercase expectation. README states `contains-any` ignores case. No scenario change.
- **Rationale**: F28 Proposed resolution; `ask:` already ignores case; objectives-smoke’s `:: repeat` vs “Repeat” is the confirmed miss.
- **Alternatives considered**: Making `contains` case-insensitive too (spec default: leave unchanged). Scenario text change to match capitalization (forbidden workaround).

## R4. F20 shorter attempt paths

- **Decision**: Shorter layout is feasible and will be implemented. Change attempt filesystem layout only (no permission/storage rule change):
  1. Work root prefix: `hh-` instead of `highway-harness-` under `os.tmpdir()`.
  2. Child folders: `h/` and `p/` instead of `homes/` and `projects/`.
  3. Attempt directory labels: short attempt token only (`${attempt}-` / mkdtemp suffix), not `${scenario.id}-${attempt}-`, so long scenario names leave the path.
  4. Keep `pathRewriter` roots (project, home, work, tmp) correct for the new layout; redaction still replaces those prefixes.
  5. Judge throwaway homes may use short prefixes (`hj-`, `hcj-`) for consistency; optional and low priority.
  Isolation, install checks, and outside-project deny stay as today. Close F20 when confirming runs show fewer collapsed-path denials than the cited baseline (any reduction); if somehow unsafe after measurement, leave open with evidence — research finds the change safe a priori.
- **Rationale**: Findings ask to investigate shorter homes/projects directly under the temp tree. The long `highway-harness-…/homes/<scenario-id>-…` and plugin nests are what models collapse. Shortening middle segments and dropping scenario ids from paths reduces that surface without weakening invariants. Nested `projects/…/projects/…` on Cursor is a model invention; shorter roots still help and do not require a skill workaround.
- **Alternatives considered**: Symlink short aliases to long trees (extra complexity; Cursor may skip out-of-tree links). Putting each project at the tmp root with no workRoot (weakens work-scoped rewrite/redaction). Skill text reminding relative paths only (findings: no skill change for F20). Doing research-only with no layout change (rejected: feasible and low risk).

## R5. Confirmation matrix and targeted set

- **Decision**: Per clarifications: Copilot `--smoke` ×1, Cursor `--smoke` ×2, Cursor targeted ×1. Targeted scenarios: `discovery-smoke` (F18), `codify-configure` (F23 `shows:`), `objectives-smoke` (F28 `contains-any`), plus `request-smoke` and `setup-smoke` as F20 path-pressure samples. Logs: `smoke-copilot.log`, `smoke-cursor-1.log`, `smoke-cursor-2.log`, `targeted-cursor.log` under `specs/251-open-findings/harness/`.
- **Rationale**: Spec FR-010 + clarify answers. Those five scenarios cover every finding’s primary evidence path without a second full smoke on Copilot.
- **Alternatives considered**: Copilot targeted (rejected). Full dual smoke×2 (user chose Copilot 1×). Codify-only targeted (misses F18/F28/F20).

## R6. Constitution / packaging

- **Decision**: Skill text change triggers Packaging + Correspondence + Skill Content gates: edit `skills/highway-discovery/` only for F18, regenerate, validate. Harness-only changes for F23/F28/F20 need no Declared Toolchain change and no constitution bump unless a rule text changes (none expected). MINOR skill version only; no backward compatibility; no commit unless asked.
- **Rationale**: Matches prior findings specs (244) and standing constraints.
- **Alternatives considered**: Constitution bump for harness path labels (not a constitution concern). Editing generated trees by hand (forbidden).
