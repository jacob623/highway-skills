# Quickstart: Substantive Contribution Re-evaluation and Conversational Clarification

## Scope

These checks validate the Experience Standard amendment only. They must not modify Profile, `highway-clarify`, the Constitution, templates, or persisted data.

## Prerequisites

Run from the repository root with the existing Bash toolchain available.

## 1. Focused amendment contract

```bash
bash .highway/tools/tests/experience-standard-amendment.test.sh
```

Expected result: the Experience Standard contract passes with version 8.2.0, 44 total rules, X2.38-X2.40 present, and all preserved X2 boundaries intact.

## 2. UX alignment and rule inventory

```bash
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/rule-checks.test.sh
```

Expected result: shared interaction guidance remains centralized, rule IDs are unique and correctly tiered, and the three new rules have one obligation and one Observable each.

## 3. Required content spot checks

```bash
grep -nE 'Substantive Contribution|Conversational Clarification|X2\.38|X2\.39|X2\.40|clarification versus Contribution Opportunity|Acceptance plus new information' .highway/governance/experience-standard.md
```

Expected result: definitions, normative rules, distinction guidance, and all required interaction examples are present.

## 4. Protected-scope check

```bash
git diff --name-only -- .highway/skills/highway-clarify/SKILL.md .highway/skills/highway-profile/SKILL.md .highway/library/templates/output/profile-record.md .highway/governance/constitution.md
```

Expected result: no protected implementation or owner files are changed by the Experience Standard amendment.

## 5. Full repository validation

```bash
bash .highway/tools/tests/run-all.sh
```

Expected result: zero failures.

## Acceptance scenarios to inspect

- A contribution adds a second meaningful business line: the next behavior reflects the changed understanding before another workflow question.
- A contribution is clear: Highway incorporates it without asking a ceremonial clarification question.
- A contribution supports two materially different interpretations: Highway asks one focused clarification question.
- A clarification resolves meaning: the Working Idea remains transient and is not accepted or persisted.
- A later X2.37 boundary: Contribution Opportunity remains distinct unless the clarification genuinely invited substantive completion.
- An acceptance response adds new information: acceptance behavior and substantive-contribution re-evaluation both apply.
- No clarification records, CLAR identifiers, finding states, or persisted clarification history are introduced by the shared standard.
