# Research: Codify Platform Catalog

## R1. Which platform executes when several are included

- **Decision**: A platform the person names is the Provider. Otherwise, when the implementation being automated is itself in the catalog, that platform is the Provider. Otherwise the first catalog row is the Provider. The person can correct it on the proposal, and every task then uses the corrected platform.
- **Rationale**: The choice is deterministic, and the proposal remains the place the person changes it. No new question is added.
- **Alternatives considered**: Asking before the proposal. Rejected because inclusion and configure already cover catalog changes, and the proposal already asks what to add, correct, or remove.

## R2. Where inclusion runs

- **Decision**: A new `platforms` step runs after a new implementation is written and after an accepted proposal reuses an existing implementation. It then goes to `close`. Opening a record, listing implementations, and declining a proposal do not enter `platforms`.
- **Rationale**: Reuse goes to `close` today without writing. The spec requires that accepting again includes the platform again, and that opening does not.

## R3. What qualifies

- **Decision**: Read Technology Choice, Runtime Components, and Realized By. Include the implementation when those describe a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, or an agent that starts the work. A store, a newsletter, a records product, or a backup does not qualify. The skill states these classes and does not ask.
- **Rationale**: Cursor qualifies as an agent that starts the work. Shopify does not. A fixed product list would miss the next pipeline.

## R4. Align keeps the Provider

- **Decision**: `align` may correct the method, library, module, or pattern. It must not replace the Provider with a different platform. When no correction keeps the action for that Provider, the existing failure line returns to `suggest`.
- **Rationale**: A coding standard must not silently turn Cursor back into a script.

## R5. The executor folder stays

- **Decision**: The proposal actor is the Provider. The diagram's first node is that Provider. Task files for that platform stay tagged `[Executor]` and stay in `executor/`. The task template says the Provider is the first diagram node and that its files use that tag and folder. The README Use sentence says the interface of the Provider.
- **Rationale**: Spec 203 tests require the `[Executor]` tag and the `executor/` path. The spec for this feature changes who executes and what the diagram shows. It does not change where the generated files go.
- **Alternatives considered**: Renaming the tag to `[Provider]`. Rejected because it would break the existing task-list contract without a request to move files.

## R6. Onboarding

- **Decision**: After onboarding writes an implementation, it follows `platforms` in `highway-implementation`, writes the same catalog, and emits the same two sentences when the platform qualifies. It still does not emit the implementation proposal or its questions. The sentence that forbids an inventory stays. This catalog is not that inventory.
- **Rationale**: Onboarding writes the implementation itself, so it never reaches `highway-implementation`'s `close`.

## R7. An empty catalog

- **Decision**: The proposal is shown, the Provider is left unset, and one sentence says a platform that can start automation is needed and points to `/highway-codify configure`. Accept stays on `propose` until a Provider is named. The person and the target are not used as the Provider.

## R8. Existing records

- **Decision**: No scan and no backfill. A platform already accepted is included when that implementation is accepted again, or when the person adds it from configure. Saved automations are not rewritten.

## R9. D3.5 note: replaced version assertion

- `.highway/tools/tests/record-purpose-titles.test.sh` pinned `highway-implementation` at `version: 5.0.0`. This feature makes a MAJOR change to that skill, so the pin is now `version: 6.0.0`. Every title assertion in that test is unchanged, and the `highway-architecture` pin stays at `5.0.0`. The assertion is not loosened: it still requires one exact version.
