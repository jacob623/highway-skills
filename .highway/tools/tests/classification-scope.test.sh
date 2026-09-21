#!/usr/bin/env bash
# Checks that every pass which classifies repository paths prunes the subtrees no manifest record
# can include, instead of walking them and discarding the result afterwards.
#
# This is a structural check on purpose. The defect it guards against is a performance defect, but
# asserting a duration would make the suite fail on a loaded machine and pass on a fast one, which
# decides nothing. What it asserts instead is the mechanism: a classification walk must derive its
# prune set from the manifest via dist_prune_roots and hand it to find, so a walk that stops
# pruning fails here rather than merely getting slower.
#
# It also asserts the prune set is safe. Pruning a subtree that contains an includable path would
# silently drop that path from the distribution, so every derived root is checked to have no
# manifest record beneath it.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing the prune predicates from a declared walker must fail this test.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
fail=0

# shellcheck source=/dev/null
. "$HIGHWAY_ROOT/tools/lib/distribution.sh"

# Every file containing a pass that walks repository paths and classifies them. A new one must be
# added here; that is the point of the list being explicit rather than discovered.
WALKERS="
.highway/tools/generate-distribution.sh
.highway/tools/tests/shipped-tree-independence.test.sh
"

echo "classification scope"

prune_roots="$(dist_prune_roots)"
if [[ -z "$prune_roots" ]]; then
	echo "  FAIL: dist_prune_roots derived no prunable root from the manifest"
	echo "    every classification walk would enumerate the whole repository"
	fail=1
else
	count="$(printf '%s\n' "$prune_roots" | sed '/^$/d' | wc -l | tr -d ' ')"
	echo "  PASS: $count prunable roots derived from the manifest"
fi

# A prune root with an includable path beneath it would drop that path from the distribution.
over_pruned=""
while IFS= read -r root; do
	[[ -n "$root" ]] || continue
	beneath="$(dist_records | awk -F'\t' -v r="$root/" '$2 == "include" && index($1, r) == 1 { print $1 }')"
	if [[ -n "$beneath" ]]; then
		over_pruned="$over_pruned
    $root prunes an included record: $(printf '%s' "$beneath" | head -1)"
	fi
done <<EOF
$prune_roots
EOF

if [[ -n "$over_pruned" ]]; then
	echo "  FAIL: a derived prune root hides a path the manifest includes"
	printf '%s\n' "$over_pruned" | sed '/^$/d'
	fail=1
else
	echo "  PASS: no derived prune root hides an included record"
fi

# The mechanism itself: each walker must derive its prune set rather than hardcode one, and must
# actually pass it to find.
while IFS= read -r walker; do
	[[ -n "$walker" ]] || continue
	target="$REPO_ROOT/$walker"
	if [[ ! -f "$target" ]]; then
		echo "  FAIL: declared classification walker is missing"
		echo "    $walker"
		fail=1
		continue
	fi
	if ! grep -q 'dist_prune_roots' "$target"; then
		echo "  FAIL: a classification pass enumerates paths beneath locations no manifest record can include"
		echo "    $walker does not derive its prune set from dist_prune_roots"
		echo "    unpruned roots would include: $(printf '%s' "$prune_roots" | head -3 | tr '\n' ' ')"
		fail=1
		continue
	fi
	if ! grep -q -- '-prune' "$target"; then
		echo "  FAIL: a classification pass enumerates paths beneath locations no manifest record can include"
		echo "    $walker derives prune roots but never passes them to find as -prune"
		echo "    unpruned roots would include: $(printf '%s' "$prune_roots" | head -3 | tr '\n' ' ')"
		fail=1
		continue
	fi
	echo "  PASS: $walker prunes derived roots"
done <<EOF
$WALKERS
EOF

exit $fail
