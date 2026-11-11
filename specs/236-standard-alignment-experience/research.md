# Research: Standard Alignment highway-experience

All decisions below were made from the repository as it stood on 2026-11-11 after spec 235, and from
the clarifications recorded in [spec.md](spec.md). No item is left open.

## R1. highway-experience's folder and how its files arrive

- Decision: create `skills/highway-experience/` with `SKILL.md` and `references/`.
  `.highway/library/knowledge/highway-identity.md` moves to `references/highway-identity.md` and
  `.highway/governance/experience-standard.md` to `references/experience-standard.md`, both with
  `mv`, byte for byte. `.highway/governance/storage.md` moves to `references/storage-contract.md`
  and then takes the edits in R2.
- Rationale: neither the Experience Standard nor the Highway Identity names an old path (searched
  for `.highway`, `governance/`, `storage`, `instructions`, and `framework`), so FR-002 is met with no
  content edit. `mv` keeps history readable and stages nothing.
- Alternatives considered: copying and leaving the originals until a later phase. Rejected: two
  sources drift, and the exit condition says `.highway/governance/` is gone.

## R2. The storage contract's new content

- Decision: `references/storage-contract.md` keeps every section of `storage.md` unchanged in
  meaning, moves from version `1.0.0` to `1.1.0`, and gains:
  1. In Scope: a skill reading its own bundled files, and a skill activating highway-experience, are
     not repository operations. The four operations govern every read and write of the project.
  2. A `## Mode record` section: the project records its mode in `library/knowledge/storage.md`. A
     skill reads that file with "Read a file" before its first other repository operation. An absent
     file means Local. A record naming any mode other than Local stops the skill before any other
     repository read or write; the skill says the recorded mode is not supported yet and names Local
     as the supported mode.
  3. The Modes section's "Every run uses Local." becomes "A run uses Local unless the mode record
     names another mode." so the two sections agree.
- Rationale: FR-005 to FR-007 and the second clarification. The record is a project file, so the
  paths rule (relative to the repository root) already covers `library/knowledge/storage.md`.
- Alternatives considered: falling back to Local for an unsupported record (rejected in
  clarification); detecting the mode without a record (deferred to the Chat phase of the rollout).

## R3. The activation step and the other skill edits

- Decision: the activation sentence, identical in all 15 skills, is:

  > Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

  It is the first non-blank line under `## Procedure`, as its own paragraph. highway-help has no
  Procedure, so it gains `## Procedure` holding only that sentence, between Outputs and Verification,
  where every other skill places it.
