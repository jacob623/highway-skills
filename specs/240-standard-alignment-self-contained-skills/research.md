# Research: Standard Alignment Self-Contained Skills

All four clarifications are settled in the spec. The decisions below resolve how each requirement
is met in this repository.

## R1. highway-help's index

- Decision: `generate-catalog.sh` writes `skills/highway-help/assets/index.json`. `paths.sh` declares
  `HW_HELP_INDEX` for it and drops `HW_HIGHWAY` and `HW_CATALOG`. Each entry holds `id`, `name`,
  `description`, `usage`, `version`, `dependencies`, and `example`, in that order.
  - `dependencies` is a JSON array of `"<path>@<version>"` strings from `metadata.dependencies`,
    empty for every skill today.
  - `example` is the first line under `## Example` that is one inline code span, stored without the
    backticks: for highway-help, `/highway-help highway-help`.
  - `compatibility` and `source_path` are dropped. highway-help prints neither, and `source_path`
    names a file in another skill's folder.
- Rationale: the fields are exactly what highway-help prints. The output stays deterministic: no
  timestamp, entries in folder order.
- Alternatives considered: keeping `compatibility` for Phase 12. Rejected: no reader, and Phase 12
  rewrites that field anyway.

## R2. Name equals folder (FR-002)

- Decision: keep the existing guarantee and test it. `generate-catalog.sh` already validates every
  skill before it writes, and `validate-skill.sh` runs `sv_validate_name`, which fails when `name`
  differs from the folder. `generate-catalog.test.sh` gains a case: a temporary skill whose `name`
  differs from its folder makes the generator fail, name the skill, and leave the index unchanged.
- Rationale: one implementation of the rule, now proven at the generator.
- Alternatives considered: a second name check inside the generator. Rejected: a duplicate that can
  drift.

## R3. highway-help's text

- Decision: Inputs name only the declared identifier, `assets/index.json`, and highway-experience.
  The `.highway/skills/` folder description, the run-time `name` check, and the misapplied
  `[AS-4: …]` citation are removed. AS-4 means a tool's official documentation, not a file in this
  repository. Error Handling names `assets/index.json`:
  `ERROR: the skill index 'assets/index.json' is missing or unreadable`. Verification counts entries in
  `assets/index.json`. The output contract is unchanged. Version 3.2.0 → 3.3.0, and the Example
  shows `Version: 3.3.0` (P9.5).
- Rationale: FR-003. The error line keeps its shape, and its wording follows the file it names.

## R4. Merging `validate-library.sh` into `validate-skill.sh`

- Decision: `validate-skill.sh` gains one function, `check_bundled <file> <kind>`, which runs the
  same steps `validate-library.sh` ran:
  - `template` (a complete template in `assets/*.md`): `ls_validate_name`, `ls_validate_description`,
    then every automatic Highway Skills Constitution rule except `rc_template_exempt_ids` and
    `rc_library_exempt_ids`.
  - `reference` (every `references/*.md`): every automatic constitution rule except
    `rc_bundled_exempt_ids` and `rc_reference_exempt_ids`, which lists the template-exempt rules
    (P1.1, P1.3, P7.4, P7.5) plus P7.1 and P7.2. There are no frontmatter checks. Citations (P3.5)
    and the remaining rules apply.
  - Findings keep today's form: `ERROR: [<tag>] assets/<file>: …` or
    `ERROR: [<tag>] references/<file>: …`. Each failed rule joins the skill's FAILED line, as for
    assets today.
  - `rc_library_exempt_ids` is renamed `rc_bundled_exempt_ids`, and its comment speaks of bundled
    files. `lib/library-schema.sh` stays as the template frontmatter check.
  - Experience Standard rules do not apply to bundled files, as before, because a bundled file emits
    nothing.
- Rationale, corrected during implementation:
  - The planning probe on today's three references was hollow. `bs_scan` assumed every file opens
    with frontmatter, so it skipped every line of a file without one. Every body rule passed only
    because it saw no text.
  - `bs_scan` now treats a file whose first line is not `---` as having no frontmatter.
  - With real scanning, `experience-standard.md` fails P1.1, P1.3, P7.4, and P7.5: it is a rule
    table of 64 MUST rows that defines rules for others. `highway-identity.md` fails P7.1 through
    its `# Purpose` heading.
  - These rules judge a skill's own instructions, as the template exemption already recognizes
    for placeholder text. References are therefore exempt from them and from P7.1, and P3.5 and
    the remaining rules still apply.
  - The library validator never judged these files: they sat outside its containment scope.
  - Agent Skills defines frontmatter for `SKILL.md` only, so references keep none (spec edge case).
- Removed: the containment rule (`OUT-OF-SCOPE`) and the type detection (`LIBRARY-TYPE`). The skill
  validator judges only the folder it is given, and a bundled file's kind comes from its folder.
  The governance kind has no files left.
