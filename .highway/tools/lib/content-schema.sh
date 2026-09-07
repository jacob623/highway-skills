#!/usr/bin/env bash
# Minimal frontmatter checks for a shared content file (template, knowledge, or governance).
# Every finding is tagged [SCHEMA], mirroring lib/schema-validate.sh's convention for skills.
# Requires frontmatter.sh to be sourced first.
#
# A content file's required frontmatter is smaller than a skill's: name, description,
# metadata.version only -- no compatibility, since that field is agent/adapter-specific and
# does not apply to shared content (FR-014).

# Usage: cs_validate_name <name>
cs_validate_name() {
	local name="$1"
	if [[ -z "$name" ]]; then
		echo "ERROR: [SCHEMA] missing required field 'name'"
		return 1
	fi
	return 0
}

# Usage: cs_validate_description <description>
# Reuses the same 500-character threshold sv_validate_description already applies to skills
# (research.md Decision 6): no unstated, undecided number for content files.
cs_validate_description() {
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
