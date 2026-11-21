# Contract: Experience repository gate

**Consumer**: `skills/highway-experience/SKILL.md` + `assets/repository-gate.md`  
**Activators**: Every other Highway skill (first procedure step)

## Activated-by-a-skill procedure (order)

1. Apply Experience Standard (as today).
2. Read storage contract.
3. **Resolve** effective knowledge root (storage contract order).
4. If ready → return to activating skill with no extra user-visible output (except gate flows
   below that already completed in this invocation).
5. If not ready → run gate from `assets/repository-gate.md` only.

## Gate outcomes

| Situation | Result |
| --- | --- |
| Usable local pointer or cwd knowledge root | `ready` |
| Committed URL only | Emit URL-only block; `not-ready` |
| No root | Dual offer (setup vs path/URL) |
| Invalid path | Reject; ask again or dual offer; never use as root |
| Successful path bind (± persist) | `ready`; same invocation continues |
| Setup chosen; activator ≠ `highway-setup` | `not-ready`; next action `highway-setup` |
| Setup chosen; activator = `highway-setup` | `ready`; effective root = open project; setup continues |
| Persist local path | Write `hw-repository.local.md` only if gitignore accepted; ensure ignore entry |
| Persist URL | Write `hw-repository.md`; do not gitignore it |

## Owning skills

- MUST activate experience first.
- MUST NOT embed the old Oops dual-unaware setup-only block.
- On `not-ready`: write nothing; end.
- MAY keep seeded-file existence checks that do not re-offer the dual gate.
