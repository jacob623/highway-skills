#!/usr/bin/env bash
# Checks free-form frontmatter prose (description, usage, metadata.agent_exceptions[].deviation)
# against the closed word list at library/knowledge/frontmatter-lexicon.txt. A word is accepted
# if it is in the lexicon OR it resolves as an identifier: a rule id (a single uppercase letter
# followed by digits, a dot, and digits -- e.g. P6.4, X1.4 -- that exists in the Highway Skills
# Constitution or the Experience Standard) or a skill id (a directory name that exists under
# skills/). The development constitution is never consulted here, so this file never references
# a development-only path (per D1.1).
#
# shellcheck source=tools/lib/constitution.sh

: "${FRONTMATTER_LEXICON_FILE:=}"

# Resolves the lexicon path, preferring an explicit override. Anchored at the framework root.
# Usage: fl_file <highway_root>
fl_file() {
	local highway_root="$1"
	if [[ -n "$FRONTMATTER_LEXICON_FILE" ]]; then
		printf '%s' "$FRONTMATTER_LEXICON_FILE"
	else
		printf '%s' "$highway_root/library/knowledge/frontmatter-lexicon.txt"
	fi
}

# Validates the lexicon shape: sorted, one lowercase alphanumeric/hyphen word per line, no
# duplicate lines. Prints one "ERROR: [SCHEMA] ..." line per problem and returns 1 if malformed.
# Usage: fl_validate_lexicon <highway_root>
fl_validate_lexicon() {
	local highway_root="$1" file ok=0
	file="$(fl_file "$highway_root")"
	if [[ ! -f "$file" ]]; then
		echo "ERROR: [SCHEMA] frontmatter lexicon not found at '$file'"
		return 1
	fi
	if ! sort -c "$file" 2>/dev/null; then
		echo "ERROR: [SCHEMA] frontmatter lexicon is not sorted"
		ok=1
	fi
	local dup
	dup="$(sort "$file" | uniq -d)"
	if [[ -n "$dup" ]]; then
		echo "ERROR: [SCHEMA] frontmatter lexicon contains duplicate word(s): $(printf '%s' "$dup" | tr '\n' ' ')"
		ok=1
	fi
	local bad
	bad="$(grep -Ev '^[a-z0-9-]+$' "$file")"
	if [[ -n "$bad" ]]; then
		echo "ERROR: [SCHEMA] frontmatter lexicon contains malformed line(s): $(printf '%s' "$bad" | tr '\n' ' ')"
		ok=1
	fi
	return $ok
}

# Returns 0 if word is present in the lexicon, 1 otherwise. word must already be lowercase.
# Usage: fl_word_in_lexicon <highway_root> <word>
fl_word_in_lexicon() {
	local highway_root="$1" word="$2" file
	file="$(fl_file "$highway_root")"
	[[ -f "$file" ]] || return 1
	grep -Fxq "$word" "$file"
}

# Returns 0 if token is a rule id (e.g. P6.4, X1.4) that exists in the Highway Skills
# Constitution or the Experience Standard. The development constitution is deliberately never
# consulted here: this file ships to users (per D1.1, a shipped artifact must not reference a
# development-only path), and a skill has no legitimate reason to cite a development-process rule.
# Usage: fl_resolve_rule_id <highway_root> <token>
fl_resolve_rule_id() {
	local highway_root="$1" token="$2" file
	[[ "$token" =~ ^[A-Z][0-9]+\.[0-9]+$ ]] || return 1
	for file in "$(con_file "$highway_root")" "$(con_experience_file "$highway_root")"; do
		[[ -f "$file" ]] || continue
		grep -Eq "^\\| *${token} *\\|" "$file" && return 0
	done
	return 1
}

# Returns 0 if token is a skill id (kebab-case) that exists as a skill directory.
# Usage: fl_resolve_skill_id <highway_root> <token>
fl_resolve_skill_id() {
	local highway_root="$1" token="$2"
	[[ "$token" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || return 1
	[[ -d "$highway_root/skills/$token" ]]
}

# Checks one free-form field value. Prints one "ERROR: [SCHEMA] ..." line per unrecognized word
# and returns 1 if any word is unrecognized, or returns 0 silently if every word is accepted.
# Usage: fl_check_field <highway_root> <field_label> <value>
fl_check_field() {
	local highway_root="$1" field_label="$2" value="$3" ok=0 raw clean lower noapos words part
	local -a raw_tokens

	[[ -z "$value" ]] && return 0

	IFS=' ' read -ra raw_tokens <<< "$value"
	local raw_count=${#raw_tokens[@]}
	local i
	for ((i = 0; i < raw_count; i++)); do
		raw="${raw_tokens[$i]}"
		clean="$(printf '%s' "$raw" | sed -E 's/^[^A-Za-z0-9]+//; s/[^A-Za-z0-9]+$//')"
		[[ -z "$clean" ]] && continue

		if fl_resolve_rule_id "$highway_root" "$clean"; then
			continue
		fi
		if fl_resolve_skill_id "$highway_root" "$clean"; then
			continue
		fi

		lower="$(printf '%s' "$clean" | tr '[:upper:]' '[:lower:]')"
		noapos="$(printf '%s' "$lower" | sed -E "s/['’]//g")"
		words="$(printf '%s' "$noapos" | sed -E 's/[^a-z0-9-]+/ /g' | tr '-' ' ')"
		local -a parts
		read -ra parts <<< "$words"
		local part_count=${#parts[@]}
		local j
		for ((j = 0; j < part_count; j++)); do
			part="${parts[$j]}"
			[[ -z "$part" ]] && continue
			if ! fl_word_in_lexicon "$highway_root" "$part"; then
				echo "ERROR: [SCHEMA] field '${field_label}' contains unrecognized word '${part}'"
				ok=1
			fi
		done
	done
	return $ok
}
