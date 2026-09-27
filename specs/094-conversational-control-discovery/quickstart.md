# Feature 094 Quickstart Validation

## Prerequisites

From the repository root:

```sh
.specify/scripts/bash/check-prerequisites.sh --json --paths-only
```

The project uses macOS Bash 3.2-compatible scripts and the existing `.highway/tools/tests/` harness.
No package installation is required.

## Pre-change baseline

The full suite completed within the 240-second allowance before Feature 094 implementation. It
reported 59 passing tests and one existing failure in
`.highway/tools/tests/highway-ux-alignment.test.sh`: `.highway/skills/highway-objectives/SKILL.md`
does not contain the expected `Success Measures` text. This baseline failure is tracked separately
from Feature 094 implementation results.

The foundational probes initially failed as expected: Controls lacked the adaptive/action-result
contract, NFR candidate timing/readiness was not declared, and Setup lacked delegated-result ordering.
After the canonical contract edits, all four probes pass when invoked through Bash:
`highway-controls-onboarding.test.sh`, `control-derived-nfr.test.sh`,
`setup-owner-loop-contract.test.sh`, and `highway-setup.test.sh`.

US1 handoff verification also passes `highway-setup-executable.test.sh`: Setup emits the transition
once, preserves the owner result field order, treats `Continue` as non-terminal, and does not claim
completion for zero-Control, blocked, declined, aborted, malformed, or failed-persistence outcomes.

## Focused contract checks

Run the existing Controls, Setup, NFR, readiness, UX, and correspondence checks after implementation:

```sh
.highway/tools/tests/highway-controls-onboarding.test.sh
.highway/tools/tests/highway-setup.test.sh
.highway/tools/tests/highway-nfr-onboarding.test.sh
.highway/tools/tests/readiness-contract.test.sh
.highway/tools/tests/setup-owner-loop-contract.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
.highway/tools/tests/control-derived-nfr.test.sh
.highway/tools/tests/feature-092-correspondence.test.sh
```

Expected result: all focused checks pass, with separate static contract and executed-behavior evidence.

## Required scenarios

1. **Setup handoff**: Controls readiness `Missing` emits the Setup purpose once, delegates setup,
   consumes the collection action result, then requests fresh readiness. Pre-delegation `Complete`
   skips Controls.
2. **Adaptive discovery**: Concern-only, Concern-plus-Condition, complete obligation, rich answer,
   NFR-shaped intent, ambiguous classification, and explicit user-override routes ask at most one
   unresolved question or decision.
3. **Persistence and continuation**: Accept Control 1, verify one Add MINOR increment and candidate
   generation, continue to Control 2, then finish. Reuse an existing Control and verify no bytes,
   relationship, identifier, candidate, or version changes.
4. **Interruption**: Interrupt after Control 1 persistence and before collection finish. A new
   invocation restores no conversation, while NFR readiness still sees durable candidate-generation
   state for Control 1.
5. **Candidate failure**: Force candidate generation failure after valid Control persistence. Verify
   the Control remains valid, no partial NFR relationship is written, NFR readiness is Blocked, and
   Setup does not advance.
6. **Direct actions**: `configure` continues with a valid baseline; `add` creates one Control and
   terminates; a complete direct obligation works without optional Profile/Objectives context.
7. **Context and UX**: Profile owner Blocked is preserved; optional malformed context is excluded;
   relevant connections remain advisory; proposal action appears first; no status bookkeeping is
   exposed as routine user-facing prose.
8. **Correspondence**: Regenerate canonical/generated artifacts and run the full suite, allowing up to 240 seconds for completion:

```sh
.highway/tools/tests/run-all.sh
```

Allow up to 240 seconds for the full suite to complete.

Expected result: zero failures, no generated drift, and no shipped artifact references to development
paths.
