# Contract: Skill Text

Every line below is pinned by `tests/harness-failure-resolutions.test.sh` unless noted. Source is
`skills/`. The agent trees are regenerated.

## F1: Entry title selection

- highway-adr `### Entry` step 1: `1. Read the invocation for one Discovery id and one option id. When it has no Discovery id and contains the exact title of one waiting Discovery, as \`choose-discovery\` defines it, that Discovery's id is present. Compare without regard to case.`
- highway-architecture `### Entry` step 1: `1. Read the invocation for one ADR id. When it has no ADR id and contains the exact title of one waiting ADR, as \`choose\` defines it, that ADR's id is present. Compare without regard to case.`
- highway-discovery `### Entry` step 1: `1. Read the invocation for one Request id or one Discovery id. When it has neither, and contains the exact title of one Discovery that is ready to explore, as \`choose\` defines it, that Discovery's id is present. Otherwise, when it contains the exact title of one Request that is ready to analyze, that Request's id is present. Compare without regard to case.`
- highway-implementation `### Entry` step 3: `3. Read the invocation for one Reference Architecture id. When it has none and contains the exact title of one accepted architecture, that architecture's id is present. Compare without regard to case.`

## F2: highway-profile `offer`

The bullets after the offer text:

- `- The person has nothing: go to \`identity.ask\`.`
- `- Text, with or without a link: the text is supplied material for every domain. Store a link in it as Organization URL and retrieve it. When the link cannot be read, say so once and continue with the text. Go to \`identity.review\` when the material supports at least one Identity finding. Otherwise go to \`identity.ask\`.`
- `- A link or document with no other text: retrieve it. Store a supplied link as Organization URL. Go to \`identity.review\` when it supports at least one Identity finding. Otherwise go to \`identity.ask\`.`
- `- A link with no other text, when retrieval is unavailable: go to \`identity.ask\`. Do not mention the missing retrieval.`

After the bullets: `Facts from supplied material stay proposed until accepted in that domain's proposal.`

Error Handling replaces the unavailable-retrieval bullet with:

- `- Pasted text is supplied material. A link in it that cannot be read is named once, and the skill continues with the text.`
- `- A link with no other text and no retrieval continues at \`identity.ask\` without mentioning the missing capability.`

## F6, F10, F12: storage contract `1.2.0`

- `Version \`1.2.0\`.`
- After the operations table: `"Read a file" and "Check a file exists" act on the exact path. A search or pattern tool does not decide whether a file exists. A file is absent only when one of those two operations reports it absent at its path.`
- `A folder is created by writing a file in it.`
- "What a skill does not do" adds `- Run a shell command.` and `- Decide that a file is absent from a search or pattern result.`
- highway-experience `SKILL.md` `metadata.version: 1.2.0`.

## F10: governance Entry step 1

- objectives: `1. Read \`library/governance/objectives.md\`. Then read each record it indexes at \`library/objectives/[ID].md\`, with "Read a file".`
- controls: `1. Read \`library/governance/controls.md\`. Then read each active record it indexes at \`library/governance/controls/[ID].md\`, with "Read a file".`
- nfrs: `1. Read \`library/governance/nfrs.md\`. Then read each active record it indexes at \`library/governance/nfrs/[ID].md\`, with "Read a file".`

## F5: governance `queue` question

In each `references/proposal.md` `### queue`, the question after the additional set becomes the
queue-has-titles question:

- objectives: `**Would you like to select any of these outcomes, modify them, or are you ready to review the selected objectives?**`
- controls: `**Would you like to select any of these safeguards, modify them, or are you ready to review the selected Controls?**`
- nfrs: `**Would you like to select any of these operational expectations, modify them, or are you ready to review the selected NFRs?**`

The test asserts that `### queue` holds no empty-queue question.

## F4: onboarding `map`

- `Cursor, VS Code, GitHub Copilot, Claude, and Codex are names the session may identify.`
- `- \`unknown\`: when the provider is \`Unknown\`, emit the provider question below instead of this block. Otherwise re-emit this block. Stay on \`map\`.`
- The provider question: `**Who builds or runs [Capability title] today?**`, then `If no one does, just say so and I'll mark the provider as Does not exist.`
- Its replies: a named person, team, platform, or service becomes the provider and re-emits the block; "no one", or `unknown` again, sets `Does not exist` and re-emits the block; `decline` stops and writes nothing.
- Removed: `- \`unknown\`: re-emit this block, including the unable-to-infer line. Stay on \`map\`.`

## F4: codify

- `record.md` `### check`: `5. When none qualify, go to \`menu\`. Do not show the plan until the person selects 1. Do not say the check ran.`
- `SKILL.md` `### record check`: `2. The record is incomplete when Language is \`Needed\`, empty, or names a standard with no row. Language \`None\` names no standard and is complete.` (also pinned in `code-project.test.sh`)

## F9: highway-implementation

- The line `Classify the reply:` comes directly before each of the six reply lists, with a blank line between: `choose`, `start`, `title`, `platforms`, `delivery platforms`, and `delivery decline`.
- `field` step 2: `2. When the name has an accepted implementation and no row, emit "Let's configure [Platform]." Then follow \`highway-codify-config\` for [Platform], with the return step \`execution\` in \`highway-implementation\`.`
- `field` step 3: `3. When the name has no accepted implementation, emit "Let's onboard [Platform]." Then follow \`highway-onboarding\` for [Platform], with the return step \`execution\` in \`highway-implementation\`.`
- `start` `accept`: `- \`accept\`: when Deployed by or Managed by is Needed, name that field and re-emit this block. When a stated responsibility is neither covered nor marked not applicable, name it and re-emit this block. In both cases stay on \`start\`. Otherwise go to \`identifier\`.`

## Versions (MINOR)

| Skill | From | To |
| --- | --- | --- |
| highway-adr | 6.6.0 | 6.7.0 |
| highway-architecture | 5.7.0 | 5.8.0 |
| highway-discovery | 5.6.0 | 5.7.0 |
| highway-implementation | 7.15.0 | 7.16.0 |
| highway-profile | 14.4.0 | 14.5.0 |
| highway-onboarding | 10.12.0 | 10.13.0 |
| highway-codify | 14.7.0 | 14.8.0 |
| highway-objectives | 8.6.0 | 8.7.0 |
| highway-controls | 8.6.0 | 8.7.0 |
| highway-nfrs | 9.7.0 | 9.8.0 |
| highway-experience | 1.1.0 | 1.2.0 |
