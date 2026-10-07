# Quickstart: Profile Runtime Architecture Alignment

## Prerequisites

- Repository root: `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`
- macOS shell with Bash 3.2-compatible scripts available.
- Feature 148 source, tests, and generated artifact changes applied.

## Focused validation

From the repository root, run:

```sh
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/bin
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-runtime-separation.test.sh
bash .highway/tools/tests/profile-convergence-behavior.test.sh
```

Expected outcome: each command exits `0` and reports a passing Profile contract. These checks cover
retained Profile structure, four-domain readiness, acquisition boundaries, Experience delegation,
cross-domain reasoning fixtures, runtime dependency removal, and generated Profile adapter
correspondence.

## Generated artifact validation

Regenerate Profile's declared agent adapters and verify correspondence:

```sh
.highway/tools/generate-agent-adapters.sh
bash .highway/tools/tests/adapter-coverage.test.sh
```

Expected outcome: all four Profile adapters match `.highway/skills/highway-profile/SKILL.md`, and no
catalog or manifest correspondence failure is reported.

## Full validation

Run the complete repository suite:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: the suite exits `0` with no failed tests.

## Manual boundary checks

Review `.highway/skills/highway-profile/SKILL.md` and confirm:

- `metadata.version` is `9.0.0`.
- Inputs reference Highway Identity as shared non-normative context and do not reference retired
  Highway Vision or Highway Platform Objectives runtime documents.
- The separate Profile semantic convergence procedure is absent.
- Profile still defines four-domain completeness, acceptance, readiness, persistence, acquisition,
  cross-domain reasoning, and local failure behavior.
- Operations and Error Handling contain no Constitution common failure model dependency.
- Completion synthesis ownership is explicit and does not duplicate Setup.
- `profile-record.md` and the protected Highway Identity and Experience Standard documents are
  unchanged.

## Design references

- [Feature specification](spec.md)
- [Research decisions](research.md)
- [Data model and state transitions](data-model.md)
