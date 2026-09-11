# Candidate Result Contract

NFR verification consumes candidate-result data and derives status from the data. Fixture names must not be used as the status source.

| Candidate result | NFR status | Setup status | Artifact behavior |
|---|---|---|---|
| Success, count 0, no accepted artifacts | Not Applicable | Complete | No NFR artifact |
| Success, count > 0, proposal not started | Missing | In Progress | Proposal path available |
| Success, count > 0, proposal pending | In Progress | In Progress | Await acceptance |
| Success, accepted valid artifacts | Complete | Complete | Accepted artifacts preserved |
| Unavailable generation | Blocked | In Progress | No fabricated artifact |
| Malformed or contradictory result | Blocked | In Progress | No fabricated artifact |

The decision function must reject a result that claims zero candidates while containing candidate entries.
