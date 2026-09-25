#!/usr/bin/env bash
# Validates the structural contract of the Markdown Profile.
set -u
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/profile.sh"
if [[ $# -ne 1 ]]; then
	echo "ERROR: [SCHEMA] usage: .highway/tools/validate-profile.sh <profile-file>" >&2
	exit 1
fi
profile_file="$1"
if [[ ! -f "$profile_file" ]]; then
	echo "ERROR: [SCHEMA] no profile found at '$profile_file'" >&2
	exit 1
fi
errors=""
collect() { errors="${errors}${1}"$'\n'; }
if [[ "$(sed -n '1p' "$profile_file")" != '---' ]]; then collect 'ERROR: [FRONTMATTER] Markdown Profile must begin with frontmatter'; fi
fence_count="$(grep -c '^---[[:space:]]*$' "$profile_file" || true)"
if [[ "$fence_count" -ne 2 ]]; then collect 'ERROR: [FRONTMATTER] Markdown Profile must contain exactly two frontmatter delimiters'; fi
if [[ "$(profile_metadata_field "$profile_file" schema_version)" != '2.0.0' ]]; then collect 'ERROR: [METADATA] schema_version must be 2.0.0'; fi
if ! grep -Fxq '# Organizational Profile' "$profile_file"; then collect 'ERROR: [STRUCTURE] # Organizational Profile is required'; fi
domain_count=0
previous_line=0
for domain in $(profile_domain_keys); do
	state="$(profile_domain_state "$profile_file" "$domain")"
	domain_count=$((domain_count + 1))
	if ! profile_valid_state "$state"; then collect "ERROR: [DOMAIN] $domain has invalid or missing outcome '$state'"; fi
	heading="$(profile_domain_heading "$domain")"
	line_number="$(grep -n -F "$heading" "$profile_file" | head -1 | cut -d: -f1)"
	if [[ -n "$line_number" && "$line_number" -le "$previous_line" ]]; then
		collect "ERROR: [STRUCTURE] $domain narrative is out of canonical order"
	fi
	[[ -n "$line_number" ]] && previous_line="$line_number"
	has_heading=0
	grep -Fqx "$heading" "$profile_file" && has_heading=1
	case "$state:$has_heading" in
		not_discussed:1) collect "ERROR: [STATE] $domain not_discussed must not have a narrative section" ;;
		discussed:0) collect "ERROR: [STATE] $domain discussed requires a narrative section" ;;
		bounded:1)
			if ! profile_domain_has_evidence "$profile_file" "$heading"; then
				collect "ERROR: [STATE] $domain bounded narrative requires accepted evidence";
			fi
			;;
	esac
done
if [[ "$domain_count" -ne 5 ]]; then collect 'ERROR: [DOMAIN] exactly five domain outcomes are required'; fi
if [[ -n "$errors" ]]; then printf '%s' "$errors" >&2; echo "FAILED: profile '$profile_file' is structurally invalid" >&2; exit 1; fi
echo "OK: profile '$profile_file' is structurally valid"
