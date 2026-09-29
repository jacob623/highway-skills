# Research: Revise the Runtime Experience Standard

## 1. Which files change

**Decision**: Edit `.highway/governance/experience-standard.md` and `.highway/governance/constitution.md` only.

**Rationale**: The 2026-09-29 clarification chose the Experience Standard and the Skills Constitution. X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, and X6.1 move into the constitution. A later instruction cleared the development-process exceptions, so tests and live citations of the removed contract or retired identifiers change in the same work. Skill domain workflows, shared templates, and the development constitution stay unchanged.

**Alternatives considered**: Experience Standard only, which would drop the seven obligations with no new home. Including skill rewrites now, which the source instructions sequence after this standard is authoritative.

## 2. Where the seven obligations live

**Decision**: Add them to Principle IX as P9.2 through P9.8. Do not open a new principle. Do not change the precedence table.

| New ID | Former ID | Rule text |
|---|---|---|
| P9.2 | X1.1 | A skill MUST declare the shape of what it emits. |
| P9.3 | X1.2 | A skill MUST emit content in its declared shape. |
| P9.4 | X1.3 | An empty result MUST have a declared form. |
| P9.5 | X1.4 | A specimen MUST agree with the metadata it repeats. |
| P9.6 | X1.5 | A retained file artifact MUST include frontmatter. |
| P9.7 | X4.1 | A skill that writes a file MUST declare its path. |
| P9.8 | X6.1 | A retained artifact MUST derive its content from declared inputs. |

**Rationale**: These obligations already apply to shipped skills, so a skill that satisfies them still satisfies them. That is a minor constitution amendment, 4.0.0 to 4.1.0. A new principle inserted into precedence would change which rule prevails and would be major. Principle VI stays about which action is selected. P9.8 is about what a retained artifact contains, so it sits with the other output rules. P6.6 is not redefined.

**Alternatives considered**: A new Principle XIII at the lowest rank. It would avoid reordering existing ranks, and it would still add a principle the conflict procedure has to read. Principle IX already owns emitted shape.

## 3. Tier of the moved rules

**Decision**: Tag P9.5 `[auto]` and retarget the existing specimen check so it reports under P9.5. Tag P9.2, P9.3, P9.4, P9.6, P9.7, and P9.8 `[agent-checkable]`.

**Rationale**: The inventory honesty check fails when a constitution rule is tagged `[auto]` and no check reports under that identifier. The specimen obligation already has a check. Reporting that check under P9.5 keeps the tier honest. The other six moved obligations have no check, so they stay agent-checkable.

**Alternatives considered**: Leave the check reporting under X1.4. X1.4 would no longer be a current rule, and the lexicon test that requires X1.4 to exist would fail.

## 4. Experience Standard tables the parser can still read

**Decision**: Keep a tier column on every remaining and new X rule. Remove the Sample column, the N/A token table, and PASS/FAIL/N/A review instructions. Add no `[auto]` X rule. X1.4 leaves, so no current X rule claims a registered check.

**Rationale**: The shipped parser reads an X row as identifier, rule, observable, and tier. A row without a tier is a malformed-rule error. The spec removes enforcement-tier registration and review vocabulary. The column the parser requires is not that review procedure.

**Alternatives considered**: Delete the tier column with the review procedure. The shipped validator would then reject the standard.

## 5. One interaction model

**Decision**: Delete the Interactive Workflow UX Contract, including resume states, owner-outcome tokens, and the ownership display. Replace it with one short ordered model of the eleven steps in the spec. The X rules hold the obligations. The model does not restate each rule.

**Rationale**: The spec forbids a second prose contract that substantially restates the rules. Resume and generic ownership already belong to the owning skill and the constitution's owner/orchestrator rules. This change does not add a second copy of those rules.

**Alternatives considered**: Keep the long contract and mark it non-normative. It would still restate the interaction rules.

## 6. Which X identifiers stay, change, or arrive

**Decision**: Retire X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, and X6.1 as current rows. Redefine X1.6, X2.1 through X2.10, X5.1, and X5.2 in place where the spec changes the behavior. Add X1.7 and X2.11 through X2.31 for obligations that have no current row. Do not reuse a retired identifier.

X1.6 keeps its current rule sentence. X2.3's observable keeps the sentence "Every user-visible response excludes Implementation details unless requested." and adds the wider implementation-detail list from the spec.

**Rationale**: The spec says presentation labels, irreversible-loss confirmation, and addressable messages stay because the person sees them. The two preserved sentences remain true, so the amendment does not delete them only to force a test edit.

**Alternatives considered**: Renumber the surviving X2 rules. Retired identifiers would be reused or the historical reports would become the only map, and both outcomes fight the versioning policy.

## 7. Versions and dates

**Decision**: Experience Standard footer `**Version**: 3.0.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-09-29`. Skills Constitution footer `**Version**: 4.1.0 | **Ratified**: 2026-09-06 | **Last Amended**: 2026-09-29`. Prepend one sync impact report to each file. Keep the older reports.

**Rationale**: Removing and redefining X rules is major under the Experience Standard versioning policy. Adding P9.2 through P9.8 without invalidating a skill that already met those obligations is minor under the constitution versioning policy. Ratified dates stay. The amendment date is 2026-09-29.

**Alternatives considered**: Call the constitution change major because the rules move up a precedence layer. Their obligations do not get stricter, and principle ranks do not move, so the minor classification matches the spec.

## 8. Shipped tokens and citations

**Decision**: Neither shipped file gains `.specify/` or `specs/`. The Experience Standard stops naming the development constitution as a runtime dependency. It cites Highway identity and platform objectives by their shipped document names and does not restate them. Current sections stop citing constitution rules removed by the 4.0.0 amendment.

**Rationale**: Both files ship. A development path in either file fails the packaging gate. The spec requires those citations to leave.

**Alternatives considered**: Leave the scope sentence that names the development constitution. That sentence is a runtime-facing dependency the spec removes.
