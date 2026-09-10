# Feature 038 Coverage Record

This record separates requirement coverage from executable behavior and generated-artifact checks.
NFR `Missing` is excluded from NFR-specific coverage because candidates with none accepted are
always `In Progress`.

| Requirement | Coverage | Evidence class |
|---|---|---|
| FR-001 | NFR ordered state contract and owner-state test | static contract; executable owner |
| FR-002 | NFR `Missing` exclusion assertion | static contract |
| FR-003 | Contract, fixture, and plan vocabulary checks | static contract; coverage |
| FR-004 | Canonical source map and plan check | static contract |
| FR-005 | Plan placeholder scan | static contract |
| FR-006 | Feature 037 immutability check | static contract |
| FR-007 | Profile, Objectives, Controls, and NFR fixture matrix | executable owner |
| FR-008 | Four-field parser over owner evaluation output | executable owner |
| FR-009 | Before/after fixture and identifier hashes | executable owner |
| FR-010 | Three unchanged evaluations per fixture | executable owner |
| FR-011 | Ordered Setup captured-response routing | Setup routing |
| FR-012 | NFR `In Progress`, `Blocked`, `Complete`, and `Not Applicable` routes | Setup routing |
| FR-013 | Evidence report category separation | evidence report |
| FR-014 | Catalog, adapter, and distribution correspondence checks | generated artifacts |
| FR-015 | Evidence report and quickstart output sections | documentation; evidence report |
| SC-001 | State-row references in contracts, fixtures, and this record | coverage |
| SC-002 | Feature 038 plan source/path scan | static contract |
| SC-003 | Owner fixture execution matrix | executable owner |
| SC-004 | Hash preservation assertions | executable owner |
| SC-005 | Three-run repeat assertions | executable owner |
| SC-006 | Setup short-circuit and NFR route matrix | Setup routing |
| SC-007 | Generated correspondence suite | generated artifacts |
| SC-008 | Separate evidence report sections | evidence report |
