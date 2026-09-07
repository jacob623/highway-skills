# Research: Rename Shared Content Directory to Library

No `[NEEDS CLARIFICATION]` markers remain in the Technical Context (this is a rename of
existing, already-implemented tooling; there is no new technology to choose). The decisions
below record the scope boundary and mechanics of the rename itself, resolved during
`/speckit-specify`'s clarification step and confirmed here against the actual current codebase.

## Decision 1: Rename mechanism

**Decision**: Every move is performed with `git mv <old> <new>` (or a tool-equivalent that git
records as a rename), never a plain delete-then-recreate.

**Rationale**: `git log` confirms `.highway/content/` and every file feature 004 added were
already merged to `main` (commit `344de50`, merged via `ea3ddc0`) before this feature began.
Deleting and recreating those paths would show as 100% additions/deletions in history and lose
`git blame` continuity for no benefit; `git mv` costs nothing extra and preserves it.

**Alternatives considered**: Plain `rm` + `create_file` — rejected for the history-loss reason
above, with no offsetting advantage.

## Decision 2: Where the two changed contracts live

**Decision**: `content-validation-output.md` and `content-catalog.schema.json` are not edited
in place under `specs/004-shared-content-library/contracts/`. Instead, this feature adds
`library-validation-output.md` and `library-catalog.schema.json` under its own
`specs/005-rename-content-to-library/contracts/`, describing the same format with the renamed
tag/field/filenames.

**Rationale**: `specs/004-shared-content-library/` is a historical record of what feature 004
shipped (FR-007), mirroring the existing precedent that `specs/001-...` and
`specs/002-highway-folder-consolidation/` were never edited by later features even as the
runtime code they informed kept evolving. The tag (`CONTENT-TYPE`→`LIBRARY-TYPE`) and field
(`content_type`→`library_type`) genuinely change shape in this feature — that is a new contract
version, not a typo fix, so it belongs in this feature's own contracts directory.

**Alternatives considered**: Editing the specs/004 contracts in place — rejected, breaks the
frozen-historical-record precedent and would misrepresent what feature 004 actually shipped.

## Decision 3: `dependency-validation-output.md` is left alone

**Decision**: `specs/004-shared-content-library/contracts/dependency-validation-output.md` is
not superseded, copied, or edited. `.highway/tools/lib/dependency-check.sh` keeps citing it
unchanged.

**Rationale**: Read in full, the `[DEPENDENCY]` tag and its two message shapes do not contain
the word "content" as an identifier — FR-008/FR-009 list only the content-type tag, the catalog
field, and specific script/file names, none of which this contract governs. Its two illustrative
example messages (`dependency 'content/templates/foo.md' does not exist`) will read as a stale
path after the rename, but that is the same accepted cost as any other frozen historical
example — this repository already accepted an analogous stale-but-verbatim historical record
earlier (feature 004's own Clarifications Q1 answer text).

**Alternatives considered**: Forking a `specs/005` copy solely to refresh the example path —
rejected as unnecessary churn for a contract whose actual shape is unchanged.

## Decision 4: Internal function-prefix rename scope

**Decision**: Only the `cs_*` prefix in `lib/content-schema.sh` is renamed (to `ls_*`), because
that file itself is renamed to `lib/library-schema.sh` per FR-008. Every other library's
prefix — `con_*` (`constitution.sh`), `fm_*` (`frontmatter.sh`), `rc_*` (`rule-checks.sh`),
`dc_*` (`dependency-check.sh`), `bs_*` (`body-scan.sh`), `sv_*` (`schema-validate.sh`) — is
confirmed, by reading each file's own header comment, to stand for something other than
"content" and is left untouched.

**Rationale**: Leaving `cs_*` (literally short for "content-schema") inside a file freshly
renamed to `library-schema.sh` would recreate the exact naming inconsistency this feature
exists to remove, and would leave a `.highway/content` literal absent but a `cs_` mnemonic
present with no textual trace of what it once meant. Renaming the other five prefixes would be
scope creep with no rename to justify it — none of them derive from "content".

**Alternatives considered**: Renaming every library prefix "for consistency" regardless of
whether it says "content" — rejected; out of scope per FR-007/FR-008's boundary and the spec's
explicit edge case that generic, unrelated uses of the word are untouched.

## Decision 5: The shared `[SCHEMA]` tag and generic field names are untouched

**Decision**: The `[SCHEMA]` error tag (used by both `validate-skill.sh` and the renamed
`validate-library.sh` for identity/frontmatter findings) and the catalog schema's `name`,
`description`, and `version` field names are not renamed.

**Rationale**: `[SCHEMA]` and these field names do not contain or derive from the word
"content" — `schema-validate.sh`'s own header already establishes `[SCHEMA]` as the generic
tag shared across artifact types. Renaming them would be unrelated to this feature's stated
scope (spec.md Edge Cases: "the generic English word 'content' ... is explicitly untouched").

**Alternatives considered**: None; this is a verification against the actual current file
contents, not a genuine alternative.

## Decision 6: Verifying zero residue is itself a script, not a manual pass

**Decision**: Completion of the rename is confirmed by a repeatable command —
`grep -rn '\.highway/content' <every live path>`, scoped to exclude
`specs/001-multi-agent-skill-suite/`, `specs/002-highway-folder-consolidation/`,
`specs/003-constitution-enforcement/`, and `specs/004-shared-content-library/` — returning zero
matches (SC-004), run alongside `.highway/tools/tests/run-all.sh` (SC-002).

**Rationale**: A named, scriptable check is consistent with this repository's own Measurable
Quality Gates principle (already applied to this feature's own tooling in feature 004's plan);
a manual "look for stragglers" pass is not repeatable and cannot be cited as evidence in a
completion report.

**Alternatives considered**: Manual `git grep` eyeballing before merge — rejected as
unrepeatable.
