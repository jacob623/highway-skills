#!/usr/bin/env bash
# Each kind of edit in revise is its own line, and every current consequence remains.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: joining the edit lines in revise back into one line fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
CODIFY="$(fl_skill_text_file "$HW_SKILLS/highway-codify")"
fail=0

propose="$(awk '$0 == "### revise" {p=1; next} $0 == "### identifier" || /^##? / {p=0} p' "$CODIFY")"

require_line() {
	local text="$1"
	if ! printf '%s\n' "$propose" | grep -Fxq -- "$text"; then
		echo "FAIL: highway-codify revise lacks the line: $text"
		fail=1
	fi
}

editing=0
printf '%s\n' "$propose" | while IFS= read -r line; do
	case "$line" in
		'- `edit`:'*) editing=1 ;;
		'- `'*) editing=0 ;;
	esac
	if [[ "$editing" -eq 1 && ${#line} -gt 240 ]]; then
		echo "FAIL: highway-codify revise edit line has ${#line} characters: ${line:0:60}"
		exit 1
	fi
done || fail=1

for text in \
	'- `edit`: emit one consequence sentence. Re-emit the proposal with the diagram and tasks still matching. Stay on `revise`.' \
	'An edit that names a different Executor sets the Executor and the diagram start. It does not change a task'"'"'s Provider.' \
	'An edit that names a different Provider sets it on that task, then goes to `standards`.' \
	'An edit that changes a method goes to `standards`, then `align`, for that task.' \
	'An edit that adds, removes, or reorders a task'"'"'s Standards changes only that list, then goes to `align` for that task.' \
	'A Files edit changes only this automation and leaves out a path that is not relative.' \
	'A title not in the coding standards catalog is left out, and the rest of the list is kept. Say: [Title] is not a listed coding standard. To add it, run highway-codify-config.' \
	'A second action is removed. Say it waits for another run.' \
	'The person can switch to another accepted architecture by title. An architecture that is not accepted is not added.' \
	'A preparation-only request stays one self-service action.' \
	'Removing the last task or the last acceptance criterion says at least one is needed.'; do
	require_line "$text"
done

words=$(printf '%s\n' "$propose" | wc -w | tr -d ' ')
if [[ "$words" -gt 400 ]]; then
	echo "FAIL: highway-codify revise has $words words; the limit is 400"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: revise states each edit on its own line'
