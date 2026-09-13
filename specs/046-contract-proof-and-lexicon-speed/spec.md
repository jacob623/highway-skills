# Feature Specification: Contract Proof and Lexicon Speed

**Feature Branch**: `046-contract-proof-and-lexicon-speed`

**Created**: 2026-09-12

**Status**: Draft

**Input**: User description: "encode the required-key proof as a permanent test; fix the lexicon's
per-word forking"

## Summary

Feature 045 hardened the skill frontmatter contract and closed the defects it set out to close.
A post-implementation assessment found two residual gaps, and this feature closes exactly those
two. Nothing else in 045 is reopened.

**The first gap is that the assertion which justifies 045 is not a test.** `governance-plan.md`
named it directly: adding a required key to the declared contract must make a previously-conforming
skill fail, *with no change to any script*. Without that, the manifest is decoration and the feature
has produced a more elaborate copy of the constants it replaced. 045 proved it once by hand, in
task `T018`, recorded the verdict in prose, and moved on. The proof is now a claim in a task file,
not a check. Nothing prevents a future change from re-hardcoding a constraint and silently reverting
the premise of the feature while the suite stays green.

**The second gap is that the lexicon check spawns processes per word.** Checking one word forks a
subshell to resolve the lexicon path and a `grep` to search it; resolving a token as a rule id forks
two more subshells and up to two more greps; normalising a token forks a `sed`/`tr` pipeline. At
roughly 30 free-form words per skill that is several hundred processes per validator invocation, and
the suite invokes the validator hundreds of times. Measured effect: the lexicon check accounts for
0.237s of a 0.501s `validate-skill.sh` run, and total suite runtime rose from a 191s pre-045 baseline
to roughly 280s — a breach of the 240 second interim ceiling Feature 042 set, in a repository where
Phase 14 is an *active* phase whose stated purpose is recovering exactly this runtime. The check's
verdicts are correct; only the way it reaches them is wasteful.

Both gaps are cheap to close and neither changes what the validator decides. This feature adds no
rule, amends no constitution, and alters no finding text.

## Clarifications

Both items were named explicitly in the request, and two open judgement calls — the binding runtime
target, and whether the proof must cover both manifest scopes — are resolved by reasonable default
and recorded in Assumptions rather than deferred.

### Session 2026-09-12

- Q: What should the per-invocation speed target measure, given that total invocation time cannot
  reach 0.255s without work this feature has excluded? (SC-006) → A: Target the lexicon check's own
  cost at ≤0.025s per invocation, down from 0.237s; total run time becomes an observation, not a gate.

  Context: measurement showed the lexicon check accounts for 0.237s of a 0.501s validator run, so
  roughly 0.264s is fixed overhead this feature is not permitted to touch. The original criterion,
  derived by halving the total, was unreachable even with a zero-cost lexicon check.

- Q: Should the 240 second suite ceiling be a hard gate on this feature, or a recorded observation
  alongside a gate on the lexicon's own suite-wide cost? (FR-012, SC-005) → A: Gate on the lexicon's
  suite-wide contribution falling at least 90%; record total suite runtime as an observation, with any
  residue above the ceiling owned by Phase 14.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The contract's load-bearing property is defended by a check (Priority: P1)

A maintainer changes how `validate-skill.sh` or `lib/schema-validate.sh` sources its constraints —
refactoring, optimising, or simply reverting to a hardcoded list because it seemed simpler. Today the
suite would stay green and the manifest would quietly become inert. After this feature, the suite
fails and names what broke: the declared contract is no longer what the validator obeys.

**Why this priority**: This is the deeper of the two risks. A slow suite is visible and annoying; a
silently inert manifest is invisible and total. It would leave 045's entire structure standing while
removing everything it was for, and the only evidence that it ever worked would be a sentence in a
completed task file.

**Independent Test**: Seed a defect by making the validator ignore the manifest's required-key rows;
confirm the new test fails. Restore; confirm it passes. This requires nothing from User Story 2.

**Acceptance Scenarios**:

1. **Given** a contract manifest carrying one required key beyond those a conforming skill declares,
   **When** a real, otherwise-conforming skill is validated against it, **Then** validation fails and
   the finding names the missing key.
2. **Given** the unmodified contract manifest, **When** the same skill is validated, **Then**
   validation succeeds — so the test cannot pass vacuously by failing in both directions.
3. **Given** a validator changed to source its required keys from anywhere other than the manifest,
   **When** the suite runs, **Then** the suite fails.
4. **Given** the test has run to completion, whether it passed or failed, **When** the tracked
   manifest is inspected, **Then** it is byte-identical to its committed content.
