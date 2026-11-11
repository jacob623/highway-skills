# Feature 035 Fixture Matrix

| Fixture state | Owner result | Expected Setup result | Executable evidence |
|---|---|---|---|
| Profile absent | Profile `Missing` | Stop at Profile | Execute absent input; no output bytes |
| Organization name empty | Profile `Missing` | Stop at Profile | Execute empty input; no write |
| Organization name whitespace-only | Profile `Missing` | Stop at Profile | Execute whitespace input; no write |
| Organization name supplied and confirmed | Profile `Complete` | Continue downstream | Execute write; supplied value and bytes deterministic |
| Profile proposal declined | Profile `Declined` | Stop at Profile | Execute declined input; original bytes unchanged |
| Profile malformed | Profile `Blocked` | Stop at Profile | Execute malformed input; original bytes unchanged |
| Zero NFR candidates | NFR `Not Applicable` | Setup `Complete` | Candidate-result decision; no NFR artifact |
| Candidates pending | NFR `In Progress` | Setup `In Progress` | Candidate-result decision; await acceptance |
| Accepted NFR artifacts | NFR `Complete` | Setup `Complete` | Candidate-result decision; accepted artifact present |
| Candidate generation unavailable | NFR `Blocked` | Setup `In Progress` | Candidate-result decision; no fabrication |
| Candidate result malformed or contradictory | NFR `Blocked` | Setup `In Progress` | Candidate-result decision; no completion |

All fixtures are deterministic: identical owner inputs and repository bytes produce the same state, route, dashboard, and write behavior. Static contract-text assertions are reported separately from these executable observations.
