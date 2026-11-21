# Contract: Version-bump guard

## Command

```text
bash tests/plugin-version-bump.test.sh
```

## Behavior

1. Resolve comparison baseline = `merge-base(HEAD, main)` or `merge-base(HEAD, origin/main)`.
2. If baseline cannot be resolved → exit non-zero with an actionable message (fail closed).
3. Detect whether covered inputs differ between baseline and the working tree + index
   (`skills/`, `framework/plugin/`), including untracked files under those prefixes.
4. If the only covered difference is the `version` field of `framework/plugin/plugin.json` →
   exit 0 (no further bump required).
5. If no covered differences → exit 0.
6. If covered differences exist → read baseline and current `version` strings; both must be
   valid `MAJOR.MINOR.PATCH`; current must be strictly greater as integer triples; otherwise
   exit non-zero naming that a version bump is required.

## Outputs

- Exit 0: OK line on success  
- Exit non-zero: stderr explains baseline failure, invalid semver, or missing bump  