5. **Given** a required key declared in the `metadata` scope rather than the top-level scope,
   **When** a skill omitting it is validated, **Then** validation fails naming that key, so the proof
   covers both scopes the manifest can describe.

---

### User Story 2 - The lexicon check stops paying a process per word (Priority: P2)

A contributor runs the test suite. It completes within the declared ceiling rather than beyond it,
and every verdict is exactly what it was before. The priority reflects sequencing, not lesser
importance: this is a live breach of a declared constraint that every contributor pays on every run.

**Why this priority**: The runtime cost is real and currently unbudgeted, but it is a cost rather
than a correctness hazard, and the remedy is mechanical. User Story 1 protects a property that cannot
be recovered once lost; this one recovers time, which can be recovered at any point.

**Independent Test**: Capture the validator's complete output for all skills and all fixtures before
the change, apply the change, capture again, and diff. Byte-identical output with a measurably lower
runtime is the whole result. This requires nothing from User Story 1.

**Acceptance Scenarios**:

1. **Given** any skill or fixture, **When** it is validated before and after this change, **Then**
   the findings are byte-identical in text, order, and exit status.
2. **Given** a free-form field of any length, **When** its words are checked, **Then** the lexicon is
   consulted without spawning a process per word.
3. **Given** a field containing rule-id or skill-id tokens, **When** they are resolved, **Then** the
   governing documents are not re-read once per token.
4. **Given** the full test suite, **When** it runs to completion, **Then** the lexicon check's
   contribution to runtime has fallen by at least 90%, and total runtime is recorded against the 240
   second interim ceiling.
5. **Given** a word that is absent from the lexicon, **When** it is checked, **Then** it is still
   reported individually by name with the field it came from — the reporting contract is unchanged.

---

### Edge Cases

- An empty or whitespace-only field value must remain a silent pass, as it is today. This path
  already caused one `bash` 3.2 unbound-variable defect during 045 and must not regress.
- A field whose tokens reduce to nothing after punctuation stripping (for example `"---"`) must
  produce no findings rather than a finding for an empty word.
- A missing, unreadable, or empty lexicon file must be reported as a malformed-lexicon condition,
  not silently treated as "every word is unrecognised" or "every word is fine".
- The required-key proof must not depend on which specific skill it validates; if a skill is later
  edited to declare the key the test adds, the test must still be meaningful.
- The required-key proof must leave no temporary file behind when it fails partway, so a failing run
  does not pollute the next one.
- A field long enough to exceed the declared upper length bound is not lexicon-checked today,
  because its length check already failed. That skip must survive unchanged.

## Requirements *(mandatory)*

### Functional Requirements

**Required-key proof (User Story 1)**

- **FR-001**: The test suite MUST contain a permanent check that a required key declared in the
  contract manifest, and absent from an otherwise-conforming skill, causes that skill to fail
  validation with a finding naming the key.
- **FR-002**: That check MUST exercise the real validator end to end, not a unit-level call to an
  internal function, so it detects a validator that stops consulting the manifest as well as a
  manifest reader that stops working.
- **FR-003**: That check MUST cover both scopes the manifest can declare — a top-level required key
  and a `metadata` required key.
- **FR-004**: That check MUST assert the positive case as well as the negative: the same skill
  validated against the unmodified manifest succeeds.
- **FR-005**: That check MUST NOT write to the tracked contract manifest at any point, including on
  failure paths, and MUST remove any temporary artifact it creates.
- **FR-006**: That check MUST have been observed failing against a seeded defect in which the
  validator derives a required key from somewhere other than the manifest, and passing again once
  that defect is removed.

**Lexicon performance (User Story 2)**

- **FR-007**: Checking a word against the lexicon MUST NOT spawn a subprocess per word.
- **FR-008**: Resolving a token as a rule id MUST NOT re-read the governing documents per token.
- **FR-009**: Normalising a token MUST NOT spawn a process per token.
- **FR-010**: The findings produced for every skill and every fixture MUST be byte-identical to those
  produced before this change, in text, order, and exit status. Unrecognised words MUST still be
  reported individually with their originating field; a count MUST NOT be substituted.
- **FR-011**: The lexicon's declared shape check — one lowercase word per line, sorted, without
  duplicates — MUST continue to be enforced, and a malformed or missing lexicon MUST still be
  reported rather than silently changing what is checked.
- **FR-012**: The lexicon check's contribution to total suite runtime MUST fall by at least 90%,
  measured as the median of three consecutive runs on an otherwise idle machine. Total suite runtime
  MUST be recorded alongside it as an observation. If total runtime remains above the 240 second
  interim ceiling after this reduction, the residue MUST be reported as outstanding work owned by
  Phase 14 rather than treated as a failure of this feature.

