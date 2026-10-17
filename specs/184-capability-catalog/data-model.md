# Capability Catalog Data Model

## Reference Implementation

The authoritative accepted implementation record identified by `RI######`.

| Field | Rule |
|---|---|
| Identifier | Exactly one uppercase `RI######` value from the implementation catalog |
| Status | Must be accepted evidence for catalog generation; the implementation workflow retains its existing publication status contract |
| Realized Capabilities | Zero or more explicit business-outcome entries |

## Realized Capability Evidence

A capability realization statement retained inside the owning RI record.

| Field | Rule |
|---|---|
| Title | Required, business-readable outcome; normalized for identity and ordering |
| Realized By | One or more non-empty provider, platform, product, technology, service, process, or mechanism values |
| Evidence | Required source explanation or traceability for why the RI realizes the capability |

A title that names only an implementation component, such as a queue, gateway, database, or event processor, is not a valid business capability. The evidence remains owned by the RI.

## Capability Catalog

The generated repository-wide index at `implementations/capabilities.md`.

| Field | Rule |
|---|---|
| Version | Catalog format version, retained by the catalog template |
| Next ID | Next unused sequential `CAP######`; greater than every allocated identifier |
| ID | Unique catalog-local `CAP######` identifier |
| Parent | Exactly one valid `RI######` owning implementation |
| Title | Business-readable capability title from the RI evidence |
| Realized By | One or more canonical realization values, rendered deterministically |

## Identity and Relationships

- Catalog entry identity is `(Parent RI, normalized Title)`.
- One catalog entry may contain multiple Realized By values.
- The same Title may appear under multiple Parent RIs, with a distinct CAP identifier for each parent.
- A CAP identifier has no record file and no independent lifecycle.
- A catalog row without a valid Parent, Title, or Realized By value is invalid.

## State Transitions

1. Accepted RI evidence is resolved and validated.
2. Existing capability identities are matched to the prior catalog.
3. Existing CAP identifiers are retained; new identities receive sequential IDs.
4. Rows unsupported by current accepted RI evidence are removed during regeneration.
5. RI, implementation catalog, and capability catalog are validated together.
6. All outputs publish atomically, or all pre-operation bytes remain unchanged.
