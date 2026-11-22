# Research: Slim Highway Identity

## R1. Keep path vs inline into SKILL.md

- **Decision**: Keep `skills/highway-experience/references/highway-identity.md`; replace body only.
- **Rationale**: Spec default; `hw_doc highway-identity`, experience-activation file list, harness
  path map, and constitution XI already name that path.
- **Alternatives**: Inline into SKILL.md (more churn across activations and tests).

## R2. Heading shape for suite tokens

- **Decision**: Use `# Highway Identity` plus `## What Highway is`, `## Knowledge chain`,
  `## Boundaries`. Update `constitution-profile-context.test.sh` to require those three `##`
  headings (drop `## Purpose` / `## User Experience`).
- **Rationale**: Matches locked substance; gives the static-document test stable anchors.
- **Alternatives**: No headings (weaker contract test).

## R3. Experience skill version

- **Decision**: Bump `metadata.version` `1.4.0` → `1.5.0` (MINOR: framing change, no breaking
  procedure contract).
- **Rationale**: Reference content change that agents read; house skill versioning.
- **Alternatives**: Leave 1.4.0 (under-states the change).

## R4. Plugin finish order

- **Decision**: After content lands: `--exclude-plugin-gen` green → bump `framework/plugin/plugin.json`
  (e.g. `0.1.1` → `0.1.2`) → `generate-agent-plugin.sh` (+ adapters/catalog as existing suite
  requires) → `--plugin-gen-only`.
- **Rationale**: Feature 259 / D4.8; covered inputs under `skills/` change.
- **Alternatives**: Skip bump (fails version-bump guard).
