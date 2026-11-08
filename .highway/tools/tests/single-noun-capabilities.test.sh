#!/usr/bin/env bash
# A capability is one noun phrase of five words or fewer. A joined title is split, and codify reads establish from the implementation title.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring the onboarding merge sentence, the joined static capability, or the capability-title establish check fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
IMPL="$SKILLS/highway-implementation/SKILL.md"
ONBOARD="$SKILLS/highway-onboarding/SKILL.md"
ARCH="$SKILLS/highway-architecture/SKILL.md"
CONFIG="$SKILLS/highway-codify-config/SKILL.md"
CODIFY="$SKILLS/highway-codify/SKILL.md"
CAP="$OUTPUT/capability-catalog.md"
ARCH_RECORD="$OUTPUT/architecture-record.md"
fail=0

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

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

words_under() {
	local file="$1" heading="$2" limit="$3" body words
	body="$(section "$file" "$heading")"
	words="$(printf '%s\n' "$body" | wc -w | tr -d ' ')"
	if [[ -z "$body" ]] || ((words > limit)); then
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") $heading has $words words; the limit is $limit"
		fail=1
	fi
}

for text in \
	'Title is one capability: one noun phrase of five words or fewer.' \
	'A Title does not contain `and`, `or`, `&`, `/`, `+`, or a comma.' \
	'A title that joins two things is two capabilities, one per part.' \
	'version: 2.1.0'; do
	require "$CAP" "$text"
done
reject "$CAP" 'Title is the business capability.'

require "$ARCH_RECORD" 'Capability: <capability title without a capability identifier>'
require "$ARCH_RECORD" 'version: 2.2.0'
reject "$ARCH_RECORD" 'advisory capability text'

for text in \
	'### capability title' \
	'1. Each capability title follows the Title rule in `.highway/library/templates/output/capability-catalog.md`.' \
	'Do not ask first.' \
	'3. Shorten a title of six or more words to five words or fewer.' \
	'If one is later done apart from the other, one joined capability would compound the effect of that change.' \
	'Follow `capability title` for each capability.' \
	'4. Derive each capability id as `write` does. When a title breaks the Title rule in `.highway/library/templates/output/capability-catalog.md`, or `write` would ask for a wording change, leave that capability out.' \
	'version: 7.6.0'; do
	require "$IMPL" "$text"
done
reject "$IMPL" 'Each realized capability has a business-readable title'

for text in \
	'When two activities rely on one technology, propose each as its own capability.' \
	'Follow `capability title` in `highway-implementation`' \
	'1. **AI-Augmented Technology Development:**' \
	'version: 10.5.0'; do
	require "$ONBOARD" "$text"
done
reject "$ONBOARD" 'When two activities rely on one technology, propose one capability.'
reject "$ONBOARD" 'AI-Assisted Engineering and Planning'

require "$ARCH" 'Follow `capability title` in `highway-implementation`'
require "$ARCH" '.highway/library/templates/output/capability-catalog.md'
require "$ARCH" 'version: 5.1.0'

require "$CONFIG" '5. Title that automation under the Title rule in `.highway/library/templates/output/capability-catalog.md`.'
require "$CONFIG" 'version: 3.5.0'
reject "$CONFIG" 'one noun phrase of five words or fewer'

for text in \
	'When no instance is running, the first suggestion is `Establish [implementation title]`' \
	'When an instance is running and Realized Capabilities is empty, the only suggestion is `Run [implementation title]`.' \
	'A title from a realized capability does not start with `Establish`.' \
	'The action is establishing when its title contains `establish`' \
	'version: 12.3.0'; do
	require "$CODIFY" "$text"
done
reject "$CODIFY" 'A capability title containing `establish`'
reject "$CODIFY" 'leading kind'

words_under "$IMPL" '### capability title' 250
words_under "$CODIFY" '### rank' 250

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: a capability is one noun phrase of five words or fewer'
