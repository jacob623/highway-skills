# Data Model: highway-nfrs Shared Output Contract Final Cleanup

## NFR Record Template

The authoritative structural contract for one user-owned NFR record.

| Field | Description | Validation |
|---|---|---|
| Artifact identity | NFR record identity and `NFR` identifier family | Matches `nfr-record.md` |
| Frontmatter | Identifier, title, status, and relationship list representation | Template conformance; values remain user-owned |
| Body | User-provided statement and rationale placement | Template conformance, not duplicated skill prose |
| Control relationship list | Identifier-only `CTL` relationship values; direct creation starts empty | Relationship ownership remains in the Control-derived workflow |

## NFR Catalog Template

The authoritative structural contract for the user-owned NFR catalog.

| Field | Description | Validation |
|---|---|---|
| Catalog identity | Non-Functional Requirements catalog identity | Matches `nfr-catalog.md` |
| Version | Baseline version representation | Template conformance; version increments remain workflow behavior |
| Next identifier | Recorded next `NFR` identifier allocation value | Read from the catalog; never inferred from files |
| NFR index | Stable identifier/title/status rows and ordering | Template conformance; allocation and regeneration remain workflow behavior |

## Behavioral Skill Contract

`highway-nfrs` remains responsible for:

- action selection and classification of NFR-shaped versus Control-shaped input;
- routing Control-shaped statements to `/highway-controls` and outcome-shaped Control input to
  `/highway-nfrs`;
- identifier allocation from the recorded catalog `next_id`, permanent identifiers, and no reuse;
- version increments for Add, Update, Remove, and Set;
- destructive-action impact analysis and explicit confirmation;
- relationship boundaries, including empty direct-creation `controls` and Control-derived ownership;
- deterministic catalog regeneration without a timestamp and unchanged-baseline identity;
- validated transaction behavior with no partial writes on failure;
- malformed, ambiguous, unavailable, declined, and validation-failure no-write behavior.

## Generated Adapter

A derived representation of the canonical `highway-nfrs` skill distributed to:

- `.github/skills/highway-nfrs/SKILL.md`;
- `.claude/skills/highway-nfrs/SKILL.md`;
- `.cursor/rules/highway-nfrs.mdc`.

Adapters are regenerated from `.highway/skills/highway-nfrs/SKILL.md` and validated for
correspondence; they are not independent authorities.

## Contract Validation Fixture

A temporary valid or invalid skill or document copy used to prove one contract rule.

- **Valid fixture**: contains both complete template citations and all retained behavior signals.
- **Invalid fixture**: changes one targeted citation, structural declaration, or behavior signal.
- **Isolation rule**: fixture execution leaves canonical skills, shared templates, generated
  adapters, protected Request paths, and user-owned NFR records/catalogs byte-for-byte unchanged.

## Ownership Relationships

```text
NFR record template ---------------------> highway-nfrs behavior -----> NFR adapters
NFR catalog template ---------------------^            |
                                                   focused tests
```

## Lifecycle

1. Inspect the canonical skill and the two shared NFR templates.
2. Remove duplicated structural prose and add complete template citations/conformance wording.
3. Run independent disposable structural, behavioral, correspondence, and no-write probes.
4. Regenerate the three NFR adapters from the canonical skill.
5. Validate templates, skill, adapters, packaging, focused tests, and the complete suite.
