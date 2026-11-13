# Implementation Plan: Principle XIV, Agent Skills Alignment

**Branch**: `245-standard-alignment-principle-xiv` | **Date**: 2026-11-13 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/245-standard-alignment-principle-xiv/spec.md`

## Summary

Phase 15 of `standard-alignment.md`. The Highway Skills Constitution gains Principle XIV. It holds
P5.15, moved unchanged, and four new `[auto]` rules, P14.1 to P14.4, covering the twelve flow
pattern boundaries. Each rule names the Agent Skills specification clause it narrows.

- Checks: `rc_check_P14_1` to `rc_check_P14_4` in `framework/lib/rule-checks.sh`, ported from the
  retired test's `check_skill`. Each check judges the whole skill folder from its `SKILL.md` and
  returns N/A for any other file.
- Constitution 10.5.0: five definitions, Principle XIV, precedence rank 12, a Sync Impact Report,
  and a Self-Application sentence. Rule count goes from 76 to 80.
- Tests:
  - `tests/rule-checks.test.sh` gains the twelve seeded boundary cases and four cases in a skill
    without `references/`.
  - `tests/skill-flow-pattern.test.sh` is deleted.
  - The rule count test expects 80.
- Cache: the key covers the skills a handoff names and fails closed (VC-12 to VC-15).
- Docs: the authoring standard cites P14.1 to P14.4. `standard-alignment.md` marks Phase 15
  complete.

No skill file changes.

## Technical Context

**Language/Version**: Bash 3.2.57 (D2.1). Markdown for the constitution and documents.

**Primary Dependencies**: the Declared Toolchain (awk, sed, grep, find, wc, sort, shasum or
sha256sum).

**Storage**: files.
- `framework/constitution.md`, `framework/lib/rule-checks.sh`,
  `framework/lib/validation-cache.sh`, and `framework/authoring-standard.md`.
- Under `tests/`: `rule-checks.test.sh`, `validation-cache.test.sh`, and
  `constitution-experience-alignment.test.sh`.
- `standard-alignment.md`.

**Testing**: `bash tests/run-all.sh`, which runs 87 tests today and 86 after. It needs an
unsandboxed shell and takes about 9 minutes.

**Target Platform**: macOS (Apple/BSD utilities) and Linux (GNU) (D2.3).

**Project Type**: an authoring framework (validator, generators, tests) for a set of Agent Skills.

**Performance Goals**: validating one skill with the cache off stays within about 2 seconds. Each
check reads only its skill folder and the skills its handoffs name.

**Constraints**:
- No skill change.
- No backward compatibility.
- MINOR bumps only.
- No commit unless asked.
- `rollout-plan.md` stays gitignored and excluded.
- Use `mv`, not `git mv`.
- Generators run only from `skills/`.

**Scale/Scope**: 16 skills, 4 new checks, 1 retired test, 5 amended tests (`bundled-files` and `generate-agent-adapters` added during implementation), and 4 framework files.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (development constitution 3.5.0)

| Gate | Triggered | Verdict |
| --- | --- | --- |
| Packaging (D1.1, D1.2, D1.6) | Yes: `framework/constitution.md` and `framework/lib/*.sh` ship | PASS by design: no new file, so the distributed path set is unchanged. The checks name no development path. Cross-skill handoffs resolve against the sibling folders, so `distribution-packaging.test.sh` validates the verification tree against its own `skills/`. |
| Non-restatement (D1.3, D1.4) | Yes | PASS: the authoring standard cites P14.1 to P14.4 and repeats no rule sentence. Principle XIV links the specification and restates none of it. |
| Toolchain (D2.1 to D2.5) | Yes: two libraries and two tests change | PASS by design: Bash 3.2, with no associative array or `mapfile`; arrays are built with `while read`. Declared utilities only. Paths come from `paths.sh` and from the argument given. |
| Generator (D4.1 to D4.4) | No: no `generate-*.sh` changes | N/A |
| Correspondence (D4.5 to D4.7) | No skill input changes | PASS: both generators run twice and change nothing (FR-017). |
| Validation (D3.4 to D3.7) | Yes: four new checks | D3.4: each check runs against the 16 skills and every `tests/fixtures/*/SKILL.md` before registration (research R10). D3.5: the retired test's twelve seeds are reproduced unchanged, and its removal is recorded (R8). D3.6: the seeded cases and VC-12 to VC-15 are observed failing first. D3.7: binds the Enforcement Map's D rules, none of which change. P rules are held by the inventory test's registered-check assertion (R7). |
| Documentation (D6.1, D6.2, D5.3) | Yes | PASS: the authoring standard and `standard-alignment.md` are updated in the same change. The Sync Impact Report lists every changed element. |
| Agent Skills (D3.9) | No: the validator's specification checks are unchanged | N/A |

Also applied:
- D3.1: the baseline suite runs before the first edit.
- D3.2: the full suite runs after the last edit.
- D3.3: `tests/` changes.
- D7.3: the completion report states requirement coverage apart from check results.

### Skill content gates (Highway Skills Constitution)

N/A: Skill Content Gate not triggered. No skill or file a skill bundles changes (D1.5). Every skill
is validated against the new rules as evidence (SC-001), not as a gate on changed content.

Post-design re-check: unchanged. No FAIL, no exception.

## Project Structure

### Documentation (this feature)

```text
specs/245-standard-alignment-principle-xiv/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── principle-xiv.md
│   ├── rule-checks.md
│   └── validation-cache.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
framework/
├── constitution.md                 # 10.5.0: Definitions, XIV, precedence, sync report
├── authoring-standard.md           # cites P14.1–P14.4 (line 201)
└── lib/
    ├── rule-checks.sh              # rc_check_P14_1..4, helpers, registry rows
    └── validation-cache.sh         # vc_hash_list, vc_key, vc_environment_hash fail closed
tests/
├── rule-checks.test.sh             # 12 boundary seeds + 4 no-references seeds
├── validation-cache.test.sh        # VC-12..VC-15
├── constitution-experience-alignment.test.sh   # 76 → 80
└── skill-flow-pattern.test.sh      # deleted
standard-alignment.md               # Phase 15 complete, Status paragraph
```

**Structure Decision**: the checks live where every other rule check lives. No new file ships.

## Complexity Tracking

No violations.
