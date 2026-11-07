# Contract: Title rule and `capability title`

## `capability-catalog.md` (version 2.1.0)

Replaces `Title is the business capability.` in the prose:

```text
Title is one capability: one noun phrase of five words or fewer. A hyphenated word counts as one word. Modifiers can precede the noun. A Title does not contain `and`, `or`, `&`, `/`, `+`, or a comma. A title that joins two things is two capabilities, one per part. Each part keeps its own words and repeats a shared noun when there is one.
```

## `highway-implementation` `### capability title` (version 7.4.0)

Placed before `### start`. At most 250 words.

```text
1. Each capability title follows the Title rule in `.highway/library/templates/output/capability-catalog.md`.
2. Split a title that joins two things into one capability per part, in its place in the list. Do not ask first. Each part keeps every other value of the entry it came from.
3. Shorten a title of six or more words to five words or fewer. Keep its meaning.
4. Leave out a part that matches a capability already listed.
5. When step 2 changed an edit, its consequence sentence is: [Entry] is now [Part] and [Part]. If one is later done apart from the other, one joined capability would compound the effect of that change.
6. When step 3 changed an edit, its consequence sentence is: [Entry] is now [Title].
7. Return to the step that named this one.
```

Callers in `highway-implementation`:

- `start` adds `Follow `capability title` for each capability.` after `Follow `execution`.`
- `start` `edit`: a capability edit follows `capability title`, then emits one consequence sentence, or the one `capability title` gave.
- `write`: `Each realized capability title follows the Title rule in `.highway/library/templates/output/capability-catalog.md`, and each capability has one or more Realized By values.`
- `add capabilities` step 4: `Derive each capability id as `write` does. When a title breaks the Title rule in `.highway/library/templates/output/capability-catalog.md`, or `write` would ask for a wording change, leave that capability out.`

## `highway-architecture` (version 5.1.0)

- Inputs gain `.highway/library/templates/output/capability-catalog.md` and `highway-implementation`.
- `start` adds `Follow `capability title` in `highway-implementation` for each capability, then return to `start`.`
- `start` `edit` follows `capability title` in `highway-implementation` for a capability it adds or corrects.
- `write`: Required Capabilities name their component, and each title follows the Title rule.

## `architecture-record.md` (version 2.2.0)

`Capability: <advisory capability text without a capability identifier>` becomes `Capability: <capability title without a capability identifier>`.

## `highway-codify-config` (version 3.4.0)

- Inputs gain `.highway/library/templates/output/capability-catalog.md`.
- `current` step 5: `5. Title that automation under the Title rule in `.highway/library/templates/output/capability-catalog.md`. Put a product name and a handoff, such as a pull request, a comment, or a ticket, in the evidence.`
- Verification: `titled under the capability catalog Title rule` replaces `titled by the automation in five words or fewer`.
