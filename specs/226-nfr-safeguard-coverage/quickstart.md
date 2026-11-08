# Quickstart: NFR Safeguard Coverage

Run from the repository root.

## Static checks

```bash
bash .highway/tools/tests/nfr-safeguard-rationale.test.sh
bash .highway/tools/tests/guided-flow-refinements.test.sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-nfrs
```

Expected: both tests print PASS, and the validator reports no failures.

## Wording grep

```bash
grep -c 'Enforces your Safeguard' .highway/skills/highway-nfrs/SKILL.md
grep -c 'no queued, shown, or captured NFR' .highway/skills/highway-nfrs/SKILL.md
```

Expected: the first count is at least 2. The second is 0.

## Walkthrough

With three accepted Controls, one titled Data Backup, and no NFR catalog, run `/highway-setup` through to operational expectations.

1. The first set shows 3 to 5 items. Each shows a **Why it matters:** line. The Data Backup item reads **Enforces your Safeguard, Data Backup,** by ...
2. Select only the two limits. The queue message's next set offers the Control-derived items again.
3. Select them and review. Capture shows the same **Why it matters:** lines.
4. Edit one rationale to drop the opening, then accept. The record stores the edited line, and `controls` still lists the Control.

See [contracts/wording.md](contracts/wording.md) for every line.
