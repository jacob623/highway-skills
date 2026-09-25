#!/usr/bin/env bash
# Canonical owner readiness responses used by contract tests.
set -u
readiness_response() {
	case "$1" in
		profile-absent) printf '%s\n' 'Status: Missing' 'Summary: No accepted Profile exists.' 'Next Action: /highway-profile setup' 'Blocking Reason: None' ;;
		profile-incomplete) printf '%s\n' 'Status: Missing' 'Summary: Profile collection is incomplete.' 'Next Action: /highway-profile configure' 'Blocking Reason: None' ;;
		profile-complete) printf '%s\n' 'Status: Complete' 'Summary: Profile is ready.' 'Next Action: None' 'Blocking Reason: None' ;;
		profile-blocked) printf '%s\n' 'Status: Blocked' 'Summary: Profile structure is invalid.' 'Next Action: None' 'Blocking Reason: malformed retained Profile' ;;
		nfr-progress) printf '%s\n' 'Status: In Progress' 'Summary: NFR candidates remain.' 'Next Action: /highway-nfrs review' 'Blocking Reason: None' ;;
		*) return 1 ;;
	esac
}
