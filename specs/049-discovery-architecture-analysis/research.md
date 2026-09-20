# Research: Discovery Architecture Analysis

## Decision: Extend the existing Markdown/Bash skill and shared-template boundary

**Rationale**: Feature 048 already establishes the canonical Discovery skill, shared record and
catalog templates, generated agent adapters, catalog-authoritative allocation, and focused shell
tests. Feature 049 changes the analysis contract and record structure, not the runtime model.

**Alternatives considered**: A new executable analyzer was rejected because it would duplicate the
instruction-driven workflow and introduce a runtime dependency. Agent-specific implementations
were rejected because generated adapters are the distribution boundary.

## Decision: Preserve closed, ordered inputs and privacy-first processing

**Rationale**: Discovery remains reproducible only when it reads one completed Request and the
optional Profile, Objective, Control, NFR, and Reference Architecture inputs in the declared order.
Redaction remains before copying, matching, scoring, or serialization.

**Alternatives considered**: Broad repository search and network lookup were rejected because they
would make output depend on undeclared state. Requesting a human to sanitize input was rejected
because it would weaken the existing deterministic privacy boundary.

## Decision: Generate options by explicit precedence and retain two through five

**Rationale**: Candidate options are generated from explicit Desired Change strategies first, then
strategies implied by Objectives, Controls, NFRs, Research Findings, and available Reference
Architectures. Normalize, deduplicate, validate required fields, sort by the specified alignment
keys and title, assign `OPT` identifiers after sorting, and retain at most five.

**Alternatives considered**: Free-form option invention was rejected because it cannot prove closed
evidence support. Retaining every viable option was rejected because the specification requires a
bounded ADR handoff. Fewer than two distinct viable options remains a no-write abort.

## Decision: Use exact, independent Reference Architecture matching

**Rationale**: Version 1 evaluates every candidate independently using the six specified rules:
explicit identifier, normalized title, capability identifier, Objective identifier, Control
identifier, and NFR identifier. Every matching candidate is reported, and each candidate records
its highest-precedence reason. Semantic similarity and inference remain excluded.

**Alternatives considered**: First-match-only reporting was rejected because it hides available
architecture evidence. Similarity matching was rejected because its threshold and evidence would
not be deterministic in Version 1.

## Decision: Use fixed weighted scoring and a deterministic tie-break

**Rationale**: Recommendation scores use Objective 30, NFR 30, Control 20, Profile 10, and Risk
Reduction 10. Zero denominators produce zero. Confidence derives from fixed score ranges. Ties
first favor an option with a Reference Architecture; when all tied options have matches, each
option uses the highest Reference Implementation count among its matches, with unavailable
catalogs treated as zero; equal counts fall back to the lower `OPT` identifier.

**Alternatives considered**: Subjective reviewer ranking was rejected because Discovery is advisory
analysis but must remain repeatable. Summing counts across multiple Reference Architectures was
rejected because it would reward match quantity rather than the strongest associated evidence.

## Decision: Keep informational categories outside recommendation scoring

**Rationale**: Complexity, Governance Impact, and Operational Overhead are mandatory matrix
categories, but their classifications are derived only from Discovery-contained counts and cannot
change score, confidence, ranking, selection, or option ordering.

**Alternatives considered**: Folding operational or governance burden into Risk Reduction was
rejected because it would change the normative score model and blur advisory information with
recommendation evidence.

## Decision: Keep ADR authoritative for decisions

**Rationale**: Discovery exposes all options, matrix data, recommendation rationale, and Reference
Architecture matches as advisory handoff data. ADR records selection, rejection, acceptance,
rationale, and consequences; Discovery never records those decisions or mutates baselines.

**Alternatives considered**: Automatically accepting the recommendation was rejected because it
would collapse analysis and decision ownership and authorize implementation without ADR review.

## Resolved Technical Context

- No new language runtime, package, network service, or database is required.
- The existing shell toolchain and generated adapter workflow remain authoritative.
- The output bound is one Discovery record with two through five options and one recommendation.
- Reference Architecture and Reference Implementation catalogs are optional advisory inputs with
  explicit empty/unreadable fallbacks.