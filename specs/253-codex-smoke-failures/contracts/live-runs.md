# Contract: Live Confirmation Runs

## Required runs

| Log path | Command | Pass bar |
| --- | --- | --- |
| `specs/253-codex-smoke-failures/harness/smoke-1.log` | `--agent codex --smoke` | ≥9/16 |
| `specs/253-codex-smoke-failures/harness/smoke-2.log` | `--agent codex --smoke` | ≥9/16 |
| `specs/253-codex-smoke-failures/harness/codify.log` | `--agent codex --skills highway-codify` | None (map failures to findings) |

## Shared requirements

- Model: pinned Codex Luna (`gpt-5.6-luna` or documented remap).
- Judge: configured Cursor / Luna.
- Every attempt still installs Highway with 16 skills (SC-001).
- Logs: no secrets; no raw temporary absolute paths (FR-009).
- Compare git-driven fails to `specs/252-codex-driver/harness/` baseline for F31.

## F31 close gate

Close F31 only when both smokes meet ≥9/16 **and** git-driven fails are fewer than Phase 9
baseline. Otherwise keep F31 open and update Runs/Basis/Proposed resolution.
