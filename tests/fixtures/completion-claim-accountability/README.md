# Completion Accountability Fixtures

These fixtures model feature-local `spec.md`, `coverage.md`, `tasks.md`, `test-evidence.md`, and
completion-report records. The test uses them to prove exact requirement coverage and to review the
non-automatic evidence and correspondence claims without editing completed feature directories.

Coverage rows use this contract:

```text
| FR-001 | satisfied | path/to/artifact.md: evidence |
| FR-002 | deferred | follow-up reason |
```

A satisfied row must name an existing artifact. A deferred row must name a non-empty reason. Each
requirement ID from `spec.md` must occur exactly once.
