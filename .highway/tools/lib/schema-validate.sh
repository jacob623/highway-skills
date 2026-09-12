#!/usr/bin/env bash
# Encodes the Skill validation rules from data-model.md / skill-frontmatter.schema.json.
# Each sv_validate_* function prints one "ERROR: ..." line per violation to stdout and returns
# 1 if invalid, or returns 0 silently if valid. Functions never exit the calling shell.
#
# The permitted key set, required/optional status, and constraint tokens (length bounds, the
# compatibility enum, the valid-agents list) are NOT declared here -- they are read at call time
# from lib/frontmatter-contract.sh's accessors over .frontmatter-contract, so the manifest is the
# single declared source (feature 045, FR-002). Callers must source frontmatter-contract.sh
# before calling any sv_validate_* function below that takes a highway_root argument.

readonly SV_ID_REGEX='^[a-z0-9]+(-[a-z0-9]+)*$'
readonly SV_VERSION_REGEX='^[0-9]+\.[0-9]+\.[0-9]+$'
# Eight required sections. SV_SECTION_RULE_TAGS is parallel: the constitution rule that owns
# each section's presence, or SCHEMA where no single rule governs it.
readonly SV_REQUIRED_SECTIONS=("Purpose" "When to use" "When not to use" "Inputs" "Outputs" "Verification" "Error Handling" "Example")
readonly SV_SECTION_RULE_TAGS=("P7.1" "SCHEMA" "SCHEMA" "SCHEMA" "SCHEMA" "P8.3" "SCHEMA" "SCHEMA")

# Parses a "length:MIN-MAX" constraint token into SV_MIN/SV_MAX. Leaves both empty if the token
# does not have that shape (e.g. "-", missing, or malformed -- fc_validate_manifest is what
# reports a malformed manifest; this helper degrades to "no bound" rather than erroring twice).
_sv_parse_length_constraint() {
	local constraint="$1" rest
	SV_MIN=""
	SV_MAX=""
	case "$constraint" in
		length:*-*)
			rest="${constraint#length:}"
			SV_MIN="${rest%-*}"
			SV_MAX="${rest#*-}"
			;;
	esac
}

# Parses an "enum:v1,v2,..." constraint token into a space-delimited list on stdout. Prints
# nothing if the token does not have that shape.
_sv_parse_enum_constraint() {
	local constraint="$1"
	case "$constraint" in
		enum:*)
			printf '%s' "${constraint#enum:}" | tr ',' ' '
			;;
	esac
}

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

