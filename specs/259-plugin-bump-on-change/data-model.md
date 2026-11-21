# Data Model: Plugin Bump on Change

## Entities

### Plugin source version

- **Source**: `framework/plugin/plugin.json` field `version`
- **Form**: string `MAJOR.MINOR.PATCH` (non-negative integers)
- **Rules**: When a bump is required, current must be strictly greater than baseline as three
  integer components. Invalid form fails the guard when a bump is required.

### Comparison baseline

- **Commit**: `git merge-base HEAD main`, else `git merge-base HEAD origin/main` if `main` absent
- **Baseline version**: `version` from `framework/plugin/plugin.json` at that commit
- **Failure**: If merge-base cannot be established or baseline file/version unreadable → fail closed

### Plugin-build inputs (covered paths)

| Path prefix | Role |
| --- | --- |
| `skills/` | Shipped skill sources |
| `framework/plugin/` | Plugin source copied/rendered into the package |

**Exempt**: Change set whose only covered difference is the `version` field inside
`framework/plugin/plugin.json` (no other covered path changes; JSON otherwise equivalent).

**Not covered**: `highway-agent-plugin/` (output), specs, tests, harness, adapters (existing suite
rules remain separate).

### Plugin generation–specific checks (closed list)

| Suite member | Role |
| --- | --- |
| `tests/plugin-version-bump.test.sh` | Version-bump guard |
| `tests/agent-plugin.test.sh` | Plugin drift / generate-currency (`--check` and related) |

Membership changes only by an explicit later amendment to this list in docs + `run-all.sh`.

### Finish order (lifecycle)

```text
[covered inputs changed]
        │
        ▼
 full suite with --exclude-plugin-gen ──► green
        │
        ▼
 harness (only if feature already requires) ──► green
        │
        ▼
 bump framework/plugin/plugin.json version
        │
        ▼
 framework/generate-agent-plugin.sh
        │
        ▼
 tests/run-all.sh --plugin-gen-only ──► green
```
