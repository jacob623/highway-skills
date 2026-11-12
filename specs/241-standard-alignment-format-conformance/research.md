# Research: Standard Alignment Agent Skills Format Conformance

Every decision below resolves an open point in `plan.md`'s Technical Context or a choice the spec
leaves to the plan. Sources: the Agent Skills specification at agentskills.io/specification, the
reference validator `skills-ref` (`parser.py` and `validator.py` in `agentskills/agentskills`),
and the repository as of `feature/std-alignment-phase12`.

## R1. The strict YAML parser

- Decision: `python3` with the PyYAML module, called from one new framework library,
  `framework/lib/yaml-frontmatter.sh`, through `python3 -c` with an inline program.
  - The program loads the frontmatter with a `yaml.SafeLoader` subclass that rejects a repeated
    key at any level.
  - It requires the document to be a mapping.
  - It prints one tab-separated line per field: scope, key, YAML type, and value, with newlines
    and tabs escaped.
- When `python3` or PyYAML is missing, validation fails closed. The validator prints
  `ERROR: [SCHEMA] the YAML parser is unavailable: framework/validate-skill.sh needs python3 with
  the PyYAML module` and exits 1. It never skips the YAML checks.
- Rationale:
  - `python3` is present on both target platforms. It is Apple's command-line tools on macOS and
    a base package on most Linux distributions.
  - PyYAML is the most widely installed Python YAML library. Its SafeLoader resolves the YAML 1.1
    implicit types (`yes`, `1.0`, `2026-11-12`, `~`), so a value any YAML client could read as a
    number, boolean, date, or null is caught.
  - The Python standard library has no YAML parser. Every candidate therefore needs one install
    step, and PyYAML is the most likely to be present already. It is installed on the
    maintainer's machine as a per-user `pip` package.
- Alternatives considered:
  - `strictyaml`, which `skills-ref` uses. It reads every scalar as a string, so it cannot report
    the type a less strict client would infer. It also needs `ruamel.yaml`, two installs instead
    of one.
  - Ruby's Psych. It is in Ruby's standard library, but Ruby is not installed by default on Linux,
    and Apple has deprecated the system Ruby.
  - `yq`. It is a separate binary, not installed here, and its two common implementations
    (mikefarah and the Python `jq` wrapper) differ.
  - The `yaml` package on the harness's Node toolchain. The development constitution keeps the
    harness toolchain under `harness/`, and `framework/` and `tests/` never invoke it.
  - A bash reader for a fixed YAML subset. The spec's clarification rejected it in favor of a
    real parser.

## R2. What counts as a wrong type

- Decision: every value the specification defines as a string, and every `metadata` value, must
  resolve to the YAML `str` type under PyYAML's SafeLoader.
  - The top-level string fields are `name`, `description`, `license`, `compatibility`, and
    `allowed-tools`.
  - `metadata` itself must be a mapping.
  - A value that resolves to any other type fails with
    `ERROR: [SCHEMA] field '<field>' must be a string (YAML reads it as <type>)`.
- Rationale:
  - Agent Skills defines `metadata` as "a map from string keys to string values".
  - A client with a typed parser would read `version: 1.0` as a float.
  - `skills-ref` hides this by converting each `metadata` value with `str()`, but a client that
    does not convert would read the wrong type.
  - Today's `version: 6.4.0` resolves as a string (two dots), so no skill needs quoting changed
    for the version.

## R3. Agreement between the parser and Highway's line readers

- Decision:
  - The index generator, the cache key, and the rule checks keep their line readers
    (`fm_get`, `fm_get_nested`).
  - The validator reads each string field both ways: `name`, `description`, `license`, and
    `compatibility` at the top level, and `metadata.version` and `metadata.usage`.
  - When the parser's value and the line reader's value differ, it fails with
    `ERROR: [SCHEMA] field '<field>' reads differently in a strict YAML parser`.
- Rationale:
  - Every skill passes the validator before the generator runs, because the generator validates
    first.
  - So every value the generator and highway-help use is one the parser agrees with (SC-006).
  - The library readers stay fast and dependency-free.
- Alternative considered: route every reader through the parser. That would add a `python3` call
  to the generators and the cache key for no gain the agreement check does not already give.

## R4. The frontmatter contract after this change

