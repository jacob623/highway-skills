# Data Model: Controls Skill Update

## Control record

The retained user-owned artifact remains `library/governance/controls/CTLXXXXXX.md`.

| Section | Required | Meaning |
|---|---:|---|
| YAML frontmatter | Yes | Existing identity and operational metadata: `id`, `title`, `status`, and identifier-only `nfrs`. |
| Control statement | Yes | The accepted safeguard expressed as the retained Control statement. |
| Rationale | Yes | The accepted evidence-grounded explanation for the safeguard. |
| `## Provenance` body section | No | Grounding references for a recommendation-created Control. Never stored in frontmatter. |

The optional provenance section is omitted for a user-authored Control when no recommendation
grounding applies. It does not become a new classification, override, Concern, Condition, or
Obligation field.

## Control baseline

The user-owned `library/governance/controls.md` catalog remains authoritative for:

- semantic baseline version;
- next permanent `CTLXXXXXX` identifier;
- deterministic Control index;
- uniqueness and ordering.

Readiness is derived only from the persisted baseline:

- `Missing`: no valid Control exists;
- `Complete`: at least one valid Control exists and the baseline is consistent;
- `Blocked`: the record, catalog, or allocation state is malformed or inconsistent.

Readiness does not represent active setup/configure collection completion.

## Transient interaction state

The following state is evaluated during one interaction and is not retained or restored:

- Concern, Condition, and Obligation evidence;
- Control-versus-NFR classification;
- recommendation candidates and selection state;
- staged title, statement, and rationale;
- continuation state;
- collection routing.

Recommendation provenance is the exception only after an accepted recommendation becomes a retained
Control; the retained projection is the optional body section described above.

## Ownership relationships

- Controls owns Control records, the Control catalog, identifier allocation, readiness, duplicate and
  overlap detection, and the originating NFR candidate-generation invocation.
- Setup owns orchestration and consumes only Controls collection status and fresh readiness; it does
  not inspect transient identifiers or NFR internals.
- NFRs owns candidate-generation state, classification, review, accepted NFR artifacts, NFR
  identifiers, NFR readiness, and NFR completion.
