# Contract: Current Proposal Rules

Skill: `.highway/skills/highway-codify-config/SKILL.md`, version `3.0.0`.

Template: `.highway/library/templates/output/coding-standard.md`, version `3.0.0`.

The skill body stays imperative. It does not add the keywords MUST or SHOULD.

## Procedure paragraph

Add this paragraph after the sentence that says a list is joined with `; ` on write:

```markdown
On a platform proposal and a standard proposal, each When to use entry and each When not to use entry is one sentence that names a condition and the required outcome. The next line is **Why it matters:** and one sentence. The entry does not say should, consider, prefer, usually, or where appropriate. The catalog view, a conflict quote, and the saved cell keep the rule only.
```

The closing question stays **What would you add or correct?** It does not gain a Why it matters line.

## `current`

Insert `### current` immediately before `### platform proposal`.

```markdown
### current

Read the technology's current public documentation. Write nothing.

A capability the documentation describes is captured. A capability it no longer describes is not proposed. For a platform, a documented capability is proposed only when the accepted implementation realizes it.

When the documentation cannot be read, say: The current documentation could not be read. Add no capability as current. Continue from the accepted implementation and the catalogs already present.

Then go to the proposal named with this step.
```

An add or update in `platforms` says `go to \`current\`, then \`platform proposal\``. An add or correction in `standards` says `go to \`current\`, then \`standard proposal\``. A removal does not.

## Proposals

Replace the opening of `platform proposal` with:

```markdown
Ground When to use and When not to use in `current`, the implementation's Technology Choice, Runtime Components, and Realized Capabilities, and the other platform rows. An update starts from the current values after `current`. A remove shows the current values and does not run `current`.
```

Replace the opening of `standard proposal` with:

```markdown
When no standard file exists, propose at most ten rules from the documentation `current` read. Each rule contains the word must and names a condition and the required outcome. Use the file and folder structure that documentation recommends. Otherwise start from the standard file after `current`, including a standard re-added after removal. A platform standard inherits from the language standards its files use. A remove shows the current values and does not run `current`. One rule keeps encoded or encrypted credentials outside this standard's files. When the documentation names a supported way to encrypt or store them, the rule requires that way. When it names none, the rule names no product. Include it once. When ten current rules lack it, leave out the last rule the documentation no longer describes, or the last rule when all are still described, and name it in Consequences.
```

`platform proposal` stays at or under 400 words. `standard proposal` stays at or under 400 words. `current` stays at or under 400 words.

## `standard write`

Replace the no-conflict branch so it reads:

```markdown
3. When the proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`. Otherwise state the consequence of the accepted change in one sentence and go to `menu`.
```

The platform write's follow-up is unchanged.

## Template

In `coding-standard.md`, set `metadata.version` to `3.0.0`. Replace the Rules placeholder with:

```markdown
1. <one rule containing the word must; at most ten rules>
```

Add this paragraph after the Tests explanation:

```markdown
One rule keeps encoded or encrypted credentials outside the files this standard covers. When the technology's current documentation names a supported way to encrypt or store them, that rule names that way. This file does not contain a Why it matters line.
```

## Verification

Add bullets that a check can find:

- `### current` is read before an add or update, and a removal does not run it.
- A proposal use entry is one sentence, with **Why it matters:** on the next line, and the saved catalog does not keep that line.
- Each coding rule contains the word must, and one rule keeps encoded or encrypted credentials outside the files.
- A standard write with no conflicts states one consequence sentence and returns to the menu.
