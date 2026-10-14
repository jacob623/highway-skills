# Quickstart: Controls NFR Decoupling

## Prerequisites

Run commands from the repository root with the macOS system path available:

```sh
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
```

No new runtime dependency is required.

## 1. Inspect the baseline

Confirm the Feature 171 checklist is complete and identify active candidate references before editing:

```sh
sed -n '1,220p' specs/171-controls-nfr-decoupling/spec.md
sed -n '1,220p' specs/171-controls-nfr-decoupling/checklists/requirements.md
rg -n -i 'candidate-generation|candidate state|nfr-candidate-state|control-derived candidate|pending candidate' .highway .github .claude .cursor .agents
```

## 2. Implement source changes

Update authoritative sources first:

- `.highway/skills/highway-controls/SKILL.md`
- `.highway/skills/highway-nfrs/SKILL.md`
- `.highway/skills/highway-setup/SKILL.md`
- affected `.highway/tools/tests/*.test.sh`
- remove `.highway/catalog/nfr-candidate-state.md`

Preserve accepted Control/NFR record formats and relationships. Do not modify `.highway/skills/highway-profile/SKILL.md`.

## 3. Run focused checks

Run the tests covering the changed ownership surfaces and absence requirements. The exact test list is finalized in `tasks.md`; expected checks include Controls, NFR management, Setup onboarding, governance routing, candidate-state absence, and generated correspondence.

```sh
.highway/tools/tests/control-derived-nfr.test.sh
.highway/tools/tests/nfr-management.test.sh
.highway/tools/tests/highway-setup-onboarding.test.sh
.highway/tools/tests/governance-routing.test.sh
```

## 4. Regenerate derived artifacts

Use the repository's existing generation entry points from the implementation tasks. Regeneration must update adapters, catalogs, manifests, and distributed instructions from authoritative sources; do not hand-edit generated copies.

Then scan all governed and derived surfaces:

```sh
rg -n -i 'candidate-generation|candidate state|nfr-candidate-state|control-derived candidate|pending candidate' .highway .github .claude .cursor .agents
```

The scan should return no active candidate-generation ownership references. Historical Feature 171 planning text may describe the removed concept and is not an active governed surface.

## 5. Run the complete suite

```sh
.highway/tools/tests/run-all.sh
```

Expected result: zero failures, with preserved Control/NFR behavior and explicit decoupling checks passing.

## 6. Review correspondence and task state

Confirm generated files match their authoritative sources, the candidate-state artifact is absent, and all implementation tasks are marked complete:

```sh
git diff --check
git status --short
```
