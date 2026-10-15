# Quickstart: Highway Implementation Compatibility Assessment

## Prerequisites

Run from the repository root on macOS:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

Use an accepted `ARCH######` fixture and one or more Implementation Selections. The examples below are illustrative selections, not required products.

## Validate the source contract

Run the existing implementation onboarding contract:

```sh
.highway/tools/tests/highway-implementation-onboarding.test.sh
```

Expected result: the test exits 0 and the existing explicit-source, no-write, ownership, and traceability contracts remain valid.

## Validate compatibility outcomes

Run the focused compatibility contract once implemented:

```sh
.highway/tools/tests/implementation-compatibility.test.sh
```

The fixture set must cover:

1. `Compatible`: an event-driven architecture with selections that cover compute, messaging, and durable persistence.
2. `Incomplete`: selections that leave required messaging, identity, or observability responsibilities unresolved.
3. `Incompatible`: an event-driven architecture with a directly contradictory scheduled batch or file-transfer selection.
4. Evidence-insufficient recommendation: a required gap whose suggested realization remains `Unknown`.
5. Controls/NFR realization: missing security, recovery, availability, scalability, or monitoring realization contributes to `Incomplete` unless explicitly contradictory.
6. Determinism: reordered selections produce identical assessment output and ordering.
7. No-write behavior: incomplete and incompatible inputs produce no RI artifact and do not change the RI catalog.

## Validate generated outputs

After changing the authoritative skill or shared implementation template, regenerate derived surfaces:

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
```

Then rerun the focused onboarding and compatibility tests.

## Validate the full suite

```sh
.highway/tools/tests/run-all.sh
```

Expected result: the complete suite exits 0.

See [implementation-compatibility.md](contracts/implementation-compatibility.md) for the exact input, outcome, output, and failure contract. See [data-model.md](data-model.md) for assessment entities and transitions.
