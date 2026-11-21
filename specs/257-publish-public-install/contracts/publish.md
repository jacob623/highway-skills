# Contract: Publish agent plugin

## Command

```text
framework/publish-agent-plugin.sh [--dry-run]
```

## Behavior

1. Build a fresh `highway-agent-plugin/` (or equivalent temp build used for comparison).
2. Prepare a checkout of `https://github.com/highway-systems/agent-plugin.git`.
3. Replace the checkout's working tree with the build contents (plugin at root).
4. **Refuse** (exit non-zero, no push) when:
   - staged tree ≠ fresh build;
   - any staged path or file content references `specs/` or `.specify/` as a packaged path;
   - secret scan finds a denied pattern;
   - version was already published and source `version` was not bumped (skips this check on first
     publish of `0.1.0` when no `v0.1.0` tag exists).
5. Commit with a message that names the version.
6. Ensure annotated tag `v<version>` exists for this version.
7. Unless `--dry-run`, push the default branch and the tag.

## Outputs

- Stdout: progress lines (no secrets).
- Exit 0: publish completed (or dry-run validated).
- Exit non-zero: refusal reason on stderr.
