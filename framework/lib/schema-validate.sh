#!/usr/bin/env bash
# Encodes the Skill validation rules: the Agent Skills specification's frontmatter rules plus
# Highway's narrower ones (data-model.md). Each sv_validate_* function prints one "ERROR: ..." line
# per violation to stdout and returns 1 if invalid, or returns 0 silently if valid. Functions never
# exit the calling shell.
#
# The permitted key set, required/optional status, and constraint tokens (length bounds) are NOT
# declared here -- they are read at call time from lib/frontmatter-contract.sh's accessors over
# .frontmatter-contract, so the manifest is the single declared source. Callers must source
# frontmatter-contract.sh before calling any sv_validate_* function below that takes a root
# argument. Functions that take <parsed> read the output of yf_parse (lib/yaml-frontmatter.sh).

readonly SV_ID_REGEX='^[a-z0-9]+(-[a-z0-9]+)*$'
readonly SV_VERSION_REGEX='^[0-9]+\.[0-9]+\.[0-9]+$'
readonly SV_NAME_MAX=64
# Eight required sections. SV_SECTION_RULE_TAGS is parallel: the constitution rule that owns
# each section's presence, or SCHEMA where no single rule governs it.
readonly SV_REQUIRED_SECTIONS=("Purpose" "When to use" "When not to use" "Inputs" "Outputs" "Verification" "Error Handling" "Example")
readonly SV_SECTION_RULE_TAGS=("P7.1" "SCHEMA" "SCHEMA" "SCHEMA" "SCHEMA" "P8.3" "SCHEMA" "SCHEMA")
# Fields the specification types as strings. Every metadata value is a string too.
readonly SV_STRING_FIELDS=("name" "description" "license" "compatibility" "allowed-tools")
# Fields both the strict parser and the line readers in lib/frontmatter.sh read, as scope:key.
readonly SV_AGREEMENT_FIELDS=("top:name" "top:description" "top:license" "top:compatibility" "metadata:version" "metadata:usage")

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

sv_validate_id() {
	local id="$1"
	if [[ ! "$id" =~ $SV_ID_REGEX ]]; then
		echo "ERROR: [SCHEMA] invalid id '$id' -- directory name must match ${SV_ID_REGEX} (kebab-case)"
		return 1
	fi
	return 0
}

