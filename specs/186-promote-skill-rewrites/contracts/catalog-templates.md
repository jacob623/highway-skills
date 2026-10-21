# Contract: Catalog templates

Draft content replaces the template content. Template filenames stay.

| Draft | Template |
|---|---|
| `objectives-catalog.md` | `.highway/library/templates/output/objective-catalog.md` |
| `controls-catalog.md` | `.highway/library/templates/output/control-catalog.md` |
| `nfrs-catalog.md` | `.highway/library/templates/output/nfr-catalog.md` |
| `request-catalog.md` | `.highway/library/templates/output/request-catalog.md` |
| `discovery-catalog.md` | `.highway/library/templates/output/discovery-catalog.md` |
| `adr-catalog.md` | `.highway/library/templates/output/adr-catalog.md` |
| `architecture-catalog.md` | `.highway/library/templates/output/architecture-catalog.md` |
| `implementation-catalog.md` | `.highway/library/templates/output/implementation-catalog.md` |
| `assessment-findings.md` | `.highway/library/templates/output/assessment-findings.md` |

The capability template `.highway/library/templates/output/capability-catalog.md` follows `implementation.md`: columns ID, Parent, Title, and Realized By; no `Next ID`; capability ids are `CAP` plus eight hexadecimal digits.

Record templates change only when a promoted skill's written record no longer matches them.

Objectives, Controls, and Non-Functional Requirements statuses are `active` or `removed`. Request, Discovery, Decision, Reference Architecture, and Reference Implementation statuses are `accepted` or `removed`. A removed row keeps its identifier.