- Decision: `framework/.frontmatter-contract` declares exactly these rows.

  | Scope | Key | Required | Constraint |
  | --- | --- | --- | --- |
  | top | `name` | yes | `kebab-case` |
  | top | `description` | yes | `length:1-1024` |
  | top | `license` | yes | `-` |
  | top | `compatibility` | no | `length:1-500` |
  | top | `allowed-tools` | no | `-` |
  | metadata | `version` | yes | `semver` |
  | metadata | `usage` | yes | `length:1-500` |

- Rationale:
  - The top-level set is the specification's six fields.
  - `name`: `kebab-case` (`^[a-z0-9]+(-[a-z0-9]+)*$`) already forbids uppercase, leading or
    trailing hyphens, and consecutive hyphens. The validator adds the 64-character limit.
  - Highway's ASCII-only names are narrower than the specification's Unicode letters. They add
    to the specification without contradicting it.
  - `license` is required because FR-004 requires it; the specification makes it optional, and
    requiring it adds without contradicting.
  - `metadata` keys stay a closed set (`version`, `usage`). The specification allows any key;
    Highway narrowing it adds without contradicting.
  - The `usage` limit keeps Highway's 500 characters, because `usage` is Highway's own key.
- Removed rows:
  - top-level `usage`;
  - the `compatibility` enum (`all`, `github-copilot`, `claude-code`, `cursor`, `codex`);
  - `metadata.agent_exceptions`;
  - `metadata.dependencies`.
- Key listing: `fm_list_keys` cannot match `allowed-tools`, because its key pattern has no
  hyphen. The closed-key-set and duplicate-key checks therefore read keys from the parser (R1),
  not from `fm_list_keys`.

## R5. The "Use when" rules

- Decision: the Highway Skills Constitution gains two rows under Principle V.

  | Rule | Text | Tier |
  | --- | --- | --- |
  | P5.15 | A skill's description MUST contain a sentence beginning "Use when". | `[auto]` |
  | P5.16 | A description's "Use when" sentence MUST name only scenarios the skill's "When to use" section lists. | `[agent-checkable]` |

  - P5.15's check is `rc_check_P5_15` in `framework/lib/rule-checks.sh`, registered with N/A
    condition `N4`.
  - The check passes when the frontmatter `description` matches
    `(^|[.!?][[:space:]]+)Use when[[:space:]]`.
  - It returns N/A (2) when the file is not a `SKILL.md`, so templates bundled in `assets/` (which
    carry a `description`) are not judged by it.
  - It passes an empty description, which the schema check already reports as missing, so one
    defect gives one finding.
- Rationale:
  - The IDs start at P5.15 because P5.14 was retired in 10.0.0, and a retired ID is never reused.
  - Principle V already holds P5.6, the "When to use" rule.
  - Each rule has one keyword, one obligation, and no more than 25 words, as the constitution's
    self-application requires (P1.1 through P1.4).
  - N4 ("the rule's stated scope names an artifact type that the reviewed artifact is not") is
    the closed-list condition that fits a bundled template.

## R6. Invocation-neutral skill text

- Decision:
  - Outside each skill's `## Example` section, no file in a skill folder contains `/highway-`,
    `$highway-`, or `highway:highway-` as an invocation.
  - The rewrite drops the prefix and keeps the skill name and its arguments, inside or outside a
    code span.
    - "Run `/highway-implementation [RA id]` to create" becomes "Run `highway-implementation
      [RA id]` to create".
    - "Run /highway-setup to get started." becomes "Run highway-setup to get started."
    - "The person invokes `/highway-adr` with one Discovery id." becomes "The person invokes
      `highway-adr` with one Discovery id."
  - `metadata.usage` reads "Run highway-<id> …" (for example "Run highway-adr with one discovery
    id.").
  - highway-help's all-skills line becomes `Help: highway-help <id>`.
- Rationale:
  - The skill's name and arguments are the part every agent shares.
  - About 75 mentions outside `## Example` follow the same few shapes, so a mechanical rewrite
    keeps meaning and sentence structure. Tests that pin the old sentences change with them.
- Kept:
  - Every `## Example` keeps its `/highway-…` line (spec clarification), and the help index's
    `example` field stays `/highway-help highway-help`.
  - Harness scenario `open:` prompts are the person's input and stay. A `shows:` expectation of
    skill output follows the skill (`request-setup-needed.scenario`).
- Enforcement: the new `tests/agent-skills-format.test.sh` scans every file under `skills/` for
  the three prefixes outside `## Example`, with a seeded probe.

## R7. Retired features

