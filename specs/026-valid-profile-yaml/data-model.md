# Data Model: Valid Profile YAML

## Canonical Profile

- **Path**: `.highway/library/templates/output/profile.yaml`
- **Format**: Pure YAML without frontmatter or document delimiters.
- **Top-level sections**: `metadata`, `organization`, `constraints`, `strategic_directions`,
  `preferences`, `business_context`, `architecture_principles`, `approved_technologies`,
  `prohibited_technologies`, `operating_model`, and `vendor_strategy`.
- **Ordering**: The 11 sections remain in the order established by Feature 025.
- **Defaults**: `metadata.version` remains `1.0.0`; `metadata.description` remains the existing
  folded description; organization fields remain empty strings; non-metadata sections remain empty
  mappings.

## YAML Validity Check

- **Input**: The canonical profile file.
- **Pass state**: A standard YAML parser reads the entire file without a syntax error.
- **Fail state**: The parser returns a syntax error or the profile cannot be read.
- **Mutation**: None. The check is read-only and must not rewrite the profile.