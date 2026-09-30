# Controls Skill Update Quickstart

## Prerequisites

Run from the repository root with the existing Highway tooling available.

## Validate the specification and design artifacts

```sh
bash .highway/tools/tests/objective-management.test.sh
```

The implementation phase must add or update the focused Controls, Setup, NFR handoff, template,
adapter, and removal checks before the full suite is run.

Baseline before implementation: the existing suite was green at 62 passed, 0 failed.

## Required implementation scenarios

1. **Evidence-first discovery**: supply a complete enforceable safeguard to `add`; verify it reaches
   capture without separate Concern, Condition, or Obligation questions.
2. **NFR classification**: supply an outcome or quality goal; verify it routes to NFRs, and verify
   ambiguous intent receives one bounded classification question.
3. **Grounded recommendation**: provide accepted Profile or Objective context and verify a small
   recommendation set, provenance, no applicability claim, and a user-authored alternative.
4. **Direct selection**: select a recommendation and verify direct capture without redundant review.
5. **User-authored review**: provide evidence requiring material interpretation and verify the exact
   captured-Control structure with acceptance at the bottom.
6. **Continuation**: create one Control through `configure`, verify the exact continuation wording,
   then finish explicitly and verify fresh readiness routing.
7. **Collection result**: verify the result contains no `Created Control IDs` and Setup routes only
   from collection status plus fresh readiness.
8. **Provenance**: verify recommendation provenance appears under `## Provenance` in the Control
   record body when applicable, and never appears in YAML frontmatter.
9. **Persistence safety**: verify duplicate, overlap, allocation, destructive, malformed, and
   failed-mutation paths preserve existing safeguards and do not report failure as success.
10. **NFR handoff**: verify one candidate-generation invocation after a successful new Control,
    preservation of the Control on Blocked generation, and no Controls-owned NFR internals.

## Final verification

```sh
bash .highway/tools/tests/run-all.sh
```

Final result: 62 passed, 0 failed. Generated adapters are aligned with the canonical skill, and
all template-dependent skills were revalidated.
