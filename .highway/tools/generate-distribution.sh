#!/usr/bin/env bash
# Produces the user-facing Highway distribution from this repository, then verifies it is
# self-contained before accepting it.
#
# Usage: .highway/tools/generate-distribution.sh <target-directory>
# Output format and exit codes are a contract: per feature 012 (distribution packaging).
# Exit 0: distribution produced and verified. Exit 1: verification failed, the manifest is
# invalid, or the step refused to overwrite a target it did not produce.
#
# What ships is read from .distribution-manifest, never hard-coded here, so the path set has one
# declaration (D1.6). Artifacts are copied and never regenerated: generate-catalog.sh records a
# timestamp, so regenerating during packaging would break byte-identical output.
#
# No environment variable is honored. CONSTITUTION_FILE in particular is deliberately ignored
# during verification -- an override would supply from outside the repository exactly what the
# verification exists to prove is inside the distribution.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
# shellcheck source=tools/lib/distribution.sh
source "$SCRIPT_DIR/lib/distribution.sh"

RECORD_REL=".highway/tools/.distribution-record"

if [[ $# -ne 1 ]]; then
	echo "ERROR: usage: .highway/tools/generate-distribution.sh <target-directory>" >&2
	exit 1
fi
TARGET="$1"

sha256_of() {
	local file="$1"
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$file" | awk '{print $1}'
	else
		shasum -a 256 "$file" | awk '{print $1}'
	fi
}

# Every repository file, .git excluded, as repository-relative paths.
repo_files() {
	find "$REPO_ROOT" -type f -not -path "$REPO_ROOT/.git/*" 2>/dev/null \
		| sed "s|^$REPO_ROOT/||" | sort
}

# Files inside the distribution, as distribution-relative paths.
dist_files() {
	find "$TARGET" -type f 2>/dev/null | sed "s|^$TARGET/||" | sort
}

# --- Refuse to overwrite a target this generator did not produce (FR-013, D4.3) ---

check_no_drift() {
	local record="$TARGET/$RECORD_REL"
	[[ -d "$TARGET" ]] || return 0
	# An empty directory is safe to populate.
	[[ -n "$(find "$TARGET" -type f 2>/dev/null | head -n1)" ]] || return 0

	if [[ ! -f "$record" ]]; then
		echo "ERROR: '$TARGET' exists and is not tracked by $RECORD_REL -- refusing to overwrite a directory this generator did not produce. Remove it manually if it is safe." >&2
		return 1
	fi

	local rel expected actual
	while IFS= read -r rel; do
		[[ "$rel" == "$RECORD_REL" ]] && continue
		expected="$(awk -F'\t' -v p="$rel" '$1 == p { print $2; exit }' "$record")"
		if [[ -z "$expected" ]]; then
			echo "ERROR: '$TARGET/$rel' is not listed in $RECORD_REL -- refusing to overwrite. Remove it manually if it is safe to regenerate." >&2
			return 1
		fi
		actual="$(sha256_of "$TARGET/$rel")"
		if [[ "$actual" != "$expected" ]]; then
			echo "ERROR: '$TARGET/$rel' was modified outside .highway/tools/generate-distribution.sh -- refusing to overwrite. Restore it from the generator's output or remove it manually." >&2
			return 1
		fi
	done < <(dist_files)
	return 0
}

# --- Verification (FR-007, FR-008, FR-009, FR-009a) ---

verify_no_development_paths() {
	local hits
	hits="$(grep -rnF -e '.specify/' -e 'specs/' "$TARGET" 2>/dev/null | sed "s|^$TARGET/||")"
	if [[ -n "$hits" ]]; then
		echo "  FAIL: distributed files reference a development-only location"
		printf '%s\n' "$hits" | sed 's/^/    /'
		return 1
	fi
	echo "  PASS: no distributed file references a development-only location"
	return 0
}

# Extracts Markdown link targets and requires each to resolve inside the distribution. Skips
# in-page anchors and absolute URLs. Mirrors the extraction in lib/rule-checks.sh so there is one
# link-parsing behavior rather than two that can diverge.
verify_cross_references() {
	local failures="" checked=0 file rel line_no target resolved dir
	while IFS= read -r rel; do
		case "$rel" in
		*.md) ;;
		*) continue ;;
		esac
		file="$TARGET/$rel"
		dir="$(dirname "$file")"
		while IFS=$'\t' read -r line_no target; do
			[[ -z "$target" ]] && continue
			case "$target" in
			'#'*) continue ;;
			[a-zA-Z]*:*) continue ;;
			esac
			target="${target%%#*}"
			[[ -z "$target" ]] && continue
			checked=$((checked + 1))
			resolved="$dir/$target"
			if [[ ! -e "$resolved" ]]; then
				failures="$failures
    $rel:$line_no: link target $target does not exist in the distribution"
			fi
		done < <(awk '{
			t = $0
			while (match(t, /\]\([^)]*\)/)) {
				print NR "\t" substr(t, RSTART + 2, RLENGTH - 3)
				t = substr(t, RSTART + RLENGTH)
			}
		}' "$file")
	done < <(dist_files)

	if [[ -n "$failures" ]]; then
		echo "  FAIL: cross-references do not resolve within the distribution"
		printf '%s\n' "$failures" | sed '/^$/d'
		return 1
	fi
	echo "  PASS: $checked cross-references resolve within the distribution"
	return 0
}

