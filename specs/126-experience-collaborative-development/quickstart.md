# Quickstart: Experience Standard Collaborative Development

## Scope

Run these checks from the repository root. The implementation target is exactly
`.highway/governance/experience-standard.md`. Do not update tests or other governance artifacts
for this feature.

## Prerequisites

- macOS or another environment with the repository's declared shell utilities.
- Feature 126 files present under `specs/126-experience-collaborative-development/`.
- The current Experience Standard at `.highway/governance/experience-standard.md`.

## Focused structural checks

```sh
standard=.highway/governance/experience-standard.md

grep -nF '### Interaction model' "$standard"
grep -nF '#### Collaborative Development (Non-Normative Guidance)' "$standard"
grep -nF '#### Contextual Re-evaluation (Non-Normative Guidance)' "$standard"
grep -nF '#### Evolution-Aware Guidance (Non-Normative)' "$standard"
grep -nF '| X2.8 | When accepted information changes Highway' "$standard"
grep -nF '| X2.36 | An Interactive Workflow MUST NOT narrate internal workflow progression' "$standard"
grep -nF 'Interpretation, sharpening, implications, alternatives' "$standard"
grep -nF 'The owning skill determines what constitutes a complete candidate' "$standard"
```

Expected result: every command prints at least one matching line, and the document contains one
current X2.8 row and one current X2.36 row.

## Focused version and scope checks

```sh
standard=.highway/governance/experience-standard.md

grep -nF '**Version**: 8.0.0' "$standard"
test "$(git diff --name-only -- .highway/governance/experience-standard.md)" = '.highway/governance/experience-standard.md'
git diff --check
```

Use the version assertion only after the compatibility review in `research.md` confirms the MAJOR
classification. If the repository's policy review documents a different permitted development
version, update this expectation and the version rationale together.

## Cross-reference checks

```sh
for reference in \
  .highway/library/knowledge/highway-identity.md \
  .highway/library/knowledge/highway-platform-objectives.md \
  .highway/governance/constitution.md
 do
  test -f "$reference"
done
```

Expected result: every referenced authoritative path exists.

## Full repository compatibility check

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result for a fully reconciled repository is a zero exit status. At the Feature 126
planning baseline, the suite has one known unrelated failure in
`constitution-inventory.test.sh` because it still asserts the former Constitution precedence.
Feature 126 must report that result and must not modify the test because its implementation scope
is limited to `experience-standard.md`.

## Acceptance review

Review the final document against the Feature 126 acceptance scenarios and confirm:

- changed understanding is interpreted in accumulated context rather than merely paraphrased;
- Working Ideas may develop without artifact persistence;
- acceptance is followed by useful contextual re-evaluation without workflow narration;
- domain completeness and accepted organizational truth remain owner-controlled;
- recommendations remain grounded in present reality and do not assert unsupported futures;
- collaborative turns may conclude without a question when no response-demanding need remains;
- no retained schema, individual skill, or unrelated governance file changed.
