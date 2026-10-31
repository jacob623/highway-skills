# Quickstart: ADR Safeguard Span

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `202-adr-safeguard-span`
- A passing suite recorded before the first edit

## Confirm the span

1. Compare the `highway-adr` `start`, `write`, Entry, and `close` steps with [contracts/adr-span.md](contracts/adr-span.md).
2. The span proposal names every architecture and does not ask **Which architecture should this decision use?**
3. Removing architectures down to one asks **Does this decision replace [decision], or run beside it?**
4. The span write lists every RA id in the ADR catalog cell and adds the ADR id to each architecture, superseding nothing.
5. The span close offers codify for one implementation, lists two to five, or lists none above five, and never offers a covered implementation.

## Confirm the templates

1. `adr-catalog.md` and `adr-record.md` allow several RA ids for a span, and `None` still means a new architecture will follow.
2. `architecture-catalog.md` still says "An ADR id appears on at most one row." and states the span exception.

## Confirm the assessment menu

1. Compare `highway-assessment` with [contracts/assessment-review.md](contracts/assessment-review.md).
2. Assessment opens on **What would you like to review?** with the two choices in order.
3. The gaps choice reaches `list of findings`, which is unchanged.
4. The ready view numbers categories, letters records, shows at most five per category, and always ends with "If you'd like to return to the main menu, just say so."
5. Readiness matches the table in [data-model.md](data-model.md).

## Confirm the discovery line

1. Compare `highway-discovery` `explore` with [contracts/discovery-select.md](contracts/discovery-select.md).
2. The selection sentence follows the exploration question, and `adopt` continues as `highway-adr` with the Discovery id and option id.

## Confirm the product-claim check

1. Compare `highway-discovery` `analyze` and `discovery-record.md` with [contracts/product-claim-check.md](contracts/product-claim-check.md).
2. A named product or feature the vendor no longer offers is absent from the option list, named with its source, and scored zero times.
3. An inconclusive check leaves the option listed and records `inconclusive`.
4. An option whose required platform is unconfirmed is absent from the scored options, and vendor documentation does not put it back.
5. Opening a written discovery does not run the check. An option the person adds is not removed by it.

## Confirm the suite

Run `.highway/tools/validate-skill.sh` on `highway-adr`, `highway-assessment`, `highway-discovery`, `highway-architecture`, and `highway-onboarding`; `.highway/tools/validate-library.sh` on the four changed templates; then `.highway/tools/tests/run-all.sh`. Each is expected to exit 0.
