# Quickstart: Experience Profile Presentation Rhythm

## Prerequisites

Run from the repository root on macOS or Linux with the existing shell toolchain available.

## Validation

1. Confirm the plan and design artifacts contain no unresolved template markers:

   `grep -nE '\[FEATURE\]|\[DATE\]|ACTION REQUIRED|NEEDS CLARIFICATION|Option [123]' specs/123-experience-profile-presentation-rhythm/plan.md`

   Expected result: no output.

2. Run focused Experience Standard and Profile contracts:

   `bash .highway/tools/tests/experience-standard-amendment.test.sh`

   `bash .highway/tools/tests/profile-behavior.test.sh`

   `bash .highway/tools/tests/profile-structure.test.sh`

   `bash .highway/tools/tests/profile-lifecycle.test.sh`

   Expected result: each prints `OK` and exits 0 after implementation.

3. Validate the canonical Profile skill:

   `bash .highway/tools/validate-skill.sh .highway/skills/highway-profile`

4. Regenerate derived catalogs and adapters using the repository's declared generators, then run correspondence checks.

5. Run the complete suite:

   `bash .highway/tools/tests/run-all.sh`

   Expected result: summary reports zero failures.

## Review points

Inspect the Experience Standard for X2.36 and version 7.2.0, then inspect the Profile source for all three subject headings, X2.8 acknowledgment intent, transient presentation boundaries, canonical fallback, and absence of workflow-mechanics narration. Confirm generated adapters match the canonical source and that `profile-record.md` is unchanged.
