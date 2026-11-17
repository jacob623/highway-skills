# Feature Specification: Open Findings

**Feature Branch**: `251-open-findings`

**Created**: 2026-11-17

**Status**: Draft

**Input**: User description: "create a new spec to address the open Findings in harness-model-findings.md"

The open findings under `# Harness Failures` in `harness-model-findings.md` are:

| Id | Category | Proposed resolution (from findings) |
| --- | --- | --- |
| F18 | Skill | In highway-discovery `references/options.md`, after the keep-every-heading guidance, require keeping the Example Realization Matrix header row even when there are no examples, with `None` after it. |
| F23 | Harness | In the harness `shows:` check, strip backticks as well as emphasis markers so a backticked skill name matches plain `shows:` text. Unit test required. No skill change. |
| F28 | Harness | Make `contains-any` ignore case; unit test and README note. No scenario change. |
| F20 | Model / harness layout | No skill change. Investigate shorter throwaway home and project paths so the model is less likely to drop path segments; compare denied collapsed-path counts across confirming runs. |

Baseline evidence includes Copilot Luna runs through specs 244–248 and Cursor confirmation runs in spec 250 (`20261116-183431Z-smoke-cursor-db3d54c`, `20261116-185430Z-smoke-cursor-db3d54c`, `20261116-191450Z-targeted-cursor-db3d54c`), where F18 still failed discovery-smoke and F20 still appeared as nested or invented absolute paths.

Out of scope: Cursor cloud (Phase 20); marketplace install; promoting fixtures from non-Copilot runs; reopening closed findings (F1, F19, F21, F22, F24–F27, F29) unless a confirming run brings them back; chasing Copilot/Cursor pass-table parity beyond the findings named here.

## Clarifications

### Session 2026-11-17

- Q: When is F20 considered resolved enough to remove from the open findings list? → A: Close F20 when confirming runs show fewer collapsed-path denials than the cited baseline after a layout change (or leave open if research finds no safe change)
- Q: Should the confirmation cycle also include Cursor when validating F20 path-layout results? → A: Always run both Copilot and Cursor smoke matrices before closing any of the four findings; Copilot smoke once; Cursor smoke twice
- Q: If the F18 skill wording is updated but discovery-smoke still drops the Example Realization Matrix header in confirmation, what should happen to F18? → A: Keep F18 open (update Basis/Runs; optionally note it as model behavior) until confirmation smokes no longer fail that header check
- Q: Which agent(s) should run the post-smoke targeted confirmation covering scenarios this spec affects? → A: Targeted on Cursor only (Copilot covered by its single smoke)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Discovery keeps every required table header (Priority: P1)

A person finishes a Discovery that has no example products. The written record still keeps the Example Realization Matrix heading and its header row, with `None` after the header when there are no rows (F18).

**Why this priority**: discovery-smoke still fails the template check on this exact case in the latest Cursor confirmation smokes, and the same miss has recurred across Copilot plugin and groundwork runs.

**Independent Test**: Run discovery-smoke live after the skill change; assert the Discovery file matches `discovery-record.md`, including the Example Realization Matrix header row.

**Acceptance Scenarios**:

1. **Given** highway-discovery’s write guidance for empty sections, **When** a maintainer reads the skill text this finding names, **Then** it explicitly requires keeping the Example Realization Matrix header row even when there are no examples, with `None` after that header.
2. **Given** a Discovery with no examples, **When** it is written in a live discovery-smoke attempt, **Then** the record keeps `| Product | Purpose | Key Capabilities | Estimated Cost |` (or the template’s current header wording) under `## Example Realization Matrix`, and does not replace the whole section with bare `None` alone.
3. **Given** confirming smoke runs after the change, **When** discovery-smoke finishes, **Then** it does not fail the template check for a missing Example Realization Matrix header row.

---

### User Story 2 - Harness text checks ignore formatting and case noise (Priority: P1)

A maintainer runs scenarios that use `shows:` or `contains-any`. A skill name shown in backticks still satisfies `shows:` (F23). A capitalized word in a record still satisfies a lowercase `contains-any` fragment (F28).

**Why this priority**: Both are harness false failures with concrete, local fixes. They make correct skill behavior look broken.

**Independent Test**: Unit tests cover backtick stripping for `shows:` and case-insensitive `contains-any`; README states the case rule for `contains-any`.

**Acceptance Scenarios**:

