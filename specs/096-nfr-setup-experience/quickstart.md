# Quickstart: Highway NFR Setup Experience

## Prerequisites

Run from the repository root with the existing Highway shell toolchain:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

No new runtime dependency or external service is required.

## Static contract validation

```sh
./.highway/tools/validate-skill.sh .highway/skills/highway-nfrs
./.highway/tools/validate-skill.sh .highway/skills/highway-setup
```

Expected result: both canonical skills pass validation.

## Focused contract and behavior validation

```sh
bash .highway/tools/tests/highway-nfr-onboarding.test.sh
bash .highway/tools/tests/nfr-management.test.sh
bash .highway/tools/tests/highway-setup.test.sh
bash .highway/tools/tests/highway-setup-executable.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/readiness-contract.test.sh
bash .highway/tools/tests/output-template.test.sh
```

Expected result: candidate presentation is contextual and one-at-a-time; decision vocabulary maps to
existing durable decisions; open discovery follows candidate review or begins directly for zero
candidates; uncertainty, suggestions, direct authoring, explicit finish, failures, and resume obey
owner boundaries; and Setup consumes collection completion followed by fresh readiness.

## Generated correspondence validation

After changing either canonical skill, regenerate the derived representations:

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
bash .highway/tools/tests/adapter-coverage.test.sh
```

Expected result: GitHub, Claude, and Cursor adapters plus generated indexes remain synchronized.

## Full validation

```sh
./.highway/tools/tests/run-all.sh
```

Expected result: the complete repository suite passes with no packaging, governance, skill,
Experience Standard, or generated-correspondence failures.

## Manual acceptance matrix

1. Existing durable candidates: one contextual recommendation and one decision at a time.
2. Multiple candidates: stable durable order; open discovery only after all decisions persist.
3. Zero candidates: exact broad discovery prompt, not completion.
4. `I don't know`: one guided follow-up, no invented NFR.
5. Suggestions: one to three declared-context possibilities, transient until adoption.
6. Direct NFR authoring: verified record with `controls: []`.
7. Accepted NFR: continuation prompt; collection remains active until explicit finish.
8. Immediate finish with zero accepted NFRs: `Finished`, then fresh readiness independently determines persisted-state status.
9. Setup delegation: consume owner result without inspecting NFR internals; advance only after fresh terminal-success readiness.
10. Any declined, aborted, blocked, malformed, or failed owner result: no successful Setup conclusion.
