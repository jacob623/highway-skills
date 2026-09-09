---
name: output-template-invalid
description: "Fixture for a file-emitting skill that repeats its output structure inline."
usage: "Use this fixture only in output-template tests."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose
Expose an inline output contract.

## When to use
- Use when testing a missing shared template citation.
- Use when testing duplicate structure prose.

## When not to use
Never use this fixture for a real repository change.

## Inputs
A test request.

## Outputs
A retained file with frontmatter fields `id`, `title`, `status`, and `controls: []`, followed by a statement and rationale.

## Verification
Run the focused output-template test.

## Error Handling
- If the citation is missing, abort and report the fixture failure.

## Example
A retained file begins with frontmatter.
