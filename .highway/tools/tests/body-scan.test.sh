#!/usr/bin/env bash
# Tests the body scanner's annotations, especially that fenced-block state is running state
# rather than a per-line judgement.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
# shellcheck source=tools/lib/body-scan.sh
source "$HIGHWAY_ROOT/tools/lib/body-scan.sh"

fail=0
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

cat >"$tmp_dir/SKILL.md" <<'EOF'
---
name: Scanner Fixture
description: "x"
---

## Purpose
One sentence.

## When to use
- first scenario
- second scenario

1. step one
2. step two

```text
## NotAHeading
This line MUST be ignored.
```

## Error Handling
- If the input is missing, abort.
EOF

scan="$(bs_scan "$tmp_dir/SKILL.md")"

# --- Frontmatter is not scanned ------------------------------------------------------------

if printf '%s\n' "$scan" | cut -f7 | grep -q '^name: Scanner Fixture$'; then
	echo "FAIL: frontmatter lines were emitted by the scanner"
	fail=1
fi

# --- A heading inside a fence does not become the current section ---------------------------

if printf '%s\n' "$scan" | awk -F'\t' '$2 == "NotAHeading"' | grep -q .; then
	echo "FAIL: a heading inside a fenced block was treated as a section"
	fail=1
fi

fenced_section="$(printf '%s\n' "$scan" | awk -F'\t' '$7 ~ /^## NotAHeading/ { print $2 }')"
if [[ "$fenced_section" != "When to use" ]]; then
	echo "FAIL: expected fenced heading to remain in section 'When to use', got '$fenced_section'"
	fail=1
fi

# --- Fence state is tracked across lines ----------------------------------------------------

fenced_count="$(printf '%s\n' "$scan" | awk -F'\t' '$3 == 1' | wc -l | tr -d ' ')"
if [[ "$fenced_count" -ne 4 ]]; then
	echo "FAIL: expected 4 lines marked inside the fence, got $fenced_count"
	fail=1
fi

# --- A keyword inside a fence is not a normative rule ---------------------------------------

if bs_normative_lines "$tmp_dir/SKILL.md" | grep -q 'MUST be ignored'; then
	echo "FAIL: a keyword inside a fenced block was counted as a normative rule"
	fail=1
fi

# --- List and ordered-list detection --------------------------------------------------------

list_count="$(printf '%s\n' "$scan" | awk -F'\t' '$4 == 1' | wc -l | tr -d ' ')"
if [[ "$list_count" -ne 5 ]]; then
	echo "FAIL: expected 5 list items, got $list_count"
	fail=1
fi

ordered_nums="$(printf '%s\n' "$scan" | awk -F'\t' '$5 == 1 { printf "%s", $6 }')"
if [[ "$ordered_nums" != "12" ]]; then
	echo "FAIL: expected ordered items numbered 1 then 2, got '$ordered_nums'"
	fail=1
fi

# --- Section extraction ----------------------------------------------------------------------

purpose="$(bs_section "$tmp_dir/SKILL.md" "Purpose" | cut -f7 | grep -v '^$')"
if [[ "$purpose" != "One sentence." ]]; then
	echo "FAIL: expected Purpose section body 'One sentence.', got '$purpose'"
	fail=1
fi

if bs_section "$tmp_dir/SKILL.md" "Purpose" | grep -q '^## '; then
	echo "FAIL: bs_section emitted the section heading line"
	fail=1
fi

# --- Line numbers are real file line numbers, usable as evidence -------------------------------

purpose_line="$(printf '%s\n' "$scan" | awk -F'\t' '$7 == "## Purpose" { print $1 }')"
expected_line="$(grep -n '^## Purpose$' "$tmp_dir/SKILL.md" | cut -d: -f1)"
if [[ "$purpose_line" != "$expected_line" ]]; then
	echo "FAIL: scanner reported line $purpose_line for '## Purpose', file has it at $expected_line"
	fail=1
fi

exit $fail
