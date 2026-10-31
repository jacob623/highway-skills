#!/usr/bin/env bash
# One architecture can have many implementations. A decision names the architecture and no implementation.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: putting a Reference Implementation line back in the ADR handoff fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
fail=0

require() {
	local file="$1" text="$2"
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$file") omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$file") still contains: $text"
		fail=1
	fi
}

ADR_RECORD="$OUTPUT/adr-record.md"
ADR_CATALOG="$OUTPUT/adr-catalog.md"
ARCH_RECORD="$OUTPUT/architecture-record.md"
ARCH_CATALOG="$OUTPUT/architecture-catalog.md"
IMPL_RECORD="$OUTPUT/implementation-record.md"
IMPL_CATALOG="$OUTPUT/implementation-catalog.md"
ADR="$SKILLS/highway-adr/SKILL.md"
ARCH="$SKILLS/highway-architecture/SKILL.md"
IMPL="$SKILLS/highway-implementation/SKILL.md"
DISCOVERY="$SKILLS/highway-discovery/SKILL.md"
ONBOARDING="$SKILLS/highway-onboarding/SKILL.md"

require "$ADR_RECORD" 'Reference Architecture: <RA id, or `None`>'
require "$ADR_RECORD" 'The handoff contains no implementation entry.'
handoff="$(sed -n '/^## Reference Architecture Handoff$/,/^```$/p' "$ADR_RECORD")"
if printf '%s\n' "$handoff" | grep -Fq -- 'Reference Implementation:'; then
	echo "FAIL: adr-record.md handoff still contains an implementation entry"
	fail=1
fi

require "$ADR_CATALOG" '| Architecture ID |'
require "$ADR_CATALOG" 'or `None` before that architecture exists.'

require "$ARCH_CATALOG" 'ADR11111111, ADR22222222'
require "$ARCH_CATALOG" 'in id order, separated by a comma and a space'
require "$ARCH_CATALOG" 'An ADR id appears on at most one row.'

require "$IMPL_CATALOG" 'More than one row may name the same Architecture ID.'
reject "$IMPL_CATALOG" 'Each Architecture ID appears on at most one row.'

for text in \
	'id: RAXXXXXX' \
	'status: accepted' \
	'## Current Decisions' \
	'## Information' \
	'## Variation' \
	'Must Keep:' \
	'May Choose:' \
	'## Responsibilities' \
	'Responsibility:' \
	'Interface:' \
	'- OBJXXXXXX: advances' \
	'- CTLXXXXXX: bound by' \
	'- NFRXXXXXX: satisfies'; do
	require "$ARCH_RECORD" "$text"
done
reject "$ARCH_RECORD" '## Key Technologies'
reject "$ARCH_RECORD" 'id: ARCHXXXXXX'
reject "$ARCH_RECORD" 'status: proposed'

for text in \
	'id: RIXXXXXX' \
	'architecture: RAXXXXXX' \
	'status: accepted' \
	'## Variation Choices' \
	'## Coverage' \
	'Conformance: compatible or incomplete' \
	'## Realized Interfaces' \
	'Conformance Evidence:' \
	'## Limitations' \
	'## Technology Choice' \
	'## Realized Capabilities' \
	'Title: <business-recognizable outcome>' \
	'Realized By:'; do
	require "$IMPL_RECORD" "$text"
done
reject "$IMPL_RECORD" '## Implementation Gaps'
reject "$IMPL_RECORD" '## Implementation Conflicts'
reject "$IMPL_RECORD" 'architecture: ARCHXXXXXX'
reject "$IMPL_RECORD" 'status: proposed'

require "$DISCOVERY" 'is a current implementation of'
require "$DISCOVERY" 'A wording resemblance does not produce this notice.'
require "$DISCOVERY" 'The notice does not ask for confirmation.'

require "$ADR" 'Do not write an implementation entry.'
require "$ADR" 'Suggest exactly one next step.'
require "$ADR" 'A new architecture is not required.'
require "$ADR" 'Do not suggest creating an architecture or another implementation.'
require "$ADR" 'Does this decision replace'
require "$ADR" 'same title, character for character'

require "$ARCH" 'Create an architecture only when the accepted ADR names none.'
require "$ARCH" 'Do not write Key Technologies.'

require "$IMPL" 'One accepted architecture can have more than one current implementation.'
require "$IMPL" 'The skill does not write an implementation id onto the ADR.'
require "$IMPL" 'Conformance is `compatible`'
reject "$IMPL" 'at most one implementation'
reject "$IMPL" 'Reference Implementation field'

require "$ONBOARDING" 'Do not set an implementation id.'
require "$ONBOARDING" 'does not name an implementation'
require "$ONBOARDING" 'Do not ask whether a decision replaces or runs beside another.'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: multiple reference implementations"