- Other edits, limited by FR-018:
  - Inputs: the line `` - `.highway/governance/experience-standard.md`. `` becomes
    `- The highway-experience skill, activated first.` (P1.5 names every dependency in Inputs).
    highway-help, which had no such line, gains it. highway-profile drops its
    `.highway/library/knowledge/highway-identity.md` line, since the identity now arrives through
    activation.
  - Procedure prose: ``Follow `.highway/governance/experience-standard.md` for attribution and
    acceptance wording.`` becomes `Follow the Highway Experience Standard for attribution and
    acceptance wording.` in the seven skills that carry it.
  - Version: MINOR for each skill (third clarification, as amended): adr 6.1.0, architecture 5.2.0,
    assessment 5.1.0, codify-config 3.6.0, codify 14.2.0, controls 8.1.0, discovery 5.1.0, help
    3.2.0 (its Example's `Version:` line follows, per P9.5), implementation 7.10.0, nfrs 9.2.0,
    objectives 8.1.0, onboarding 10.7.0, profile 14.1.0, request 5.1.0, setup 10.1.0.
- Rationale: one sentence lets the bash test match exactly (first clarification). Naming the skill in
  plain text is the portable form until Phase 12. The sentence has no MUST, so P1.3 does not count it,
  and it stays at 23 words.
- Alternatives considered: a `###` step heading. Rejected: the coverage inventory treats each `###`
  heading as a step, so 15 new identical steps would appear in every coverage section, unreached.

## R4. Agent copies of bundled files

- Decision: `generate-agent-adapters.sh` copies every file in a skill's folder, not only `SKILL.md`,
  to the same relative path in each agent tree, with one adapter-manifest row per copied file. The
  drift check covers every copied file. `adapter-coverage.test.sh` derives the expected adapter files
  from the source folder's files, so each reference has a copy, a manifest row, and a currency check
  in all four trees.
- Rationale: an agent copy at `.github/skills/highway-experience/SKILL.md` that says "read
  `references/experience-standard.md`" needs that file beside it. The generic form also covers the
  `assets/` folders Phase 8 adds.
- Alternatives considered: copying `references/` only for highway-experience. Rejected: a special
  case in a generator that has none today.

## R5. The harness invariant

- Decision:
  - The driver records `skillsBeforeOutput`: the skills invoked before the first output the person
    sees. The first output is the first question sent to the person, or the first top-level assistant
    message with non-empty content and no tool requests. With no output at all, the list holds every
    skill invoked.
  - `checks.ts` gains `experienceInvariant(skillsBeforeOutput)`, which fails when
    `highway-experience` is not in the list.
  - `failure.ts` gains the kind `experience-order` with its likely cause.
  - The runner applies the check to every attempt whose outcome is not `error`, since an errored
    session already fails with its own cause. Each chain stage is its own attempt, so each stage is
    checked.
- Rationale: FR-010 and SC-005. A message that carries a tool request is narration attached to a
  tool call, which agents commonly emit when they load a skill. Counting it would fail runs that
  activate highway-experience correctly.
- Alternatives considered: checking only that highway-experience loaded at some point. Rejected: it
  would pass a run that showed output first, which is what FR-010 forbids.

## R6. Harness selection

- Decision: `harness/selection/shared.txt` lists `smoke skills/highway-experience/**` and drops its
  four old rows. `path-map.sh` drops its governance and instructions locations and the `AGENTS.md`
  arm. `harness-path-map.test.sh` expects `smoke` for highway-experience's `SKILL.md` and each
  reference, and its "every shipped file maps" scan covers the library tree.
- Rationale: shared rows are matched before the skills-folder rule, so one row sends every
  highway-experience file to the smoke set, because every skill loads it (FR-012).

## R7. A smoke scenario for highway-experience

- Decision: add `harness/scenarios/highway-experience/experience-smoke.scenario`. It opens
  `/highway-experience` from the `setup` stage fixture, declares no `writes:`, and has no replies. The
  storage invariant then requires that no file changes.
- Rationale: `harness-scenarios.test.sh` requires exactly one smoke scenario per skill, and the
  scenario exercises the direct invocation (User Story 1, scenario 6).

## R8. The paths helper and the path-construction check

- Decision: the helper drops `HW_INSTRUCTIONS`, `HW_GOVERNANCE`, `HW_CURSOR_RULES`, `HW_CLAUDE_MD`,
  `HW_COPILOT_MD`, and `HW_AGENTS_MD`. It adds `HW_EXPERIENCE` (`$HW_SKILLS/highway-experience`), and
  `hw_doc` resolves `experience-standard`, `storage`, and `highway-identity` to its `references/`.
  `HW_KNOWLEDGE` stays for `assessment-findings`.
  `path-construction.test.sh` drops `governance` and `instructions` from rule 2's `.highway` segments,
  and rule 4 names `HW_EXPERIENCE` in place of `HW_GOVERNANCE`.
- Rationale: FR-011. Tests that need an always-on file's path (to assert it is absent) name it as a
  literal relative path joined to `HW_ROOT`, which no rule matches.
- D3.5: the two rule-2 segments are removed because the folders no longer exist. Rule 4 keeps its
  strength: a named document joined to highway-experience's folder is flagged the way one joined to
  the governance folder was.

## R9. Validator verdicts and the cache key

- Decision: the validator reads the X rules through `hw_doc experience-standard`, so it follows the
  move with no code change. `vc_environment_hash` replaces the governance-folder `find` with
  `hw_doc experience-standard`. The key changes once.
- D3.4 evaluation: no rule is added or changed in a check. Every skill's and fixture's verdict is
  recorded with `--no-cache` before the move and compared after it. The only expected differences are
  the version lines (SC-004).
- Rationale: the storage contract and the Identity are not validator inputs, so only the Experience
  Standard joins the key.

## R10. Tests removed, amended, and added

- Removed, with their only subject (D3.5: the behavior they checked no longer exists):
  `generate-instructions.test.sh` (the generator) and `instruction-coverage.test.sh` (the generator's
  sources, outputs, and manifest rows).
- Amended:
  - `storage-contract.test.sh`: reads the new contract; checks the bundled-file, mode-record, and
    unsupported-mode text and that the contract ships; checks P2.6's new text; drops the
    agent-context section.
  - `adapter-coverage.test.sh`: bundled-file adapters; no instruction regeneration.
  - `generate-agent-adapters.test.sh`: the fixture skill carries `references/sample.md`, and each
    tree must hold a byte-identical copy with a manifest row; the instruction-output guards become
    "no `.cursor/rules/highway-*.mdc` exists".
  - `harness-path-map.test.sh` and `path-construction.test.sh`: as R6 and R8.
  - `run-all.sh`: drops the instruction residue sweep.
- Added: `experience-activation.test.sh`. It checks:
  - highway-experience's folder holds exactly three references;
  - its `SKILL.md` states the two moved rules and its description is written for its supporting role;
  - every other skill's first Procedure line is the exact sentence and no skill names an old path;
  - the four always-on files, the instruction source, the generator, and its manifest are absent, and
    the distribution manifest has no row for any of them.

  Its seeded probe is a temporary skill without the sentence, which must fail.
- Suite count: 82 − 2 + 1 = 81.

## R11. Constitution amendments

- Highway Skills Constitution 10.1.0 → 10.2.0 (MINOR, first clarification):
  - P2.6's rule text names highway-experience's storage contract.
  - P10.1's Observable says the Experience Standard is highway-experience's reference.
  - The Repository Context note names `references/highway-identity.md` in highway-experience.
  - No rule is added, and no verdict changes, because the P2.6 check reads no path from the rule
    text.
- Development constitution 3.2.0 → 3.3.0 (MINOR):
  - Definitions: Shipped artifact drops `.highway/governance/`.
  - Enforcement Map: the D4.7 note drops `generate-instructions.sh`.
  - Declared generators: drop `generate-instructions.sh`.
  - Both changes are recorded with a self-application review.

## R12. Live documents

- Decision: update the following in the same change (FR-017, D6.1):
  - `README.md`: the always-on instruction bullet goes; a highway-experience bullet is added.
  - `framework/README.md`: the `.highway/` tree, the cache inputs, the generator section, and the
    paths list.
  - `framework/authoring-standard.md`: the storage contract's location, and the activation step.
  - `harness/README.md`: the project contents, the storage reference, the invariant, and selection.
  - `governance-plan.md`: the Layer 2 location.
  - `standard-alignment.md`: the Phase 7 status.
- Historical specs and sync reports keep their paths.

## R13. Frontmatter lexicon (found during implementation)

- Decision: add `contract`, `experience`, `holds`, `identity`, `loaded`, `other`, `standard`,
  `storage`, `summary`, and `unrelated` to `framework/frontmatter-lexicon.txt`. FR-004's
  description cannot be written from the existing closed word list.
- Rationale: none of the ten words appears in a fixture's description or usage, so every skill and
  fixture keeps its findings (D3.4). `output` was tried first and dropped: two
  `tests/fixtures/output-template/` fixtures use it as a seeded unrecognized word, and adding it
  removed one finding from each.
- Alternatives considered: a description from existing words only (could not say "identity" or
  "loaded by the other skills").
