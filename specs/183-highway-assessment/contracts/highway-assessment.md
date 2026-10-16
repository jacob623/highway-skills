# Highway Assessment Contract

## Invocation

```text
/highway-assessment
/highway-assessment architectures
/highway-assessment implementations
/highway-assessment portfolio
```

No domain means `portfolio`.

## Interaction

1. Load the retained findings record.
2. Present every `Open` finding first as:

   ```text
   * **F###:** Single-sentence finding summary.
   ```

3. Offer the requester a correction-oriented Contribution Opportunity:

   ```text
   What would you add, correct, or remove?
   ```

4. On request, analyze accepted repository context for the selected domain.
5. Present only grounded findings as advisory Working Ideas.
6. Allow `Accept`, `Dismiss`, `Resolve`, `Supersede`, or `Request More Information`.
7. Persist only validated new findings or accepted status/disposition changes.

## Ownership

`highway-assessment` owns observation, correlation, finding identity, finding review, and findings
persistence. Profile, Objectives, Controls, NFRs, ADRs, Architectures, and Implementations remain
owned by their existing workflows. Assessment never creates or mutates those artifacts.

## Advisory Boundary

Findings are not organizational fact. Acceptance records that the requester considers the observation
meaningful; it does not automatically create architecture, implementation, dependency, capability,
 inventory, or an owner artifact.

## Conflict Behavior

Every mutation supplies the findings record revision it read. A revision mismatch returns a conflict,
performs no write, and requires the requester to reload and retry. Last-write-wins behavior is not
permitted.