# Usage: sv_validate_description <description_value> <highway_root>
sv_validate_description() {
	local desc="$1" highway_root="$2" ok=0 min max
	_sv_parse_length_constraint "$(fc_constraint "$highway_root" top description)"
	min="$SV_MIN" max="$SV_MAX"
	if [[ -z "$desc" ]]; then
		echo "ERROR: [SCHEMA] missing required field 'description'"
		ok=1
	elif [[ -n "$min" ]] && (( ${#desc} < min )); then
		echo "ERROR: [SCHEMA] field 'description' is shorter than the minimum ${min} characters (got ${#desc})"
		ok=1
	elif [[ -n "$max" ]] && (( ${#desc} > max )); then
		echo "ERROR: [SCHEMA] field 'description' exceeds ${max} characters (got ${#desc})"
		ok=1
	fi
	return $ok
}

# Usage: sv_validate_usage <usage_value> <highway_root>
sv_validate_usage() {
	local usage="$1" highway_root="$2" ok=0 min max
	_sv_parse_length_constraint "$(fc_constraint "$highway_root" top usage)"
	min="$SV_MIN" max="$SV_MAX"
	if [[ -z "$usage" ]]; then
		echo "ERROR: [SCHEMA] missing required field 'usage'"
		ok=1
	elif [[ -n "$min" ]] && (( ${#usage} < min )); then
		echo "ERROR: [SCHEMA] field 'usage' is shorter than the minimum ${min} characters (got ${#usage})"
		ok=1
	elif [[ -n "$max" ]] && (( ${#usage} > max )); then
		echo "ERROR: [SCHEMA] field 'usage' exceeds ${max} characters (got ${#usage})"
		ok=1
	fi
	return $ok
}

# metadata.version is validated by rule check P7.2 in lib/rule-checks.sh, so that the version
# rule is reported by its rule id and its logic lives in exactly one place.

# Generic safety net over every OTHER required key the manifest declares: name, description,
# usage (scope "top") and version (scope "metadata") each already have a bespoke presence check
# above or in rule-checks.sh's P7.2, so they are skipped here to avoid reporting one absence
# twice. Any required key added to the manifest with no bespoke check of its own is still
# enforced by this loop -- this is what makes adding a required key to the manifest alone (no
# script change) break a previously-conforming skill (FR-016).
# Usage: sv_validate_required_keys <file> <highway_root>
sv_validate_required_keys() {
	local file="$1" highway_root="$2" ok=0 key value

	while IFS= read -r key; do
		[[ -z "$key" ]] && continue
		case "$key" in
			name|description|usage) continue ;;
		esac
		value="$(fm_get "$file" "$key" || true)"
		if [[ -z "$value" ]]; then
			echo "ERROR: [SCHEMA] missing required field '$key'"
			ok=1
		fi
	done <<< "$(fc_required_keys "$highway_root" top)"

	while IFS= read -r key; do
		[[ -z "$key" ]] && continue
		case "$key" in
			version) continue ;;
		esac
		value="$(fm_get_nested "$file" metadata "$key" || true)"
		if [[ -z "$value" ]]; then
			echo "ERROR: [SCHEMA] missing required field 'metadata.$key'"
			ok=1
		fi
	done <<< "$(fc_required_keys "$highway_root" metadata)"

	return $ok
}

# Every top-level key present in the frontmatter must be declared in the manifest, or be
# "metadata" -- the implicit container for the metadata scope, not itself a declared "top" row.
# Every metadata-scope key present must likewise be declared. An undeclared key is reported by
# name (FR-005).
# Usage: sv_validate_closed_key_set <file> <highway_root>
sv_validate_closed_key_set() {
	local file="$1" highway_root="$2" ok=0 key declared_top declared_metadata
	declared_top="$(fc_declared_keys "$highway_root" top)"
	declared_metadata="$(fc_declared_keys "$highway_root" metadata)"

	while IFS= read -r key; do
		[[ -z "$key" ]] && continue
		[[ "$key" == "metadata" ]] && continue
		if ! printf '%s\n' "$declared_top" | grep -qx "$key"; then
			echo "ERROR: [SCHEMA] undeclared top-level key '$key'"
			ok=1
		fi
	done <<< "$(fm_list_keys "$file" | sort -u)"

	while IFS= read -r key; do
		[[ -z "$key" ]] && continue
		if ! printf '%s\n' "$declared_metadata" | grep -qx "$key"; then
			echo "ERROR: [SCHEMA] undeclared metadata key 'metadata.$key'"
			ok=1
		fi
	done <<< "$(fm_list_metadata_keys "$file" | sort -u)"

	return $ok
}

# A key repeated at the same scope is reported by name, as an independent pass over the raw
# (non-deduplicated) key list -- fm_get()'s existing first-match resolution is left unchanged
# (research.md Decision 4; FR-006).
# Usage: sv_validate_duplicate_keys <file>
sv_validate_duplicate_keys() {
	local file="$1" ok=0 dup key
	dup="$(fm_list_keys "$file" | sort | uniq -d)"
	if [[ -n "$dup" ]]; then
		while IFS= read -r key; do
			[[ -z "$key" ]] && continue
			echo "ERROR: [SCHEMA] duplicate top-level key '$key'"
			ok=1
		done <<< "$dup"
	fi
	dup="$(fm_list_metadata_keys "$file" | sort | uniq -d)"
	if [[ -n "$dup" ]]; then
		while IFS= read -r key; do
			[[ -z "$key" ]] && continue
			echo "ERROR: [SCHEMA] duplicate metadata key 'metadata.$key'"
			ok=1
		done <<< "$dup"
	fi
	return $ok
}

# Usage: sv_validate_compatibility <compatibility_value> <highway_root>
sv_validate_compatibility() {
	local compat="$1" highway_root="$2" ok=0 valid_compatibility
	if [[ -n "$compat" ]]; then
		valid_compatibility="$(_sv_parse_enum_constraint "$(fc_constraint "$highway_root" top compatibility)")"
		if [[ ! " $valid_compatibility " == *" $compat "* ]]; then
			echo "ERROR: [SCHEMA] field 'compatibility' (\"$compat\") must be one of: $valid_compatibility"
			ok=1
		fi
	fi
	return $ok
}

# The valid-agents list is the compatibility enum minus the literal "all" token: agent_exceptions
# names one specific agent, and "all" is not a specific agent. This keeps a single declared list
# (the compatibility row) rather than a second manifest row that would only ever repeat it.
# Usage: printf '%s\n' "$agent_exceptions_lines" | sv_validate_agent_exceptions <highway_root>
sv_validate_agent_exceptions() {
	local highway_root="$1" ok=0 agent deviation valid_agents
	valid_agents="$(_sv_parse_enum_constraint "$(fc_constraint "$highway_root" top compatibility)" | tr ' ' '\n' | grep -v '^all$' | tr '\n' ' ')"
	valid_agents="${valid_agents% }"
	while IFS='|' read -r agent deviation; do
		[[ -z "$agent" && -z "$deviation" ]] && continue
		if [[ ! " $valid_agents " == *" $agent "* ]]; then
			echo "ERROR: [SCHEMA] field 'metadata.agent_exceptions[].agent' (\"$agent\") must be one of: $valid_agents"
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
