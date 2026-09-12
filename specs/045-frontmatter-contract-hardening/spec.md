# Feature Specification: Frontmatter Contract Hardening

**Feature Branch**: `045-frontmatter-contract-hardening`

**Created**: 2026-09-11

**Status**: Draft

**Input**: User description: "create the spec for phase 17" — Phase 17 ("Harden the skill
frontmatter contract") of `governance-plan.md`, opened 2026-09-11 from a mutation audit of
`validate-skill.sh`.

## Summary

`SKILL.md` frontmatter is the densest shipped markdown in the product: four consumers read it, and
a defect there is copied verbatim into three agent adapter trees, into the catalog, and into what
`highway-help` answers a user. A mutation audit against `highway-help/SKILL.md` found the validator
catches 3 of 6 seeded frontmatter defects — it misses an undeclared extra key, a duplicated
`description:` key, and a too-short `description:` value. The common cause is structural: nothing
enumerates the permitted key set, `fm_get` resolves a repeated key with `head -n1` while YAML
semantics are last-wins, and the field constraints the validator enforces exist only as constants
hardcoded in `lib/schema-validate.sh` with no declared, shipped source of truth.

This feature declares the frontmatter contract in one shipped, machine-readable artifact under
`.highway/`; makes `lib/schema-validate.sh` derive its checks from that artifact instead of its own
constants; closes the permitted key set so an undeclared or duplicate key is reported by name; adds
a lower length bound to `description` and `usage` alongside the existing upper bound; declares
`metadata.dependencies`, which is already enforced but has no row in the authoring standard; and
spell-checks free-form frontmatter values against a maintained lexicon, with identifier tokens
(skill ids, rule ids) accepted by resolution rather than lexicon membership. No constitution
amendment is required: every frontmatter check today is reported under the `[SCHEMA]` tag with no
governing `P` rule, and every check this feature adds joins that same stratum.

## Clarifications

### Session 2026-09-11

- Q: What is the minimum character length for `description` and `usage`? → A: 10 characters —
  rejects only single-word/placeholder values such as `"x"`.
- Q: Where should the maintained lexicon file live? → A: `.highway/library/knowledge/`, alongside
  other shipped reference content.
- Q: How should a hyphenated compound word be checked against the lexicon? → A: Split on hyphens
  — each part (e.g. `non`, `functional`) is checked separately against the lexicon; the compound
  itself does not need its own entry.
- Q: When resolving a rule id identifier token, which governing documents count as valid sources?
  → A: Prefix-routed — a `D`-prefixed id resolves against the development constitution, a
  `P`-prefixed id against the authoring constitution, and an `X`-prefixed id against the experience
  standard.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The frontmatter contract is declared once and the validator reads it (Priority: P1)

As a Highway maintainer, I want the permitted frontmatter key set, each key's required/optional
status, and each key's value constraints declared in one shipped artifact that
`lib/schema-validate.sh` reads at run time, so the validator's behavior traces to a document instead
of to constants buried in a script.

**Why this priority**: Every other story in this feature depends on the contract existing as a
declared, shipped artifact rather than as implicit script behavior. Without this, closing the key
set or adding length bounds would just add more hardcoded constants to the same problem.

**Independent Test**: Add a new required key to the declared artifact with no change to any script,
then run `validate-skill.sh` against an existing conforming skill and confirm it now fails because
the key is absent — proving the declaration is load-bearing, not decorative.

**Acceptance Scenarios**:

1. **Given** the declared frontmatter contract artifact, **When** `lib/schema-validate.sh` runs
   against any skill, **Then** its checked key set, required/optional status, and value constraints
   match the artifact's content with no separate hardcoded list surviving in the script.
2. **Given** a malformed declaration in the contract artifact (e.g. a duplicate key entry in the
   declaration itself), **When** the validator runs, **Then** the malformed declaration is reported
   as an error rather than silently narrowing what gets checked.
3. **Given** a new required key added only to the declared artifact, **When** `validate-skill.sh`
   runs against a previously-conforming skill that lacks the key, **Then** the skill now fails,
   with no line of any script changed.

---

### User Story 2 - An undeclared or duplicated key is reported by name (Priority: P1)

As a Highway maintainer, I want every top-level and `metadata` key checked against the closed
permitted set, so that a misspelled optional key (e.g. `agent_exeptions:` instead of
`agent_exceptions:`) or a duplicated key is reported instead of silently accepted.

**Why this priority**: This is the phase's own stated highest-value case — "the damaging case is
not a stray key, it is a misspelled optional one." A misspelled optional key produces no error and
no behavior today; the skill ships believing it declared something it did not. This is equal in
priority to User Story 1 because it directly addresses the defect the mutation audit found most
dangerous, and both stories must land together for the contract to be meaningful.

**Independent Test**: Take a copy of a valid `SKILL.md`, add an undeclared top-level key (e.g.
`licence: MIT`), and separately create a copy with a duplicated `description:` key. Run
`validate-skill.sh` against each and confirm both are reported by name, then restore each file
byte-exact and confirm both pass again.

**Acceptance Scenarios**:

1. **Given** a `SKILL.md` with an undeclared top-level or `metadata` key, **When**
   `validate-skill.sh` runs, **Then** the output names the undeclared key.
2. **Given** a `SKILL.md` with a key appearing more than once at the same level, **When**
   `validate-skill.sh` runs, **Then** the output names the duplicated key, regardless of which
   occurrence a downstream parser would resolve.
3. **Given** a `SKILL.md` with `agent_exeptions:` (misspelled) instead of `agent_exceptions:`,
   **When** `validate-skill.sh` runs, **Then** the output reports the unrecognized key by name
   rather than silently treating the skill as having no exceptions.

---

### User Story 3 - `description` and `usage` carry a lower bound, and `metadata.dependencies` is declared (Priority: P2)

As a Highway maintainer, I want `description` and `usage` to be rejected when too short as well as
too long, and `metadata.dependencies` to have a Required-field row in the authoring standard, so
that the declared contract matches what is actually enforced today.

**Why this priority**: These close two narrower, independently valuable gaps found in the same
audit — a `description: "x"` value passes today, and `metadata.dependencies` is validated by
`dc_validate_dependencies` (path and pinned version) with no corresponding row in
`_authoring-standard.md`'s Required frontmatter table. Neither requires the spell-check
infrastructure of User Story 4.

**Independent Test**: Set `description: "x"` in a copy of a valid `SKILL.md` and confirm
`validate-skill.sh` now rejects it for being under the lower bound. Separately, confirm
`_authoring-standard.md` has a Required frontmatter table row for `metadata.dependencies` citing the
same constraint `dc_validate_dependencies` already enforces.

**Acceptance Scenarios**:

1. **Given** a `description` or `usage` value shorter than the declared lower bound, **When**
   `validate-skill.sh` runs, **Then** the value is rejected and the bound violated is named.
2. **Given** the existing upper bound on `description` and `usage`, **When** `validate-skill.sh`
   runs, **Then** the upper-bound check still functions exactly as before this feature.
3. **Given** `_authoring-standard.md`, **When** its Required frontmatter table is read, **Then** it
   contains a row for `metadata.dependencies` naming the same constraint
   `dc_validate_dependencies` enforces today.

---

### User Story 4 - Free-form frontmatter values are checked against a maintained lexicon (Priority: P2)

As a Highway maintainer, I want every word in `description`, `usage`, and each
`agent_exceptions[].deviation` checked against a maintained lexicon or resolved as an existing skill
id or rule id, so that a typo in free-form prose (e.g. `organisation` drifting against
`organization`, or a reference to a skill id that does not exist) is caught individually rather than
passing as ordinary text.

**Why this priority**: This is valuable but structurally independent of Stories 1-3 — it adds a new
kind of check (vocabulary) rather than closing a gap in the existing key/length checks, and it
depends on a lexicon being built and measured against real content first.

**Independent Test**: Add a nonexistent skill id (e.g. `highway-nfrz`) to a copy of a valid
`SKILL.md`'s `description`, run `validate-skill.sh`, and confirm it is reported individually as
unresolved. Separately, confirm every one of the 126 words measured 2026-09-11 across the 8 existing
skills' free-form fields is accepted with zero false positives.

**Acceptance Scenarios**:

1. **Given** a word in `description`, `usage`, or an `agent_exceptions[].deviation` that is neither
   in the lexicon nor resolvable as an existing skill id or rule id, **When** `validate-skill.sh`
   runs, **Then** that word is reported individually together with the field it came from.
2. **Given** multiple unrecognized words in the same field, **When** `validate-skill.sh` runs,
   **Then** each is reported individually — a single count is not sufficient.
3. **Given** a token that names a skill id or rule id, **When** `validate-skill.sh` runs, **Then**
   the token is accepted only if a skill with that id exists under `.highway/skills/` or a rule with
   that id exists in a governing document, not merely because the token resembles one.
4. **Given** the lexicon file, **When** its shape is checked, **Then** it is one word per line,
   sorted, with no duplicate lines, and a check enforces that shape.

---

### Edge Cases

- What happens when the declared contract artifact itself is malformed (e.g. a duplicate key
  declaration, or a required/optional flag with an invalid value)? It must be reported as an error,
  not silently narrow what is checked (covered by User Story 1, Acceptance Scenario 2).
- What happens when a hyphenated compound word (e.g. `control-to-nfr`, `non-functional`) appears in
  a free-form field? It is split on hyphens and each part is checked separately against the
  lexicon; a compound is accepted once every one of its parts is recognized, with no separate entry
  required for the compound itself.
- What happens when a word is correctly spelled but not yet in the lexicon (e.g. a new technical
  term introduced by a future skill)? The only path to acceptance is adding it to the lexicon file —
  no per-skill exemption, inline suppression, or ignore list is permitted.
- What happens to the existing, unshipped schema file at
  `specs/001-multi-agent-skill-suite/contracts/skill-frontmatter.schema.json`, which the validator's
  header comment cites but nothing reads? It is historical record and is left unchanged; this
  feature creates a new, shipped declaration rather than editing a historical spec directory.
- What happens when an existing skill's frontmatter is found to actually violate the newly-declared
  contract during rollout? The defect is reported and fixed as a real defect in that skill — no
  check is loosened and no skill is edited merely to make a check pass without the edit also being a
  genuine correction.

## Requirements *(mandatory)*

### Functional Requirements

#### Declared contract

- **FR-001**: The frontmatter contract — every permitted top-level and `metadata` key, whether each
  is required or optional, and the constraint on each key's value, including
  `metadata.dependencies` — MUST be declared in exactly one shipped artifact under `.highway/`.
- **FR-002**: `lib/schema-validate.sh` MUST derive its checked key set and value constraints from
  that declared artifact at run time rather than from hardcoded constants.
- **FR-003**: The declaring artifact's own shape MUST itself be validated, so that a malformed
  declaration is reported as an error rather than silently narrowing what is checked.
- **FR-004**: `.highway/skills/_authoring-standard.md` MUST cite the declaring artifact and MUST NOT
  restate its content, per `P7.3`.

#### Closed key set

- **FR-005**: An undeclared top-level or `metadata` key MUST be reported by name.
- **FR-006**: A key appearing more than once at the same level MUST be reported by name, regardless
  of which occurrence a downstream parser would resolve as authoritative.

#### Length bounds and dependency declaration

- **FR-007**: `description` and `usage` MUST each be checked against both a lower bound of 10
  characters and the existing upper bound, and a value outside either bound MUST be reported naming
  which bound was violated.
- **FR-008**: `_authoring-standard.md`'s Required frontmatter table MUST include a row for
  `metadata.dependencies` naming the same constraint `dc_validate_dependencies` already enforces.

#### Lexicon and identifier resolution

- **FR-009**: Every word in `description`, `usage`, and each `agent_exceptions[].deviation` MUST be
  checked against a maintained lexicon or resolved as an existing identifier (a skill id or a rule
  id). A hyphenated compound MUST be split on its hyphens, with each part checked separately; no
  separate lexicon entry for the compound as a whole is required.
- **FR-010**: Each unrecognized word MUST be reported individually together with the field it came
  from; a count alone MUST NOT be reported in place of the individual words.
- **FR-011**: A token naming a skill id MUST be accepted only if a skill with that id exists under
  `.highway/skills/`. A token naming a rule id MUST be resolved by its prefix: a `D`-prefixed id
  MUST be accepted only if that rule exists in `.specify/memory/constitution.md`, a `P`-prefixed id
  only if it exists in `.highway/governance/constitution.md`, and an `X`-prefixed id only if it
  exists in `.highway/governance/experience-standard.md`.
- **FR-012**: The lexicon MUST be one word per line, sorted, with no duplicate lines, and a check
  MUST enforce that shape.
- **FR-013**: The lexicon MUST be the only mechanism for admitting new vocabulary — no per-skill
  exemption, inline suppression, or ignore list MUST exist.

#### Verification discipline

- **FR-014**: Every new check added by this feature MUST be observed failing against a seeded
  defect and passing again after byte-exact restoration, before being enabled.
- **FR-015**: Every new check MUST be evaluated against all 8 existing skills and every existing
  fixture before being enabled, per `D3.4`, with the verdicts recorded.
- **FR-016**: Adding a required key to the declared contract MUST be observed to make a
  previously-conforming skill fail, with no accompanying script change, as the acceptance proof that
  the declaration is load-bearing rather than decorative.
- **FR-017**: No existing skill's frontmatter MUST be edited solely to make a new check pass; a real
  defect found in an existing skill during rollout MUST be reported and fixed as a defect.
- **FR-018**: After this feature, `UNCHECKED` MUST remain empty for every skill, `run-all.sh` MUST
  exit 0, and the suite's runtime MUST be reported against the 240 second interim ceiling Feature 042
  set.
- **FR-019**: This feature MUST NOT add, remove, or retag any constitution rule. Every check it adds
  MUST be reported under the existing `[SCHEMA]` tag, consistent with every frontmatter check that
  exists today.

### Key Entities

- **Declared frontmatter contract**: the single shipped artifact under `.highway/` naming every
  permitted key, its required/optional status, and its value constraint, including
  `metadata.dependencies`. Supersedes the constants currently hardcoded in
  `lib/schema-validate.sh` as the source of validator behavior.
- **Lexicon**: the shipped, one-word-per-line, sorted, duplicate-free word list under
  `.highway/library/knowledge/` against which free-form frontmatter values are checked. Measured
  2026-09-11, the 8 existing skills' free-form fields use 126 unique words, 38 of which are absent
  from macOS's default `/usr/share/dict/words`.
- **Identifier token**: a word in a free-form field that names a skill id or a rule id. A skill id
  is accepted by resolution against `.highway/skills/`. A rule id is accepted by prefix-routed
  resolution: `D` against the development constitution, `P` against the authoring constitution, `X`
  against the experience standard.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 6 mutations from the 2026-09-11 audit are caught after this feature, up from 3 of
  6 before it — including the 3 that previously passed silently (an undeclared extra key, a
  duplicated `description:` key, and a too-short `description:` value).
- **SC-002**: `lib/schema-validate.sh` contains no hardcoded frontmatter key list or constraint that
  duplicates what the declared contract artifact states.
- **SC-003**: All 126 words measured 2026-09-11 across the 8 existing skills' free-form fields are
  accepted (by lexicon membership or identifier resolution) with zero false-positive rejections.
- **SC-004**: Adding one new required key to the declared contract, with zero lines of any script
  changed, causes at least one currently-conforming skill to fail validation.
- **SC-005**: `run-all.sh` exits 0 after every new check is added, and the suite's runtime is
  reported against the 240 second interim ceiling.
- **SC-006**: `UNCHECKED` is empty for all 8 skills after this feature.

## Assumptions

- The three questions the phase names as needing settlement before planning — the numeric lower
  bound for `description`/`usage`, the lexicon's location, and hyphenated-compound tokenization —
  are all resolved above under Clarifications, so `/speckit.plan` inherits no open question from
  this feature.
- The lexicon is seeded from the 126 words measured in use across the 8 skills' free-form fields on
  2026-09-11, not from a general-purpose dictionary; `aspell` and `hunspell` remain forbidden by
  `D2.4`'s Declared Toolchain.
- This feature is Layer 1 (Authoring). No Layer 0 (development constitution) amendment is needed:
  every check this feature adds is tagged `[SCHEMA]`, consistent with every frontmatter check that
  exists today, none of which is governed by a `P` rule.
- The historical schema file at
  `specs/001-multi-agent-skill-suite/contracts/skill-frontmatter.schema.json` is left unchanged; it
  is superseded in function, not edited, since it does not ship and nothing reads it today.
- `D3.1` and `D3.2` continue to bind: the suite passes before the first edit and after the last.

## Out of Scope

- Any Layer 3 (Architecture) content — user-authored NFRs and controls remain out of `.highway/`
  entirely and are unaffected by this feature.
- Any change to the four-layer model, the routing test, or any other phase's scope.
- General-purpose spelling correction beyond the closed set of free-form fields named in User
  Story 4 (`description`, `usage`, `agent_exceptions[].deviation`).
- Adoption of an external spell-checking dependency (`aspell`, `hunspell`, or similar); `D2.4`
  forbids introducing either.
