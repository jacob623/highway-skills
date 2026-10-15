# Feature 181 Quickstart: Proposal-First Highway New

## Prerequisites

Run from the repository root with the existing macOS shell/toolchain:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

Feature 181 changes the canonical `highway-new` skill contract and its generated adapters. No
runtime service or external dependency is required.

## Canonical Validation

Validate the source skill and its cited output contracts:

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-new
.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md
.highway/tools/validate-library.sh .highway/library/templates/output/request-catalog.md
```

Expected result: each command exits successfully.

## Focused Contract Tests

Run the existing focused tests after implementation:

```sh
bash .highway/tools/tests/highway-new.test.sh
bash .highway/tools/tests/output-template.test.sh
```

Expected result: both tests pass and verify the canonical skill, Request templates, fixtures,
privacy/no-write behavior, Solution Constraints, and proposal-first interaction tokens.

## Behavioral Fixture Matrix

The implementation should add or extend disposable fixtures for:

| Scenario | Expected result |
|---|---|
| Initial evidence supports a responsible interpretation | Contribution Opportunity opens with the exact starting-point prompt |
| Initial evidence does not support a responsible interpretation | One consequential missing-evidence question; no invented proposal |
| Existing evidence already covers a domain | Evidence is reused; duplicate question is absent |
| Substantive correction or removal | Active proposal is re-evaluated and changed content is reflected |
| Unknown or unavailable evidence | `Unknown` remains explicit; no inference is persisted |
| Complete seven-domain proposal | Converged Request Proposal appears under the required heading |
| Contribution Opportunity or draft approval | No Request acceptance or creation occurs |
| Accepted complete proposal | Existing validation and transaction create the Request and catalog |
| Incomplete, cancelled, privacy-blocked, allocation-failed, or write-failed path | No Request/catalog mutation; original bytes remain unchanged |
| Architecture, Discovery, or ADR request during intake | Owning workflow boundary is preserved; no downstream artifact is created |

## Generated Correspondence

Regenerate derived artifacts from canonical sources:

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
```

Verify the four `highway-new` adapters match `.highway/skills/highway-new/SKILL.md` byte-for-byte
and that catalog/manifest checks pass.

## Full Suite

```sh
bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the full suite passes with zero failures and no whitespace errors.

## Contract References

- Interaction, lifecycle, and ownership details: [contracts/highway-new-proposal-first.md](contracts/highway-new-proposal-first.md)
- Entities, state, and validation: [data-model.md](data-model.md)
- Requirements and acceptance scenarios: [spec.md](spec.md)