1. **Given** a `shows:` expectation of plain text and agent output that wraps a matching token in backticks, **When** the harness `shows:` check runs, **Then** it passes.
2. **Given** a `shows:` expectation and agent output with different words, **When** the check runs, **Then** it still fails.
3. **Given** a `contains-any` expectation with a lowercase fragment and a matching file whose text uses different capitalization, **When** the check runs, **Then** it passes.
4. **Given** the harness README after the change, **When** a reader looks up `contains-any`, **Then** it states that the comparison ignores case.

---

### User Story 3 - Shorter attempt paths reduce collapsed absolute paths (Priority: P2)

A maintainer runs the harness after a layout change that shortens each attempt’s throwaway home and project path. Collapsed or invented absolute paths (F20) appear less often in denied-request lines, and attempts that previously failed only because of a dropped path segment succeed more often.

**Why this priority**: F20 is confirmed and still visible in spec 250 Cursor logs, but the findings document forbids a skill change and calls for a harness path-layout investigation first.

**Independent Test**: Research records whether shorter paths are feasible without breaking install, isolation, or redaction; if implemented, compare denied collapsed-path counts and request-smoke / setup-smoke outcomes against the baseline.

**Acceptance Scenarios**:

1. **Given** planning research for F20, **When** it completes, **Then** it states whether shorter attempt homes and project paths are feasible under current isolation and redaction rules, with evidence.
2. **Given** research finds a feasible shorter layout, **When** the change lands, **Then** each attempt still uses an isolated throwaway home and project, plugins still install with the shared checks, and secrets/temp paths remain redacted in committed logs.
3. **Given** research finds no safe shorter layout, **When** findings are updated, **Then** F20 stays open with that evidence, and this story does not invent a skill workaround.
4. **Given** a feasible layout change and confirming runs, **When** denied-request lines are reviewed, **Then** nested or segment-dropped absolute paths are fewer than in the baseline runs this finding cites (that reduction is enough to close F20), or research found no safe layout change and F20 stays open with that evidence.

---

### User Story 4 - Findings and live records close or update the four findings (Priority: P3)

After the suite and harness tests pass, a maintainer runs the confirmation live checks, updates `harness-model-findings.md`, and removes each finding that the confirming evidence resolves.

**Why this priority**: The findings document is the input to later work; it must match the confirming runs.

**Independent Test**: Read this spec’s committed run logs and the Harness Failures section.

**Acceptance Scenarios**:

1. **Given** the harness unit tests and the full bash suite pass, **When** the confirmation live cycle completes (Copilot smoke once, Cursor smoke twice, plus Cursor targeted for scenarios this spec affects), **Then** standard-output logs for each of those runs are saved under `specs/251-open-findings/harness/` without secrets or temporary filesystem paths.
2. **Given** F18’s skill change, **When** findings are updated, **Then** F18 is removed only if confirmation smokes no longer fail the Example Realization Matrix header check; if the skill text is correct but that live failure remains, F18 stays open with updated Runs/Basis (and may note model behavior).
3. **Given** F23 and F28 unit tests pass, **When** findings are updated, **Then** both are removed from the open list.
4. **Given** F20’s research and any layout change, **When** findings are updated, **Then** F20 is resolved and removed, or left open with updated Runs/Basis/Proposed resolution from the confirming evidence.
5. **Given** a new failure kind in the confirming runs that no open finding explains, **When** findings are updated, **Then** a new finding is added rather than silently ignored.

---

### Edge Cases

- F18’s wording must not weaken the existing “keep every heading and table header row” rule for other empty sections.
- F23 must not make unrelated punctuation or code fences cause false passes for `shows:`.
- F28 applies to `contains-any` only; existing `contains` behavior stays as today unless research shows it must change for the same reason (default: leave `contains` unchanged).
- F20 must not weaken the storage invariant: outside-project reads and writes still deny; shorter paths are layout only.
- Copilot driver behavior for unrelated features stays unchanged except where F23/F28 shared checks apply to every agent.
- No fixture or scenario rewrite is required for F23/F28; F18 is skill text only; F20 is harness layout / research.
- If confirming runs reintroduce a previously closed finding, record it; do not expand this spec into a full parity chase.

## Requirements *(mandatory)*

### Functional Requirements

**F18 (skill)**

- **FR-001**: highway-discovery’s write guidance named by F18 MUST require keeping the Example Realization Matrix header row when there are no examples, with `None` after that header.
- **FR-002**: The F18 change MUST NOT remove or weaken the existing keep-every-heading / keep-header-row guidance for other empty sections. F18 MUST NOT be removed from the open findings list until confirmation smokes no longer fail that header check; a skill-text-only change with a remaining live miss keeps F18 open (Runs/Basis updated; model behavior may be noted).

