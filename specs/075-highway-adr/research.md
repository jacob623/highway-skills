# Research: Highway ADR Decision Workflow

## Decision 1: Reuse the repository's canonical skill and template boundaries

Decision: Add the ADR skill and ADR record/catalog templates under `.highway/`, then regenerate
adapters, catalogs, and manifests from those canonical inputs.

Rationale: Existing Discovery and Clarification workflows establish this as the repository's
source-of-truth boundary. It keeps distributed outputs synchronized and satisfies D4.1-D4.7 and
the shared-template dependency rule.

Alternatives considered: Editing generated adapters directly was rejected because regeneration
would overwrite the change and leave the canonical workflow incorrect.

## Decision 2: Use in-memory validation, allocation, and ordered commit

Decision: Resolve and snapshot all inputs, build the ADR and catalog in memory, validate the
complete structures, allocate the catalog identifier, and commit only after validation. Retry an
exclusive catalog conflict no more than three times.

Rationale: This matches the Discovery and Clarification transaction boundary and provides the
required no-partial-write behavior. No lock, back-off dependency, or external persistence service
is needed; conflict detection is the existing catalog allocation mechanism.

Alternatives considered: Writing the ADR before catalog validation was rejected because it could
leave an orphaned decision. Automatic merging was rejected because catalog conflicts must preserve
existing bytes and never silently combine decisions.

## Decision 3: Treat Discovery's recorded analysis as authoritative input

Decision: Consume the Discovery recommendation, scores, comparison matrix, candidate options, and
Reference Architecture matches exactly as recorded. ADR selection may choose any existing option,
but it does not recompute scores, matches, confidence, or ranking.

Rationale: Discovery explicitly owns advisory analysis and its ADR handoff. The ADR owns the final
selection and rationale, while preserving traceability to the advisory source.

Alternatives considered: Re-running matching or scoring in ADR was rejected because it would create
two competing analyses and violate the specification's source immutability and determinism rules.

## Decision 4: Define deterministic option and relationship ordering from stable identifiers

Decision: Apply the specified tie-break sequence: Discovery recommendation, higher Discovery score,
more recorded Reference Architecture matches, then the numeric suffix of the `OPT` identifier.
Order Objective, Control, and NFR relationships by identifier type, numeric identifier suffix, and
title. Sort each alternatives list by the Discovery option order.

Rationale: All keys are present in retained source artifacts and do not depend on filesystem order,
timestamps, or environment state.

Alternatives considered: Sorting by path or file discovery order was rejected as nondeterministic.
Sorting by full identifier text was rejected because the contract explicitly separates identifier
type and numeric identifier.

## Decision 5: Make Clarification a start-of-run, consumer-only snapshot

Decision: Resolve only `CLAR-REQ######` and `CLAR-DISC######` through the Clarification catalog at
the beginning of generation. Consume resolved findings and responses according to status; carry
open findings as references and advisory risks; record conflict guidance in risks and rationale;
never use guidance to select an option or mutate Clarification.

Rationale: Clarification owns detection, responses, lifecycle, and status. A start-of-run snapshot
prevents a mid-run status change from producing mixed evidence and preserves byte-level source
immutability.

Alternatives considered: Re-reading Clarification during rendering was rejected because it could
mix status or findings from different revisions. Consuming `CLAR-ADR######` was rejected because
ADR clarification is explicitly post-generation.

## Decision 6: Permit explicit empty handoff values

Decision: A Reference Architecture Handoff field is valid when it contains a typed value or the
literal `None`. Empty lists such as no matching architectures or no required architecture work are
rendered as `None`, never as an omitted field or an invented value.

Rationale: FR-041 requires every field to be present and valid while the Discovery contract permits
missing optional matches. Explicit `None` preserves completeness without manufacturing evidence.

Alternatives considered: Treating every empty list as fatal was rejected because the specification
allows permitted absence. Omitting empty fields was rejected because consumers could not distinguish
absence from malformed output.

## Decision 7: Make conditional sections genuinely conditional

Decision: Render Recommendation Override immediately after Decision only when the selected option
differs from the Discovery recommendation. Render Open Clarification Findings only when a
contributing open finding exists. Always render required sections, including Decision Confidence,
and always render initial `Supersedes: None` and `Superseded By: None` fields.

Rationale: The specification names the trigger and required values for each conditional section;
adding empty pseudo-overrides or empty finding sections would obscure whether the condition occurred.

Alternatives considered: Always rendering `Override: None` was rejected because FR-029 requires a
traceable override section specifically for divergent decisions.

## Decision 8: Use existing Bash and Markdown validation infrastructure

Decision: Add focused static-contract and executed-behavior fixtures to the existing Bash 3.2 test
harness, then run validators, generators, focused tests, and the full suite.

Rationale: Existing tests already cover source documents, generated artifacts, disposable fixtures,
byte preservation, and deterministic output. A new test framework would add a dependency without
improving coverage of Markdown workflow contracts.

Alternatives considered: Introducing a runtime service, package, or separate test framework was
rejected because the feature is a repository workflow and D2.4 prohibits unnecessary dependencies.

## Resolved Technical Unknowns

- Catalog conflicts use the existing exclusive allocation pattern and a maximum of three retries.
- Reference Architecture tie-breaking uses the recorded match count only; equal counts proceed to
  the next specified tie-break.
- Recommendation Override is conditional and appears immediately after Decision.
- Clarification is snapshotted at the start of a run.
- Explicit `None` is valid for an empty handoff field.
- Open finding identifiers are deduplicated by finding identifier after source resolution.
- Relationship numeric ordering uses the identifier's numeric suffix, followed by title.