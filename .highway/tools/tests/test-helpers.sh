#!/usr/bin/env bash
# Shared deterministic assertions for governance behavior fixtures.

assert_file_unchanged() {
	local label="$1" before="$2" after="$3"
	if [[ "$before" != "$after" ]]; then
		echo "FAIL: $label changed bytes"
		return 1
	fi
}

assert_deterministic() {
	local label="$1" first="$2" second="$3"
	assert_file_unchanged "$label" "$first" "$second"
}

assert_status() {
	local label="$1" expected="$2" actual="$3"
	if [[ "$expected" != "$actual" ]]; then
		echo "FAIL: $label (expected '$expected', got '$actual')"
		return 1
	fi
}

assert_no_artifact() {
	local label="$1" path="$2"
	if [[ -e "$path" ]]; then
		echo "FAIL: $label created '$path'"
		return 1
	fi
}

assert_review_empty() {
	local label="$1" status="$2" entry_count="$3"
	if [[ "$status" != "Status: Empty" || "$entry_count" != "Entry Count: 0" ]]; then
		echo "FAIL: $label must emit Status: Empty and Entry Count: 0"
		return 1
	fi
}

assert_review_decisions() {
	local label="$1" actual="$2" expected="$3"
	if [[ "$actual" != "$expected" ]]; then
		echo "FAIL: $label decision set (expected '$expected', got '$actual')"
		return 1
	fi
}

assert_readiness_response() {
	local label="$1" response="$2"
	local status_value summary_value next_action_value blocking_reason_value
	local line_count

	line_count="$(printf '%s\n' "$response" | wc -l | tr -d ' ')"
	if [[ "$line_count" != "4" ]]; then
		echo "FAIL: $label must contain exactly four lines"
		return 1
	fi

	status_value="$(printf '%s\n' "$response" | sed -n '1p')"
	summary_value="$(printf '%s\n' "$response" | sed -n '2p')"
	next_action_value="$(printf '%s\n' "$response" | sed -n '3p')"
	blocking_reason_value="$(printf '%s\n' "$response" | sed -n '4p')"

	assert_status "$label field order" "Status:" "${status_value%% *}"
	assert_status "$label summary field" "Summary:" "${summary_value%% *}"
	assert_status "$label next action field" "Next Action" "${next_action_value%%:*}"
	assert_status "$label blocking reason field" "Blocking Reason" "${blocking_reason_value%%:*}"

	case "$status_value" in
		"Status: Complete"|"Status: Missing"|"Status: In Progress"|"Status: Blocked"|"Status: Not Applicable") ;;
		*) echo "FAIL: $label has an invalid status '$status'"; return 1 ;;
	esac

	if [[ "$summary_value" == "Summary:" || "$next_action_value" == "Next Action:" || "$blocking_reason_value" == "Blocking Reason:" ]]; then
		echo "FAIL: $label has an empty response field"
		return 1
	fi

	if [[ "$status_value" == "Status: Blocked" && "$blocking_reason_value" == "Blocking Reason: None" ]]; then
		echo "FAIL: $label blocked response has no blocking reason"
		return 1
	fi
	if [[ "$status_value" != "Status: Blocked" && "$blocking_reason_value" != "Blocking Reason: None" ]]; then
		echo "FAIL: $label non-blocked response has a blocking reason"
		return 1
	fi
}
