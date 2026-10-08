# Contract: Validation Cache

**Feature**: 151 | **Interface**: `.highway/tools/validate-skill.sh` CLI and its library

## Command surface

```text
validate-skill.sh <skill-dir>
validate-skill.sh --no-cache <skill-dir>
```

| Element | Before | After |
|---|---|---|
| `<skill-dir>` argument | required | unchanged |
| Exit 0 on a valid skill | yes | unchanged |
| Exit non-zero on an invalid skill | yes | unchanged |
| Error text on stderr | `ERROR: [<CLASS>] ...` | unchanged, byte-for-byte |
| `--no-cache` | absent | new; forces full validation and writes no record |

**Backward compatibility**: every existing invocation keeps its meaning. The flag is additive and
optional, so the four call sites in `generate-agent-adapters.sh`, `generate-catalog.sh`,
`generate-distribution.sh`, and `validate-library.sh` need no edit.

## Behavioral contract

| ID | Obligation |
|---|---|
| VC-1 | A skill whose key is present in the cache MUST exit 0 without re-running validation. |
| VC-2 | A skill whose key is absent MUST be validated in full. |
| VC-3 | A validation that exits 0 MUST write its key. |
| VC-4 | A validation that exits non-zero MUST NOT write its key, and MUST emit its error text unchanged. |
| VC-5 | Editing a skill's `SKILL.md` MUST change its key. |
| VC-6 | Editing `validate-skill.sh`, any file under `tools/lib/`, either governance document, or any file under `.highway/library/` MUST change the key of every skill. |
| VC-7 | `--no-cache` MUST perform full validation and MUST NOT write a record. |
| VC-8 | A cache directory that is absent, unwritable, or has been cleared MUST NOT cause failure; it degrades to full validation. |
| VC-9 | The cache MUST NOT be created inside the repository tree. |

## Error states

| Condition | Behavior |
|---|---|
| Cache directory cannot be created | Proceed with full validation; no warning on stdout, which would corrupt generator output |
| Key file exists but is unreadable | Treat as a miss |
| `sha256sum` absent | Fall back to `shasum -a 256`, as the existing `sha256_of` helper already does |

## Non-obligations

The cache makes no claim about validation *correctness*. It asserts only that the same inputs
produce the same verdict. Any defect in `validate-skill.sh` is preserved exactly, which is the
intent — this feature changes when validation runs, never what it decides.
