# Feature 077 onboarding fixtures

These fixtures exercise the Controls and NFR onboarding contracts in isolated, disposable trees.
Governance records remain root-level user-owned content under `library/governance/`; `.highway`
contains only skill contracts, templates, generators, and tests.

The focused tests verify collection and review state transitions through contract assertions and
byte-snapshot probes. Review decisions are held in memory until `Review Complete`; cancellation
must leave the input tree byte-identical.

Scenario fixtures:

- `empty-baseline`: missing baseline routes to guided collection.
- `valid-existing`: valid baseline skips collection and routes to existing actions.
- `malformed`: malformed baseline is blocked without writes.
- `duplicate`: duplicate proposals remain independently reviewable and advisory.
- `undecided`: incomplete review fails before allocation or persistence.
- `injected-failure`: a write failure rolls back the complete transaction.

Every scenario is deterministic and contains only expected state markers. Tests copy scenarios to
temporary roots before probing them; the shipped fixture tree is never mutated.
