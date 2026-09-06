# Data Model: Multi-Agent Skill Suite

## Entity: Skill

A single, self-contained, agent-agnostic unit of guidance authored at
`skills/<id>/SKILL.md`.

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string (kebab-case slug) | Yes | Derived solely from the directory name. Immutable once catalogued; unique across the whole catalog. Independent of the frontmatter `name` field — the two are never required to match. |
| `name` | string | Yes | Human-readable display name. Frontmatter `name`. Free-form text; not required to be kebab-case or match `id`. |
| `description` | string (≤ 500 chars) | Yes | One-line purpose + when to use. Frontmatter `description`. Drives catalog discovery (FR-001) and is the sole carrier of "applicability" in the generated catalog (spec.md Key Entities); `when_not_to_use` stays body-only and is intentionally not exposed in the catalog. |
| `when_to_use` / `when_not_to_use` | string (body section) | Yes | Explicit applicability boundaries (FR-003, Skill Authoring Workflow). |
| `version` | string, semver `MAJOR.MINOR.PATCH` | Yes | Frontmatter `metadata.version`. Governed by FR-007. |
| `inputs` | string/list (body section) | Yes | Required inputs the invoking agent must supply. |
| `outputs` | string/list (body section) | Yes | Expected outputs/outcome. |
| `verification` | string (body section) | Yes | How to verify successful completion (Constitution IV). |
| `error_handling` | string (body section) | Yes | Failure/precondition detection and next action: retry, abort, escalate, or fall back (FR-009). |
| `compatibility` | string, one of `github-copilot`, `claude-code`, `cursor`, or `all` (default `all`) | No | Frontmatter `compatibility`. Declares which of the 3 in-scope agents (FR-010) the skill targets; `all` unless stated otherwise. |
| `agent_exceptions` | list (frontmatter `metadata.agent_exceptions`) | No | Explicitly declared, isolated agent-specific extensions (FR-002). Must name the agent and the exact deviation. |

**Validation rules**:
- `id` MUST match `^[a-z0-9]+(-[a-z0-9]+)*$` and MUST equal the containing directory name.
- `id` MUST be unique across all skills in `skills/`.
- `description` MUST be non-empty and ≤ 500 characters.
- `version` MUST match `^\d+\.\d+\.\d+$`.
- `when_to_use`, `when_not_to_use`, `inputs`, `outputs`, `verification`, `error_handling` MUST
  each be present and non-empty (Skill Authoring Workflow self-containment requirement).
- If `agent_exceptions` is present, each entry MUST name one of the 3 in-scope agents and MUST
  NOT alter the skill's core guidance for the other agents.

**Failure handling**: `tools/validate-skill.sh` MUST fail with a non-zero exit code and a message
naming the specific missing/invalid field(s) when any rule above is violated. It MUST NOT emit a
partial/best-effort catalog entry for an invalid skill.

## Entity: Skill Catalog

The generated, indexed collection of all skills, at `catalog/index.json` (authoritative) and
`catalog/index.md` (generated human view).

| Field | Type | Notes |
|---|---|---|
| `generated_at` | ISO-8601 timestamp | Set each time `tools/generate-catalog.sh` runs. |
| `entries` | list of `{id, name, description, compatibility, version, source_path}` | One per valid skill in `skills/`. `description` carries the skill's applicability summary (see Skill entity above); `when_not_to_use` is deliberately not duplicated into the catalog. |
| `overlap_flags` | list of `{skill_a, skill_b, reason}` | Populated by the manual review step (FR-005); empty by default until a reviewer records a flag. |

**Relationship**: Catalog is fully derived from Skill entities (1 catalog : N skills). It MUST be
regenerated (not hand-edited) whenever any skill under `skills/` is added, removed, or changed.

**Validation rules**:
- `entries` MUST contain exactly one entry per valid skill directory under `skills/`; an invalid
  skill (per Skill validation rules) MUST be excluded and MUST cause
  `tools/generate-catalog.sh` to exit non-zero rather than silently omitting it.
- Regenerating the catalog from unchanged `skills/` content MUST produce a byte-identical
  `catalog/index.json` (determinism, Constitution VI/VIII), aside from `generated_at`.

## Entity: Agent Integration (Adapter)

The generated, per-agent artifact that lets one specific agent discover and invoke a skill.

| Field | Type | Notes |
|---|---|---|
| `agent_id` | one of `github-copilot`, `claude-code`, `cursor` | Fixed set per FR-010 for this feature. |
| `target_path_pattern` | string | `.github/skills/<id>/SKILL.md`, `.claude/skills/<id>/SKILL.md`, `.cursor/rules/<id>.mdc` respectively. |
| `transform` | one of `identity-copy`, `mdc-transform` | GitHub Copilot and Claude Code use `identity-copy` (byte-identical to canonical); Cursor uses `mdc-transform` (frontmatter re-encoded, per `contracts/agent-adapter-contract.md`). |
| `generated_from` | `{skill_id, skill_version}` | Used to detect drift: an adapter whose `generated_from` does not match the canonical skill's current version is stale and MUST be regenerated before use. |

**Validation rules**:
- Every adapter file MUST be reproducible by re-running `tools/generate-agent-adapters.sh` with
  no resulting diff (idempotency).
- Adding a 4th agent MUST only require adding a new `agent_id`/`target_path_pattern`/`transform`
  entry to the generator; it MUST NOT require editing any file under `skills/` (FR-004, FR-008).

## Entity: Constitution (reference, not owned by this feature)

The already-ratified governance document at `.specify/memory/constitution.md`. Every Skill MUST
be validated against it before being catalogued (FR-006); this feature does not modify it.
