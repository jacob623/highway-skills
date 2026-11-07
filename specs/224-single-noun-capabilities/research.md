# Research: Single Noun Capabilities

## R1 Owner of the Title rule

- **Decision**: `capability-catalog.md` states the Title rule. Each skill cites it.
- **Rationale**: Constitution P7.3 forbids a skill restating a rule owned elsewhere. The catalog template already owns the Title column, and four skills produce capability titles.
- **Alternatives considered**: Repeating the rule in each skill, which leaves four copies to drift. A new library knowledge file, which adds a file for one rule.

## R2 Owner of split and shorten

- **Decision**: A new `capability title` step in `highway-implementation` splits a joined title, shortens a long one, and gives the consequence sentence. `highway-onboarding` and `highway-architecture` follow it.
- **Rationale**: Onboarding already follows `platforms` in `highway-implementation`. One step keeps one consequence sentence. Implementation is the skill that writes the capability catalog.
- **Alternatives considered**: Putting the split in the template, which would place interaction wording in an output skeleton. A step in each skill, which repeats the consequence sentence three times.

## R3 Consequence sentence

- **Decision**: A split edit says `[Entry] is now [Part] and [Part]. If one is later done apart from the other, one joined capability would compound the effect of that change.` A shortened edit says `[Entry] is now [Title].`
- **Rationale**: The clarification asked the person to be told why a joined capability is a risk. The sentence is fixed, so tests pin it.
- **Alternatives considered**: A free-form explanation, which is not testable.

## R4 Configuration titles

- **Decision**: Step 5 of `current` titles each automation under the Title rule, and still puts the product and handoff in the evidence.
- **Rationale**: Configuration feeds `add capabilities`. Its five-word limit matches the template's five-word limit. `add capabilities` leaves out a title that breaks the rule, in its existing step 4, so its step numbers stay.
- **Alternatives considered**: A new numbered step in `add capabilities`, which renumbers every pinned step.

## R5 Codify suggestions

- **Decision**: With no instance running, `Establish [implementation title]` comes first. Every other suggestion comes from one realized capability, in record order. With an instance running and no realized capability, the only suggestion is `Run [implementation title]`. A title from a realized capability does not start with `Establish`. The `provider` check on the action title stays.
- **Rationale**: A noun phrase never contains `establish`, so the old classification never matches. Keeping capability suggestions off `Establish` keeps the executor choice in `provider` unchanged.
- **Alternatives considered**: Removing the `provider` check too, which would break spec 223's executor choice.

## R6 Moved pins

Each assertion below moves because the behavior it pinned is replaced. The new test pins the replacement.

- `static-highway-capability.test.sh`: every `AI-Assisted Engineering and Planning` string becomes `AI-Augmented Technology Development`. The static capability is renamed.
- `onboarding-technology-capabilities.test.sh`: `When two activities rely on one technology, propose one capability.` becomes `When two activities rely on one technology, propose each as its own capability.` The merge rule is removed.
- `group-realized-capabilities.test.sh`: step 5 of `current` and its verification line no longer say `one noun phrase of five words or fewer` or `in five words or fewer`. They cite the Title rule.
- `platform-starting-point.test.sh`: `add capabilities` step 4 also leaves out a title that breaks the Title rule.
- `version: 3.3.0` becomes `version: 3.4.0` for `highway-codify-config` in `standard-starting-point`, `single-rule-shape`, `platform-starting-point`, `labeled-proposal-lines`, `group-realized-capabilities`, `establish-from-record`, `entry-level`, `configure-handoff`, `config-live-rules`, `codify-file-layout`, and `codify-config-skill`.
- `version: 12.1.0` becomes `version: 12.2.0` for `highway-codify` in `propose-edit-lines`, `establish-from-record`, `codify-write-refactor`, `codify-products`, `codify-platform-catalog`, `codify-file-layout`, `codify-feature-wording`, `codify-deterministic-steps`, `codify-config-skill`, and `codify-closing-guide`.
- `version: 7.3.0` becomes `version: 7.4.0` for `highway-implementation` in `record-purpose-titles`, `platform-starting-point`, `establish-from-record`, `configure-handoff`, and `codify-platform-catalog`.
- `version: 10.2.0` becomes `version: 10.3.0` for `highway-onboarding` in `onboarding-technology-capabilities`, `establish-from-record`, `configure-handoff`, and `codify-platform-catalog`.
- `version: 5.0.0` becomes `version: 5.1.0` for `highway-architecture` in `record-purpose-titles` only. Other `5.0.0` pins belong to other skills.
- `architecture-record.md` `version: 2.1.0` becomes `version: 2.2.0` in `record-purpose-titles`.