# Frontmatter `name` MUST equal the directory-derived id exactly, byte-for-byte, and fit the
# specification's 64-character limit.
sv_validate_name() {
	local name="$1" id="$2" ok=0
	if (( ${#name} > SV_NAME_MAX )); then
		echo "ERROR: [SCHEMA] field 'name' exceeds ${SV_NAME_MAX} characters (got ${#name})"
		ok=1
	fi
	if [[ "$name" != "$id" ]]; then
		echo "ERROR: [SCHEMA] frontmatter 'name' ('$name') does not match directory-derived id '$id'"
		ok=1
	fi
	return $ok
}

# Every key present must be declared in the manifest. "metadata" is the implicit container for
# the metadata scope, not itself a declared "top" row.
# Usage: sv_validate_closed_key_set <parsed> <root>
sv_validate_closed_key_set() {
	local parsed="$1" root="$2" ok=0 key declared_top declared_metadata
	declared_top="$(fc_declared_keys "$root" top)"
	declared_metadata="$(fc_declared_keys "$root" metadata)"

	while IFS= read -r key; do
		[[ -z "$key" || "$key" == "metadata" ]] && continue
		if ! printf '%s\n' "$declared_top" | grep -qxF -- "$key"; then
			echo "ERROR: [SCHEMA] undeclared top-level key '$key'"
			ok=1
		fi
	done <<< "$(yf_keys "$parsed" top)"

	while IFS= read -r key; do
		[[ -z "$key" ]] && continue
		if ! printf '%s\n' "$declared_metadata" | grep -qxF -- "$key"; then
			echo "ERROR: [SCHEMA] undeclared metadata key 'metadata.$key'"
			ok=1
		fi
	done <<< "$(yf_keys "$parsed" metadata)"

	return $ok
}

# A string field that YAML reads as another type (a number, a date, a list) is rejected: a
# client's strict parser would either refuse it or hand the skill a non-string.
# Usage: sv_validate_string_types <parsed>
sv_validate_string_types() {
	local parsed="$1" ok=0 field type metadata_type key
	for field in "${SV_STRING_FIELDS[@]}"; do
		type="$(yf_type "$parsed" top "$field")"
		if [[ -n "$type" && "$type" != "str" ]]; then
			echo "ERROR: [SCHEMA] field '$field' must be a string (YAML reads it as $type)"
			ok=1
		fi
	done
	metadata_type="$(yf_type "$parsed" top metadata)"
	if [[ -n "$metadata_type" && "$metadata_type" != "map" ]]; then
		echo "ERROR: [SCHEMA] field 'metadata' must be a mapping"
		return 1
	fi
	while IFS= read -r key; do
		[[ -z "$key" ]] && continue
		type="$(yf_type "$parsed" metadata "$key")"
		if [[ "$type" != "str" ]]; then
			echo "ERROR: [SCHEMA] field 'metadata.$key' must be a string (YAML reads it as $type)"
			ok=1
		fi
	done <<< "$(yf_keys "$parsed" metadata)"
	return $ok
}

# Presence and length for every manifest row. name and metadata.version have bespoke checks
# (sv_validate_name and rule P7.2), so their absence is reported there, once.
# Usage: sv_validate_fields <parsed> <root>
sv_validate_fields() {
	local parsed="$1" root="$2" ok=0 scope key required constraint label value type
	while IFS=$'\t' read -r scope key required constraint; do
		[[ -z "$key" ]] && continue
		[[ "$scope:$key" == "top:name" || "$scope:$key" == "metadata:version" ]] && continue
		label="$key"
		[[ "$scope" == "metadata" ]] && label="metadata.$key"
		type="$(yf_type "$parsed" "$scope" "$key")"
		value="$(yf_value "$parsed" "$scope" "$key")"
		if [[ -z "$type" || ( -z "$value" && "$required" == "yes" ) ]]; then
			if [[ "$required" == "yes" ]]; then
				echo "ERROR: [SCHEMA] missing required field '$label'"
				ok=1
			fi
			continue
		fi
		_sv_parse_length_constraint "$constraint"
		if [[ -n "$SV_MIN" ]] && (( ${#value} < SV_MIN )); then
			echo "ERROR: [SCHEMA] field '$label' is shorter than the minimum ${SV_MIN} characters (got ${#value})"
			ok=1
		elif [[ -n "$SV_MAX" ]] && (( ${#value} > SV_MAX )); then
			echo "ERROR: [SCHEMA] field '$label' exceeds ${SV_MAX} characters (got ${#value})"
			ok=1
		fi
	done <<< "$(fc_rows "$root")"
	return $ok
}

# The line readers in lib/frontmatter.sh serve every other reader of a skill (the generators, the
# rule checks), so a value they read differently from a strict parser is a defect: a client would
# see one value and Highway another.
# Usage: sv_validate_agreement <parsed> <file>
sv_validate_agreement() {
	local parsed="$1" file="$2" ok=0 pair scope key label strict line
	for pair in "${SV_AGREEMENT_FIELDS[@]}"; do
		scope="${pair%%:*}"
		key="${pair#*:}"
		[[ "$(yf_type "$parsed" "$scope" "$key")" == "str" ]] || continue
		strict="$(yf_value "$parsed" "$scope" "$key")"
		if [[ "$scope" == "top" ]]; then
			label="$key"
			line="$(fm_get "$file" "$key" || true)"
		else
			label="metadata.$key"
			line="$(fm_get_nested "$file" metadata "$key" || true)"
		fi
		if [[ "$strict" != "$line" ]]; then
			echo "ERROR: [SCHEMA] field '$label' reads differently in a strict YAML parser"
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
		content="$(printf '%s\n' "$body" | awk -v section="$section" '
			BEGIN { found = 0; capturing = 0 }
			{
				if ($0 == "## " section || ($0 == "# Purpose" && section == "Purpose")) { found = 1; capturing = 1; next }
				if (capturing && $0 ~ /^# /) { capturing = 0 }
				if (capturing) print
			}
			END { if (!found) exit 2 }
		')"
		local awk_status=$?
		if [[ $awk_status -eq 2 ]]; then
			echo "ERROR: [${tag}] missing required body section '## ${section}' (or '# Purpose' for Purpose)"
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
