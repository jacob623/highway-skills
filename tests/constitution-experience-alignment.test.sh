#!/usr/bin/env bash
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
CONSTITUTION="$(hw_doc constitution)"
fail=0

require_text() {
	local token="$1"
	if ! grep -Fq "$token" "$CONSTITUTION"; then
		echo "FAIL: Constitution missing $token"
		fail=1
	fi
}

require_text '| **Development Validator** | A maintainer, compliance check, or development tool that evaluates a shipped artifact against this constitution. |'
require_text '| **Runtime Contract** | A skill-owned or shared contract that defines runtime inputs, outputs, state, ownership, persistence, failure behavior, or interaction delegation. |'
require_text 'This constitution is development-time governance for the design and validity of shipped Highway'
require_text 'An executing skill MUST NOT need to load or'
require_text 'consult this document, and this document does not govern runtime interaction'
require_text 'Experience Standard and each owning skill govern their respective'
require_text 'runtime contracts.'
require_text '| P13.2 | A skill MUST assign acceptance and persistence to the owning workflow. | The runtime contract names the owner and its mutation boundary. | [agent-checkable] |'
require_text 'development-time validation of shipped skills and shared runtime contracts'
require_text 'The applicable workflow defines proposal acceptance and persistence'
require_text 'Development validation verifies that required failure behavior exists in the effective'
require_text 'A correctness-critical contract choice between two or more actions'
require_text 'P1.1-P1.4, P6.4, P6.6, and P7.3'
require_text 'P10.1 remains the generic Experience delegation rule'

if [[ "$(grep -cE '^\| P[0-9]+[A-Z]?\.[0-9]+ ' "$CONSTITUTION")" -ne 80 ]]; then
	echo 'FAIL: Constitution rule inventory must contain 80 rules'
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'OK: Constitution and Experience Standard alignment contract passes'
