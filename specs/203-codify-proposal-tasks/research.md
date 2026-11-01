# Research: Codify Proposal Tasks

## R1. Where the product, platform, or application name comes from

- **Decision**: Use the `Choice:` value when the implementation record has exactly one `## Technology Choice` block. Use the implementation title when it has none or several.
- **Rationale**: Technology Choice is the field the implementation template reserves for the product or mechanism. The opening comes before an action is selected, so no single automation can decide between several choices.
- **Alternatives considered**: Realized By of the first suggestion. Rejected because it names the product of one suggestion in a line that covers all of them. Joining several names. Rejected because the opening would stop reading as one subject.

## R2. Turning a realized capability into an action

- **Decision**: Each suggestion is one realized capability rewritten as an action that starts with a verb and names the target. Its summary is one sentence that expands on that action, grounded in the capability's Realized By and the first sentence of its evidence. The establishing-first ordering still classifies the original capability title, and an establishing action starts with `Establish`.
- **Rationale**: Capability titles state outcomes, such as "Multi-factor sign-in enforced". The person is choosing work to automate. Classifying the original title keeps the existing ordering rule and its tested strings.
- **Alternatives considered**: Classifying the rewritten action. Rejected because an action may start with another verb and change the order.

## R3. Running-instance rule without a current state or day

- **Decision**: Move the running-instance definition from `start` to `suggest`. It orders suggestions only. The proposal and the record state neither a current state nor a day.
- **Rationale**: The spec keeps instance-aware ordering and removes the visible fields. `instance is running`, `instances are running`, and `Establish` remain asserted by `highway-codify.test.sh`.

## R4. Order and scope of the checks

- **Decision**: `align` runs after `start` drafts the proposal and before `propose` shows it. The standard check runs first on the executor and each task. The source check then runs on the corrected draft. Each standard is chosen from `library/coding-standards/coding-standards.md` by its Technology column, or by File Patterns when the method names a file. Its whole text is read for provider boundaries, accepted libraries or modules, and required patterns. A standard need not use headings with those names.
- **Rationale**: Organization standards have no required section names. The Terraform sample states its expectations as numbered rules, such as pinned versions, secrets read from the secret store, and one concern per file.
- **Alternatives considered**: Adding required sections to standards. Rejected because Highway does not judge organization content.

## R5. What a conflict changes

- **Decision**: A conflict changes the provider, method, library, module, or pattern. It never changes the action. One sentence before the proposal says what changed and names the standard title. When no correction keeps the action, the proposal is not shown. One sentence says the standard cannot be met for this action, and codify returns to `suggest`, or asks for another action when the action was named in the invocation.
- **Rationale**: Clarification Q3 keeps the selected action and makes the proposal congruent with the organization.

## R6. Source check outcomes

- **Decision**: Follow the vendor-documentation rule from `highway-discovery`. Send only the product, feature, or library name and the vendor name. A vendor page saying deprecated, retired, or no longer offered corrects the proposal and cites the source. Conflicting vendor pages correct the proposal and cite both. Secondary sources, missing sources, and incomplete checks are named as inconclusive. Results appear before the proposal and are not saved.
- **Rationale**: This matches the rule people already see in discovery, and it keeps "nothing is written before acceptance".

## R7. Edits after the proposal is shown

- **Decision**: An edit that changes a provider or method runs `align` on the changed task before the proposal is shown again. Other edits do not run the checks again.
- **Rationale**: The person can introduce a library or provider that the standard does not accept. Re-checking only the changed task keeps the proposal congruent without redoing finished checks.

## R8. Diagram shape

- **Decision**: One fenced `flowchart TB` block. The first node is the executor. Each task adds one arrow, labeled with its verb phrase, to a new node for its target. Arrows chain in task order. Every target has its own node, even when two targets share a name, so the diagram never loops.
- **Rationale**: A chain reads top to bottom in task order. A fan-out from the executor lays targets side by side and loses the order.

## R9. Executor and file list

- **Decision**: The executor is the diagram's first node. Its files are written once and tagged `[Executor]`. A task whose method needs its own artifact adds that artifact's files, tagged `[Task N]`, in task order. A task carried entirely by the executor adds no line. The readme is last. Executor files go in `code/[ID]/executor/`. A task's files go in `code/[ID]/task-N/`.
- **Rationale**: Clarification Q2. Numbered folders stay stable when the person rewords a task, and they never collide.
- **Alternatives considered**: Folders named after verb phrases. Rejected because rewording an action would rename its folder.

## R10. Provider and method grounding

- **Decision**: A provider is the person, or something the accepted architecture or the implementation names, including Realized By, Technology Choice, and Runtime Components. A method may name that provider's libraries, modules, plugins, MCP servers, or APIs, subject to `align`. "Do not invent a means that no accepted architecture describes" now applies to the executor and providers.
- **Rationale**: This keeps the existing grounding rule and still lets Method name the specific libraries the user asked for.

## R11. Coverage after `## Action` is removed

- **Decision**: `highway-adr` span coverage matches the automation title, without regard to case.
- **Rationale**: Clarification Q1. Codify 3.0.0 already writes the title as the action, so existing records give the same result.

## R12. Superseded test assertions (D3.5)

| Assertion in `highway-codify.test.sh` | Superseded by | Replacement |
|---|---|---|
| codify requires `You can also provide your own.` | FR-003 | require `If you have another idea, provide a brief description and we'll work through it together.` and reject the old line |
| codify requires `Responsibility:` | FR-012, FR-013 | require `**Scope:**` and `**Provider:**` |
| codify requires `Boundary:` | FR-012, FR-013 | require `**Method:**` and `**Assumptions:**` |
| record requires `Day 1 or Day 2` | FR-014, clarification Q1 | require `## Tasks` and reject `## Day` |

Every other assertion in that file stays.

`adr-span-progression.test.sh` requires `version: 5.0.0` in `highway-adr`. That version is superseded by the 5.0.1 patch for title-based coverage. The assertion now requires `version: 5.0.1`, which is equally strict.
