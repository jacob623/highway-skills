#!/usr/bin/env bash
# Fails when the spec record's feature numbering has a gap or a duplicate.
#
# Enforces D5.4 of the Highway Development Constitution. The rule reads as a statement about the
# next directory, but its content is a property of the whole set: numbers contiguous from 001.
# Checking only the newest directory would never detect a gap introduced earlier.
#
# The spec record is append-only history. A gap means either a feature directory was deleted or
# one was numbered by guess, and both destroy the ability to reconstruct why a decision was made.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SPECS_DIR="$REPO_ROOT/specs"
fail=0

# Emits "<problem>" per line, or nothing when the numbering is sound. Takes the directory to
# inspect so the self-test below can point it at a seeded tree instead of the real one.
numbering_problems() {
	local dir="$1"
	ls "$dir" 2>/dev/null \
		| grep -oE '^[0-9]{3}' \
		| sort \
		| awk '
			NR == 1 {
				if ($1 + 0 != 1) printf("numbering starts at %s, expected 001\n", $1)
				prev = $1 + 0
				next
			}
			{
				cur = $1 + 0
				if (cur == prev) printf("duplicate feature number %03d\n", cur)
				else if (cur != prev + 1) printf("gap between %03d and %03d\n", prev, cur)
				prev = cur
			}
		'
}

problems="$(numbering_problems "$SPECS_DIR")"
if [[ -n "$problems" ]]; then
	echo "FAIL: feature directory numbering is not contiguous:"
	printf '%s\n' "$problems" | sed 's/^/    /'
	fail=1
fi

# The check must be capable of failing. Seeded in a temporary tree rather than in the real spec
# record, so a crash between seeding and cleanup cannot leave a stray directory behind.
probe_root="$(mktemp -d)"
mkdir -p "$probe_root/001-a" "$probe_root/002-b" "$probe_root/004-d"
probe_hits="$(numbering_problems "$probe_root" | grep -c 'gap between' | tr -d ' ')"
rm -rf "$probe_root"

if [[ "$probe_hits" -eq 0 ]]; then
	echo "FAIL: the numbering check did not detect a deliberately seeded gap"
	fail=1
fi

exit $fail
