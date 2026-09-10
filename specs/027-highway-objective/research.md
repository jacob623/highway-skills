# Research: Highway Objective

## Decision: Mirror the existing user-owned governance workflow

**Decision**: Implement Business Objectives as Markdown records with YAML frontmatter, following
the established `highway-nfrs` and `highway-controls` ownership boundary: source skill and shared
template in `.highway/`, records and generated catalog at repository-root `library/`.

**Rationale**: Existing skills already define how Highway distinguishes shipped authoring guidance
from user-owned governance content. Reusing that boundary prevents the framework from treating a
user's objective prose as Highway governance and keeps `validate-library.sh` from judging files it
does not own.

**Alternatives considered**:

- Store objective records under `.highway/library/`: rejected because it would make user-owned
  governance subject to framework distribution and library validation rules.
- Store all objectives in one file: rejected because permanent per-objective records are required
  for stable downstream references and selective updates/removals.

## Decision: Use a dedicated runtime catalog generator contract

**Decision**: The skill owns deterministic generation of `library/governance/objectives.md` from
the objective records and the authoritative baseline metadata, including `next_id` and version.

**Rationale**: The existing shared-library catalog generator indexes shipped authoring artifacts;
it is not the owner of user governance baselines. A dedicated objective workflow keeps objective
versioning, permanent ID allocation, and mutation transactions together.

**Alternatives considered**:

- Extend `generate-library-catalog.sh` to generate the objective baseline: rejected because that
  generator intentionally scans `.highway/library/` and emits framework metadata, not user-owned
  records.
- Derive `next_id` from filenames: rejected because removed identifiers must never be reused and
  the catalog is the authoritative allocation state.

## Decision: Treat every mutation as a staged transaction

**Decision**: Read and validate the complete baseline, construct proposed records/catalog/version,
show the proposal and confirmation state, and write only after explicit confirmation; a declined,
ambiguous, malformed, or failed operation leaves all affected bytes unchanged.

**Rationale**: The feature's destructive-operation and versioning requirements make partial writes
unacceptable. Staging also ensures exactly one version increment per confirmed action.

**Alternatives considered**:

- Write the record first and regenerate the catalog afterward: rejected because catalog failure
  could leave an inconsistent baseline.
- Increment version before confirmation: rejected because declined operations must preserve bytes
  and version.

## Decision: Keep title derivation deterministic and non-interactive

**Decision**: Derive the title deterministically from the first prompt's statement, as bounded by
the specification's three-prompt interview, and present it in the proposal for confirmation.

**Rationale**: The required interview has exactly three prompts and no separate title prompt. A
deterministic proposal makes the title visible without inventing user facts and allows correction
before any write.

**Alternatives considered**:

- Add a fourth title prompt: rejected because it violates the specified three-prompt workflow.
- Generate a title from timestamps or environment values: rejected because emitted artifacts must
  be deterministic and environment-independent.