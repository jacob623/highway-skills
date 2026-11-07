#!/usr/bin/env bash
# An implementation records who deploys it, who runs it later, and its language. Codify reads the executor and lets each task keep its platform.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing the Kind column, the Execution section, or the two platform-standard phrases fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
IMPL="$SKILLS/highway-implementation/SKILL.md"
ONBOARD="$SKILLS/highway-onboarding/SKILL.md"
CODIFY="$SKILLS/highway-codify/SKILL.md"
CONFIG="$SKILLS/highway-codify-config/SKILL.md"
PLATFORMS="$OUTPUT/codify-platforms.md"
RECORD="$OUTPUT/implementation-record.md"
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

require "$PLATFORMS" '| Platform | Implementation ID | Kind | When to use | When not to use |'
require "$PLATFORMS" 'version: 2.1.0'
require "$RECORD" '## Execution'
require "$RECORD" 'Deployed by: <platform title> (<RI id>) or Needed'
require "$RECORD" 'version: 2.2.0'

for text in \
	'### execution' \
	'earliest candidate whose Kind is `pipeline`' \
	'earliest `orchestrator`' \
	'earliest `desired-state`' \
	'earliest `agent`' \
	'earliest candidate whose Kind is `self-service`' \
	'**Deployed by:**' \
	'**Managed by:**' \
	'**Language:**' \
	'Follow `highway-codify-config`' \
	'return step `execution`' \
	'Follow `highway-onboarding`' \
	'version: 7.3.0'; do
	require "$IMPL" "$text"
done

require "$ONBOARD" 'return step `execution`'
require "$ONBOARD" 'version: 10.2.0'

for text in \
	'### kind' \
	'### platform entries' \
	'[Platform] is used' \
	'[Platform] is not used' \
	'**Kind:**' \
	'version: 3.3.0'; do
	require "$CONFIG" "$text"
done

for text in \
	'**Executor:**' \
	'Do not copy the Executor onto a task' \
	'Helm, Terraform, or CloudFormation' \
	'[Field] is needed. Name it on the implementation.' \
	'A missing When to use entry does not remove Language' \
	'version: 12.1.0'; do
	require "$CODIFY" "$text"
done

reject "$CODIFY" 'Every task names that same Provider'
reject "$CODIFY" "this implementation's row, then the first row"

words_under "$IMPL" '### execution' 250
words_under "$CONFIG" '### kind' 250
words_under "$CONFIG" '### platform entries' 250
words_under "$CONFIG" '### platform proposal' 400
words_under "$CODIFY" '### draft' 250
words_under "$CODIFY" '### provider' 250

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: establish reads the record and a platform standard has two entries'
