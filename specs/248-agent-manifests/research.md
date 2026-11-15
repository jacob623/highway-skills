# Research: Agent Manifests

Sources were read on 2026-11-14. "Docs" means the agent's own published documentation or schema.
"Evidence" means the manifests of the publishers reviewed for the rollout, read from their
repositories on the same day: Cloudflare (`cloudflare/skills`), Superpowers (`obra/superpowers`),
AWS (`awslabs/agent-plugins`), and wshobson (`wshobson/agents`).

## R1. One renderer, one format table

- Decision: the manifests are rendered by a Python program inside
  `framework/lib/plugin-manifest.sh`, the file that already reads `plugin.json` with `python3`'s
  standard-library `json` module. One format table in that program drives both the generator
  (render) and the validator (check), so the two cannot disagree on a field list. Output is
  `json.dumps(indent=2, ensure_ascii=False)` plus a newline, with keys in a fixed order.
- Rationale: JSON rendering with escaping in Bash 3.2 is fragile. `python3` is already declared,
  and keeping the program in the same library keeps the list of `python3` callers unchanged; only
  the caller's stated purpose widens (render, not only read), which the constitution amendment
  records.
- Alternatives: hand-written manifests checked by the validator only (rejected: the point of the
  phase is that nobody edits them); `jq` (rejected: not in the Declared Toolchain).

## R2. The root `plugin.json` stays a byte copy of the source

- Decision: `framework/plugin/plugin.json` is the Agent Plugins manifest and is copied unchanged,
  as today. It gains `author` and `keywords` (both in Agent Plugins §5.4), and `homepage` becomes
  `https://www.highway.systems`. The five agent manifests are rendered from it plus the listing
  file. The validator compares each agent manifest's shared fields with the plugin's own root
  `plugin.json`, so it works on any plugin folder.
- Alternatives: render the root too (rejected: no gain; the source already is the standard's
  manifest, and its existing checks stay in force).

## R3. Codex: keep the `.codex-plugin/plugin.json` overlay

- Docs: Codex now prefers OpenAI settings in the root manifest under `extensions.com.openai`. A
  `.codex-plugin/plugin.json` overlay "remains supported as a compatibility fallback" and is used
  when that object is absent. Root identity and portable components stay canonical either way.
  Paths in the overlay start with `./`; visual assets go under `./assets/`.
- Evidence: Cloudflare, Superpowers, AWS, and wshobson all ship `.codex-plugin/plugin.json` with
  an `interface` block: `displayName`, `shortDescription`, `longDescription`, `developerName`,
  `category`, `capabilities`, `defaultPrompt`, `websiteURL`, and optionally `privacyPolicyURL`,
  `termsOfServiceURL`, `brandColor`, `composerIcon`, `logo`, `screenshots`.
- Decision: write the overlay, as Phase 6 and FR-007 say, with `"skills": "./skills/"` and the
  `interface` block. `developerName` comes from `author.name` and `websiteURL` from `homepage`
  (FR-003). `logo` and `composerIcon` both name `./assets/logo.svg`. Leave out
  `privacyPolicyURL`, `termsOfServiceURL`, `brandColor`, and `screenshots` (FR-004). Category is
  `Developer Tools` (Cloudflare, Superpowers, AWS); the docs' examples use `Productivity`.
  Capabilities are `Interactive`, `Read`, `Write` (Superpowers): Highway asks questions, reads
  records, and writes them.
