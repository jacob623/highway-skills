# Implementation Plan: Standard Alignment Agent Skills Format Conformance

**Branch**: `feature/std-alignment-phase12` | **Date**: 2026-11-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/241-standard-alignment-format-conformance/spec.md`

## Summary

Every Highway skill conforms to the Agent Skills specification, and the bash suite proves it.

- Frontmatter:
  - holds only the specification's fields;
  - moves `usage` under `metadata`;
  - drops `compatibility`;
  - adds `license: Apache-2.0`;
  - gives each description a "Use when" sentence.
- `framework/validate-skill.sh` parses frontmatter with a strict YAML parser (`python3` with
  PyYAML, R1). It enforces every specification rule, and checks that its line readers agree with
  the parser.
- Skill text outside `## Example` names skills without `/`, `$`, or a plugin namespace.
- Retired:
  - the closed word list;
  - `metadata.dependencies`, with its check, index field, and help line;
  - `metadata.agent_exceptions`.
- The Highway Skills Constitution gains P5.15 (`[auto]`) and P5.16. The development constitution
  gains D3.9, `python3` on the Declared Toolchain, and a Governance paragraph naming the
  specification as the authority on skill format.

## Technical Context

**Language/Version**: Bash 3.2.57 for every script (D2.1). `python3` (3.9 or later) with PyYAML,
called only from `framework/lib/yaml-frontmatter.sh`. Markdown skill sources. TypeScript under
`harness/` for its unit tests only.

**Primary Dependencies**: the Declared Toolchain plus `python3` with PyYAML (R1, R8).

**Storage**: files: `skills/*/SKILL.md`, `framework/.frontmatter-contract`,
`skills/highway-help/assets/index.json`, the agent trees.

**Testing**: `tests/run-all.sh` (84 tests after this change: −2, +1). Harness:
`node --test "test/*.test.ts"` and `tsc`.

**Target Platform**: macOS (Apple/BSD utilities) and Linux (GNU) (D2.3).

**Project Type**: an authoring framework (validators, generators, tests) for a set of Agent
Skills.

**Performance Goals**: one `python3` call per skill validation. Cached verdicts replay without it.

**Constraints**:
- no backward compatibility;
- skill versions take MINOR bumps;
- `rollout-plan.md` stays gitignored and excluded;
- no commit unless asked.

**Scale/Scope**:
- 16 skills;
- 12 skill fixtures;
- about 75 invocation mentions outside `## Example`;
- about 20 tests that pin changed text;
- 2 constitutions;
- the authoring standard and READMEs.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (development constitution 3.4.0)

| Gate | Triggered | Verdict |
| --- | --- | --- |
| Packaging (D1.1, D1.2, D6.2) | Yes: skills and agent trees change | D1.1 PASS: no development path is added to a skill. D1.2 PASS: verification from `.agents/skills/` keeps working. It needs `python3`, which is present wherever the suite runs. D6.2 PASS: references to the removed lexicon and dependency docs are removed with them. |
| Toolchain (D2.1–D2.5) | Yes | D2.1 PASS: the bash stays 3.2-safe; the Python is in a string passed to `python3 -c`. D2.2 and D2.4 PASS through the amendment that adds `python3` to the Declared Toolchain in this change (R8; Complexity Tracking). D2.3 PASS: no new utility flags. D2.5 PASS: the new library gets paths from `paths.sh`. |
| Generator (D4.1–D4.4) | Yes: `generate-catalog.sh` | PASS: the outputs are regenerated, and a second run produces no diff. |
| Correspondence (D4.5–D4.7) | Yes | PASS: the help index and agent trees are regenerated. |
| Validation (D3.4, D3.5) | Yes | D3.4 PASS: fixture verdicts are recorded in `data-model.md` before wiring. D3.5 PASS: each removed assertion names its superseded behavior (R7). |
| Skill Content | Yes | Delegated below (D1.5). |

Also applied:
- D3.1: baseline `tests/run-all.sh` before the first edit.
- D3.2: the full suite after the last edit.
- D3.3: tests change.
- D3.6: the new checks are observed failing on seeded defects.
- D3.7: `agent-skills-format.test.sh` declares a probe.
- D6.1: the authoring standard, `framework/README.md`, and the root README are updated in this
  change.

