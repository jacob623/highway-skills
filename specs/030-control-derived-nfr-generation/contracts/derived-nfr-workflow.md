# Contract: Control-Derived NFR Workflow

## Proposal Contract

After a valid new Control is created, the Control workflow MUST produce a deterministic proposal
before any derived NFR write. Each proposal item contains:

- originating Control ID;
- originating Control title;
- candidate NFR title;
- candidate NFR statement;
- candidate NFR rationale; and
- stable candidate order.

A valid Control with no matching derivation rule produces an explicit zero-candidate result and
remains valid.

## Review Contract

The author reviews each candidate independently and chooses one of:

- **Accept**: use the candidate wording as approved;
- **Modify**: edit the candidate wording, then approve the edited result;
- **Replace**: supply replacement wording, then approve the replacement;
- **Reject**: discard the candidate; or
- **Cancel**: end the review without creating derived NFRs.

No NFR identifier is allocated and no NFR record, catalog entry, or relationship is written before
review decisions are complete.

## Accepted-Write Contract

For each accepted candidate, using the existing NFR catalog allocation rules:

1. allocate one new immutable NFR ID;
2. create the NFR with the author-approved title, statement, rationale, and `controls: [CTL...]`;
3. add the new NFR ID to the originating Control's `nfrs` list;
4. regenerate the existing NFR catalog; and
5. report the accepted identifiers and both relationship updates.

Existing identifiers, unrelated files, and existing valid relationships remain unchanged. Duplicate
relationship IDs are not added.

## Direct NFR Contract

An NFR created directly through `highway-nfrs` starts with `controls: []`. Direct NFR authoring does
not infer or create a Control relationship in this phase.

## Failure Contract

The workflow MUST stop before derived governance writes when:

- the Control is invalid;
- the NFR catalog is missing, malformed, or inconsistent;
- safe NFR allocation cannot be established; or
- an accepted write cannot update both relationship sides.

Rejected, cancelled, zero-candidate, and failed runs leave NFR records, catalogs, and relationship
fields byte-identical or absent, except for intentionally committed accepted results.

## Determinism Contract

For identical Control title and statement, the proposal fields and order are identical. Candidate
output does not depend on timestamps, random values, environment values, or NFR catalog ordering.

## Scope Contract

This phase does not generate Controls from NFRs, remove records because of relationships, repair
orphans or broken links, synchronize pre-existing relationships, analyze removal impact, or add a
relationship store. Those behaviors belong to Phase 4.
