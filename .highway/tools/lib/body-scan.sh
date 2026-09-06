#!/usr/bin/env bash
# Walks a SKILL.md body once and annotates every line, so that no rule check has to parse
# Markdown for itself. Fence state is running state and cannot be decided from a line in
# isolation (see specs/003-constitution-enforcement/research.md Decision 2).

# Emits one TAB-delimited record per body line:
#   line_no  section  in_fence  is_list  is_ordered  ordered_num  text
# line_no is the real line number in the file, so findings can cite it.
# section is the nearest preceding '## ' heading, empty before the first one.
# in_fence is 1 for lines inside a fenced block, including the fence markers themselves.
# ordered_num is the parsed number of an ordered list item, or 0.
# Usage: bs_scan <file>
bs_scan() {
	local file="$1"
	awk '
		BEGIN {
			OFS = "\t"; delim = 0; in_fence = 0; section = ""
		}
		{
			line = $0

			# Frontmatter: count delimiters, emit nothing until the block closes.
			if (delim < 2 && line ~ /^---[[:space:]]*$/) { delim++; next }
			if (delim < 2) next

			# Fence toggling. The fence line itself is reported as inside the fence.
			if (line ~ /^[[:space:]]*```/) {
				if (in_fence) { print NR, section, 1, 0, 0, 0, line; in_fence = 0 }
				else { in_fence = 1; print NR, section, 1, 0, 0, 0, line }
				next
			}

			if (!in_fence && line ~ /^## /) {
				section = line
				sub(/^##[[:space:]]+/, "", section)
				gsub(/[[:space:]]+$/, "", section)
				print NR, section, 0, 0, 0, 0, line
				next
			}

			is_list = 0; is_ordered = 0; ordered_num = 0
			if (!in_fence) {
				if (line ~ /^[[:space:]]*[-*+][[:space:]]+/) {
					is_list = 1
				} else if (line ~ /^[[:space:]]*[0-9]+\.[[:space:]]+/) {
					is_list = 1; is_ordered = 1
					n = line
					sub(/^[[:space:]]*/, "", n)
					sub(/\..*$/, "", n)
					ordered_num = n + 0
				}
			}
			print NR, section, (in_fence ? 1 : 0), is_list, is_ordered, ordered_num, line
		}
	' "$file"
}

# Emits the annotated records for one named section only (excluding its heading line).
# Usage: bs_section <file> <section_title>
bs_section() {
	local file="$1" want="$2"
	bs_scan "$file" | awk -F'\t' -v want="$want" '$2 == want && $7 !~ /^## / { print }'
}

# Emits the annotated records that are normative rule lines: outside a fenced block and
# carrying at least one keyword. The token MUST-level names a category and is not a keyword
# occurrence, per the constitution's own exclusion.
# Usage: bs_normative_lines <file>
bs_normative_lines() {
	local file="$1"
	bs_scan "$file" | awk -F'\t' '
		$3 == 0 {
			t = $7
			gsub(/MUST-level/, "", t)
			if (t ~ /MUST NOT/ || t ~ /MUST/ || t ~ /SHOULD/) print
		}
	'
}

# Counts keywords on one line of text, after removing the MUST-level exclusion.
# Prints "<must_not> <must> <should>".
# Usage: bs_count_keywords <text>
bs_count_keywords() {
	printf '%s' "$1" | awk '
		{
			t = $0
			gsub(/MUST-level/, "", t)
			mn = gsub(/MUST NOT/, "", t)
			m  = gsub(/MUST/, "", t)
			s  = gsub(/SHOULD/, "", t)
			print mn, m, s
		}
	'
}
