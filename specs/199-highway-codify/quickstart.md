# Quickstart: Highway Codify

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `199-highway-codify`

## Confirm the records

1. Compare the codify templates with [contracts/record-and-catalog.md](contracts/record-and-catalog.md).
2. Confirm the catalog allows more than one row for one implementation, and a removed row keeps its id with no folder.
3. Confirm the readme has an Implement part and a Use part.

## Confirm the flow

1. Compare the skill steps and the request close with [contracts/codify-flow.md](contracts/codify-flow.md).
2. A choice list shows titles and descriptions.
3. A request that matches one implementation closes with `/highway-codify` for that title and the one action, and does not state the day.
4. A request that matches none closes with `/highway-discovery` and the request id.
5. Assessment still turns an explored finding into a request.

## Confirm the suite

Run `.highway/tools/validate-library.sh` on the two new templates, `.highway/tools/validate-skill.sh` on `highway-codify` and `highway-request`, and `.highway/tools/tests/run-all.sh`. Each is expected to exit 0.
