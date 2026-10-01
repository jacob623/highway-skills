# Contract: Repository Review Checks

These checks are development and review infrastructure. They must not be referenced from `.highway/governance/experience-standard.md` or from a shipped skill. They must not be added as a runtime input of `validate-skill.sh`.

Each edited assertion that stops requiring a superseded sentence names that superseded behavior in a comment. The old sentence is not kept as an alternate passing token.

## `.highway/tools/tests/highway-ux-alignment.test.sh`

Stop requiring:

- `3.0.0 → 4.0.0 (MAJOR)`
- `| X1.7 | Setup presentation MUST place one decision or question last, after framing, the main content, and any supporting rationale or example.`
- `| X2.9 | Decision Context MUST use the label "**Why it matters:**" and explain why the answer matters to the person without asking a second question.`

Require:

- `4.0.0 → 5.0.0 (MAJOR)`
- the X1.7, X2.9, X2.13, and X2.25 sentences in [experience-standard-amendment.md](./experience-standard-amendment.md)
- X2.32, X2.33, X2.34, and X2.35 rule sentences
- `Accepted information compounds during a guided interaction.`
- absence of `Select any of these`
- absence of the former X1.7 and X2.9 rule sentences

Leave the `Why it matters:` assertion on `.highway/skills/highway-objectives/SKILL.md` unchanged.

Instrument class remains static document-contract evidence for the Experience Standard assertions.

## `.highway/tools/tests/experience-standard-amendment.test.sh`

Stop requiring `3.0.0 → 4.0.0 (MAJOR)` and the former X2.9 rule sentence.

Keep requiring:

- exactly one `Sync Impact Report`
- `Every user-visible response excludes Implementation details unless requested.`
- the preserved X2.2, X2.7, X2.11 through X2.22, and X2.25 rule sentences already asserted
- `Here's what I've captured as your [category]:`
- `at most 5`
- the unchanged X2.13 rule sentence

Require also:

- `4.0.0 → 5.0.0 (MAJOR)`
- `**Version**: 5.0.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-01`
- the new X2.9 rule sentence
- the X2.13 observable beginning `Before each unresolved guided-collection question`
- the X2.32 through X2.35 rule sentences
- absence of the former X2.9 rule sentence

Do not require a skill file to change.

## `.highway/tools/tests/feature-092-contract.test.sh`

Replace only the Experience Standard assertion:

`| X1.7 | Setup presentation MUST place one decision or question last`

with the new X1.7 rule prefix:

`| X1.7 | Setup presentation MUST keep one response-demanding question or decision`

Do not change `version: 4.0.0` on the Profile skill. Do not change schema fixture versions.

## Out of scope

Do not edit these assertions:

- Skills Constitution history tokens `3.0.1 → 4.0.0 (MAJOR)` and `4.0.0 → 4.1.0 (MINOR)` in `constitution-inventory.test.sh`
- skill `Why it matters:` assertions in `objective-management.test.sh`, `nfr-management.test.sh`, `control-derived-nfr.test.sh`, and `output-template.test.sh`
- the preserved X2.3 observable assertion in `experience-x23-contract.test.sh` and `rule-checks.test.sh`
- historical records under `specs/102-final-governance-amendment/`

No check may pass while it still requires the 4.0.0 Experience Standard contract.
