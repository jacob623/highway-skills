# Feature 035 NFR Candidate Outcome Contract

| Candidate result | NFR status | Setup status | Next action |
|---|---|---|---|
| Unavailable | `Blocked` | `In Progress` | Report candidate-generation failure and stop |
| Malformed | `Blocked` | `In Progress` | Report malformed result and stop |
| Zero candidates | `Not Applicable` | `Complete` | Emit terminal completion dashboard; do not create NFR |
| Candidates available; proposal not started | `Missing` | `In Progress` | Invoke Control-owned proposal path |
| Candidates available; proposal pending | `In Progress` | `In Progress` | Pause for author acceptance |
| Accepted valid artifacts | `Complete` | `Complete` | Emit normal completion dashboard |

The zero-candidate result is valid only when the Control-owned generation path explicitly reports successful generation with a count of zero. Missing, unavailable, malformed, and pending results are not zero candidates.
