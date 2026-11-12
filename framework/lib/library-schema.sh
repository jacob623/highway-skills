#!/usr/bin/env bash
# Minimal frontmatter checks for a complete template a skill bundles in its assets/.
# Every finding is tagged [SCHEMA], mirroring lib/schema-validate.sh's convention for skills.
# Requires frontmatter.sh to be sourced first.
#
# A template's required frontmatter is smaller than a skill's: name, description,
# metadata.version only. A template is not a skill, so the Agent Skills fields such as license
# do not apply to it.

# Usage: ls_validate_name <name>
ls_validate_name() {
	local name="$1"
	if [[ -z "$name" ]]; then
		echo "ERROR: [SCHEMA] missing required field 'name'"
		return 1
	fi
	return 0
}

# Usage: ls_validate_description <description>
# A template's description is held to 500 characters, half a skill's 1,024: it describes one
# record shape, not when to activate a skill.
ls_validate_description() {
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

# metadata.version is validated by rule check P7.2 in lib/rule-checks.sh, exactly as for a
# skill, so the version rule is reported by its rule id and its logic lives in exactly one
# place (see lib/schema-validate.sh's identical comment for skills).