- Alternatives considered:
  - Adding frontmatter to the references. Rejected: the files would carry two versions (body and
    frontmatter) for no reader.
  - Calling the old script as a helper. Rejected: FR-005 removes it.

## R5. The validation cache

- Decision: `vc_key` hashes the skill's `assets/` and `references/` files. `vc_environment_hash` drops
  `validate-library.sh`; `lib/` is still hashed whole.
- Rationale: FR-006. A bundled file is now a validator input for its own skill only.

## R6. Bundled-file paths, and setup's copying

- Decision: a new `tests/self-contained-skills.test.sh` covers every skill under `skills/`:
  1. Every `references/…`, `assets/…`, or `scripts/…` token in `SKILL.md` is one level deep, and the
     file exists.
  2. Every file in those folders is named in `SKILL.md` as `<folder>/<file>`. This passes today.
  3. No `SKILL.md` or bundled file names `../`, `skills/highway-`, `framework/`, `tests/`, or
     `harness/`.
  4. A `.highway` mention is allowed only on a line that also names `code/`, `product`,
     `metadata.md`, or `features/`. Those are a code product's records (clarification 2).
  5. `.highway/` does not exist at the repository root.
  6. No framework script, test script, harness source, binary, scenario, selection, coverage file,
     manifest, or live document (`README.md`, `framework/README.md`, `framework/authoring-standard.md`,
     `harness/README.md`) names `.highway` outside the code-product rule.
  7. highway-setup states "Setup writes no file other than the seeded files.", and every `assets/`
     file it names is a seeded skeleton (`hw_seeded`).

  The test builds the token from parts, as the packaging tests do for development paths, so its own
  text holds none. Each check has a seeded probe on a temporary copy.
- Rationale: FR-007, FR-008, FR-011, and FR-012 in one place. The narrower old guards it replaces are
  listed in R11.

## R7. The project root (clarification 1)

- Decision: 14 skills drop "(A) Project root containing `.highway/`." from Inputs. highway-request,
  highway-codify, and highway-codify-config drop their Entry stop and their Error Handling bullet.
  - highway-codify and highway-codify-config renumber their Entry steps (the stop was step 1).
    highway-request's was its last step.
  - highway-controls, highway-objectives, and highway-nfrs drop "No … record is written beneath
    `.highway`." Nothing is beneath `.highway` now.
  - Each changed skill takes a MINOR version, its Example's `Version:` line follows (P9.5), and the
    adapters and index are regenerated.
- Rationale: the seeded-file check already precedes the first question in all three skills (Phase 8),
  so a project that has not run setup still gets the setup message.

## R8. The distribution

- Decision:
  - Manifest: `include skills .highway/skills` becomes `exclude skills -`, and both `.highway` rows go.
    The skills ship only in the four agent trees, which already hold every bundled file.
  - `generate-distribution.sh`:
    - Its record moves to `.distribution-record` at the distribution root.
    - The verification tree copies `.agents/skills/` (`HW_AGENT_CODEX`, the cross-agent location)
      to `skills/` before validating.
  - `distribution-packaging.test.sh`:
    - Compares each `SKILL.md` with the copy under `.agents/skills/`.
    - Asserts no `framework/`, `tests/`, `skills/`, or `.highway` in the distribution.
    - Seeds its probes in `.agents/skills/highway-help/`, an included folder.
  - `shipped-tree-independence.test.sh` seeds its probe there too, and `run-all.sh` cleans those globs.
- Rationale: FR-013. Nothing reads a source copy of the skills in a project any more, so shipping one
  only adds files.
- Alternatives considered: shipping `skills/` unchanged at the distribution root. Rejected: no agent
  discovers it, and Phase 14's plugin replaces the distribution anyway.

## R9. The harness test project

- Decision:
  - `project.ts`:
    - `buildDistribution` becomes `buildSkills`. Once per run it copies each folder in `skills/`
      that has a `SKILL.md` into `<work>/base/.github/skills/<name>/`, the Copilot driver's
      discovery location.
    - `path-map.sh --location agent-skills` prints that location from `HW_AGENT_COPILOT`.
    - `ProjectSource.distDir`, `Context.distDir`, and `saveCandidate`'s argument become `baseDir`.
      Chain snapshots skip what the base supplies, as before.
    - The `build-failed` failure kind stays, with check `skills` and message
      "The skill copy failed; …".
  - `fixture-check.sh`: its `.highway` rule becomes "fixtures hold project files only; the harness
    supplies the skills". It is raised when a fixture holds any of the four agent skill folders.
  - `harness-fixtures.test.sh` seeds a temporary overlay holding `.github/skills/` and requires that
    failure.
  - `path-map.sh` loses its catalog arm. `skills/highway-help/assets/index.json` now selects
    highway-help.
  - `treatments.txt` loses the waiver for codify's removed bullet. The template waiver's reason says
    the harness copies each skill folder whole.
  - `runner.test.ts` and `chain.test.ts` build their fake base with `.github/skills/`.
