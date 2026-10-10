---

description: "Task list for Profile and Setup Advisory Hardening"
---

# Tasks: Profile and Setup Advisory Hardening

**Input**: Design documents from `/specs/154-profile-setup-advisory-hardening/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/delivery-sites.md, quickstart.md

**Tests**: Static document-contract tests are required by FR-018 and the quickstart. Conversational evaluation remains deferred.

## Phase 1: Setup

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing baseline in `specs/154-profile-setup-advisory-hardening/research.md`.
- [X] T002 [P] Inspect `.highway/skills/highway-profile/SKILL.md`, `.highway/governance/experience-standard.md`, `.highway/skills/highway-setup/SKILL.md`, and existing related tests to confirm current delivery sites and generated-source ownership.

## Phase 2: Foundational Test Contract

- [X] T003 Add `.highway/tools/tests/feature-154-delivery-sites.test.sh` with seeded-failure and neutralised-probe support plus assertions for all five user-story contract groups.
- [X] T004 Run `.highway/tools/tests/feature-154-delivery-sites.test.sh --probe source-document` and the neutralised probe, then record the expected failure evidence in `specs/154-profile-setup-advisory-hardening/research.md`.

## Phase 3: User Story 1 - Proposal reassurance and contribution state (Priority: P1)

**Goal**: Distinguish Converged Proposal validation from pre-contribution uncertainty guidance.

**Independent test**: The focused test passes the reassurance literals, emphasis constraints, per-domain contribution condition, and imported-evidence exclusion.

- [X] T005 [US1] Update `.highway/skills/highway-profile/SKILL.md` so Converged Proposals use the unemphasized `If this is accurate, just say so.` reassurance.
- [X] T006 [US1] Add conditional pre-contribution guidance to `.highway/skills/highway-profile/SKILL.md`, remove it after the first Substantive Contribution per active domain, and state that imported evidence alone does not count.
- [X] T007 [US1] Run `.highway/tools/tests/feature-154-delivery-sites.test.sh` and confirm the US1 assertions pass without adding a second acceptance literal or MUST-level keyword.

## Phase 4: User Story 2 - Proposed starting point and domain boundaries (Priority: P1)

**Goal**: Restore the pre-candidate heading and make cross-domain transitions collaborative.

**Independent test**: The focused test finds the new X2.72 rule and all four Profile domain heading sites, plus a boundary cue that carries material forward without prohibited error framing.

- [X] T008 [P] [US2] Amend X2.72 in `.highway/governance/experience-standard.md` to require `Here is a proposed starting point for your [domain]:` with no acceptance request following it.
- [X] T009 [US2] Replace the old reaction-heading references in `.highway/skills/highway-profile/SKILL.md` with the domain-specific proposed-starting-point heading while preserving the existing capture heading.
- [X] T010 [US2] Replace the Vision boundary cue in `.highway/skills/highway-profile/SKILL.md` with language that acknowledges value, carries the material forward, returns to Vision, and avoids user-error framing.
- [X] T011 [US2] Run `.highway/tools/tests/feature-154-delivery-sites.test.sh` and confirm the US2 assertions pass.

## Phase 5: User Story 3 - Direct approval to candidate (Priority: P1)

**Goal**: Remove the redundant contribution-review loop after unambiguous approval.

**Independent test**: The focused test confirms direct approval-to-candidate wording and preserves re-evaluation for ambiguity or new substantive information.

- [X] T012 [US3] Update the acceptance-flow guidance in `.highway/skills/highway-profile/SKILL.md` so unambiguous approval proceeds directly to candidate presentation and then validation.
- [X] T013 [US3] Add the optional materially-identical validation wording and explicit handling for ambiguous approval or approval containing new substantive information in `.highway/skills/highway-profile/SKILL.md`.
- [X] T014 [US3] Run `.highway/tools/tests/feature-154-delivery-sites.test.sh` and confirm the US3 assertions pass.

## Phase 6: User Story 4 - Advisory question scaffolding (Priority: P1)

**Goal**: Make one grounded advisory addition visible before applicable non-canonical exploratory questions.

**Independent test**: The focused test finds one grounded addition before applicable exploratory questions, preserves attribution and Working Idea handling, emphasizes only the question, and excludes canonical or validation questions.

- [X] T015 [US4] Add Profile-owned advisory-question scaffolding guidance to `.highway/skills/highway-profile/SKILL.md`, bounded to one grounded addition and excluded question classes.
- [X] T016 [US4] Add representative Profile examples in `.highway/skills/highway-profile/SKILL.md` covering a distinction, implication, tension, possibility, tradeoff, or decision criterion before an exploratory question.
- [X] T017 [US4] Run `.highway/tools/tests/feature-154-delivery-sites.test.sh` and confirm the US4 assertions pass with the question as the only emphasized element.

## Phase 7: User Story 5 - Welcome-first Setup (Priority: P1)

**Goal**: Prevent procedural preambles before the existing fresh Setup welcome.

**Independent test**: The focused test confirms the welcome is first for fresh Setup, prohibited preambles are absent before it, and resumed Setup remains excluded.

- [X] T018 [US5] Update `.highway/skills/highway-setup/SKILL.md` so no review, loading, supplied-website, checking, or setup-order narration precedes the existing welcome block.
- [X] T019 [US5] Run `.highway/tools/tests/feature-154-delivery-sites.test.sh` and confirm the US5 assertions pass.

## Phase 8: Regeneration and cross-cutting validation

- [X] T020 Run `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-agent-adapters.sh`, and `.highway/tools/generate-instructions.sh` after source edits; do not hand-edit generated files.
- [X] T021 [P] Audit changed Profile, Setup, and Experience Standard text for ownership violations, prohibited retired literals, duplicated acceptance requests, MUST-level keywords in Profile, and any `specs/` or `.specify/` references in shipped artifacts.
- [X] T022 [P] Verify every requirement in `specs/154-profile-setup-advisory-hardening/contracts/delivery-sites.md` has a focused assertion or an explicitly recorded human-review/deferred-evaluation status.
- [X] T023 Run `.highway/tools/tests/run-all.sh` and record pass count, duration, and separate coverage claims in `specs/154-profile-setup-advisory-hardening/research.md`.
- [X] T024 Walk `specs/154-profile-setup-advisory-hardening/quickstart.md` end to end and record that its expected values match the implementation.

## Dependencies and execution order

- T001-T004 are foundational and must complete before story work.
- US1, US2, US3, US4, and US5 are independently implementable after T004, except T008 and T009 both touch the heading contract and should be coordinated sequentially.
- T020-T024 require all story work to be complete; T023 is the final executable validation.

## Parallel opportunities

- T002 can run in parallel with T001.
- T008 can run in parallel with T010; T009 follows T008 for consistent heading wording.
- T015 and T018 can run in parallel because they touch different source files.
- T021 and T022 can run in parallel after regeneration.

## Implementation strategy

Deliver the document-contract MVP through US1 and US2 first, then complete the approval and advisory
workflow slices, then the Setup welcome ordering. Finish by regenerating all declared outputs and
running the full suite. Do not claim runtime conversational success from static checks; record that
human evaluation remains deferred.
