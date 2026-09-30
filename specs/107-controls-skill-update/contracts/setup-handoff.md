# Setup-to-Controls Handoff Contract

1. Setup delegates `setup` or `configure` to Controls when its owner contract says Controls
   collection is required.
2. Controls owns Control discovery, recommendation presentation, proposal acceptance, persistence,
   and collection state.
3. Setup renders the Controls-owned response without interpreting transient evidence or inspecting
   Control identifiers.
4. `Collection Result: Continue` keeps the interaction with Controls.
5. `Collection Result: Finished` causes Setup to request fresh Controls readiness.
6. Setup advances only from the fresh readiness and the owner-declared collection result.
7. A readiness `Complete` result does not end an active collection before explicit finish.
8. A zero-Control or `Missing` readiness result remains at Controls and does not claim Setup
   completion.

The Controls collection result does not contain `Created Control IDs`. No cumulative identifier
state is restored or used for routing.
