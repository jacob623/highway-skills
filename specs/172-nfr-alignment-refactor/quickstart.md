# Quickstart: NFR Alignment Refactor

## Prerequisites

Run from the repository root with the existing Highway shell toolchain available.

```sh
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
```

The authoritative source is `.highway/skills/highway-nfrs/SKILL.md`. Generated adapters and catalogs must be regenerated after source changes.

## Focused Validation

Run the NFR owner and relationship contracts:

```sh
.highway/tools/tests/highway-nfr-onboarding.test.sh
.highway/tools/tests/nfr-management.test.sh
.highway/tools/tests/control-derived-nfr.test.sh
.highway/tools/tests/governance-routing.test.sh
.highway/tools/tests/output-template.test.sh
bash .highway/tools/tests/readiness-executable.test.sh
```

Expected result: each command exits successfully; NFR onboarding and management validate recommendation-first behavior, queue/acceptance boundaries, preserved ownership, and no Control-derived candidate lifecycle.

## Regenerate Derived Artifacts

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-instructions.sh
```

Expected result: the NFR adapters, catalogs, manifests, and instructions correspond to the authoritative NFR skill.

## Full Regression

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the complete suite reports zero failures and the diff check reports no whitespace errors.

## Behavioral Scenarios

1. Begin NFR setup with accepted context and verify recommendations appear before user invention.
2. Select several recommendations and verify they enter an ordered queue without creating NFR records.
3. Request more suggestions, then explicitly start queue processing and verify exploration ends.
4. Process one queued recommendation through converged proposal, correction or replacement, acceptance, capture, and next-item continuation.
5. Provide a user-authored NFR and verify it follows the same lifecycle.
6. Exhaust the queue and verify advisory portfolio synthesis, additional suggestions, and another-NFR continuation remain available.
7. Inspect readiness, relationships, duplicate handling, overlap handling, and destructive workflows to verify existing NFR ownership remains intact.
