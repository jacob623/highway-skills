# Data Model: Static Highway Capability

## Highway capability

A line on the capability starting point.

| Field | Rule |
|---|---|
| Title | Highway |
| Sentence | Connect accepted business goals, decisions, architecture, and implementation work into a single traceable system of knowledge. |
| Edit | The person may change the sentence or remove the line before accept |
| Removal | The line is not queued, mapped, or given a decision |

## Agent platform

The provider for an accepted Highway capability.

| Field | Rule |
|---|---|
| Name | The session's identified platform name, or the name the person supplies |
| Examples | Cursor, VS Code, Claude, Codex, only when that name is identified or supplied |
| Scope | This capability only, unless another capability is work the platform operates |
| Duplicate | Omit the line when an accepted ADR already records Highway for this same provider name |

## Other capability

Unchanged. It keeps its own description and its own provider.

## State

1. The capability list shows Highway with the other capabilities.
2. Removal drops Highway before mapping.
3. Acceptance queues Highway.
4. Mapping sets its provider.
5. The existing provider path writes the decision, reference architecture, and reference implementation.
