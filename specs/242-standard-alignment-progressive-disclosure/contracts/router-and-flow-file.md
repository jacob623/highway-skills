# Contract: Router and Flow File

## Router (`SKILL.md`)

The Procedure introduction ends with the flows sentence and table, before the first step:

```markdown
## Procedure

<existing introduction, unchanged>

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/proposal.md` | `start`, `span` |
| `references/record.md` | `identifier`, `title`, `write` |

### Entry
...
```

Rules:
- The sentence is exactly as shown.
- The table header is exactly `| File | Steps |`.
- A File cell is one inline-code path `references/<name>.md`.
- A Steps cell is inline-code step names joined by `, `, in the order the steps appear in the file.
- No other line of `SKILL.md` names a file in `references/`.
- A handoff in a step that stays names the target step only, such as "go to `identifier`". The
  table resolves it.

## Flow file (`references/<name>.md`)

```markdown
# Proposal

<optional: rules only this flow applies, moved verbatim>

### start

<moved verbatim>

### span

<moved verbatim>

## Verification

- <moved verbatim>
```

Rules:
- There is no frontmatter, and line 1 is the L1 heading.
- The L1 names the flow in title case, from the file name: `proposal.md` gives `# Proposal`,
  `ready-records.md` gives `# Ready Records`.
- Steps are L3 headings, with text and body byte-identical to the original.
- `## Verification` is the only L2 heading, comes last, and holds one or more bullets.
- The file names no file in `references/`.
- Size: at most 500 lines and 20,000 characters. It has at least 25 lines.
