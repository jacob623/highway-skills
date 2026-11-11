---
name: output-template-valid
description: "Fixture for a file-emitting skill that cites a complete shared output template."
usage: "Use this fixture only in output-template tests."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose
Validate a shared output-template citation.

## When to use
- Use when a file-emitting fixture must cite a template.
- Use when validating complete output structure.

## When not to use
Never use this fixture for a real repository change.

## Inputs
A test request.

## Outputs
A retained file at `library/governance/example.md` following `.highway/library/templates/output/nfr-record.md`.

## Verification
Run the focused output-template test.

## Error Handling
- If the citation is missing, abort and report the fixture failure.

## Example
A retained file begins with frontmatter.
