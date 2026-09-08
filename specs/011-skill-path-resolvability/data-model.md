# Data Model: Skill Path Resolvability Rule

Phase 1 output. This feature moves no data at runtime; the entities below are rules, checks, and
documents.

## Entity: The new rule

| Property | Value |
|---|---|
| Identifier | `P8.7` |
| Principle | VIII. Reliability and Repeatability |
| Keyword | Exactly one, MUST NOT |
| Subject | A skill |
| Tier | `[auto]` |
| Not-applicable condition | None; applies to every skill unconditionally |

**Obligation**: a skill does not carry a link whose target is a relative filesystem path.

**Observable**: no Markdown link target in the skill body is a relative filesystem path.

**Phrasing constraint**: names no location that exists only during development. A recipient has
never seen those locations, and a rule they cannot interpret is not a rule they can follow.

## Entity: Reference classification

What the check does and does not treat as a reference. Established in research.md R4.

| Text in a skill body | Classified as | In scope |
|---|---|---|
| `[label](../governance/constitution.md)` | Cross-reference, relative | **Violation** |
| `[label](./sibling.md)` | Cross-reference, relative | **Violation** |
| `[label](https://example.org/spec)` | Cross-reference, absolute URL | Permitted |
| `` `.highway/tools/validate-skill.sh <dir>` `` | Command example | Out of scope |
| `.highway/catalog/index.json` in prose | Prose mention | Out of scope |

A command example is instruction text and is correct as written. Resolving it would be a category
error, and a check that did so would force correct content to be mangled.

## Entity: Why a relative target cannot resolve

The fact that reduces the rule to a prohibition. A `SKILL.md` exists in four places.

| Location | Shape | `../governance/constitution.md` resolves to | Exists |
|---|---|---|---|
| `.highway/skills/<id>/SKILL.md` | Source directory | `.highway/governance/constitution.md` | Yes |
| `.github/skills/<id>/SKILL.md` | Copied directory | `.github/governance/constitution.md` | No |
| `.claude/skills/<id>/SKILL.md` | Copied directory | `.claude/governance/constitution.md` | No |
| `.cursor/rules/<id>.mdc` | Flat file, no directory | `.cursor/governance/constitution.md` | No |

The generator copies `SKILL.md` alone and never a sibling file, so a target inside the skill's own
directory fails in three locations too.

## Entity: The check

| Property | Value |
|---|---|
| Function | `rc_check_P8_7` |
| Location | `.highway/tools/lib/rule-checks.sh` |
| Registered in | `rc_registry`, gaining a thirteenth row |
| Dispatched by | `validate-skill.sh`, unchanged |
| Reported as | `P8.7`, in the existing coverage groups |
| Filesystem access | None; the rule is a property of the text |
| Utilities used | `grep`, `sed`, `awk` — all on the Declared Toolchain |

Registry row shape, matching the twelve rows already present:

```text
P8.7    rc_check_P8_7   -
```

The third column is the not-applicable condition. `-` means the rule always applies: a skill with
no links satisfies it rather than being exempt from it.

**Failure output**: names the skill, the offending target, and its location, so the author can act
without re-deriving what failed.

## Entity: Documents amended

| Document | Change | Ships |
|---|---|---|
| `.highway/governance/constitution.md` | `P8.7` added; version incremented; change report records the addition; three follow-up entries removed | Yes |
| `.highway/skills/_authoring-standard.md` | Cites `P8.7` by identifier; restates no rule text | Yes |
| `README.md` | Governance section naming and linking both documents | No — not in the distributed path set |

The front page is live documentation but not a distributed artifact, so it is subject to the rules
on documentation currency and resolvable cross-references, and not to the rule on development-path
references.

## Entity: Follow-up entries removed

Each removal records the evidence that the work is complete. None required implementation.

| Entry | Evidence it is already satisfied |
|---|---|
| `PURPOSE_SECTION_ENFORCEMENT` | The required-sections list in `schema-validate.sh` includes `Purpose` |
| `BUMP_TYPE_REVIEW` | `highway-help` exists and declares a `## Purpose` section, so the reclassification condition never triggered |
| `AUTHORING_STANDARD_REALIGNMENT` | The standard cites 28 distinct rule identifiers, restates no rule text, and has no section by the name the entry uses; `authoring-standard.test.sh` enforces the first two and passes |

| Entry | Disposition |
|---|---|
| `AUTO_TIER_ENFORCEMENT` | Remains. Genuinely outstanding, owned by a later phase. |

## Entity: New fixture

| Property | Value |
|---|---|
| Name | `invalid-skill-relative-link` |
| Location | `.highway/tools/tests/fixtures/` |
| Shape | Conformant in every respect except one relative link target |
| Expected verdict | Exactly one failure, reported as `P8.7` |

Required because no existing artifact exercises the failure path — every fixture and the one real
skill contain no links at all. A check never observed to fail proves nothing.

## Version impact

| Artifact | Change | Increment |
|---|---|---|
| `.highway/governance/constitution.md` | One rule added; no rule removed or redefined; no conforming artifact invalidated | MINOR |
| Any `SKILL.md` | None | None |
| Catalog, adapters, manifest | None; no skill content changes | None regenerated |

The increment is verified against the constitution's own versioning policy during implementation,
not assumed. Reasoning in research.md R5.
