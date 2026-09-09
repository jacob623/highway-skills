# Quickstart: Highway Organizational Profile

This guide validates Feature 024 after implementation. It does not prescribe implementation bodies.

## Prerequisites

- Run from the repository root.
- Use the declared Bash 3.2.57-compatible toolchain.
- Have a clean or disposable workspace because setup and confirmed mutations write `.highway/profile.yaml`.

## 1. Validate the source skill and distributed profile

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-profile
.highway/tools/validate-profile.sh .highway/profile.yaml
```

Expected result: both structural validators exit 0.

## 2. Validate the default artifact

Inspect `.highway/profile.yaml` and confirm it contains only:

- `metadata` as the first top-level section
- `metadata.version: 1.0.0`
- the specified `metadata.description`
- no seeded constraints, strategic directions, preferences, timestamps, or random identifiers

Expected result: the shipped profile is a valid empty context container.

## 3. Exercise read-only actions

```text
/highway-profile
/highway-profile view
/highway-profile show
/highway-profile describe
```

Expected result: help/status and profile contents are displayed; file bytes and modification state do not change. An absent profile offers setup without creating it.

## 4. Exercise setup confirmation

Run `/highway-profile setup` and `/highway-profile configure` in a disposable workspace.

- Answer the questionnaire with representative values.
- Confirm the proposed profile is displayed before the prompt.
- Decline once and verify the file is absent or byte-for-byte unchanged.
- Repeat and confirm; verify metadata-first ordering and omission of empty sections.

## 5. Exercise mutation confirmation

Against a populated profile, run representative commands:

```text
/highway-profile add preference cloud gcp
/highway-profile update preference cloud aws to gcp
/highway-profile remove preference cloud aws
/highway-profile reset preference cloud
```

For each operation, verify the preview contains `Action`, `File`, `Summary`, `Affected Entries`, and `Confirmation Status`, plus current/proposed state and ramifications where required. Declined operations must leave the original bytes unchanged.

## 6. Validate deterministic rewriting and routing

- Rewrite an unchanged profile twice and compare bytes; both outputs must be identical.
- Confirm no timestamp, random identifier, or environment-derived value appears.
- Send NFR and Control baseline requests and confirm routing to `/highway-nfrs` and `/highway-controls` without profile mutation.
- Add supported future sections and confirm existing ordering and values are preserved.

## 7. Regenerate and run correspondence checks

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/library-containment.test.sh
.highway/tools/tests/run-all.sh
```

Expected result: the source skill, profile artifact, catalogs, adapters, manifests, and distribution all agree; the full suite exits 0.