**F23 / F28 (harness checks)**

- **FR-003**: The shared `shows:` check MUST treat backtick markers the same way it already treats emphasis markers for matching, so a backticked token can satisfy plain expected text.
- **FR-004**: The shared `contains-any` check MUST compare ignoring case.
- **FR-005**: Each of FR-003 and FR-004 MUST have a unit test observed failing for the missing behavior before the behavior is marked complete. The harness README MUST state that `contains-any` ignores case.
- **FR-006**: No scenario file MUST change solely to work around F23 or F28.

**F20 (path layout)**

- **FR-007**: Planning MUST record research on shorter attempt home and project paths (feasibility, isolation, install, redaction). An unworkable answer MUST leave F20 open with evidence and MUST NOT add a skill workaround.
- **FR-008**: If a shorter layout is adopted, every attempt MUST remain isolated; shared plugin install checks and the storage/permission invariants MUST stay as strong as today. F20 MUST be removed from the open list when confirming runs show fewer collapsed-path denials than the cited baseline after that change; zero denials or scenario-pass recovery is not required to close it.

**Tests, live runs, findings**

- **FR-009**: The full bash suite and harness unit tests MUST pass after the changes.
- **FR-010**: After those pass, one confirmation cycle MUST run before any of F18/F20/F23/F28 may be closed: one Copilot `--smoke` run, two Cursor `--smoke` runs, then one Cursor targeted run covering scenarios this spec’s changes affect (at least discovery-smoke, and any scenario exercised by F23/F28 or F20 layout proof). Copilot does not need a separate targeted run beyond its smoke. Logs MUST be saved under `specs/251-open-findings/harness/` as committed stdout logs that distinguish Copilot smoke, each Cursor smoke, and Cursor targeted (for example `smoke-copilot.log`, `smoke-cursor-1.log`, `smoke-cursor-2.log`, `targeted-cursor.log`). No secret, token, or temporary path MUST appear in a committed log.
- **FR-011**: `harness-model-findings.md` MUST be updated from those runs: resolve and remove F18 only when confirmation smokes clear the header check (FR-002); remove F23 and F28 when their acceptance evidence holds; resolve or update F20 per FR-007/FR-008; add new findings for unexplained new failure kinds.
- **FR-012**: When any of F18/F20/F23/F28 resolve, `rollout-plan.md` MAY note the follow-up under the relevant phase Status without reopening a completed phase unless a person decides otherwise.

### Key Entities

- **Open finding**: one of F18, F20, F23, F28 as recorded in `harness-model-findings.md`.
- **Confirmation log**: committed standard-output record of a live harness run under this spec’s folder.
- **Collapsed path**: an absolute tool path that drops a temporary or attempt segment and is denied as outside the project or invents a non-existent root.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In the Copilot smoke and both Cursor smoke runs, discovery-smoke does not fail for a missing Example Realization Matrix header row (F18).
- **SC-002**: Unit tests prove `shows:` passes for backtick-wrapped matching text and still fails on different words (F23).
- **SC-003**: Unit tests prove `contains-any` matches across capitalization differences (F28).
- **SC-004**: F23 and F28 are removed after their unit-test evidence holds; F18 is removed only when confirmation smokes no longer fail the Example Realization Matrix header check (skill text alone is not enough if the live miss remains).
- **SC-005**: F20 is removed when confirming runs after a shorter-path change show fewer collapsed-path denials than the cited baseline (any confirmed reduction is enough; zero denials are not required), or left open with research evidence that no safe layout change is available.
- **SC-006**: The full bash suite and harness unit tests pass; each committed confirmation log holds no secret, token, or temporary path.
- **SC-007**: This spec completes after one confirmation cycle (Copilot smoke×1, Cursor smoke×2, Cursor targeted×1); it does not require Cursor/Copilot pass-count parity beyond the four findings.

## Assumptions

- Spec 250 is complete enough that Cursor experience-order is no longer an open finding; this spec does not re-fix F29.
- Confirmation always includes both agents before closing any of the four findings: Copilot smoke once, Cursor smoke twice, then Cursor targeted once as in FR-010. Cursor-specific F20 evidence from spec 250 still informs research.
- Shared parallel count, judge configuration, and redaction rules stay as configured.
- Constraints carried from earlier work: do not commit unless asked; secrets redacted; `rollout-plan.md` stays gitignored and distribution-excluded; use `mv`, not `git mv`; skill change is allowed only for F18 as named; F23/F28/F20 are harness (or research) only.
- `contains` (non-any) stays case-sensitive unless a confirming failure proves otherwise.
