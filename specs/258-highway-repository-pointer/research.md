# Research: Highway Repository Pointer

## R1. Owner of resolution and gate

- **Decision**: Implement resolve-root, dual gate, pointer persistence, and URL-only stop only in
  `highway-experience` (+ storage contract). No `highway-repository` skill.
- **Rationale**: Every skill already activates experience first; a second mandatory skill would
  drift. Spec clarifications lock this.
- **Alternatives considered**: New skill; duplicate procedure in each owning skill. Rejected
  (drift).

## R2. Path usability

- **Decision**: Local pointer path is usable only if the directory is already a Highway knowledge
  root (`library/knowledge/profile.md` or `library/knowledge/storage.md` readable). Otherwise
  reject; do not use as effective root.
- **Rationale**: Clarification A; matches “existing Highway project.”
- **Alternatives considered**: Accept any folder then setup-inside-pointer. Rejected.

## R3. Continue vs re-run after bind

- **Decision**: Same invocation continues after successful bind (FR-007a).
- **Rationale**: Clarification; better UX and one-turn harness stories.
- **Alternatives considered**: Always re-run. Rejected.

## R4. Setup choice vs setup skill

- **Decision**: Non-setup skills: choose setup → not-ready, next action `highway-setup`.
  `highway-setup`: choose setup-here → continue with open project as effective root (FR-007c).
  Setup may still show the dual gate so bind remains available.
- **Rationale**: Clarifications A/B for setup handoff.
- **Alternatives considered**: Setup never shows gate. Rejected — blocks bind-from-setup.

## R5. Absolute path vs P2.6

- **Decision**: Storage-operation paths stay relative to effective root. The local pointer’s
  `path:` value may be absolute or open-project-relative; it is configuration that **sets** the
  effective root, listed under a dedicated “Pointer files” section, not as an operation argument.
  Skill prose must not tell the agent to Read `/Users/.../library/...` as a storage path; it
  resolves root then uses relative paths.
- **Rationale**: Keeps P2.6; matches spec FR-005.
- **Alternatives considered**: Forbid absolute paths entirely (unusable on real machines).
  Rejected.

## R6. Owning-skill entry checks after gate move

- **Decision**: Remove the shared Oops / “Run highway-setup to get started” block from owning
  skills. Keep “confirm these seeded files exist”; when absent after experience returned ready,
  stop and write nothing with a short domain line that names the missing file(s) and
  `highway-setup` as repair — **not** the dual-gate asset and **not** the old Oops headline.
  Update `catalog-seeding.test.sh` accordingly.
- **Rationale**: FR-011; catalogs can still be missing on a knowledge root; dual gate is
  experience-only.
- **Alternatives considered**: Leave Oops blocks (fails SC-002). Drop all entry checks (weaker
  catalog integrity). Rejected.

## R7. Storage contract version

- **Decision**: Bump storage-contract document version `1.3.0` → `1.4.0` (MINOR: additive
  effective-root and pointer sections; Local column clarifies working tree = effective root).
  Experience skill version MINOR bump.
- **Rationale**: Additive contract behavior for Local; no Remote/Chat fill.
- **Alternatives considered**: MAJOR. Rejected — no removal of Local ops.

## R8. Gate asset shape

- **Decision**: Single `skills/highway-experience/assets/repository-gate.md` holding exact copy
  blocks: dual offer, invalid path, URL-only stop, persist+gitignore asks, setup-here next-action
  (non-setup), bound-ready (silent). Experience procedure references sections by name.
- **Rationale**: Spec shared-asset requirement; testable byte pins.
- **Alternatives considered**: Inline in SKILL.md only. Rejected (drift risk inside long SKILL).

## R9. Harness live fixtures

- **Decision**: Suite static tests are required for exit. Optional harness fixture deferred unless
  quickstart smoke is trivial with existing drivers; do not block on live multi-agent runs for
  this feature.
- **Rationale**: Spec allows existing drivers; pointer behavior is primarily procedural/static.
- **Alternatives considered**: Full harness dual-tree fixture now. Deferred to reduce scope.
