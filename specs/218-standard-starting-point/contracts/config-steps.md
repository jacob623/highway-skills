# Contract: highway-codify-config 3.2.1 steps

Step order: `Entry`, `Classify`, `menu`, `platforms`, `current`, `use entries`, `platform proposal`, `platform written`, `standards`, `standard rules`, `standard proposal`, `standard write`, `conflicts`, `resolve`. `current`, `use entries`, `standards`, and `standard write` keep their 3.2.0 text, apart from `standard write` step 3.

## Classify

```markdown
Classify the latest reply before any other action. Test the classes in this order and stop at the first match.

1. `edit`: adds, removes, corrects, or replaces proposal text, or names a record to add, correct, or remove.
2. `decline`: answers no, stops, or cancels.
3. `question`: asks for an explanation.
4. `select`: names a listed option, conflict, platform, or standard by number or title.
5. `unknown`: the person says they do not know.
6. `accept`: affirms the proposal or answers yes, and adds no fact.

On a proposal, "looks good" is `accept`.
```

## platforms

```markdown
1. When Entry carried a platform name, apply the name bullets below to that name. Do not emit the list or its question.
2. Otherwise read `library/coding-standards/codify-platforms.md` when present. Emit one item per row, in file order. Do not use an id as the label.
```

The onboard question gains:

```markdown
  - `decline`: emit this list and its question.
  - `question`: answer, then ask **Would you like to onboard [Platform]?** again.
  - `unknown`: ask **Would you like to onboard [Platform]?** again.
```

## platform proposal

```markdown
3. Fill this proposal.
```

After the shape:

```markdown
4. Assess conflicts as `conflicts` does, against the catalogs as they would be after acceptance. With none, show `None`. When any exist, add: You can accept this proposal with these conflicts and resolve them afterward.
5. List each capability `current` marked new under New Realized Capabilities. With none, show `None`.
6. Emit this proposal, then the closing question and the cancel line.
```

## platform written

```markdown
1. When the accepted proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`. `question` answers, then asks again. `unknown` asks again.
2. Otherwise, when the platform works with code or configuration files, ask **Would you like to configure coding standards for [Platform]?** `accept` goes to `standards` with [Platform] as the standard to add or update. `question` answers, then asks again. `unknown` asks again.
3. Otherwise, or after `decline`, go to `platforms`.
```

## standard rules

```markdown
1. When no standard file exists, propose at most ten rules from the documentation `current` read. Use the file and folder structure that documentation recommends.
2. Otherwise start from the standard file after `current`, including a standard re-added after removal.
3. Write each rule with the word must, naming a condition and the required outcome.
4. For a platform standard, inherit from the language standards its files use.
5. Include one rule, once, that keeps encoded or encrypted credentials outside this standard's files. When the documentation names a supported way to encrypt or store them, require that way. When it names none, name no product.
6. When ten current rules lack the credentials rule, leave out the last rule the documentation no longer describes, or the last rule when all are still described. Name it in Consequences.
7. Write every structure path relative to the automation folder. Fill a placeholder in angle brackets, such as `<module>`, for each automation.
8. Cover only this standard's own files in the structure. Leave a component the platform calls, such as a module, to its own standard.
9. Return to `standard proposal`.
```

## standard proposal

```markdown
1. For an add or update, follow `standard rules`.
2. For an add or update, follow `use entries`.
3. For a remove, show the current values. Do not run `current`, `standard rules`, or `use entries`.
4. Fill this proposal.

[One sentence stating the consequence of this change.]

[On an add or update with no edit yet: **Here is a proposed starting point for the [Language or platform] coding standards**]

**Standard Title:** [Language or platform] Coding Standard
```

After the shape:

```markdown
5. Assess conflicts as `conflicts` does, against the catalogs as they would be after acceptance. With none, show `None`. When any exist, add: You can accept this proposal with these conflicts and resolve them afterward.
6. For a remove, say in Consequences that `[Standard Path]` remains and is no longer used. List in Conflicts each standard whose Inherits From names it.
7. Emit this proposal, then the closing question and the cancel line.

- `edit`: emit one consequence sentence. Re-emit this proposal with the change and without the starting-point line. Stay on `standard proposal`.
```

## standard write step 3

```markdown
3. When the proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`. `question` answers, then asks again. `unknown` asks again. `decline` states the consequence of the accepted change in one sentence and goes to `menu`. Otherwise state the consequence of the accepted change in one sentence and go to `menu`.
```

## conflicts

```markdown
1. Read both catalogs.
2. Assess platforms first, then standards, each in catalog order. Judge overlap by meaning, not exact wording. A conflict is:
   - (the six 3.2.0 bullets)
3. When none exist, emit `Highway found no conflicts between your platforms and coding standards.` Then ask **What inconsistencies have you noticed?** Assess what the person describes against the catalogs, then re-emit this step.
4. Otherwise quote both entries and name both records in each description. Emit each conflict as an ordered list item, then the question and the cancel line.
```

## resolve

```markdown
1. Propose the fewest changes that remove the selected conflict, starting from its recommendation.
2. List each record once, in bold, with a lettered list of its changes.
3. Fill this proposal.
```

After the shape:

```markdown
4. Emit this proposal, then the closing question and the cancel line.
```

## Rejected text

- `Assess conflicts as \`platform proposal\` does.`
- `Each rule contains the word must and names a condition and the required outcome.`
- `Then emit the closing question and the cancel line.`
