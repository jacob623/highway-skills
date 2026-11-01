# Contract: Platform Catalog

## highway-implementation

### platforms

Runs after `write` succeeds and after `identifier` reuses an existing implementation. Then goes to `close`.

- Read Technology Choice, Runtime Components, and Realized By.
- Include the implementation when those describe a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, or an agent that starts the work.
- A store, a newsletter, a records product, or a backup is not included. Say nothing and go to `close`.
- Write `library/knowledge/codify-platforms.md` from `.highway/library/templates/output/codify-platforms.md`. Create `library/knowledge/` when it is absent.
- One row for this Implementation ID. A second inclusion replaces that row and does not add another.
- Leave every other row unchanged.
- Then say: "[Platform] is included as a platform that can start automation. To remove it, run /highway-codify configure."

Opening, listing, and declining do not enter `platforms`.

## highway-onboarding

After the implementation exists, follow `platforms` in `highway-implementation`. Emit the same two sentences when a platform is included. Do not emit the implementation proposal or its questions. Do not create an inventory. This catalog is not an inventory.

## Unchanged

The implementation record, the architecture, and the decision are not changed by inclusion. Already accepted implementations are not scanned.