- Phase 9 (Codex driver) rechecks: whether to move the block into `extensions.com.openai`, and
  whether Codex shows an SVG logo (the docs' example is PNG; Cloudflare ships SVG).

## R4. Cursor: no listing fields in the plugin manifest

- Docs (`cursor.com/docs/plugins/building`): `.cursor-plugin/plugin.json` requires `name`.
  Optional: `description`, `version`, `author` (`name` required, `email` optional), `homepage`,
  `repository`, `license`, `keywords`, `logo`, and component paths including `skills`. There is no
  `displayName` and no `category`; `category` exists only on a marketplace entry, which is Phase
  14. A `skills` path replaces folder discovery. Logos are committed and referenced by a relative
  path such as `assets/logo.svg`. Cursor also loads a root Agent Plugins `plugin.json`.
- Evidence: Superpowers' Cursor manifest has `displayName`; Cloudflare's has neither.
- Decision: the Cursor manifest carries the shared fields, an `author` of `name` only (Highway
  has no email, and the docs list no `url`), `"skills": "./skills/"`, and `"logo":
  "assets/logo.svg"`. No `displayName` or `category`. This changes FR-002's Cursor entry, per
  FR-007a: the documented format wins over the plan's expectation.
- Phase 7 (Cursor driver) rechecks: which manifest Cursor reads when both are present.

## R5. Antigravity: the published schema

- Docs (`https://antigravity.google/schemas/v1/plugin.json`): `name` is required, matching
  `^[a-zA-Z0-9_-]+$`. `additionalProperties` is false: Antigravity ignores unknown keys and `agy
  plugin validate` reports them. Properties: `$schema`, `name`, `displayName`, `description`,
  `version`, `disabled`, `logo` (a relative `.png`, `.svg`, `.jpg`, `.jpeg`, or `.webp` path, not
  starting with `/`), `suggestedPrompts` (at most 3), `skills` (extra folders, in addition to
  `skills/`), `author` (string or `name`/`email`/`url`), `homepage`, `repository`, `license`,
  `keywords`, `extensions`. There is no `category`.
- Evidence: Cloudflare's Antigravity manifest carries `category`, which the schema does not list.
- Decision: carry `$schema`, the shared fields, `displayName`, `logo`, and `suggestedPrompts`. No
  `category` (changes FR-002's Antigravity entry, per FR-007a) and no `skills` key, because
  `skills/` is loaded by default and the key adds folders.

## R6. Claude Code

- Docs (`code.claude.com/docs/en/plugins-reference`): `name` is the only required key. `version`,
  `description`, `author` (`name` required, `email` and `url` optional), `homepage` (must parse as
  a URL), `repository`, `license`, `keywords` are accepted. `skills` adds folders to the default
  `skills/` scan. Unknown top-level fields are stripped with a validator warning. `icon` and the
  policy URLs are read only by Anthropic's directory listing.
- Decision: the shared fields only. No `skills` key (it would add `skills/` a second time). No
  `icon`: listings are Phase 14.

## R7. Gemini CLI

- Docs (`gemini-cli/docs/extensions/reference.md`): `gemini-extension.json` at the extension
  root, with `name`, `version`, `description`. Skills are discovered from `skills/`. A
  `GEMINI.md` is loaded when present even without `contextFileName`; Highway ships none.
- Evidence: Superpowers ships name, description, version, and `contextFileName`.
- Decision: `name`, `version`, `description`, and nothing else.

## R8. Logo

- Docs: Antigravity accepts PNG, SVG, JPG, and WebP; Cursor's example is `assets/logo.svg`;
  Codex's example is PNG under `./assets/`.
- Evidence: Cloudflare ships `logo.svg` for Codex and Cursor; Superpowers ships PNG and SVG.
- Decision: one committed text file, `framework/plugin/assets/logo.svg`, copied to
  `highway-agent-plugin/assets/logo.svg`: a 512 by 512 rounded square with the word "Highway". It
  is a source file, not drawn at build time, so the build stays byte-identical. Replacing the
  file under the same name replaces the logo everywhere.
- Alternatives: PNG (rejected for the placeholder: binary, needs a drawing tool, not reviewable
  in a diff). Phase 9 rechecks SVG in Codex.

## R9. Shared fields per format

| Field | Root | Claude Code | Codex | Cursor | Antigravity | Gemini CLI |
| --- | --- | --- | --- | --- | --- | --- |
| `name` | yes | yes | yes | yes | yes | yes |
| `version` | yes | yes | yes | yes | yes | yes |
| `description` | yes | yes | yes | yes | yes | yes |
| `author` | name, url | name, url | name, url | name | name, url | no |
| `homepage` | yes | yes | yes | yes | yes | no |
| `repository` | yes | yes | yes | yes | yes | no |
| `license` | yes | yes | yes | yes | yes | no |
| `keywords` | yes | yes | yes | yes | yes | no |

Every listed shared field is required in its manifest and must equal the root's value; `author`
is compared on the keys the format accepts.

## R10. Precedence in Copilot

- Evidence: Superpowers' Copilot install reads `.claude-plugin/` because it has no root
  manifest. Spec 246 showed Copilot reading the root `plugin.json` when it is the only manifest.
- Decision: no harness change. The live smoke run is the check: every attempt must report
  `installed plugin highway (16 skills)`. If Copilot reads another manifest, the spec stops for
  the user (spec edge case).

## R11. The listing text

Drafted here and reviewed with the user before `listing.json` is written (spec Assumptions):

- Codex `displayName`: `Highway`.
- Codex `shortDescription`: `Governance, architecture, and traceability skills`.
- Codex `longDescription`: `Carry business intent from a request to working code. Highway
  records objectives, controls, and NFRs, explores options, records architecture decisions, and
  produces reference architectures, implementations, and code, each traced to the decisions and
  requirements behind it.`
- Codex `defaultPrompt` and Antigravity `suggestedPrompts`: `Set up Highway in this repository`,
  `Record a new business request`, `Show me the Highway skills I can run`.
- Antigravity `displayName`: `Highway`.
- Keywords (shared, in `plugin.json`): `governance`, `architecture`, `adr`, `traceability`,
  `platform-engineering`, `agent-skills`.

## R12. Listing file checks

- Decision: the generator validates `framework/plugin/listing.json` before writing anything:
  - its top-level keys are exactly the agents that take listing fields (`codex`, `cursor`,
    `antigravity`);
  - no entry holds a shared field (name, version, description, author, homepage, repository,
    license, keywords) or a field the generator derives (`developerName`, `websiteURL`);
  - each entry holds only the fields R3 to R5 allow for that agent.
  A failure prints `ERROR: listing.json: <agent>.<field>: <problem>` and exits 1 with nothing
  written. `--check` runs the same check and reports the error in place of drift.

## R13. Validator scope

- Decision: `framework/validate-plugin.sh` adds `[AGENT]` findings for each agent manifest (exists,
  valid JSON with no repeated key, only the keys its format allows, the shared fields equal to the
  root, the format's fixed values, the Codex derived fields, the skills path leading to the
  plugin's skills folder, each logo path leading to a shipped image) and `[LAYOUT]` findings for
  the closed list: top-level entries, one `plugin.json` per agent folder, and no file in `assets/`
  that no manifest names.

## Constraints carried

No commit; secrets redacted; `rollout-plan.md` stays gitignored and excluded from the
distribution; MINOR version bumps only; no backward compatibility; `mv`, not `git mv`; templates
fixed; no skill change.
