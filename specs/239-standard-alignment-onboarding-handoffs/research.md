# Research: Standard Alignment Onboarding Handoffs

No item in Technical Context was left as NEEDS CLARIFICATION. The decisions below settle what the spec
left to the plan.

## R1. How highway-onboarding reaches each owner

**Decision**: Each owner gains a `### onboarding` step. A sentence before its Entry list routes there:
"When `highway-onboarding` hands off …, go to `onboarding`." The numbered Entry cases are not renumbered,
because `choose` steps and tests cite them ("follow Entry from case 3").

**Rationale**: The handoff is a caller naming the owner's step, which is how the skills already hand off
(`highway-codify-config` → `add capabilities`, `highway-codify` → `delivery platforms`). A sentence before
the list keeps every existing case number.

**Alternatives considered**: a new numbered case 1 (renumbers every case and its citations); routing by
an invocation keyword such as `onboarding` (a person could type it, which is not intended).

## R2. What each entry step reuses and what it adds

**Decision**:

- **highway-adr `onboarding`**: takes the provider, the capabilities, the decision, the alternatives, the
  rationale, and the limitations. It derives the id as `identifier` does and reuses an existing record
  with the same title. When the id is taken by a different title, it adds the provider name to the title
  and derives again, without asking. It writes as `write` does, with the onboarding values moved
  verbatim from onboarding's `orchestrate`: `request: onboarding`, `discovery: highway`, the Discovery-only
  values `None`, alternatives by name, and Selection Source `Accepted onboarding mapping`. It then returns
  the id. The catalog rule "Each Discovery ID appears on at most one row" gains "except `highway`".
- **highway-architecture `onboarding`**: takes an accepted ADR id. When the ADR already names an
  architecture, it returns that id and writes nothing. Otherwise it builds the architecture as `start`
  does without emitting it, and derives the title and id as `identifier` does. It asks only the
  `identifier` purpose question or the `title` question, in the FR-021 cases. Then it runs `write` and
  `name`, and returns the `RA` id.
- **highway-implementation `onboarding`**: takes an accepted `RA` id, the provider, and the capabilities.
  It builds the realization as `start` does without emitting it and without `execution`, with Execution
  `Needed` ×3. It derives as `identifier` does and asks only the `title` question in the FR-021 case. It
  then runs `write` and `platforms`, and returns the `RI` id and whether the platform was included.

**Rationale**: Each owner already holds the shape, ids, and catalog rules. Only the onboarding-specific
values are new to it, and they move word for word, so FR-009 holds.

**Alternatives considered**: a separate onboarding template per owner (it would duplicate the shape and
was ruled out by "templates are fixed").

## R3. The retry and the decline

**Decision**: highway-onboarding owns the retry. When an owner says its record could not be written or
named, onboarding follows that owner's `onboarding` step once more. When it fails again, onboarding keeps
the earlier records, says which record could not be written or named, and does not claim completion. A
`decline` at an owner's title question returns to onboarding with no record. Onboarding then stops that
provider and keeps the earlier records, as it does for a failure.

**Rationale**: The retry is about the whole chain, which only onboarding sees. The owners keep their own
"a failed write leaves every byte unchanged" rule.

**Alternatives considered**: a retry inside each owner (it would hide a failure from the chain, and the
direct invocation has no retry today).

## R4. The ADR catalog Architecture ID gap

**Decision**: highway-architecture's `name` sets the ADR's `Reference Architecture` field and that ADR's
Architecture ID in `adrs/adrs.md` to the `RA` id, in one write, and changes no other ADR or catalog byte.
The seeded check adds `adrs/adrs.md`. "When not to use" becomes "Do not change the ADR or its catalog
row, except its Reference Architecture field and its Architecture ID." Entry case 6 still goes to `name`
when the field is `None`, so a rerun repairs both.

**Rationale**: Today only onboarding sets the catalog cell. A direct run leaves `None`, so the two paths
disagree (SC-004). `choose` lists ADRs with Architecture ID `None` and no architecture-catalog cell, so it
is unaffected.

**Alternatives considered**: setting the cell in `write` (that would split the ADR update across two
steps and two failures).

## R5. The execution chain

**Decision**: The implementation `onboarding` step says: "This visit returns only to `highway-onboarding`.
Do not go to a step another `highway-implementation` visit holds." Onboarding keeps "When the caller named
the return step `execution`, go to `execution` in `highway-implementation`" after the implementation step
returns, with "Do not ask to configure. Do not continue the queue."

**Rationale**: The outer visit's `field` step holds `execution`. The nested entry step must not pick it up.
Only onboarding returns there, as it does today.

## R6. Moving the templates

**Decision**: `mv` each template after `cmp` against a `/tmp` copy. `hw_template` points the three names at
`$HW_SKILLS/<owner>/assets/`. `HW_LIBRARY` and `HW_OUTPUT_TEMPLATES` are removed from `paths.sh`, and
their last users change:

