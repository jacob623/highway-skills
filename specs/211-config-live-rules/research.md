# Research: Current Proposal Rules

## R1. Where the documentation check lives

- **Decision**: A new `### current` step. An add or update goes to `current`, then the proposal. A removal goes to the proposal and does not run `current`. When the documentation cannot be read, the step says exactly `The current documentation could not be read.` and continues from the accepted implementation and the catalogs already present.
- **Rationale**: `platform proposal` is 287 words and `standard proposal` is 309. The check is about 78 words. Its own step keeps both proposals under 400 (P7.5). The spec places the check before the proposal.
- **Alternatives considered**: Fold the check into each proposal. Rejected because `standard proposal` would pass 400 once the credential rule is added.

## R2. Use rules and Why it matters

- **Decision**: One paragraph in the procedure, shared by both proposals. Each When to use entry and each When not to use entry is one sentence that names a condition and the required outcome. The next line is `**Why it matters:**` and one sentence. The entry does not say should, consider, prefer, usually, or where appropriate. The catalog view, a conflict quote, and the saved cell keep the rule only. The closing question stays `**What would you add or correct?**` and does not gain a Why it matters line.
- **Rationale**: FR-003 and FR-004. The label explains the rule above it. Putting the same label under the closing question would give it a second job on the same proposal.
- **Alternatives considered**: Repeat the paragraph inside both proposals. Rejected because `standard proposal` has little room. A different label. Rejected because the spec names `**Why it matters:**`.

## R3. Must rules and the credential rule

- **Decision**: A new coding standard proposes at most ten rules from the documentation `current` read. Each rule contains the word must and names a condition and the required outcome. The file and folder structure is the one that documentation recommends. An update starts from the standard file after `current`. One rule keeps encoded or encrypted credentials outside that standard's files. When the documentation names a supported way to encrypt or store them, the rule requires that way. When it names none, the rule names no product. The rule appears once. When the current standard has ten rules and lacks it, leave out the last rule the documentation no longer describes, or the last rule when every current rule is still described, and name the omitted rule in Consequences.
- **Rationale**: FR-005 and FR-006. "Least supported" is the last rule the documentation no longer describes, which a later check can apply the same way every time. The skill says "the word must" so the instruction does not add the keyword MUST.
- **Alternatives considered**: Allow an eleventh rule. Rejected because the ten-rule limit stays. Refuse the write until the person deletes a rule. Rejected because the proposal is supposed to arrive at ten rules on its own.

## R4. After a standard write

- **Decision**: When the proposal listed conflicts, keep the question `**Would you like help resolving these conflicts?**`. Otherwise state the consequence of the accepted change in one sentence and go to `menu`. A platform write is unchanged.
- **Rationale**: FR-007 and FR-008. Today the no-conflict path goes to `standards`.

## R5. Template

- **Decision**: `coding-standard.md` moves from `2.0.0` to `3.0.0`. The Rules placeholder says each rule contains the word must, at most ten, and one rule keeps encoded or encrypted credentials outside the files. The file does not contain a Why it matters line. `codify-platforms.md` and `coding-standards-catalog.md` are unchanged.
- **Rationale**: The skill writes the standard file from that template. The catalogs already store each list as rule text separated by `; `.
- **Alternatives considered**: Leave the template on the imperative placeholder. Rejected because the written file would not match the template the skill calls its complete structure.

## R6. Replaced assertions (D3.5)

- `codify-config-skill.test.sh`: the `highway-codify-config` pin moves from `version: 2.0.0` to `version: 3.0.0`. Reason: the skill's MAJOR bump. That loop checks only the skill.
- `codify-file-layout.test.sh`: the same skill pin moves from `version: 2.0.0` to `version: 3.0.0`. Reason: the skill's MAJOR bump.
- `codify-file-layout.test.sh`: the `coding-standard.md` pin moves from `version: 2.0.0` to `version: 3.0.0`. Reason: the template's Rules placeholder now requires the word must and the credential rule.

## R7. Who is re-checked

- **Decision**: `validate-skill.sh` on `highway-codify-config` and `validate-library.sh` on `coding-standard.md`. `highway-codify` is not edited and does not cite the template.
- **Rationale**: D8.1. The config skill is the only skill that cites `coding-standard.md`.