**Cross-cutting**

- **FR-013**: No constitution rule may be added, removed, or retagged. Every check this feature
  touches remains reported under the `[SCHEMA]` tag.
- **FR-014**: No skill's frontmatter, and no word in the shipped lexicon, may be changed to make a
  check pass. Any real defect found is reported and fixed as a defect.
- **FR-015**: All work MUST remain within the Declared Toolchain and MUST run under the `bash` 3.2
  that macOS ships as its default shell.
- **FR-016**: `UNCHECKED` MUST remain empty for every skill.

### Key Entities

- **Contract manifest**: the shipped declaration of permitted frontmatter keys, their required or
  optional status, and their value constraints. This feature does not change its content or shape; it
  adds a check that the validator genuinely obeys it.
- **Frontmatter lexicon**: the shipped, sorted word list against which free-form frontmatter prose is
  checked. This feature does not add or remove a word; it changes only how the list is consulted.
- **Seeded defect**: a deliberate, temporary break used to prove a check can fail. Required by the
  repository's testing discipline and used here for both user stories.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A validator modified to ignore the manifest's required-key declarations causes the test
  suite to fail. Before this feature, that modification leaves the suite green.
- **SC-002**: The required-key proof exists as an automated check that runs unattended in the normal
  suite, rather than as a verdict recorded in a task file.
- **SC-003**: The tracked contract manifest is byte-identical before and after a full suite run,
  including runs in which the new check fails.
- **SC-004**: Validator output for all 8 skills and every fixture is byte-identical before and after
  the lexicon change, compared as complete captured output rather than exit status alone.
- **SC-005**: The lexicon check's suite-wide cost falls by at least 90%. Total suite runtime is
  measured as the median of three consecutive runs and recorded against the approximately 280 seconds
  observed at the close of Feature 045; any remaining excess over the 240 second interim ceiling is
  reported as Phase 14's outstanding work, not as a failure of this feature.
- **SC-006**: The lexicon check's own cost for a single validator invocation is at or below 0.025
  seconds, down from a measured 0.237 seconds — a reduction of roughly 90%. Total invocation time is
  recorded as an observation, not a gate, because the remaining ~0.264 seconds is fixed startup
  overhead outside this feature's scope.
- **SC-007**: The suite passes in full, `UNCHECKED` is empty for every skill, and the test file count
  grows only by whatever new files these two changes require.

## Assumptions

- **The binding gate is the cost this feature controls, not total runtime.** The 240 second ceiling
  Feature 045 breached remains the repository's declared constraint and this change is expected to
  recover most of the overage, but the lexicon is only one contributor to suite runtime. Gating on a
  total that is mostly made of costs this feature may not touch would let a complete implementation
  fail, so the ceiling is tracked as an observation. Phase 14 remains the owner of further runtime
  recovery.
- **The required-key proof may use the existing environment-variable override** that lets a test point
  the validator at an alternative manifest. Feature 045 established this mechanism and used it for the
  malformed-manifest test; reusing it is what keeps `FR-005` satisfiable without a revert step.
- **Byte-identical output is the correctness standard for the lexicon change**, in preference to
  re-deriving expected findings. The current findings are trusted as the baseline because they were
  verified against all 8 skills and every fixture at the close of Feature 045.
- **Both changes are independent of each other** and of every other open phase, and may be
  implemented, reviewed, and landed separately.
- **The lexicon's 172 words are correct as they stand** for the purposes of this feature. Their
  provenance is questioned in the Feature 045 assessment but is explicitly out of scope here.

## Out of Scope

The assessment that produced this feature raised further findings. They are recorded here so that
their exclusion is a decision rather than an oversight, and none of them is addressed by this work:

- **The nine lexicon words added during Feature 045 to accommodate test-fixture prose.** Removing
  them and correcting the fixture instead is a separate correction with its own risk of churn.
- **The stale word counts in `specs/045-frontmatter-contract-hardening/spec.md`**, which still claim
  126 words in four places including a success criterion, against an actual 172.
- **The unexercised `agent_exceptions` paths.** No skill and no fixture declares
  `metadata.agent_exceptions`, leaving both the deviation lexicon check and the reworked valid-agent
  derivation without coverage.
- **The dead `SV_VERSION_REGEX` constant**, defined and referenced nowhere.
- **Whether the lexicon spell-check earns its keep at all**, as distinct from the identifier
  resolution it is bundled with. This feature makes the check cheap; it deliberately does not reopen
  whether the check should exist.
- **Any change to what the validator decides.** Both user stories are explicitly behaviour-preserving.
