# Quickstart: Shared Output Templates

This guide validates Feature 022 after implementation. It does not prescribe implementation details.

## Prerequisites

- Run from the repository root.
- Bash 3.2.57-compatible shell.
- Feature 022 implementation complete.
- Generated catalog and agent adapters regenerated from the updated skills.

## 1. Validate the new template files

```sh
.highway/tools/validate-library.sh .highway/library/templates/output/nfr-record.md
.highway/tools/validate-library.sh .highway/library/templates/output/control-record.md
```

Expected result: both templates are accepted, and neither is treated as the existing questionnaire template.

## 2. Validate the affected skills

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-nfrs
.highway/tools/validate-skill.sh .highway/skills/highway-controls
```

Expected result: both skills pass the authoring constitution, including the shared-template citation rule.

## 3. Verify generated correspondence

```sh
.highway/tools/generate-library-catalog.sh
.highway/tools/tests/adapter-coverage.test.sh
```

Expected result: catalog, adapters, adapter manifest, and distribution manifest agree with the updated source skills.

## 4. Verify frontmatter and output contract

Review each output template and the corresponding skill declaration:

- `highway-nfrs` cites `nfr-record.md` and retains its existing NFR fields and body sections.
- `highway-controls` cites `control-record.md` and retains its existing Control fields and body sections.
- Each retained output begins with frontmatter.
- User-owned values remain unconstrained by Highway's semantic governance.
- Transient messages are not treated as file artifacts.

Expected result: the complete emitted structure matches the template for each file type.

## 5. Verify dependent-review behavior

Change a shared output template in a controlled test fixture, identify every skill citing it, and run the planned dependent-review check.

Expected result: every citing skill is re-validated; a mismatch in frontmatter or body is reported; no unrelated skill or user-owned record is validated against Highway's content rules.

The development rule is `D8.1`: the review is agent-checkable because semantic correspondence
between a changed template and emitted output cannot be decided honestly by a static proxy.

## 6. Run the full suite

```sh
.highway/tools/tests/run-all.sh
```

Expected result: all tests pass with zero failures, including the new P/X/D governance coverage.
