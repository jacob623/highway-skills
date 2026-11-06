# Contract: highway-codify-config 3.2.4 `rule shape`

`rule shape` stands immediately after `standard rules` and immediately before `standard proposal`.

```markdown
1. Write one rule with must once, one condition, and one outcome, in eight words or fewer. Count a path, a hyphenated word, and a placeholder as one word.
2. A second outcome joined by and, or, or a comma is a separate rule. A slash that is part of a path stays inside that one word.
3. When a rule the person provides, or a saved rule, lacks must, has more than eight words, or combines rules, rewrite it to conform before the proposal is presented. State that rewrite in the consequence sentence that opens the proposal. Keep a saved rule that conforms.
4. Under each rule, emit **Why it matters:** and one sentence stating the consequence of that rule. Name no customer, product, or decision of this organization. The catalog view, a conflict quote, and the saved cell keep the rule only.
5. Return to `standard rules`.
```

## `standard rules`

Steps 2, 4, 7, 8, and 9 stay. Steps 1, 3, 5, and 6:

```markdown
1. When no standard file exists, suggest at most fifteen rules from the documentation `current` read. Use the file and folder structure that documentation recommends.
3. Follow `rule shape`, then write the rules it returned. When the suggestions exceed fifteen, keep the credentials rule, leave out the later suggestions, and name each left-out suggestion in the consequence sentence that opens the proposal. Do not leave out a rule the person provided.
5. Include one rule, once, that keeps encoded or encrypted credentials outside this standard's files. When the documentation names a supported way to encrypt or store them, require that way in its own rule. Both follow `rule shape`. When it names none, name no product.
6. When fifteen suggestions lack the credentials rule, leave out the last suggestion the documentation no longer describes, or the last suggestion when all are still described. Name it in the consequence sentence that opens the proposal. Do not leave out a rule the person provided.
```

## Proposal shape

Under **Coding Standards:**, blank line included:

```markdown
1. [Rule]

   **Why it matters:** [One sentence stating the consequence of this rule.]
```

## Saved skeleton

`coding-standard.md` version 3.0.1. The rules line:

```markdown
1. <one rule with must once, one condition, and one outcome, in eight words or fewer; the model suggests at most fifteen>
```

The file still says it does not contain a Why it matters line. It does not cap how many rules it holds.

## Rejected text

- `propose at most ten rules`
- `Write each rule with the word must, naming a condition and the required outcome.`
- `When ten current rules lack the credentials rule`
- `one rule containing the word must; at most ten rules`

`standard rules` step 9 stays `Return to `standard proposal`.
