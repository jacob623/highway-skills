# Research: Simplify the Objectives Skill

## Decision: Skill 3.0.0, record template unchanged

**Decision**: `.highway/skills/highway-objectives/SKILL.md` moves from metadata version 2.0.0 to 3.0.0. `.highway/library/templates/output/objective-record.md` stays at template version 1.0.0. `.highway/library/templates/output/objective-catalog.md` stays unchanged.

**Rationale**: Discovery, recommendation acceptance, continuation, and verification break the current skill contract. The Skill Versioning Policy treats that as MAJOR. The retained fields remain Statement, Success Measures, and Rationale, so the record template is still compatible.

**Alternatives considered**: Bumping the record template because Highway Relevance is new. Rejected because Highway Relevance is discovery context and is not stored. Leaving the skill at 2.0.0. Rejected because existing callers of Outcome, Success, and Significance no longer match the contract.

## Decision: One Experience sentence

**Decision**: The Experience section is exactly `User-visible interaction follows the Highway Experience Standard.` Checks that require Objectives to restate implementation details, User Exits, Owner Outcomes, or Resume Applicability are updated so Objectives is exempt in the same way Profile is exempt. The Experience Standard is not amended.

**Rationale**: The spec removes those restatements from the skill and leaves them with the Experience Standard. `.highway/tools/tests/highway-ux-alignment.test.sh` and `.highway/tools/tests/experience-x23-contract.test.sh` currently require the restatements. Those assertions are replaced and the old requirement is named as superseded.

**Alternatives considered**: Keeping the restatements so the current tests stay green. Rejected because the spec forbids them. Editing the Experience Standard so the tests no longer look at Objectives. Rejected because the standard already owns the rules.

## Decision: Ask once after a multi-selection

**Decision**: During setup and configure, a selection of several or all displayed recommendations is captured together. Highway then asks `**Is there another objective you'd like to capture?**` once. It does not ask that question between Objectives in the same selection. A single captured Objective is still followed by that question. Add and new capture the selection and end without the question.

**Rationale**: Clarification on 2026-09-29 chose capture-then-ask-once. Asking between selected items would interrupt a direct capture. Ending the session on a multi-selection would finish collection without an explicit finish.

**Alternatives considered**: Asking after every selected Objective before capturing the next. Rejected by the clarification. Treating a multi-selection as an explicit finish. Rejected by the clarification.

## Decision: Update only Setup's quoted opening

**Decision**: `.highway/skills/highway-setup/SKILL.md` drops the quoted sentence `If you'd like some suggestions based on your organization's Profile, just let me know.` The broad question and the uncertainty sentence stay in that quotation. Setup still renders the Objectives-owned opening and does not author Objective questions. Setup's version is unchanged. Its purpose introduction, Controls handoff, and NFR handoff stay.

**Rationale**: Setup currently records the opening this feature removes. Leaving that quotation would describe a behavior the Objectives skill no longer has. The change is limited to that quotation and the sentence that presents it as the only opening. When accepted Profile evidence supports a useful recommendation, Objectives offers that recommendation before the broad question.

**Alternatives considered**: Leaving Setup untouched. Rejected because the quotation would keep the removed sentence. Redesigning Setup's delegation. Rejected because Setup already forwards the owner opening unchanged.

## Decision: No post-write byte check

**Decision**: Persistence is successful atomic persistence of the record and catalog. The skill does not require a shell check, a file-existence check, a byte-equality check, or a retained-output check whose purpose is confirming the write. Baseline validation, duplicate and overlap handling, permanent identifiers, deterministic catalog generation, and atomic mutation stay.

**Rationale**: The spec removes post-write verification from the skill. A failed mutation remains under the common failure model and is not given a second procedure in this skill.

**Alternatives considered**: Keeping byte verification under a shorter name. Rejected because the spec removes that requirement.