# Runs the distribution's OWN validator, with no constitution override. The repository's copy
# would prove nothing: it resolves its governing document relative to its own location, so it
# succeeds against a tree containing neither toolchain nor constitution.
verify_self_validation() {
	local validator="$TARGET/.highway/tools/validate-skill.sh"
	if [[ ! -x "$validator" ]]; then
		echo "  FAIL: the distribution's own validator did not succeed"
		echo "    .highway/tools/validate-skill.sh is missing or not executable in the distribution"
		return 1
	fi

	local skill_md skill_dir count=0 output rc
	for skill_md in "$TARGET"/.highway/skills/*/SKILL.md; do
		[[ -f "$skill_md" ]] || continue
		skill_dir="$(dirname "$skill_md")"
		output="$(env -u CONSTITUTION_FILE "$validator" "$skill_dir" 2>&1)"
		rc=$?
		if [[ $rc -ne 0 ]]; then
			echo "  FAIL: the distribution's own validator did not succeed"
			printf '%s\n' "$output" | sed 's/^/    /'
			return 1
		fi
		count=$((count + 1))
	done

	if [[ $count -eq 0 ]]; then
		echo "  FAIL: the distribution's own validator did not succeed"
		echo "    the distribution contains no skill to validate"
		return 1
	fi
	echo "  PASS: skill validator succeeded against $count skills using only distribution contents"
	return 0
}

# --- Produce ---

unclassified="$(dist_unclassified_paths "$REPO_ROOT")"
if [[ -n "$unclassified" ]]; then
	echo "ERROR: unclassified paths -- every path must be declared in .highway/tools/.distribution-manifest:" >&2
	printf '%s\n' "$unclassified" | sed 's/^/    /' >&2
	exit 1
fi

check_no_drift || exit 1

echo "producing distribution at $TARGET"
mkdir -p "$TARGET"

included=0
while IFS= read -r rel; do
	[[ "$(dist_classify "$rel")" == "include" ]] || continue
	dest="$(dist_destination "$rel")"
	mkdir -p "$TARGET/$(dirname "$dest")"
	cp "$REPO_ROOT/$rel" "$TARGET/$dest"
	included=$((included + 1))
done < <(repo_files)
echo "  included $included paths from .highway/tools/.distribution-manifest"

# Written last so it records the finished tree. Excluded from its own listing.
record="$TARGET/$RECORD_REL"
mkdir -p "$(dirname "$record")"
: >"$record"
while IFS= read -r rel; do
	[[ "$rel" == "$RECORD_REL" ]] && continue
	printf '%s\t%s\n' "$rel" "$(sha256_of "$TARGET/$rel")" >>"$record"
done < <(dist_files)

# --- Verify, and reject rather than warn (FR-011) ---

echo "verifying"
failed=0
verify_no_development_paths || failed=1
verify_cross_references || failed=1
verify_self_validation || failed=1

if [[ $failed -ne 0 ]]; then
	rm -rf "$TARGET"
	echo "distribution rejected; target removed" >&2
	exit 1
fi

echo "distribution accepted: $TARGET"
exit 0
