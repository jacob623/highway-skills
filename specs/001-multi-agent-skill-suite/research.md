# Phase 0 Research: Multi-Agent Skill Suite

All unknowns from the Technical Context have been resolved below. No `NEEDS CLARIFICATION`
markers remain.

## Decision 1: Canonical frontmatter is the Agent Skills open-standard subset

**Decision**: Canonical skills (`skills/<name>/SKILL.md`) use only the portable frontmatter
fields defined by the Agent Skills open standard (agentskills.io): `name`, `description`,
`license`, `compatibility`, `metadata`. Agent-proprietary frontmatter extensions (e.g., Claude
Code's `allowed-tools`, `disable-model-invocation`, `context: fork`) are never used in the
canonical source.

**Rationale**: Verified that both GitHub Copilot's skill convention (already used by the
`speckit-*` skills in this repo) and Claude Code natively read a `SKILL.md` file with YAML
frontmatter, and that Claude Code's own documentation explicitly defines this five/six-field
subset as the portable spec for use outside Claude Code itself. Restricting canonical
frontmatter to this subset satisfies FR-002 (agent-agnostic authoring) and directly enables
FR-004 (add an agent without editing existing skills).

**Alternatives considered**:
- Authoring with each agent's native/proprietary frontmatter extensions — rejected: breaks
  unmodified portability (FR-002) the moment two agents' extensions conflict.
- Inventing a new, bespoke frontmatter schema for this suite — rejected: violates Constitution
  Principle III (must be grounded in an established practice, not a one-off invention).

## Decision 2: Cursor requires a generated adapter, not native SKILL.md support

**Decision**: Cursor is treated as a "transform" target. A generation step converts each
canonical `skills/<name>/SKILL.md` into `.cursor/rules/<name>.mdc` with Cursor's own frontmatter
(`description`, `globs`, `alwaysApply`), never a raw copy.

**Rationale**: Verified Cursor's rule system reads `.cursor/rules/*.mdc` files (or the simpler,
metadata-free `AGENTS.md`) and does not read `SKILL.md` at all; its frontmatter schema is
structurally different from the Agent Skills standard (glob/always-apply-driven rather than
description-driven skill invocation). A generated, deterministic transform is required to keep
Cursor support inside the "integration layer only" boundary set by FR-004.

**Alternatives considered**:
- Hand-maintaining a separate Cursor rule per skill — rejected: violates FR-004 and Constitution
  Principle VII (creates a hand-maintained fork that can drift out of sync).
- Using `AGENTS.md` as the single cross-agent mechanism for all three agents — rejected:
  `AGENTS.md` has no structured, per-skill applicability metadata, which the catalog (FR-001)
  depends on.

## Decision 3: Per-agent adapters are generated copies/transforms, not symlinks

**Decision**: `tools/generate-agent-adapters.sh` writes real files into `.github/skills/`,
`.claude/skills/`, and `.cursor/rules/`; it does not rely on symlinks.

**Rationale**: Symlinks are not uniformly reliable across developer operating systems and Git
checkout configurations, and Cursor's target format requires content transformation that a
symlink cannot express. A single generation mechanism for all three agents keeps the guarantee
("regenerable with zero manual edits", per the Constraints in Technical Context) consistent and
easy to verify (Constitution Principle VIII).

**Alternatives considered**:
- Symlinks for GitHub Copilot/Claude Code (byte-identical targets) plus generation only for
  Cursor — rejected: mixing two distribution mechanisms for three near-identical adapters adds
  maintenance and verification overhead for a marginal benefit.

## Decision 4: Tooling language is Bash

**Decision**: `tools/validate-skill.sh`, `tools/generate-catalog.sh`, and
`tools/generate-agent-adapters.sh` are POSIX-compatible Bash scripts.

**Rationale**: This repository already standardizes on Bash for its tooling
(`.specify/scripts/bash/`). Reusing that convention avoids introducing a new language runtime or
package manager for what is otherwise a pure-Markdown content repository, keeping the
contribution barrier low (Constitution Principle III — reuse of an established, in-repo
practice).

**Alternatives considered**:
- Python or Node.js tooling — rejected for this feature: would add a runtime dependency the
  repository does not otherwise need. May be revisited in a follow-on feature if schema
  validation needs outgrow what is comfortable in POSIX shell/`awk`.

## Decision 5: Catalog is machine-first JSON with a generated human-readable view

**Decision**: `catalog/index.json` is the authoritative, machine-readable catalog;
`catalog/index.md` is a generated, human-readable rendering of the same data. Both are generated
artifacts; neither is hand-edited.

**Rationale**: A structured JSON catalog is the most broadly consumable format for the separate,
out-of-scope external application that will later perform automated overlap detection (per the
spec's Clarifications), without this feature committing to that external application's specific
schema. The generated Markdown view satisfies FR-001's human-discoverability requirement.

**Alternatives considered**:
- YAML catalog — rejected: adds a parser dependency for marginal readability gain over JSON for
  machine consumption.
- Markdown-only catalog (no JSON) — rejected: not reliably machine-parseable; risks silent
  parsing errors in the downstream external application.
