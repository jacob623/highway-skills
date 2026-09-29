# Data Model: Revise the Runtime Skills Constitution

The only stored artifact is `.highway/governance/constitution.md`. Skill files and the development constitution are not entities of this change.

## Skills Constitution

| Field | Rule |
|---|---|
| Identity | The runtime governance document for a shipped Highway skill |
| Version before | 3.0.1 |
| Version after | 4.0.0 |
| Ratified | Unchanged |
| Last amended | The date of this amendment |
| Amendment record | A new sync impact report prepended to the existing reports. The report names every retired, redefined, and new identifier, the principle rename, the precedence reason, the removed sections, and the self-application review. |
| History | Existing reports stay in the file |

## Rule

| Field | Rule |
|---|---|
| Identifier | Stable. Retired identifiers are not reused. Redefined rules keep their identifier. |
| Keyword | Exactly one of MUST, MUST NOT, or SHOULD |
| Obligation | One. The text does not join a second obligation with "and" or "or". |
| Length | 25 words or fewer |
| Observable | A countable or checkable condition for that one obligation |
| Tier | One tier tag, defined in Definitions |
| State | `active`, `redefined`, or `retired` |

### State transitions

- `active` → `redefined` when the identifier stays and the obligation changes.
- `active` → `retired` when the obligation leaves the document. The identifier stays unused.
- A new obligation starts as `active` with a new identifier.

The full transition list is the table in [contracts/skills-constitution-amendment.md](./contracts/skills-constitution-amendment.md).

## Common failure model

One set of situations, stated once under Principle V. A skill documents failure handling only where its domain behavior differs. There is no per-step error table and no required retry, abort, escalate, or fall-back token.

| Situation | Result |
|---|---|
| Missing or contradictory required input | Obtain it before continuing |
| Malformed or unsafe authoritative state | Stop without mutation and identify the problem |
| User decline or exit | Stop without unintended mutation |
| Dependent owner non-success | Preserve and consume that result |
| Failed mutation | Do not claim success |
| Unexpected failure | Stop safely and provide actionable user-facing context |

## Owner

The skill that determines its own readiness, its own domain state, and, when interaction is required, its next supported action.

## Orchestrator

The skill that delegates the owner's supplied action, consumes the owner's declared result, advances only from the owner's declared terminal result, and does not inspect or reconstruct the owner's internal state.

## External authority

A technical, security, regulatory, protocol, or standards source. A skill cites one only when the skill asserts a requirement from that source. The citation names the source and a specific section, control, or identifier. The approved list stays closed. A later amendment may add an entry that names its provenance.

## Shared authority

The Skills Constitution, the Experience Standard, a shared template or contract, or another owning skill. A skill cross-references shared authority. It does not restate that authority's generic rules.

## Retired rule

An obligation removed by this amendment. Its identifier is not a current rule and is not assigned to a replacement. The amendment record may name it as removed. Definitions and examples that only explained it are removed or rewritten.

## Relationships

- A shipped skill is governed by the Skills Constitution at runtime.
- A shipped skill is not required to include the development constitution or development procedures.
- An orchestrator depends on an owner's declared result. It does not depend on the owner's internal records.
- Experience compliance points at the Experience Standard. The skill keeps domain-specific interaction meaning.
- A shared output names a template, a location, and the domain meaning the template does not own.
