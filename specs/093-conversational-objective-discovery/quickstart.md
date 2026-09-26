# Quickstart: Conversational Objective Discovery

## Prerequisites

- macOS or GNU/Linux development environment.
- Repository root containing `.highway/` and `.specify/`.
- Bash 3.2-compatible shell and the existing Highway tools.
- Feature 093 source skill and test changes applied before behavior validation.

## Validate source skills and shared templates

```sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-objectives
bash .highway/tools/validate-skill.sh .highway/skills/highway-setup
bash .highway/tools/validate-library.sh .highway/library/templates/output/objective-record.md
bash .highway/tools/validate-library.sh .highway/library/templates/output/objective-catalog.md
```

Expected result: both skills and both shared templates pass; `highway-objectives` cites both
Objective templates and no skill duplicates their complete retained structure.

## Run focused contract and behavior checks

```sh
bash .highway/tools/tests/objective-management.test.sh
bash .highway/tools/tests/objective-rename-contract.test.sh
bash .highway/tools/tests/highway-setup.test.sh
bash .highway/tools/tests/highway-setup-executable.test.sh
```

Expected results include:

- Setup emits the Objective-purpose introduction only for non-terminal Objective readiness and
  forwards the exact Objectives-owned opening.
- Direct and Setup-mediated Objective entry points support adaptive discovery, rich evidence,
  suggestion adoption, corrections, overlap revalidation, and one unresolved decision at a time.
- Declined, abandoned, malformed, interrupted, or persistence-failed creation leaves the verified
  baseline unchanged and does not claim successful creation.
- Confirmed creation allocates one permanent identifier, writes record and catalog together,
  verifies both retained outputs, and reports completion only after verification.
- A later invocation starts from persisted readiness and does not restore transient prompts or
  proposals.

## Regenerate and validate shipped correspondence

```sh
bash .highway/tools/generate-catalog.sh
bash .highway/tools/generate-library-catalog.sh
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/tests/output-template.test.sh
bash .highway/tools/tests/adapter-coverage.test.sh
bash .highway/tools/tests/distribution-packaging.test.sh
```

Expected result: source skills, catalogs, adapters, manifests, distribution metadata, and shared
Objective templates remain synchronized.

## Run the complete suite

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: all repository tests pass, including the focused Feature 093 assertions and the
existing readiness, context, template, packaging, and generated-artifact checks. Test fixtures use
temporary repositories or disposable files and do not mutate the live user-owned `library/` baseline.

Current implementation validation: the focused Objective and executable Setup checks pass. The
complete `run-all.sh` suite completed with `60 passed, 0 failed` using the requested 240-second
allowance.

## Manual interaction checks

1. With terminal-success Profile and Missing Objective readiness, invoke `/highway-setup`; confirm
   the Setup introduction appears once, followed by the exact Objectives opening.
2. Invoke `/highway-objectives add` with a rich Outcome, Success, and Significance response; confirm
   the complete proposal appears without repeating the opening or asking a redundant question.
3. Confirm a proposal naturally, then verify the record and catalog; confirm the identifier is
   absent from normal pre-persistence review and reported only after both outputs verify.
4. Interrupt after a verified first Objective or during a second proposal; invoke Setup again and
   confirm persisted readiness governs without restoring transient collection state.
