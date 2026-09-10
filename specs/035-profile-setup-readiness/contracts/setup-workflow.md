# Feature 035 Setup Workflow Contract

## Numbered Steps

1. Locate the project root.
2. Read Profile readiness from `/highway-profile`.
3. Invoke Profile setup when the Profile owner reports incomplete readiness.
4. Read Business Objective readiness.
5. Invoke Objective setup when Objectives are incomplete.
6. Read Control readiness.
7. Invoke Control setup when Controls are incomplete.
8. Read NFR candidate and accepted-artifact state.
9. Invoke the Control-owned NFR proposal path when candidates exist without accepted artifacts.
10. Emit the readiness dashboard or terminal blocking state.

## Integrity Rules

- Declared step numbers are exactly 1 through 10.
- Each step number appears once.
- Every reference matching `Step N` resolves to one declared step.
- A structural verification failure reports the offending number or reference and stops validation.
- Setup consumes Profile readiness from the Profile owner; it does not define `organization.name` validity.

## Zero-Candidate Branch

After Step 8, when candidate generation succeeds with zero candidates and no accepted NFR artifacts exist, Setup emits `NFRs: Not Applicable` and proceeds to Step 10 without invoking NFR authoring.
