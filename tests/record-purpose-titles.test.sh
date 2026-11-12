#!/usr/bin/env bash
# Architecture titles name the decision's purpose and implementation titles name its product.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "The architecture title is the ADR title" or "The implementation title is the architecture title" fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
SKILLS="$HW_SKILLS"
ARCH="$SKILLS/highway-architecture/SKILL.md"
IMPL="$SKILLS/highway-implementation/SKILL.md"
ARCH_RECORD="$(hw_template architecture-record)"
IMPL_RECORD="$(hw_template implementation-record)"
fail=0

require() {
	local file="$1" text="$2"
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") still contains: $text"
		fail=1
	fi
}

reject "$ARCH" 'The architecture title is the ADR title unless'
for text in \
	'**Title:** [Purpose title.]' \
	'The architecture title is the purpose in the ADR title' \
	'the first " for "' \
	'ask for a purpose title' \
	'for a different ADR: go to'; do
	require "$ARCH" "$text"
done

reject "$IMPL" 'The implementation title is the architecture title unless'
for text in \
	'**Title:** [Product title.]' \
	'The implementation title is the product in the title of the decision this realization came from' \
	'the first " for "' \
	'under a different architecture: the title becomes "[Product] for [purpose]"' \
	'under this architecture: use the existing record'; do
	require "$IMPL" "$text"
done

require "$ARCH_RECORD" '# <purpose title>'
require "$IMPL_RECORD" '# <product title>'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: record purpose and product titles"
