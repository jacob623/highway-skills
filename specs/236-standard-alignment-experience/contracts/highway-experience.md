# Contract: highway-experience and the activation step

## The skill

- `skills/highway-experience/SKILL.md` passes `framework/validate-skill.sh`.
- The description says the skill holds Highway's identity and output standard and is loaded by the
  other Highway skills, so an agent does not activate it for an unrelated request.
- `## Procedure` says when to read each reference:
  - `references/experience-standard.md` before any output the person sees;
  - `references/storage-contract.md` before the first repository read or write;
  - `references/highway-identity.md` when the work explains what Highway is or why it exists.
- `## Procedure` states the always-on instructions' two own rules:
  - when a Highway skill applies, defer the workflow, artifacts, inputs, outputs, and decisions to
    that skill;
  - do not treat Highway identity or experience guidance as organizational facts.
- Invoked directly, it gives a short summary of what Highway is, starts no workflow, and writes no file.
- It does not activate itself.
- Its folder holds `SKILL.md` and exactly three files under `references/`.

## The activation step

Every other Highway skill's first non-blank line under `## Procedure` is exactly:

```text
Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.
```

No Highway skill names `.highway/governance/` or `.highway/library/knowledge/highway-identity.md`.

## The check

`tests/experience-activation.test.sh` fails when:

- highway-experience's folder holds any file besides `SKILL.md` and the three references, or lacks
  one of them;
- its `SKILL.md` lacks either moved rule, or its description does not name the other Highway skills;
- a skill other than highway-experience lacks the exact sentence as its first Procedure line;
- any skill names one of the old paths;
- any of these exists, or the distribution manifest has a row for it:
  - `.highway/instructions/`
  - `.highway/governance/`
  - `framework/generate-instructions.sh`
  - `framework/.instruction-manifest`
  - `AGENTS.md`
  - `.cursor/rules/highway-agent-context.mdc`
  - `.claude/CLAUDE.md`
  - `.github/copilot-instructions.md`

Seeded probe: `--probe source-document` copies a skill into a temporary skills folder with its first
Procedure line changed, and requires the check to report it; `--neutralise` copies it unchanged and
requires a clean pass.
