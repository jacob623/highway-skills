# Data Model: Open Findings

## Open finding (`harness-model-findings.md`)

| Field | Role |
| --- | --- |
| Id | F18, F20, F23, F28 (this spec) |
| Skill / Category | Skill, Harness, or Model |
| Runs | Evidence run ids |
| Confirmed / Basis / Proposed resolution | Existing structure |
| Lifecycle | Open → removed when acceptance evidence holds; or open with updated Runs/Basis |

### Close rules (this spec)

| Id | Close when |
| --- | --- |
| F18 | Skill text present **and** Copilot + both Cursor smokes no longer fail discovery-smoke on missing Example Realization Matrix header |
| F23 | Unit test proves backtick `shows:` match; finding removed |
| F28 | Unit test proves case-insensitive `contains-any`; README note; finding removed |
| F20 | Layout change landed **and** confirming runs show fewer collapsed-path denials than cited baseline; else stay open with research/evidence |

## Attempt path layout (F20)

| Role | Before | After |
| --- | --- | --- |
| Work root | `tmpdir()/highway-harness-*` | `tmpdir()/hh-*` |
| Homes dir | `<work>/homes/<scenario>-<attempt>-*` | `<work>/h/<attempt>-*` |
| Projects dir | `<work>/projects/<scenario>-<attempt>-*` | `<work>/p/<attempt>-*` |
| Rewriter inputs | project, home, work, tmp | unchanged roles; new absolute values |

Isolation: one unique home and project per attempt. Plugin install and permission roots still hang under that home.

## Check normalization

| Check | Normalize |
| --- | --- |
| `shows:` | Strip `*`, word-boundary `_`, and `` ` ``; collapse whitespace |
| `contains-any` | Substring match after lowercasing both sides |
| `contains` | Unchanged (case-sensitive) |

## Confirmation logs

| File | Agent | Selection |
| --- | --- | --- |
| `smoke-copilot.log` | copilot | `--smoke` |
| `smoke-cursor-1.log` | cursor | `--smoke` |
| `smoke-cursor-2.log` | cursor | `--smoke` |
| `targeted-cursor.log` | cursor | `--paths` discovery-smoke, codify-configure, objectives-smoke, request-smoke, setup-smoke |

No secret, token, or temporary absolute path in committed bodies (rewriter/redaction).
