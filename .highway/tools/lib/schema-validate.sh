#!/usr/bin/env bash
# Encodes the Skill validation rules from data-model.md / skill-frontmatter.schema.json.
# Each sv_validate_* function prints one "ERROR: ..." line per violation to stdout and returns
# 1 if invalid, or returns 0 silently if valid. Functions never exit the calling shell.

readonly SV_ID_REGEX='^[a-z0-9]+(-[a-z0-9]+)*$'
readonly SV_VERSION_REGEX='^[0-9]+\.[0-9]+\.[0-9]+$'
readonly SV_VALID_AGENTS='github-copilot claude-code cursor'
readonly SV_VALID_COMPATIBILITY='all github-copilot claude-code cursor'
# Eight required sections. SV_SECTION_RULE_TAGS is parallel: the constitution rule that owns
# each section's presence, or SCHEMA where no single rule governs it.
readonly SV_REQUIRED_SECTIONS=("Purpose" "When to use" "When not to use" "Inputs" "Outputs" "Verification" "Error Handling" "Example")
readonly SV_SECTION_RULE_TAGS=("P7.1" "SCHEMA" "SCHEMA" "SCHEMA" "SCHEMA" "P8.3" "SCHEMA" "SCHEMA")

sv_validate_id() {
	local id="$1"
	if [[ ! "$id" =~ $SV_ID_REGEX ]]; then
		echo "ERROR: [SCHEMA] invalid id '$id' -- directory name must match ${SV_ID_REGEX} (kebab-case)"
		return 1
	fi
	return 0
}

# Frontmatter `name` MUST equal the directory-derived id exactly, byte-for-byte
# (per feature 009 (skill id namespace alignment)).
sv_validate_name() {
	local name="$1" id="$2"
	if [[ "$name" != "$id" ]]; then
		echo "ERROR: [SCHEMA] frontmatter 'name' ('$name') does not match directory-derived id '$id'"
		return 1
	fi
	return 0
}

sv_validate_description() {
	local desc="$1" ok=0
	if [[ -z "$desc" ]]; then
		echo "ERROR: [SCHEMA] missing required field 'description'"
		ok=1
	elif (( ${#desc} > 500 )); then
		echo "ERROR: [SCHEMA] field 'description' exceeds 500 characters (got ${#desc})"
		ok=1
	fi
	return $ok
}

sv_validate_usage() {
	local usage="$1" ok=0
	if [[ -z "$usage" ]]; then
		echo "ERROR: [SCHEMA] missing required field 'usage'"
		ok=1
	elif (( ${#usage} > 500 )); then
		echo "ERROR: [SCHEMA] field 'usage' exceeds 500 characters (got ${#usage})"
		ok=1
	fi
	return $ok
}

# metadata.version is validated by rule check P7.2 in lib/rule-checks.sh, so that the version
# rule is reported by its rule id and its logic lives in exactly one place.

sv_validate_compatibility() {
	local compat="$1" ok=0
	if [[ -n "$compat" ]]; then
		if [[ ! " $SV_VALID_COMPATIBILITY " == *" $compat "* ]]; then
			echo "ERROR: [SCHEMA] field 'compatibility' (\"$compat\") must be one of: $SV_VALID_COMPATIBILITY"
			ok=1
		fi
	fi
	return $ok
}

# Usage: printf '%s\n' "$agent_exceptions_lines" | sv_validate_agent_exceptions
sv_validate_agent_exceptions() {
	local ok=0 line agent deviation
	while IFS='|' read -r agent deviation; do
		[[ -z "$agent" && -z "$deviation" ]] && continue
		if [[ ! " $SV_VALID_AGENTS " == *" $agent "* ]]; then
			echo "ERROR: [SCHEMA] field 'metadata.agent_exceptions[].agent' (\"$agent\") must be one of: $SV_VALID_AGENTS"
			ok=1
		fi
		if [[ -z "$deviation" ]]; then
			echo "ERROR: [SCHEMA] field 'metadata.agent_exceptions[].deviation' must be non-empty for agent '$agent'"
			ok=1
		fi
	done
	return $ok
}

# Usage: sv_validate_body_sections <file>
sv_validate_body_sections() {
	local file="$1" ok=0 section idx tag
	local body
	body="$(fm_body "$file")"
	idx=0
	for section in "${SV_REQUIRED_SECTIONS[@]}"; do
		tag="${SV_SECTION_RULE_TAGS[$idx]}"
		idx=$((idx + 1))
		local content
		content="$(printf '%s\n' "$body" | awk -v section="## ${section}" '
			BEGIN { found = 0; capturing = 0 }
			{
				if ($0 == section) { found = 1; capturing = 1; next }
				if (capturing && $0 ~ /^## /) { capturing = 0 }
				if (capturing) print
			}
			END { if (!found) exit 2 }
		')"
		local awk_status=$?
		if [[ $awk_status -eq 2 ]]; then
			echo "ERROR: [${tag}] missing required body section '## ${section}'"
			ok=1
			continue
		fi
		# non-empty after trimming whitespace-only lines
		if [[ -z "$(printf '%s' "$content" | tr -d '[:space:]')" ]]; then
			echo "ERROR: [${tag}] body section '## ${section}' is present but empty"
			ok=1
		fi
	done
	return $ok
}