- `validation-cache.sh` (the environment key);
- `library-containment.test.sh`, `profile-convergence-behavior.test.sh`, and `harness-path-map.test.sh`;
- `record-templates.test.sh`;
- seven tests that joined `$HW_OUTPUT_TEMPLATES` with a record name, which now use `hw_template`.

The `.highway/library/` folder is removed.

**Rationale**: FR-002 forbids naming the folder. A variable for a folder that no longer exists invites a
dangling path.

## R7. P9.1 and the orphan fixtures

**Decision**: P9.1 drops its `.highway/library/templates/output/` branch, and its message names only
`assets/`. `tests/fixtures/output-template/` is removed. No test reads it (checked in Phase 9). Its four
files include the only fixtures that cite the old folder, and its two `SKILL.md` fixtures already
failed validation on schema findings. Two orphan profile fixtures that named
`.highway/library/knowledge/profile.md` now name the project path `library/knowledge/profile.md`;
their verdicts are unchanged.

**Rationale**: FR-002. Keeping the branch would leave a script naming the folder. Removing the fixtures
first means no verdict changes for any remaining skill or fixture (D3.4).

**Alternatives considered**: rewriting the fixtures to cite `assets/` (it would need an `assets/` folder
in an orphan fixture that nothing uses).

## R8. Harness selection and the manifest

**Decision**: `path-map.sh` drops `REL_LIBRARY` and its arm, because a moved template maps through the
existing skill arm ("is part of highway-adr"). `select.test.ts` line 31 uses
`skills/highway-adr/assets/adr-record.md`. `harness-path-map.test.sh` replaces its library "names" checks
with the asset mapping for the three moved templates, and its multi-skill check with the scenario
union: a change to `adr-record.md` selects adr-smoke and chain-architecture. The manifest drops the
`.highway/library` rows; the skill rows already ship each `assets/` folder.

## R9. Tests that move with the rules

**Decision**:

| Test | Change |
|---|---|
| adr-record-completeness | the onboarding ADR texts → `$ADR`; the Reference Architecture texts → `$ARCHITECTURE`; the old template path → `assets/adr-record.md` is rejected in architecture |
| multiple-reference-implementations | `Do not set an implementation id.` and `does not name an implementation` → `$ARCH`; `Do not ask whether a decision replaces or runs beside another.` → `$ADR` |
| code-project, delivery-platform-handoff | Execution `Needed` texts → `$IMPL` |
| codify-platform-catalog | `follow platforms in highway-implementation` → onboarding names `onboarding` in `highway-implementation`, and that step goes to `platforms` |
| output-template | adr names `assets/adr-record.md`; no skill cites `.highway/library/templates/output/` |
| record-templates | 14 owners; `.highway/library` absent; no skill names `.highway/library/` |
| harness-path-map, library-containment, profile-convergence-behavior | `HW_LIBRARY` removed |
| adr-span-progression, establish-from-record, record-purpose-titles, single-noun-capabilities | `hw_template` |

The new `onboarding-handoffs.test.sh` checks:

- the three entry steps and their routing sentences;
- the hand-off order in onboarding;
- the removed onboarding text;
- the title-question limit;
- the Discovery ID exemption;
- `name` setting the catalog Architecture ID, and the seeded check;
- the nested-return sentence;
- the four MINOR versions against the base branch.

Its seeded probe deletes the routing sentence from a copy of highway-adr and requires a failure.

**Rationale**: FR-015. Each moved rule keeps one assertion, against its new holder (D3.5).

## R10. Harness scenarios

**Decision**:

- **onboarding-smoke** adds `through:` highway-adr, highway-architecture, and highway-implementation. It
  adds a `template` expect for `adrs/ADR*.md`, `architectures/RA*.md`, and `implementations/RI*.md`,
  and `expect: row adrs/adrs.md :: RA0`.
- **chain-architecture** adds `expect: row adrs/adrs.md :: RA0`.
- **implementation-onboards-platform** (new) uses the `architecture` fixture and goes through
  highway-onboarding, highway-adr, and highway-architecture:
  1. It opens `/highway-implementation` for the restock architecture with Deployed by a platform that has
     no implementation.
  2. That starts onboarding, which accepts three blocks and returns to `execution`.
  3. The implementation is accepted, and the scenario declines the configure question.
  4. It expects both implementations against the template and `reaches: start`.

**Rationale**: FR-016. Static checks run in the suite; a live run needs a token.

## R11. No constitution amendment

**Decision**: None. The Highway Skills Constitution and the development constitution name neither these
templates' location, nor onboarding's record writing, nor the ADR catalog Architecture ID (checked with a
grep for `adr-record`, `templates/output`, and `Architecture ID`). FR-018 is satisfied without a change.

The development constitution's glossary still lists `.highway/library/` under Shipped artifact and the
Skill Content Gate trigger. Both are about `.highway/` as a whole, which Phase 11 removes, so that phase
amends them. An empty, unshipped folder is not a shipped artifact, so neither definition is wrong after
this change.
