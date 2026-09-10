#!/usr/bin/env bash
# Shared disposable-fixture and evidence helpers for Feature 038.

feature_038_hash_tree() {
	local root="$1"
	if [[ ! -d "$root" ]]; then
		echo "missing fixture root: $root" >&2
		return 1
	fi
	find "$root" -type f -print | LC_ALL=C sort | while IFS= read -r path; do
		shasum -a 256 "$path"
	done | shasum -a 256 | awk '{print $1}'
}

feature_038_assert_unchanged() {
	local label="$1" before="$2" after="$3"
	if [[ "$before" != "$after" ]]; then
		echo "FAIL: $label changed"
		return 1
	fi
}

feature_038_parse_response() {
	local response="$1" expected_status="${2:-}"
	local line_count status_value summary_value next_action_value blocking_reason_value
	line_count="$(printf '%s\n' "$response" | wc -l | tr -d ' ')"
	if [[ "$line_count" != "4" ]]; then
		echo "FAIL: response must contain exactly four lines" >&2
		return 1
	fi
	status_value="$(printf '%s\n' "$response" | sed -n '1p')"
	summary_value="$(printf '%s\n' "$response" | sed -n '2p')"
	next_action_value="$(printf '%s\n' "$response" | sed -n '3p')"
	blocking_reason_value="$(printf '%s\n' "$response" | sed -n '4p')"
	case "$status_value" in
		"Status: Complete"|"Status: Missing"|"Status: In Progress"|"Status: Blocked"|"Status: Not Applicable") ;;
		*) echo "FAIL: invalid response status '$status_value'" >&2; return 1 ;;
	esac
	if [[ -z "${summary_value#Summary: }" || -z "${next_action_value#Next Action: }" || -z "${blocking_reason_value#Blocking Reason: }" ]]; then
		echo "FAIL: response contains an empty field" >&2
		return 1
	fi
	if [[ "$status_value" == "Status: Blocked" && "$blocking_reason_value" == "Blocking Reason: None" ]]; then
		echo "FAIL: blocked response requires a blocking reason" >&2
		return 1
	fi
	if [[ "$status_value" != "Status: Blocked" && "$blocking_reason_value" != "Blocking Reason: None" ]]; then
		echo "FAIL: non-blocked response must use Blocking Reason: None" >&2
		return 1
	fi
	if [[ -n "$expected_status" && "$status_value" != "Status: $expected_status" ]]; then
		echo "FAIL: expected status '$expected_status', got '$status_value'" >&2
		return 1
	fi
}

feature_038_assert_deterministic() {
	local label="$1" first="$2" second="$3" third="$4"
	feature_038_assert_unchanged "$label run 1/2" "$first" "$second" || return 1
	feature_038_assert_unchanged "$label run 2/3" "$second" "$third"
}

feature_038_write_evidence() {
	local report="$1" category="$2" result="$3" detail="$4"
	printf '%s\t%s\t%s\n' "$category" "$result" "$detail" >> "$report"
}

feature_038_source_path() {
	case "$1" in
		profile|objectives|controls|nfrs|setup) printf '%s\n' ".highway/skills/highway-$1/SKILL.md" ;;
		github) printf '%s\n' '.github/skills/' ;;
		claude) printf '%s\n' '.claude/skills/' ;;
		cursor) printf '%s\n' '.cursor/rules/' ;;
		catalog) printf '%s\n' '.highway/catalog/' ;;
		*) echo "unknown Feature 038 source key: $1" >&2; return 1 ;;
	esac
}

feature_038_assert_no_nfr_missing() {
	local file="$1"
	if grep -Eq 'NFR[^[:alnum:]]+`?Missing`?|`Missing`[^[:alnum:]]+NFR' "$file"; then
		echo "FAIL: NFR Missing appears in $file" >&2
		return 1
	fi
}
