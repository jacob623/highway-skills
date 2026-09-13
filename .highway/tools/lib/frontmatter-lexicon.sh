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

# --- Caches -------------------------------------------------------------------------------------
# Membership is answered from a newline-delimited blob held in memory rather than by running a
# matcher per word. The word list is small (under 2 KB) and every caller checks tens of words
# against it, so one read beats one process per word by roughly two orders of magnitude.
#
# The caches are process-scoped. Each cache records the input it was built from and rebuilds when
# that input changes, so a caller that repoints FRONTMATTER_LEXICON_FILE mid-process is served
# fresh data rather than a stale answer.

FL_PATH=""          # scratch output of fl__path; not part of the public interface
FL_LEX_PATH=""      # lexicon path the blob was built from, empty when unloaded
FL_LEX_BLOB=""      # lexicon words, newline-delimited and newline-bracketed
FL_RULE_ROOT=""     # framework root the rule blob was built from
FL_RULE_LOADED=0    # separate from the blob: an empty rule set is a legitimate loaded state
FL_RULE_BLOB=""     # rule ids, newline-delimited and newline-bracketed
FL_LC=""            # scratch output of fl__lc; returned via a global to avoid a subshell

# Resolves the lexicon path into FL_PATH without forking. Internal.
# Usage: fl__path <highway_root>
fl__path() {
	if [[ -n "$FRONTMATTER_LEXICON_FILE" ]]; then
		FL_PATH="$FRONTMATTER_LEXICON_FILE"
	else
		FL_PATH="$1/library/knowledge/frontmatter-lexicon.txt"
	fi
}

# Resolves the lexicon path, preferring an explicit override. Anchored at the framework root.
# Usage: fl_file <highway_root>
fl_file() {
	fl__path "$1"
	printf '%s' "$FL_PATH"
}

# Loads the lexicon into FL_LEX_BLOB, bracketed by newlines so that a whole-word match is an
# ordinary substring test. Returns 1 if the lexicon is missing. Internal.
# Usage: fl__lex_load <highway_root>
fl__lex_load() {
	fl__path "$1"
	[[ -n "$FL_LEX_PATH" && "$FL_PATH" == "$FL_LEX_PATH" ]] && return 0
	if [[ ! -f "$FL_PATH" ]]; then
		FL_LEX_PATH=""
		FL_LEX_BLOB=""
		return 1
	fi
	FL_LEX_BLOB=$'\n'"$(<"$FL_PATH")"$'\n'
	FL_LEX_PATH="$FL_PATH"
	return 0
}

# Loads every rule id declared in the shipped constitution and experience standard into
# FL_RULE_BLOB. Loaded lazily: most fields contain no rule-id-shaped token at all, and paying for
# this read unconditionally costs about a third of the per-invocation budget for nothing.
# Internal.
# Usage: fl__rule_load <highway_root>
fl__rule_load() {
	local highway_root="$1" con exp
	[[ $FL_RULE_LOADED -eq 1 && "$highway_root" == "$FL_RULE_ROOT" ]] && return 0
	con="$(con_file "$highway_root")"
	exp="$(con_experience_file "$highway_root")"
	FL_RULE_BLOB=$'\n'"$(cat "$con" "$exp" 2>/dev/null | sed -n 's/^| *\([A-Z][0-9]*\.[0-9]*\) *|.*/\1/p')"$'\n'
	FL_RULE_ROOT="$highway_root"
	FL_RULE_LOADED=1
	return 0
}

# Lowercases a string into FL_LC using index arithmetic, because Bash's case-conversion parameter
# expansion was introduced in Bash 4 and the target shell is Bash 3.2. Strings with no uppercase
# letter -- the common case -- skip the loop entirely. Internal.
# Usage: fl__lc <string>
FL_LC_UPPER="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
FL_LC_LOWER="abcdefghijklmnopqrstuvwxyz"
fl__lc() {
	local s="$1" out="" ch prefix idx
	if [[ "$s" != *[A-Z]* ]]; then
		FL_LC="$s"
		return 0
	fi
	while [[ -n "$s" ]]; do
		ch="${s:0:1}"
		s="${s:1}"
		if [[ "$ch" == [A-Z] ]]; then
			prefix="${FL_LC_UPPER%%"$ch"*}"
			idx=${#prefix}
			ch="${FL_LC_LOWER:idx:1}"
		fi
		out="$out$ch"
	done
	FL_LC="$out"
	return 0
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
	fl__lex_load "$1" || return 1
	# "$2" must stay quoted. Unquoted, a value of '*' is expanded as a pattern and matches any
	# word, so every unrecognized word would be silently accepted.
	[[ "$FL_LEX_BLOB" == *$'\n'"$2"$'\n'* ]]
}

# Returns 0 if token is a rule id (e.g. P6.4, X1.4) that exists in the Highway Skills
# Constitution or the Experience Standard. The development constitution is deliberately never
# consulted here: this file ships to users (per D1.1, a shipped artifact must not reference a
# development-only path), and a skill has no legitimate reason to cite a development-process rule.
# Usage: fl_resolve_rule_id <highway_root> <token>
fl_resolve_rule_id() {
	local highway_root="$1" token="$2"
	[[ "$token" =~ ^[A-Z][0-9]+\.[0-9]+$ ]] || return 1
	fl__rule_load "$highway_root"
	# "$token" must stay quoted, for the same reason as in fl_word_in_lexicon.
	[[ "$FL_RULE_BLOB" == *$'\n'"$token"$'\n'* ]]
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
		# Leading and trailing punctuation is stripped by expansion rather than by sed, so a
		# field of thirty words costs no processes at all.
		clean="$raw"
		while [[ -n "$clean" && "$clean" == [^A-Za-z0-9]* ]]; do clean="${clean#?}"; done
		while [[ -n "$clean" && "$clean" == *[^A-Za-z0-9] ]]; do clean="${clean%?}"; done
		[[ -z "$clean" ]] && continue

		if fl_resolve_rule_id "$highway_root" "$clean"; then
			continue
		fi
		if fl_resolve_skill_id "$highway_root" "$clean"; then
			continue
		fi

		fl__lc "$clean"
		lower="$FL_LC"
		noapos="${lower//\'/}"
		noapos="${noapos//’/}"
		words="${noapos//[^a-z0-9-]/ }"
		words="${words//-/ }"
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
