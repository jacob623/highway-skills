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
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: disposable-fixture
# Seeded failure probe: --probe <class> seeds a defect and observes detection; --probe <class>
# --neutralise runs the identical path unseeded and requires a clean pass. See the Feature 041
# probe-mode contract.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SPECS_DIR="$REPO_ROOT/specs"
fail=0

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" disposable-fixture "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

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

# --- Probe mode: a dedicated CLI path for the D3.7 harness, separate from the checks below ---
if [[ -n "$probe_class" ]]; then
	probe_root="$(mktemp -d)"
	trap 'rm -rf "$probe_root"' EXIT
	if [[ "$neutralise" -eq 0 ]]; then
		mkdir -p "$probe_root/001-a" "$probe_root/002-b" "$probe_root/004-d"
	else
		mkdir -p "$probe_root/001-a" "$probe_root/002-b" "$probe_root/003-c"
	fi
	hits="$(numbering_problems "$probe_root" | grep -c 'gap between' | tr -d ' ')"
	exit $(( hits > 0 ? 1 : 0 ))
fi

problems="$(numbering_problems "$SPECS_DIR")"
if [[ -n "$problems" ]]; then
	echo "FAIL: feature directory numbering is not contiguous:"
	printf '%s\n' "$problems" | sed 's/^/    /'
	fail=1
fi

identity_problems() {
	local dir="$1"
	local base="$(basename "$dir")"
	local number="$(printf '%s' "$base" | cut -c1-3)"
	local suffix="$(printf '%s' "$base" | cut -c5-)"
	local branch="$(sed -n 's/^\*\*Feature Branch\*\*: `\([^`]*\)`.*/\1/p' "$dir/spec.md" | head -1)"
	if [[ -z "$branch" ]]; then
		printf '%s: missing Feature Branch\n' "$base"
	elif [[ "$branch" != "$base" ]]; then
		printf '%s: directory and Feature Branch differ (%s)\n' "$base" "$branch"
	fi
	if [[ "$suffix" == "$number" || "$suffix" == "feature-$number" ]]; then
		printf '%s: placeholder directory name\n' "$base"
	fi
}

identity_failures=0
for feature_dir in "$SPECS_DIR"/[0-9][0-9][0-9]-*; do
	[[ -d "$feature_dir" && -f "$feature_dir/spec.md" ]] || continue
	identity_output="$(identity_problems "$feature_dir")"
	if [[ -n "$identity_output" ]]; then
		echo "FAIL: feature identity: $identity_output"
		identity_failures=1
	fi
done

identity_probe_root="$(mktemp -d)"
mkdir -p "$identity_probe_root/001-canonical" "$identity_probe_root/002-feature-002"
printf '%s\n' '**Feature Branch**: `001-wrong`' >"$identity_probe_root/001-canonical/spec.md"
printf '%s\n' '**Feature Branch**: `002-feature-002`' >"$identity_probe_root/002-feature-002/spec.md"
if [[ -z "$(identity_problems "$identity_probe_root/001-canonical")" ]]; then
	identity_failures=1
	echo "FAIL: the identity check did not detect a seeded branch mismatch"
fi
if [[ -z "$(identity_problems "$identity_probe_root/002-feature-002")" ]]; then
	identity_failures=1
	echo "FAIL: the identity check did not detect a seeded placeholder directory"
fi
rm -rf "$identity_probe_root"

if [[ "$identity_failures" -ne 0 ]]; then
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
