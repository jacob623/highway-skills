# Research: Discovery Analysis

## Decision: Use the existing Markdown skill distribution pattern

**Rationale**: Highway skills are authored once under `.highway/skills/`, then registered and emitted to supported agent adapters by existing generators. Feature 048 will add one source skill, two shared output templates, one focused test, and regenerated outputs. No new runtime or parser dependency is justified.

**Alternatives considered**: Separate agent-specific implementations were rejected because generated adapters are the repository's established distribution boundary. A standalone executable was rejected because the feature is an instruction-driven analysis workflow, not a service.

## Decision: Resolve one source Request by explicit identifier

**Rationale**: The invocation must supply an identifier in the form `REQ` followed by exactly six digits. Resolution must find exactly one Request whose completion state is `Complete`. Missing, malformed, ambiguous, nonexistent, non-unique, or incomplete resolution aborts before catalog allocation or writes.

**Alternatives considered**: Selecting the newest Request was rejected because file ordering and timestamps are not authoritative. Analyzing all completed Requests was rejected because it changes one invocation into an unbounded batch operation.

## Decision: Use a closed, ordered input set

**Rationale**: Analysis reads only the selected Request and, when present, the Profile, Objective, Control, and NFR baselines. Inputs are loaded in that order, identified by their authoritative paths and identifiers, and treated as immutable during analysis. No network, filesystem discovery outside these sources, ADR, architecture, or implementation input is consulted.

**Alternatives considered**: Broad repository search was rejected because it makes output dependent on unrelated files and undermines reproducibility and ownership boundaries.

## Decision: Define deterministic rule-based extraction

**Rationale**: Each output section is produced by explicit rules over normalized source text. The rules preserve source evidence, classify missing information rather than inventing it, and sort all generated lists by stable key. The implementation will use this order:

1. Normalize line endings to LF, trim trailing whitespace, preserve paragraph boundaries, and compare case-insensitively for matching while retaining source spelling for display.
2. Redact secrets and regulated personal data before any candidate is copied to output; retain a stable category marker and request business-relevant replacement evidence.
3. Extract explicit Request evidence into the Request section in the template's fixed order.
4. Generate Research Findings from explicit problem, current-process, desired-change, success-measure, and constraint statements; each finding cites its source domain and is sorted by domain order then source order.
5. Generate Assumptions for required analysis inputs that are absent, explicitly unknown, or stated as dependencies; deduplicate by normalized text and sort lexicographically by normalized text.
6. Generate Risks from explicit constraints, dependencies, unresolved assumptions, privacy exclusions, and failure-sensitive transaction conditions; deduplicate and sort by normalized risk text.
7. Generate Unknowns from absent required evidence, unresolved terms, and explicit unknown markers; deduplicate and sort lexicographically.
8. Generate Candidate Approaches from distinct desired-change strategies explicitly present in the Request. If none are present, emit the required section with a deterministic `No candidate approaches identified from the supplied evidence.` entry rather than inventing an approach.
9. Match governance baselines using the confidence rules in the spec. Evaluate explicit identifiers first, then exact normalized title/statement matches, then token overlap. Emit only candidates meeting one of those rules; sort by confidence rank High, Medium, Low, then identifier.
10. Derive the title from the Request title according to the stated precedence and serialize every section and list in the template order.

**Alternatives considered**: Free-form model-authored analysis was rejected because it cannot guarantee byte-identical output. Requester-authored sections were rejected because they do not satisfy the accepted deterministic-analysis clarification.

## Decision: Define deterministic relationship matching

**Rationale**: Matching is performed independently for Objective, Control, and NFR baselines. An explicit identifier reference is High confidence. Otherwise, an exact normalized title or statement match is Medium confidence. Otherwise, a candidate is Low confidence only when at least two normalized non-stopword tokens from the Request's problem and desired-change evidence occur in the candidate statement. Single-token overlap is insufficient. Candidates are deduplicated by artifact identifier and sorted by confidence rank followed by identifier. Rationale records the first matching rule and source evidence domain.

**Alternatives considered**: A configurable similarity threshold was rejected for Version 1 because configuration would create another source of nondeterminism. Treating every keyword hit as a relationship was rejected because it creates noisy advisory output.

## Decision: Use transactional Markdown outputs

**Rationale**: The skill constructs the Discovery record and catalog update in memory, validates both against their complete templates and cross-references, then performs exclusive catalog allocation and writes both outputs. A catalog conflict retries at most three times. Any failure preserves the original bytes and writes no partial output.

**Alternatives considered**: Writing the record before the catalog was rejected because it can leave an unindexed Discovery. Deriving identifiers from filenames was rejected because the catalog is authoritative.

## Decision: Reuse the existing validation and generation toolchain

**Rationale**: Validation uses `.highway/tools/validate-skill.sh`, `.highway/tools/validate-library.sh`, the focused discovery test, catalog/adapters generators, adapter coverage, and `.highway/tools/tests/run-all.sh`. No package manager, network service, or new interpreter is introduced.

**Alternatives considered**: A new test framework or runtime parser was rejected because it would duplicate repository mechanisms and violate the no-new-dependency constraint.

## Resolved Technical Context

- Instruction format: Markdown skill with ordered normative rules.
- Inputs: one completed Request plus optional Profile, Objective, Control, and NFR baselines.
- Outputs: one `discoveries/DISCXXXXXX.md` record and one `discoveries/discoveries.md` catalog entry.
- Runtime state: user-owned Markdown files; no database or service.
- Determinism: stable normalization, rule precedence, deduplication, sorting, title derivation, and serialization.
- Privacy: redaction occurs before output construction and matching evidence is replaced with a stable marker.
