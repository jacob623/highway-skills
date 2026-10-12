# Data Model: Objectives Advisory Collection

This feature adds no durable record type. The following concepts describe the behavioral contract
and identify which state may remain transient.

| Entity | Key content | State and relationships |
|---|---|---|
| Response Support Text | Validation Question; Acceptance, Discovery, Combined, Recommendation, and Additional Suggestions Reassurance | Objective-owned reusable wording selected by interaction context; not persisted. |
| Grounded Objective Observation | One relationship, overlap, implication, coverage, gap, tension, reinforcement, focus, or portfolio observation | Provisional Working Idea grounded in accepted Profile evidence and accepted Objectives; at most one contribution at a time. |
| Objective Portfolio Assessment | Concise coverage, overlap, duplication, concentration, fragmentation, or gap assessment | Advisory only; never mutates, rejects, blocks, or completes the Objective baseline. |
| Objective Recommendation | Provisional grounded outcome plus its accepted grounding | Remains outside accepted Objective content until the existing acceptance boundary; user-authored outcome remains available. |
| Active Objective Queue | Ordered selected recommendations and current processing position | Transient; preserves user-selected order and is cleared/advanced only through the existing acceptance and mutation flow. |
| Success Measure | Accepted evidence describing how an Objective outcome is recognized | Required for capture; derived from sufficient accepted evidence or obtained through the unresolved Success question. |
| Accepted Objective | Existing user-owned record with statement, Success Measures, rationale, and owner acceptance | Durable record at `library/objectives/OBJXXXXXX.md`, indexed by the existing catalog and permanent identifier rules. |

## State transition

`Recommendation presented` -> `selected recommendation` -> `queued` -> `statement and Success
Measures established` -> `rationale synthesized` -> `review when required` -> `accepted Objective`
-> `existing atomic persistence`, then the next queue item is processed. Explanation, comparison,
modification, decline, interruption, or unresolved required Success evidence does not cross the
accepted Objective or persistence boundary.