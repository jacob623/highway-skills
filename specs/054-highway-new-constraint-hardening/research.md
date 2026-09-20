# Research: Highway New Constraint Hardening

## Decision: Extend the existing `highway-new` intake contract

**Rationale**: Feature 053 already owns the seven evidence domains and the eight Solution
Constraints fields. The requested behavior is a validation and wording correction inside that
boundary, so extending the existing authoritative skill, focused test, and shared template
preserves ownership and avoids a second contract.

**Alternatives considered**: Add a separate constraint-normalization skill; rejected because it
would split Request ownership and duplicate the existing intake transaction.

## Decision: Require a non-empty allowed-solution-class list or `unknown`

**Rationale**: The feature requirement explicitly says one-or-more values or `unknown`. Empty lists
are valid for the other list-shaped constraints because they mean no applicable values are known;
that meaning is not valid for a set of allowed solution classes. Rejecting empty and malformed values
prevents downstream consumers from treating an empty permitted set as intentional evidence.

**Alternatives considered**: Permit an empty list and interpret it as no restriction; rejected
because that collapses absence of permitted classes with an explicit unrestricted solution space.
Permit a sentinel such as `none`; rejected because it conflicts with the one-or-more-or-unknown
contract.

## Decision: Use `None known` for Business Constraints wording only

**Rationale**: The accepted clarification makes the phrase canonical for intake prompts, examples,
and recovery guidance while preserving the existing persisted empty-state representation. This
limits compatibility impact and keeps wording separate from the durable record contract.

**Alternatives considered**: Persist the exact phrase; rejected because it changes an existing
record representation without a requirement to do so. Continue using varied “none” phrases; rejected
because equivalent answers would remain harder to test and explain consistently.

## Decision: Use field-specific recovery messages

**Rationale**: Solution Constraints fields have different valid shapes. A list-shaped field may
accept populated values, an explicit empty list, or `unknown`; `allowed_solution_classes` is the
exception and requires one or more values or `unknown`; scalar fields require a non-empty value or
`unknown`. Errors must name the field and the accepted shape so the requester can repair only the
invalid answer.

**Alternatives considered**: One generic invalid-value message; rejected because it cannot explain
empty-list versus unknown semantics. Coerce malformed input; rejected because coercion would alter
user evidence and threaten no-partial-write guarantees.

## Decision: Reuse the current validation and generation toolchain

**Rationale**: Existing Bash 3.2-compatible focused tests, skill/library validators, catalog and
adapter generators, distribution checks, and full-suite checks already enforce the repository's
contracts. No package or runtime dependency is needed.

**Alternatives considered**: Add a parser or external schema library; rejected because the project
is Markdown-and-shell based and the existing validators are the established authority.
