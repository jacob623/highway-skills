# Coverage: 150 Collaborative Convergence

**Date**: 2026-10-08 | **Branch**: `150-collaborative-convergence`

Two claims are recorded here, and they are not the same claim.

## Claim 1 — check results

`.highway/tools/tests/run-all.sh` → **74 passed, 0 failed, exit 0**.

Baseline before the first edit was 73 passed, 0 failed, exit 0 (D3.1). The suite gained one file,
`.highway/tools/tests/feature-150-collaborative-convergence.test.sh`.

Per D3.8 that file declares `# Instrument class: static-document-contract`. It proves the documents
say what this feature specified. It does not prove any conversation improved, and it is not offered
as evidence for SC-001 through SC-007.

## Claim 2 — requirement coverage

Coverage below means an artifact exists and a check enforces it. It does not mean the resulting
agent behavior was observed.

### Satisfied by an Experience Standard rule

| FR | Artifact | Enforced by |
|---|---|---|
| FR-001 | `## Contribution Opportunity` prose, X2.43, X2.44 | `feature-150`, rule-row assertions |
| FR-002 | X2.43 | `feature-150` |
| FR-003 | X2.44 | `feature-150` |
| FR-004 | X2.45 | `feature-150` |
| FR-005 | X2.46 | `feature-150` |
| FR-006 | X2.41 restated as a factual condition | `feature-150` text assertion |
| FR-007 | X2.37 and X2.41 Observables excluding approval and selection | `feature-150` |
| FR-008 | X2.37 rewritten; the prior-opportunity exemption is gone | `feature-150` absence assertion |
| FR-009 | Profile Vision / Competitive Path / Guiding Principles opening sentences | `feature-150` |
| FR-010 | X2.47 | `feature-150` |
| FR-011 | `## Constructive Advisory` (pre-existing, unchanged) | `highway-ux-alignment` |
| FR-012 | X2.48 | `feature-150` |
| FR-013 | X2.49 | `feature-150` |
| FR-014 | X2.50 | `feature-150` |
| FR-015 | X2.51 | `feature-150` |
| FR-016 | Four closed Profile sentences removed | `feature-150` absence assertions |
| FR-017 | X2.52 | `feature-150` |
| FR-018 | X2.53 | `feature-150` |
| FR-019 | X2.54, plus the amended X2.7 Observable | `feature-150` |
| FR-020 | X2.55 | `feature-150` |
| FR-021 | X2.56 | `feature-150` |
| FR-022 | X2.57 | `feature-150` |
| FR-028 | X2.37 | `feature-150` |
| FR-029 | X2.37's trigger is a fact about the person's responses, not a self-assessment | `feature-150` absence of the superseded text |
| FR-030 | X2.37 and X2.41 share the Substantive Contribution condition | `feature-150` |
| FR-031 | X2.52 (`a substantive claim Highway introduces`) | `feature-150` |
| FR-032 | X2.52 Observable and the Constructive Advisory paragraph | `feature-150` |
| FR-033 | Four open Profile sentences | `feature-150`, `profile-behavior` |
| FR-034 | Profile `#### Domain completeness` substitution sentence | `feature-150` |
| FR-035 | X2.49 governs every acceptance request, substituted or default | `feature-150` |

### Satisfied structurally

| FR | How | Enforced by |
|---|---|---|
| FR-023 | X2.37's condition is already met by a domain-complete statement, so no opportunity is owed and the short path stands. Stated in `## Contribution Opportunity`. | **Not mechanically enforced.** See the gap below. |
| FR-024 | One keyword and 25 words per new rule | `feature-150` shape checks, probed failable |
| FR-025 | No retired identifier reused | `feature-150` retired-identifier check |
| FR-026 | Profile holds output wording and zero `MUST`; the Standard holds the rules | `feature-150` zero-MUST check |
| FR-027 | No second term introduced | `feature-150` `Development Turn` absence check |
| FR-036 | Every new rule is an X2 row binding all Interactive Workflows; no skill-specific exception, no X-rule exemption | Review; the Standard has no exception mechanism to use |
| FR-037 | [follow-up.md](follow-up.md) names the eight unverified skills | Document exists |
| FR-038 | Only `highway-profile` was amended and verified | Scope statement |

## Success criteria — claimed by nothing

SC-001 through SC-007 are human-decided. No automated check in this repository can evaluate them,
and none is offered.

| SC | Status |
|---|---|
| SC-001 … SC-007 | **Unclaimed.** Requires T060, a conversation run against `setup-model.md` and read by a person. |

## Gaps a reader should not have to discover

1. **FR-023 has no mechanical check.** The plan argues the short path cannot break, because a
   domain-complete statement is itself a Substantive Contribution. That argument is sound but it is
   an argument, not evidence. T059 is the check, and it is a human-run conversation.

2. **Two test couplings were missed by [contracts/test-impact.md](contracts/test-impact.md)** and
   surfaced only when the suite ran:
   - `feature-136-profile-substantive-re-evaluation.test.sh` asserted `provisional`,
     `materially assembles`, and `facets provisionally` — the deleted Identity permissive hook.
   - `highway-ux-alignment.test.sh` asserted the superseded Interaction Model step 9 text.

   Both were genuine supersessions and both carry a `# Superseded behavior:` note naming what
   replaced them (D3.5). The contract listed 17 moving assertions; the real number was 19.

3. **Eight skills are unverified against the new rules.** The rules bind them from the moment this
   lands. [follow-up.md](follow-up.md) records the exposure.

## Versions

| Artifact | Before | After |
|---|---|---|
| `.highway/governance/experience-standard.md` | 9.1.0 | 10.0.0 |
| `.highway/skills/highway-profile/SKILL.md` | 9.0.0 | 10.0.0 |

Both are MAJOR under P7.7: convergence now requires a condition that did not previously exist, and
four mandated output sentences changed.
