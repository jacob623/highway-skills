#!/usr/bin/env bash
# Checks every file beneath .highway/ for pre-relocation path references that would mislead a
# reader into running or opening something at the repository root.
#
# Scope is deliberately narrow: an executable script path such as `tools/validate-skill.sh`, or
# a Markdown link target such as `](tools/...)`. Plain prose like "every skill under skills/" is
# a relative reference that reads correctly from inside .highway/ and is not flagged.
#
# Scope is also deliberately whole-tree. The previous check enumerated four documents and so
# never looked at the test fixtures, which carried stale paths for two features.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fail=0

# Reports "<file>:<line>: <text>". The exclusion is applied to the line's TEXT only; applying it
# to the whole grep -rn line would match the .highway/ prefix in the file path and silently
# discard every hit.
find_stale() {
	local skip="${1:-}"
	grep -rnE '(^|[^./[:alnum:]-])(tools/[A-Za-z0-9._-]+\.sh|tools/\.adapter-manifest|\]\((tools|skills|catalog)/)' \
		"$HIGHWAY_ROOT" 2>/dev/null \
		| awk -F: -v skip="$skip" '
			{
				file = $1; line = $2
				text = $0
				sub("^" file ":" line ":", "", text)
				if (skip != "" && index(file, skip) > 0) next
				if (text ~ /\.highway\/(tools|skills|catalog)\//) next
				if (text ~ /shellcheck source=/) next
				if (text !~ /(^|[^.\/[:alnum:]-])(tools\/[A-Za-z0-9._-]+\.sh|tools\/\.adapter-manifest|\]\((tools|skills|catalog)\/)/) next
				print file ":" line ": " text
			}
		'
}

stale="$(find_stale "path-integrity.test.sh")"
if [[ -n "$stale" ]]; then
	echo "FAIL: pre-relocation path references found beneath .highway/:"
	printf '%s\n' "$stale" | sed "s|$HIGHWAY_ROOT|.highway|" | sed 's/^/    /'
	fail=1
fi

# The check must be capable of failing: seed a stale reference and confirm it is detected.
probe="$HIGHWAY_ROOT/tools/path-probe-$$.tmp"
printf 'run tools/validate-skill.sh for details\n' >"$probe"
probe_hits="$(find_stale "path-integrity.test.sh" | grep -c "path-probe-$$" | tr -d ' ')"
rm -f "$probe"

if [[ "$probe_hits" -eq 0 ]]; then
	echo "FAIL: the stale-path check did not detect a deliberately seeded stale reference"
	fail=1
fi

exit $fail
