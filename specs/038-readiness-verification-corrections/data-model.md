# Feature 038 Data Model

## Authoritative NFR State Model

| Input state | Status | Next action | Blocking reason |
|---|---|---|---|
| Candidate generation unavailable | `Blocked` | Repair candidate generation | Non-empty generation failure |
| Candidate generation malformed or contradictory | `Blocked` | Repair candidate generation | Non-empty malformed-state reason |
| Generation succeeds with zero candidates and no accepted artifacts | `Not Applicable` | `None` | `None` |
| Candidates exist and none are accepted | `In Progress` | Author review | `None` |
| Accepted valid NFR artifacts exist | `Complete` | `None` | `None` |

NFR `Missing` is not a supported owner state because the Feature 037 clarification makes every
candidate-present, none-accepted state `In Progress`. The shared response vocabulary remains
available to owners that use `Missing` for absent Profile, Objective, or Control baselines.

## Owner Fixture

| Field | Requirement |
|---|---|
| Owner | Profile, Objectives, Controls, or NFRs |
| Input label | Stable state name from the owner table |
| Fixture root | Disposable directory containing only the inputs needed by the owner |
| Before hashes | Artifact and identifier hashes captured before evaluation |
| Response | Parsed ordered `Status`, `Summary`, `Next Action`, and `Blocking Reason` fields |
| Repeat results | Responses and hashes from three evaluations of unchanged input |
| After hashes | Artifact and identifier hashes captured after evaluation |

## Evidence Record

Each fixture produces an evidence record with the owner, input label, exact parsed response,
selected Setup route when applicable, before/after hashes, repeat comparison result, command,
result, and evidence class. Evidence classes are executable owner behavior, Setup routing, static
contract, generated artifacts, requirement coverage, and limitations.

## Canonical Source Map

- Behavior-owning sources: `.highway/skills/*/SKILL.md`
- Test sources: `.highway/tools/tests/*.test.sh` and shared test helpers
- Generated adapters: `.github/skills/`, `.claude/skills/`, `.cursor/rules/`
- Generated catalogs and manifests: `.highway/catalog/` and `.highway/tools/*manifest`
- Development-only Feature 038 records: `specs/038-readiness-verification-corrections/`

No readiness state or evidence record is persisted as a runtime governance artifact.
