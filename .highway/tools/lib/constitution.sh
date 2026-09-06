#!/usr/bin/env bash
# Reads the constitution as data. This file holds no rule text, no tier, and no token list of
# its own -- everything is parsed at run time so the tooling cannot drift from the constitution
# (see specs/003-constitution-enforcement/research.md Decision 1 and Decision 5).

# Default location; callers may override by exporting CONSTITUTION_FILE.
: "${CONSTITUTION_FILE:=}"

# Resolves the constitution path, preferring an explicit override.
# Usage: con_file <repo_root>
con_file() {
	local repo_root="$1"
	if [[ -n "$CONSTITUTION_FILE" ]]; then
		printf '%s' "$CONSTITUTION_FILE"
	else
		printf '%s' "$repo_root/.specify/memory/constitution.md"
	fi
}

# Emits one TAB-delimited record per rule: id, tier, text, observable.
# A row that looks like a rule but does not parse is a hard error, so a table format change
# fails loudly instead of silently shrinking the inventory.
# Usage: con_rules <constitution_file>
con_rules() {
	local file="$1"
	awk -F'|' '
		BEGIN { OFS = "\t"; bad = 0 }
		function trim(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); return s }
		/^\|[[:space:]]*P[0-9]+\.[0-9]+[[:space:]]*\|/ {
			id = trim($2); text = trim($3); obs = trim($4); tier = trim($5)
			if (NF < 5 || text == "" || obs == "" || tier !~ /^\[(auto|agent-checkable|human-review)\]$/) {
				printf("ERROR: malformed rule row for %s at line %d\n", id, NR) > "/dev/stderr"
				bad = 1
				next
			}
			gsub(/^\[|\]$/, "", tier)
			print id, tier, text, obs
		}
		END { if (bad) exit 3 }
	' "$file"
}

# Prints one field of one rule. Field is tier, text, or observable.
# Usage: con_rule_field <constitution_file> <rule_id> <field>
con_rule_field() {
	local file="$1" id="$2" field="$3"
	con_rules "$file" | awk -F'\t' -v id="$id" -v f="$field" '
		$1 == id {
			if (f == "tier") print $2
			else if (f == "text") print $3
			else if (f == "observable") print $4
			exit
		}
	'
}

# Prints every rule id whose tier matches, in file order.
# Usage: con_rule_ids_by_tier <constitution_file> <tier>
con_rule_ids_by_tier() {
	local file="$1" tier="$2"
	con_rules "$file" | awk -F'\t' -v t="$tier" '$2 == t { print $1 }'
}

# Prints every rule id, in file order.
# Usage: con_rule_ids <constitution_file>
con_rule_ids() {
	local file="$1"
	con_rules "$file" | cut -f1
}

# Prints the comma-separated tokens of a blockquote list that follows the given heading, one
# token per line. Used for the Prohibited Vagueness List and any later token list that follows
# the same shape.
# Usage: con_token_list <constitution_file> <heading_text>
con_token_list() {
	local file="$1" heading="$2"
	awk -v heading="$heading" '
		BEGIN { found = 0; capturing = 0 }
		{
			if (index($0, heading) > 0 && $0 ~ /^#{2,4} /) { found = 1; next }
			if (!found) next
			if ($0 ~ /^>/) {
				capturing = 1
				line = $0
				sub(/^>[[:space:]]*/, "", line)
				print line
				next
			}
			if (capturing && $0 !~ /^>/ && $0 !~ /^[[:space:]]*$/) { exit }
		}
	' "$file" | tr ',' '\n' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | grep -v '^$'
}

# Prints the section titles the constitution itself excludes from a token list check, one per
# line. Read from the quoted titles in the paragraph introducing the list, so the exclusion is
# owned by the constitution rather than by this tooling.
# Usage: con_token_list_exclusions <constitution_file> <heading_text>
con_token_list_exclusions() {
	local file="$1" heading="$2"
	awk -v heading="$heading" '
		BEGIN { found = 0 }
		{
			if (index($0, heading) > 0 && $0 ~ /^#{2,4} /) { found = 1; next }
			if (!found) next
			if ($0 ~ /^>/) exit
			print
		}
	' "$file" | grep -oE '"[^"]+"' | tr -d '"'
}
