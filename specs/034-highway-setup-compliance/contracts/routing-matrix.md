# Feature 034 First-Time Routing Matrix

The matrix has exactly 20 rows: five readiness entry states crossed with four deterministic owner-result conditions. Each row is scored independently.

| Entry state | Success | Declined | Failed | Incomplete/Malformed |
|---|---|---|---|---|
| Empty repository | Profile owner | Stop at Profile | Stop at Profile | Stop at Profile |
| Profile-only repository | Objective owner | Stop at Objectives | Stop at Objectives | Stop at Objectives |
| Profile and Objectives repository | Control owner | Stop at Controls | Stop at Controls | Stop at Controls |
| Profile, Objectives, and Controls repository | Control-owned NFR proposal | Pause or stop at NFR proposal | Stop at NFR proposal | Stop at NFR proposal |
| Complete repository | Zero owner calls | Zero owner calls | Zero owner calls | Zero owner calls |

A row passes only when the observed first owner call or deliberate stop matches the expected cell and the resulting dashboard state is correct. The routing score is `passing rows / 20`; the minimum passing score is `19 / 20` (95%).

The complete-repository row is a no-mutation control: owner-result labels are ignored because no owner workflow should be invoked.
