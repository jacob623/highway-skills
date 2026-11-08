# Research: Codify Platform Prompt

## R1 Where each line lives

- **Decision**: Replace each line where it is emitted today. `highway-onboarding` `orchestrate` emits the included line and question, and `configure` step 3 emits the configure line. `highway-implementation` `platforms` emits all three. `highway-codify-config` `platform proposal` emits the heading, and the menu emits the platforms option.
- **Rationale**: The change is wording only. Moving a line to a shared step would change behavior and is out of scope.
- **Alternatives considered**: One shared step for the included line and question, followed by both skills. Rejected because onboarding queues the yes while implementation acts on it at once.

## R2 Paraphrases and internal rules

- **Decision**: Reword the verification lines that quote or paraphrase the old lines: onboarding lines about being asked "to configure it for automation" and the quoted configure line, and the matching implementation verification line. Keep "can start automation" where it states which platforms qualify, since the person never sees it.
- **Rationale**: D6.1 requires live documentation to change with the behavior it names. The qualification rule is unchanged by the spec.
- **Alternatives considered**: Rewording every "automation" in the three skills. Rejected as outside the spec.

## R3 Moved pins

Each assertion below moves because the line it pinned is replaced. The new test pins the replacement.

- `codify-platform-catalog.test.sh`: `is included as a platform that can start automation.**` and `**Would you like to configure [Platform] for automation?**` become the new included line and question.
- `codify-config-skill.test.sh`: the menu option and `**Would you like to configure [Platform] for automation?**` become the new wording.
- `configure-handoff.test.sh`: `3. Emit: Let's configure [Platform] for automation.` and the `platforms` accept line become the new configure line. The existing reject of `Run /highway-codify-config [Platform] to configure it for automation.` stays.
- `platform-starting-point.test.sh`: the proposal heading becomes the new heading.
- `version: 10.3.0` becomes `version: 10.4.0` for `highway-onboarding`, `version: 7.4.0` becomes `version: 7.5.0` for `highway-implementation`, and `version: 3.4.0` becomes `version: 3.5.0` for `highway-codify-config`, in every test that pins them.