- Decision: these are removed in full, with their tests.

  | Feature | What goes |
  | --- | --- |
  | Closed word list | `framework/frontmatter-lexicon.txt`; `framework/lib/frontmatter-lexicon.sh`; its two calls in `validate-skill.sh`; `tests/frontmatter-lexicon.test.sh`; the fixture `invalid-skill-unrecognized-word`; the `frontmatter-lexicon` name in `hw_doc` (`framework/lib/paths.sh`); its path in the cache's environment hash; its row in `harness/selection/shared.txt`, if present; its patterns in `tests/path-construction.test.sh`; and its sections in `framework/README.md` |
  | `metadata.dependencies` | `framework/lib/dependency-check.sh`; `fm_get_dependencies`; `dependencies_json` and the `dependencies` entry field in `generate-catalog.sh`; `tests/dependency-check.test.sh`; highway-help's `Dependencies:` line; the README and authoring-standard sections |
  | `metadata.agent_exceptions` | `fm_get_agent_exceptions`; `sv_validate_agent_exceptions`; the contract row; the authoring-standard row and example |
  | `compatibility` enum | `sv_validate_compatibility`'s enum branch, which becomes a 1–500 length check |
  | Top-level `usage` | `sv_validate_usage` reads `metadata.usage` |

- Rationale: the spec's clarifications (FR-007, FR-013) remove these. Nothing outside the items
  listed reads them; this is confirmed by the inventory search in the plan.
- Test weakening (D3.5): each removed assertion names its superseded behavior.
  - `frontmatter-lexicon.test.sh` covered the retired word list.
  - `dependency-check.test.sh` covered the retired `metadata.dependencies`.
  - The `invalid-skill-unrecognized-word` fixture covered the word list.
  - `invalid-skill-short-description` covered the 10-character minimum, which becomes the
    specification's 1. It is repurposed as an empty description, which still fails.

## R8. Constitution amendments and their versions

- Decision: both constitutions take MINOR amendments.
  - Highway Skills Constitution, 10.3.0 → 10.4.0:
    - adds P5.15 and P5.16;
    - adds P5.15 to the `[auto]` count;
    - its Sync Impact Report and self-application review (P1.1–P1.4, P6.4, P6.6, P7.3).
  - Development constitution, 3.4.0 → 3.5.0:
    - adds D3.9, "The skill validator MUST enforce every rule of the Agent Skills
      specification." Its Observable is "A seeded violation of each rule makes
      `framework/validate-skill.sh` exit non-zero." Tier `[auto]`, mapped to
      `agent-skills-format.test.sh` in the Enforcement Map.
    - adds `python3` (with the PyYAML module, used only by `framework/lib/yaml-frontmatter.sh`)
      to the Declared Toolchain;
    - adds a Governance paragraph naming the Agent Skills specification as the authority on skill
      format, so Highway's frontmatter rules may add to it but not contradict it;
    - its Sync Impact Report records why D2.4 permits `python3`: the framework no longer ships,
      so `python3` is a development tool, not a runtime dependency of anything a person installs.
- Rationale:
  - Each policy makes an addition MINOR when no conforming work is invalidated. Every skill, the
    validator, and the fixtures meet the new rules in the same change.
  - This is the precedent of the development constitution's 2.x amendment that added D2.5.
  - The authority statement goes in Governance, not as a rule on skill content. The development
    constitution's scope line says it "states no obligation about the content of any shipped
    artifact". A validator rule (D3.9) is process, which is in its scope.
  - Neither amendment removes or redefines a rule.

## R9. Skill versions and text changes

- Decision: all 16 skills take a MINOR bump. The frontmatter changes in every skill, and so does
  the `usage` text. Twelve skills also change handoff or trigger text.

  | Skill | Version |
  | --- | --- |
  | highway-adr | 6.4.0 → 6.5.0 |
  | highway-architecture | 5.5.0 → 5.6.0 |
  | highway-assessment | 5.3.0 → 5.4.0 |
  | highway-codify | 14.5.0 → 14.6.0 |
  | highway-codify-config | 3.9.0 → 3.10.0 |
  | highway-controls | 8.4.0 → 8.5.0 |
  | highway-discovery | 5.4.0 → 5.5.0 |
  | highway-experience | 1.0.0 → 1.1.0 |
  | highway-help | 3.3.0 → 3.4.0 |
  | highway-implementation | 7.13.0 → 7.14.0 |
  | highway-nfrs | 9.5.0 → 9.6.0 |
  | highway-objectives | 8.4.0 → 8.5.0 |
  | highway-onboarding | 10.10.0 → 10.11.0 |
  | highway-profile | 14.3.0 → 14.4.0 |
  | highway-request | 5.4.0 → 5.5.0 |
  | highway-setup | 10.3.0 → 10.4.0 |

  highway-help's Example shows the new version (P9.5).
