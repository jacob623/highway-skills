# Contract: Skills Constitution Amendment

Target file: `.highway/governance/constitution.md`

This contract assigns identifiers and states the obligation each row must carry. The wording in the constitution has to satisfy that document's clarity limits: one keyword, one obligation, 25 words or fewer, plus an observable and a tier. Where a sentence below uses "and" to name a spec bullet, the constitution row splits it so the row itself does not.

Version footer after the amendment: `4.0.0`, ratified date unchanged, last amended on the amendment date. Prepend a sync impact report that lists every row in the tables below. Keep the existing reports.

The file must not contain `.specify/` or `specs/`.

## Retired

These identifiers become unused. They are not assigned to a new row.

| Identifier | What leaves |
|---|---|
| P3.1 | Universal external citation on every absolute rule |
| P4.1 | Every quality claim paired with a named check |
| P4.3 | Every triggered gate names a verification command in the skill |
| P5.1 | Every step defines a failure condition |
| P5.2 | Failure action limited to retry, abort, escalate, or fall back |
| P5.3 | Retry attempt count |
| P5.4 | Fallback named by identifier |
| P5.5 | Every numbered step maps to an error-handling entry |
| P8.1 | Every workflow step is numbered |
| P11.5 | Verification records every absent context document |
| P12.1 | Persistence verification before a completion claim |
| P12.2 | No completion claim after failed persistence verification |
| P12.3 | A persistence failure names the unverified output |
| P12.4 | A multi-output claim verifies every retained output |

Also remove, without a rule identifier: the Code Generation Gate, the Testing Gate, the Maintainability Gate, the Performance Gate, Persistence Verification, Verified Completion Claim, N6, N5, N7, N8, N9, the Compliance Review Protocol, the Skill Authoring Workflow, and the merge decision. Remove definitions and examples whose only subject is a removed obligation. Remove the governance sentence that requires the protocol before merge.

## Redefined

The identifier stays. The obligation becomes the one in this table.

| Identifier | Obligation the row must state |
|---|---|
| P1.7 | An absent or self-contradictory declared input is handled by the common failure model. |
| P3.3 | An external citation is required only when the skill asserts an external requirement. |
| P7.3 | A skill does not restate a requirement owned by the Skills Constitution, the Experience Standard, a shared contract, or another skill. It cross-references that owner. |
| P8.2 | Step order is declared only when order affects behavior, ownership, safety, mutation, or output. |
| P8.4 | Verification names a checkable outcome. A command is not required for an ordinary artifact workflow. |
| P9.1 | A skill that emits a templated file names the template, the output location, and the domain meaning the template does not own, and does not repeat the template. |
| P11.1 | The skill declares each context source that can influence its behavior. |
| P11.2 | The skill uses available relevant accepted context before context-dependent behavior. |
| P11.3 | Active workflow or user evidence overrides conflicting repository context for that interaction. |
| P11.4 | The skill does not invent or silently substitute missing or unavailable context. |
| P12.5 | The orchestrator consumes the owner's declared result. |

P8.4's command clause is one observable of the checkable-outcome rule, not a second obligation to avoid commands in every skill. P7.3's cross-reference is the observable of the non-restatement rule. P9.1's "does not repeat" is the same non-duplication applied to a template; if that exceeds one obligation, state the non-repetition as the rule and the three declarations as its observable.

## Added

| Identifier | Obligation the row must state |
|---|---|
| P5.7 | Missing or contradictory required input is obtained before the skill continues. |
| P5.8 | Malformed or unsafe authoritative state stops the skill without mutation. |
| P5.9 | The skill identifies the malformed or unsafe state that stopped it. |
| P5.10 | User decline or exit stops the skill without unintended mutation. |
| P5.11 | A dependent owner's non-success result is preserved and consumed. |
| P5.12 | A failed mutation is not reported as success. |
| P5.13 | An unexpected failure stops the skill with actionable user-facing context. |
| P5.14 | The skill documents failure handling only where it differs from this model. |
| P12.6 | The owner determines its own readiness. |
| P12.7 | The owner determines its own domain state. |
| P12.8 | The owner supplies its next supported action when interaction is required. |
| P12.9 | The orchestrator delegates the action the owner supplied. |
| P12.10 | The orchestrator advances only from the owner's declared terminal result. |
| P12.11 | The orchestrator does not inspect owner-internal state. |
| P12.12 | The orchestrator does not reconstruct owner-internal state. |

P5.6 stays as it is. P5.12 is the single statement of FR-025. Principle XII does not repeat it.

## Kept

Unchanged obligations: P1.1 through P1.6, P2.1 through P2.5, P3.2, P3.4, P3.5, P4.2, P4.4, P4.5, P4.6, P5.6, P6.1 through P6.6, P7.1, P7.2, P7.4 through P7.7, P8.3, P8.5, P8.6, P8.7, P10.1 and P10.2 as Experience Standard compliance by reference, and the user-ownership meaning already in the document.

P10.1 loses any requirement that the result be recorded in the Compliance Review Protocol. The skill references the Experience Standard and keeps domain-specific interaction meaning.

The Security Gate stays. It applies when the skill performs a security-affecting action. It keeps the prohibitions in P4.5 and P4.6. It requires an external security citation only when the skill asserts an external security requirement.

The approved-source list stays closed. The authority section states that a later amendment may add an entry that names its provenance, and that a skill cites an entry only when asserting that external requirement.

Principle XII is renamed around owner-controlled completion and orchestration. Its precedence rank stays 5. The rank's reason describes owner-controlled completion, not persistence verification.

N1 through N4 stay only if a remaining gate or rule still refers to them. Tier tags stay on the remaining rows and are defined in Definitions.

## Self-application

The sync impact report records a review against P1.1, P1.2, P1.3, P1.4, P6.4, P6.6, and P7.3. The report cites identifiers. It does not copy a rule sentence from the development constitution.

## Out of this contract

Shipped skill files, `.specify/memory/constitution.md`, files under `.highway/tools/`, and other docs are not modified. `constitution-inventory.test.sh` is expected to fail. That failure is the recorded D3.2 exception, not a defect to repair in this change.
