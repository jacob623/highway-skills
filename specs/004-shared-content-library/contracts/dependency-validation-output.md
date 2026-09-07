# Contract: Dependency Validation Output

Governs the `[DEPENDENCY]`-tagged findings `.highway/tools/validate-skill.sh` emits when
checking a skill's `metadata.dependencies` list (FR-005 through FR-007, FR-015).

## Finding line format

    ERROR: [DEPENDENCY] <message>

Two messages are defined, one per failure outcome in data-model.md:

- **Missing path**:
  `ERROR: [DEPENDENCY] dependency 'content/templates/foo.md' does not exist`
- **Version mismatch**:
  `ERROR: [DEPENDENCY] dependency 'content/templates/foo.md' pinned at version 1.0.0, current version is 1.1.0`

No other message form is used for a dependency finding. Both name the dependency's `path`
verbatim as declared in the skill's frontmatter.

## Ordering

Dependency findings are checked and reported in the order the `dependencies` entries appear in
the skill's frontmatter. A skill with zero entries produces zero dependency findings and is not
penalized for having none (dependencies are optional, per data-model.md).

## Exit status

A `[DEPENDENCY]` finding is an `ERROR:` line like any other `validate-skill.sh` finding; its
presence sets exit status 1, identical to a `[SCHEMA]` or rule-ID finding. It contributes to the
`<k>` violation count in the skill's `FAILED:` result line.