### Skill content gates (Highway Skills Constitution 10.3.0)

| Rule | Verdict |
| --- | --- |
| P5.6 | PASS: the `## When to use` sections are unchanged in meaning; trigger lines only lose the `/` prefix. |
| P5.15 (added) | PASS after this change: every description gains "Use when". |
| P5.16 (added) | PASS: each "Use when" sentence is drawn from that skill's `## When to use` (R10). |
| P7.2 | PASS: every version stays `MAJOR.MINOR.PATCH` and parses as a string. |
| P7.3 | PASS: no rule text is restated; the authoring standard cites the specification and rule IDs. |
| P7.7 | Exception, recorded below. highway-help drops its `Dependencies:` line. That removes an output element, which the Breaking change definition classes as MAJOR, but the maintainer's standing direction is MINOR bumps only. Every other skill change keeps each contract element: text rewording, a moved frontmatter key. |
| P8.7 | PASS: no link is added. |
| P9.5 | PASS: highway-help's Example shows its new version. |
| P1.1–P1.4, P6.4, P6.6, P7.3 (self-application of the amendment) | Reviewed in the amendment's Sync Impact Report. P5.15 and P5.16 each have one keyword, one obligation, and no more than 25 words. |

Post-design re-check: unchanged. No FAIL; one recorded exception (P7.7).

## Project Structure

### Documentation (this feature)

```text
specs/241-standard-alignment-format-conformance/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── validator-format-checks.md
│   ├── help-output.md
│   └── invocation-text.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/<16 skills>/SKILL.md             # frontmatter, "Use when", invocation text; MINOR
skills/highway-help/SKILL.md            # five-line output; Help: highway-help <id>
skills/highway-help/assets/index.json   # regenerated: usage from metadata, no dependencies
framework/
├── .frontmatter-contract               # the seven rows in R4
├── lib/yaml-frontmatter.sh             # new: yf_parse via python3 + PyYAML
├── lib/schema-validate.sh              # parser-based key, type, length, and agreement checks
├── lib/frontmatter.sh                  # fm_get_dependencies, fm_get_agent_exceptions removed
├── lib/rule-checks.sh                  # rc_check_P5_15, registered N4
├── lib/paths.sh                        # frontmatter-lexicon doc name removed
├── lib/validation-cache.sh             # environment hash drops the lexicon
├── lib/library-schema.sh               # comment only
├── lib/frontmatter-lexicon.sh          # removed
├── lib/dependency-check.sh             # removed
├── frontmatter-lexicon.txt             # removed
├── validate-skill.sh                   # calls yf_parse; lexicon and dependency calls removed
├── generate-catalog.sh                 # usage from metadata.usage; no dependencies
├── constitution.md                     # 10.4.0: P5.15, P5.16
├── authoring-standard.md, README.md
.specify/memory/constitution.md         # 3.5.0: D3.9, python3, the authority paragraph
tests/
├── agent-skills-format.test.sh         # new; decides D3.9
├── frontmatter-lexicon.test.sh         # removed
├── dependency-check.test.sh            # removed
├── fixtures/*/SKILL.md                 # 12 fixtures to the new shape; unrecognized-word removed
└── <tests that pin changed text>       # listed in research.md R11
harness/
├── scenarios/**                        # covers hashes; one shows line
├── coverage/treatments.txt             # changed hashes
└── selection/shared.txt                # lexicon row removed, if present
README.md, standard-alignment.md
```

**Structure Decision**: one new framework library holds the only use of `python3`. Every other
reader stays in bash, behind the validator's agreement check (R3).

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
| --- | --- | --- |
| D2.2 and D2.4: a new interpreter (`python3` with PyYAML) | The spec's clarification requires a real, strict YAML parser. No utility on the Declared Toolchain is one. | A bash reader of a fixed YAML subset was rejected in clarification. Other parsers need more installs or a non-default runtime (R1). The amendment adds `python3` to the Declared Toolchain in this change, so D2.2 and D2.4 hold once it lands. |
| P7.7: highway-help drops an output line on a MINOR bump | The maintainer's standing direction: skill versions take MINOR bumps, never MAJOR. Highway is unreleased, and the dropped line always read `none`. | A MAJOR bump would contradict the standing direction for a line no person relied on. |
