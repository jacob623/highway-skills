# Workflow Variant Contract

The workflow validator accepts a path to a workflow document and returns PASS or FAIL with the invalid step or reference identified.

## Canonical Input

- Ten declared steps numbered 1 through 10.
- Each step number appears once.
- Every `Step N` reference resolves to one declared step.

## Required Negative Variants

1. Remove one declared step.
2. Duplicate a declared step number.
3. Replace one number to create a gap or out-of-order sequence.
4. Change one reference to a missing step.

Each variant is created in a temporary location. The canonical workflow hash must be unchanged after all checks.