- Rationale: the standing preference is MINOR, never MAJOR. No Input, Output, or behavior a
  person relies on changes, except highway-help's dropped `Dependencies:` line. That line always
  read `none`, because no skill declared a dependency.

## R10. Descriptions

- Decision: each description keeps one sentence saying what the skill does, rewritten in
  everyday words where the current one is terse, then adds a "Use when …" sentence drawn from
  the skill's `## When to use` section.
  - Example: "Records one architecture decision for a discovery. Use when a discovery's options
    are ready and the person wants to choose one and record it as an ADR."
  - Each stays well under 1,024 characters.
  - highway-experience's says it is loaded by every other Highway skill, and "Use when" the person
    wants a summary of Highway.
- Rationale: FR-006 and the clarifications. The "Use when" sentence gives an agent the trigger
  words it routes on.

## R11. Tests

- Decision:
  - A new `tests/agent-skills-format.test.sh` decides D3.9. It checks:
    - every skill passes `validate-skill.sh`;
    - for each Agent Skills rule, a seeded copy of the valid fixture fails with an error naming
      the rule and the field:
      - no frontmatter block;
      - invalid YAML;
      - a duplicate key;
      - a `name` over 64 characters, with uppercase, with a leading hyphen, with a double hyphen,
        or not matching the folder;
      - an empty `description`, or one over 1,024 characters;
      - an empty `compatibility`, or one over 500 characters;
      - an undeclared top-level field;
      - a non-string `metadata` value;
    - P5.15 fails a description without "Use when";
    - parser and line-reader values agree for every skill (SC-006);
    - no invocation prefix appears outside `## Example` (R6);
    - the retired word list, dependency check, and agent-exceptions code are absent.
  - It declares `# Artifact classes: skill-source` and supports `--probe skill-source` and
    `--neutralise`, as `constitution-inventory.test.sh` requires of a mapped test (D3.7).
  - The 12 skill fixtures under `tests/fixtures/*/SKILL.md` move to the new frontmatter shape.
    Each keeps the single defect it exists for.
  - `invalid-skill-duplicate-key` now fails through the parser's duplicate-key error.
  - Existing tests that pin changed text, field lists, help output, or the slash form are updated
    in place:
    - `validate-skill.test.sh`
    - `generate-catalog.test.sh`
    - `help-output-single.test.sh`
    - `help-output-all.test.sh`
    - `adr-span-progression.test.sh`
    - `adr-record-completeness.test.sh`
    - `codify-config-skill.test.sh`
    - `codify-closing-guide.test.sh`
    - `catalog-seeding.test.sh`
    - `codify-feature-wording.test.sh`
    - `codify-file-layout.test.sh`
    - `configure-handoff.test.sh`
    - `highway-codify.test.sh`
    - `propose-edit-lines.test.sh`
    - `storage-contract.test.sh`
    - `rule-checks.test.sh`
    - `generate-agent-adapters.test.sh`
    - `validation-cache.test.sh`
    - `path-construction.test.sh`
- Suite count: 85 − 2 retired (`frontmatter-lexicon`, `dependency-check`) + 1 new
  (`agent-skills-format`) = 84.
- D3.4: before P5.15 and the parser checks are wired in, each fixture's expected verdict is
  recorded in `data-model.md`. Every valid fixture passes, and each invalid fixture fails only for
  its own defect.

## R12. Harness

- Decision:
  - The bullets whose text changes get new coverage hashes. `harness/bin/inventory.sh`
    regenerates them.
  - Each scenario's `covers:` line and each `harness/coverage/treatments.txt` row that names a
    changed hash is updated to the new hash with the new text.
  - `request-setup-needed.scenario`'s `shows:` line takes the new setup message.
  - Scenario `open:` prompts are unchanged.
- Rationale: harness coverage is keyed by bullet text. A reworded bullet is a new bullet, and
  `harness-coverage.test.sh` fails until its coverage follows. Live runs need a token and are not
  part of this phase's checks; the harness unit tests and type check are.
