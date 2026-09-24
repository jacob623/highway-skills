# Implementation Plan: Seed Library Context Documents
**Branch**: `087-seed-library-context` | **Date**: 2026-09-24 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/087-seed-library-context/spec.md`

## Summary
Copy the three exact root seed documents into `.highway/library/knowledge/` with unchanged
filenames and bytes. The implementation will preflight all required sources, converge each
destination to its source, and verify byte equality and source preservation with a focused Bash
## Technical Context

**Language/Version**: Markdown source files; Bash 3.2.57-compatible validation scripts
**Primary Dependencies**: Existing POSIX shell utilities and repository test harness; no new dependency

**Storage**: Repository files under the root and `.highway/library/knowledge/`
**Testing**: Focused Bash test plus `.highway/tools/tests/run-all.sh`; byte equality via existing file comparison utilities

**Target Platform**: macOS and GNU-like environments supported by the existing Bash test suite
**Project Type**: Repository documentation and shell validation suite

**Performance Goals**: Complete the three-file copy and verification in a single local test run; no service-level latency requirement
**Constraints**: Preserve bytes exactly; use the existing toolchain; do not delete root sources; do not add a runtime dependency; do not modify unrelated library files

**Scale/Scope**: Exactly three source-to-destination mappings and one focused test; no catalog or library taxonomy change
## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*
- **D1.5 PASS**: This plan records a Constitution Check because it creates repository library files and a validation test.
- **D2.1 PASS**: The focused test will remain Bash 3.2.57-compatible and avoid unsupported features.
- **D2.2/D2.4 PASS**: The plan uses only utilities in the declared toolchain and adds no runtime dependency.
- **D3.1 PASS at planning baseline**: The repository's existing suite was previously observed passing before this feature work; implementation must recheck before editing.
- **D3.2/D3.3 REQUIRED**: Implementation must end with the full suite passing and add the focused test under `.highway/tools/tests/` for this behavioral copy contract.
- **D3.6/D3.8 REQUIRED**: The focused test must be observed failing for a seeded copy defect before completion and must report executed byte-copy behavior separately from static spec evidence.
- **D6.1/D6.2 PASS**: The feature's live quickstart and plan references use paths created or retained by the feature; no unrelated live documentation is invalidated.
- **D8.1 N/A**: No existing skill cites one of these new knowledge files, so there are no dependent skills to revalidate.
- **Generator gate N/A**: No generator script or generated artifact is changed.
No constitution violation requires a complexity exception.

## Project Structure
### Documentation (this feature)

```text
specs/087-seed-library-context/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/
│   └── requirements.md
└── tasks.md                  # Created later by /speckit-tasks
```

### Source and validation paths

```text
highway-identity.md
highway-platform-objectives.md
highway-vision.md
.highway/library/knowledge/
├── highway-identity.md
├── highway-platform-objectives.md
└── highway-vision.md
.highway/tools/tests/
└── seed-library-context.test.sh
.highway/tools/seed-library-context.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/.distribution-manifest
```

**Structure Decision**: This is a repository-file feature. The three root documents remain
temporary source inputs, the retained copies live in the existing knowledge library, and a
copy tool and focused test join the existing Bash test suite. No application source tree, service layer,
database, or contracts directory is introduced.

## Phase 0: Research Decisions

Research is recorded in [research.md](research.md). The resolved decisions are:

1. Use `.highway/library/knowledge/` as the destination.
2. Treat Markdown as opaque bytes and avoid normalization.
3. Preflight all three sources before copying, then compare every result.
4. Make reruns deterministic by converging conflicting destinations to source bytes.
5. Verify the behavior with a focused repository test.
6. Skip `contracts/` because the feature exposes no external interface.
7. Exclude opaque context copies from frontmatter cataloging and temporary root seeds from distribution packaging.

## Phase 1: Design Outputs

- [data-model.md](data-model.md) defines the three source entities, three destination entities,
  fixed mappings, invariants, and lifecycle.
- [quickstart.md](quickstart.md) defines focused, manual, cleanup, and full-suite validation.
- No `contracts/` artifact is required because no API, CLI schema, service endpoint, or protocol
  is introduced.

## Implementation Approach

1. Confirm all three exact root source files exist before producing a complete result.
2. Ensure `.highway/library/knowledge/` is available without changing its unrelated contents.
3. Run `.highway/tools/seed-library-context.sh` to copy each source to its same-named destination, replacing stale destination bytes if needed.
4. Compare every source/destination pair byte-for-byte.
5. Keep the three opaque context copies out of frontmatter-based library cataloging and classify the temporary root sources as excluded from distribution.
6. Verify source bytes and unrelated knowledge files remain unchanged.
7. Exercise missing-source and conflicting-destination probes in the focused test.
8. Run the focused tests and the full repository suite.

## Complexity Tracking

No violations or complexity exceptions are present.
