# Feature 127 Quickstart: Experience Acceptance Boundaries

## Scope

Run these checks from the repository root. The implementation target is exactly
`.highway/governance/experience-standard.md`. Do not modify individual skills, retained templates,
schemas, or unrelated Experience Standard rules.

## Prerequisites

- Feature 127 files exist under `specs/127-experience-acceptance-boundaries/`.
- The current Experience Standard is version `8.0.0`.
- Existing focused contract tests are available under `.highway/tools/tests/`.

## Rule and lifecycle checks

```sh
standard=.highway/governance/experience-standard.md

grep -nF '| X2.18 | Selecting a displayed Converged Proposal MUST count as acceptance without a second confirmation.' "$standard"
grep -nF '| X2.19 | A request for explanation, comparison, or more information MUST NOT be treated as acceptance.' "$standard"
grep -nF '| X2.21 | A materially interpreted Converged Proposal MUST be reviewed under the heading' "$standard"
grep -nF '| X2.22 | A direct domain-complete statement or explicitly selected Converged Proposal MUST be captured' "$standard"
grep -nF '| X2.25 | Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST use the shared collaborative recommendation model.' "$standard"
grep -nF 'When understanding changes, the visible response should emerge from contextual re-evaluation rather than from a required acknowledgment formula.' "$standard"
grep -nF 'interpret what the person'"'"'s contribution means in context' "$standard"
```

Expected result: each command finds one current matching line, and the revised rules use
Working Idea, Converged Proposal, and artifact acceptance language.

## Preservation checks

```sh
standard=.highway/governance/experience-standard.md

test "$(grep -c '^| X2\\.8 |' "$standard")" -eq 1
test "$(grep -c '^| X2\\.36 |' "$standard")" -eq 1
grep -nF '**Version**: 8.0.0' "$standard"
grep -nF '**Contextual Acknowledgment**:' "$standard"
grep -nF '#### Collaborative Development (Non-Normative Guidance)' "$standard"
grep -nF '#### Contextual Re-evaluation (Non-Normative Guidance)' "$standard"
grep -nF '### Evolution-Aware Guidance (Non-Normative)' "$standard"
```

Expected result: X2.8, X2.36, the legacy definition, the existing loops, and evolution-aware
guidance remain present exactly once where applicable.

## Focused contract tests

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected result: both contracts pass after their assertions are updated only for the superseded
immediate-acceptance and acknowledgment-sequencing behavior.

## Scope and whitespace checks

```sh
git diff --name-only -- .highway/governance/experience-standard.md
git diff --check -- .highway/governance/experience-standard.md
```

Expected result: the implementation target is the only shipped document changed by Feature 127 and
its diff contains no whitespace errors. Generated Spec Kit artifacts are development records and do
not expand the shipped implementation boundary.

## Full repository compatibility check

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: zero exit status, with full-suite results reported separately from the Feature 127
requirement review. Existing protected-path and stale-contract failures must not be hidden or fixed
by weakening assertions.

## Acceptance review

Confirm the final document demonstrates all of the following:

- a recommendation can remain a Working Idea;
- agreement with a Working Idea does not itself cross an artifact acceptance boundary;
- only a displayed complete Converged Proposal is authoritative on selection;
- materially interpreted Converged Proposals receive final review without forcing review on ordinary development;
- X2.8 and X2.36 are unchanged;
- contextual re-evaluation replaces acknowledgment sequencing as the continuity pattern;
- examples focus on meaning, implications, boundaries, and accepted knowledge;
- mature contributions can converge quickly and collaboration stops when further development adds no value;
- the user-authored alternative remains available;
- only `.highway/governance/experience-standard.md` is the implementation target.