- Rationale: FR-014, FR-015. The test project holds exactly what a plugin install gives an agent: the
  skill folders.

## R10. Constitutions (clarification 4)

- Decision: the Highway Skills Constitution is unchanged. Its current text names neither `.highway/`
  nor the library; its mentions are in Sync Impact Report history.
- The development constitution goes 3.3.0 → 3.4.0, MINOR under its Versioning Policy:
  - the Shipped artifact definition names the agent trees with each skill's bundled files and
    `framework/README.md`;
  - the D1.2 Enforcement Map note says the verification tree takes the skills from an agent tree;
  - D1.5 reads "a skill or a file it bundles";
  - Principle VIII becomes "Bundled File Dependency Review", and D8.1 reads "A change to a skill's
    bundled file MUST be followed by re-validation of every skill that cites it." The Observable is
    unchanged;
  - the Skill Content Gate triggers on a file under `skills/`.
- Classification: no principle's obligation is removed, redefined in meaning, or strengthened. The
  shared library's files are the files skills now bundle, and every Observable is unchanged, so no
  conforming work fails. The definitions follow the new arrangement, as in 3.3.0. The Sync Impact
  Report records this with the self-application review (D1.3, D1.4, D5.3).
- Alternatives considered: removing Principle VIII (MAJOR). Rejected: its obligation still has
  subjects, the templates in `assets/`.

## R11. Tests retired, reduced, or repointed (FR-016)

- Retired:
  - `validate-library.test.sh`: its seven fixture checks move to `bundled-files.test.sh`, which builds
    temporary skills from `fixtures/valid-skill/` holding the old library fixtures in `assets/` or
    `references/`.
    - Kept:
      - the valid template with placeholder MUST, which passes;
      - the template missing `metadata.version` (P7.2);
      - the reference with a bad citation (P3.5, from the governance fixture);
      - the valid knowledge and governance files, now references.
    - Superseded:
      - the orphan `LIBRARY-TYPE` case, since a bundled file's kind comes from its folder;
      - the template's printed N/A group, since a bundled file's verdict joins the skill's
        FAILED line and prints no group of its own;
      - the knowledge file with two keywords (P1.1), since references are exempt from the
        rule-shape rules (R4).
    - Added: every shipped skill's bundled files pass.
  - `library-containment.test.sh`: superseded. Its subject, the validator's out-of-scope rule, is
    gone. The validator now judges only a skill folder it is given; a user's control file is not one.
    Its "fixtures are still judged" check is kept by `bundled-files.test.sh`. Its "no controls under
    `.highway`" check is kept by R6 check 5.
  - `tests/fixtures/library/` moves to `tests/fixtures/bundled-files/`, with `mv`.
- Repointed:
  - `generate-catalog.test.sh`: `HW_HELP_INDEX`, the new fields, and the R2 case.
  - `adapter-coverage.test.sh`: reads `HW_HELP_INDEX` and stops copying `.highway`.
  - `validation-cache.test.sh`: stops copying `.highway`, and gains a references-key case.
  - `storage-contract.test.sh`: the highway-help lines.
  - `harness-path-map.test.sh`: the index maps to highway-help, and the two `.highway` expectations
    are dropped, superseded by R6.
  - `dependency-check.test.sh`: the target is a file in a temporary skill's own `references/`.
  - `record-templates.test.sh`: sections 2–4 become "no `.highway` anywhere", covered by R6, so they
    reduce to section 1 and the probe.
  - `profile-template-migration.test.sh` and `experience-activation.test.sh`: their `.highway`
    absence guards are superseded by R6.
  - `rule-checks.test.sh`: the P9.1 shared-folder probe names `shared/templates/example-record.md`.
  - `feature-038-helpers.sh`: the unused `catalog` arm goes.
- `lib/dependency-check.sh` resolves against the skill's own folder (clarification 3).

## R12. Documents

- Decision:
  - `README.md` and `framework/README.md`: the index path; the merged validator; the distribution
    layout and record; dependencies resolving in the skill folder. The library validator section
    goes, and the tree diagram drops `.highway/`.
  - `framework/authoring-standard.md`: the `metadata.dependencies` row names the skill's own folder.
    "as it checks a library file" becomes the bundled-file wording.
  - `harness/README.md`: the test project, fixtures, and build failure.
  - `standard-alignment.md`: the Phase 11 status note and the Phase table rows for 10 and 11.
  - `governance-plan.md` is a plan record and keeps its history (spec US5 #3).
