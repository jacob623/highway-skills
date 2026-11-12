#!/usr/bin/env bash
# Produces the user-facing Highway distribution from this repository, then verifies it is
# self-contained before accepting it.
#
# Usage: framework/generate-distribution.sh <target-directory>
# Output format and exit codes are a contract: per feature 012 (distribution packaging).
# Exit 0: distribution produced and verified. Exit 1: verification failed, the manifest is
# invalid, or the step refused to overwrite a target it did not produce.
#
# What ships is read from .distribution-manifest, never hard-coded here, so the path set has one
# declaration (D1.6). Artifacts are copied and never regenerated. The framework does not ship;
# the shipped skills are validated with it from a verification tree outside the target.
#
# No environment variable is honored. CONSTITUTION_FILE in particular is deliberately ignored
# during verification -- an override would supply from outside the repository exactly what the
# verification exists to prove is inside the distribution.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/paths.sh
source "$SCRIPT_DIR/lib/paths.sh"
# shellcheck source=lib/distribution.sh
source "$HW_LIB/distribution.sh"

RECORD_REL=".distribution-record"

if [[ $# -ne 1 ]]; then
	echo "ERROR: usage: framework/generate-distribution.sh <target-directory>" >&2
	exit 1
fi
TARGET="$1"

# Work over the distribution's files runs in batches, never one subprocess per file: on macOS, one
# bash process that forks a few thousand times starts failing to fork, and the loops below would
# then pass on empty output.

# Prints "path<TAB>sha256" for every file in the target but the record, sorted by path. find's
# `-exec … +` keeps each hashing batch within the command-line argument limit.
hash_tree() {
	local hasher=(shasum -a 256)
	command -v sha256sum >/dev/null 2>&1 && hasher=(sha256sum)
	(cd "$TARGET" && find . -type f ! -path "./$RECORD_REL" -exec "${hasher[@]}" {} +) \
		| awk '{ h = $1; p = substr($0, length(h) + 3); sub(/^\.\//, "", p); print p "\t" h }' \
		| sort -t $'\t' -k1,1
}

# Every repository file that could possibly be included, as repository-relative paths.
#
# Subtrees the manifest excludes with nothing included beneath them are pruned rather than walked:
# descending into them can only produce paths that classify as 'exclude' and are then discarded.
# The prune list is derived from the manifest at runtime by dist_prune_roots, so it cannot drift
# out of step with it. This keeps the walk proportional to what ships rather than to the
# repository, which otherwise grows with every feature directory that is added and never shipped.
candidate_files() {
	local prune_args root
	prune_args=(-path "$HW_ROOT/.git")
	while IFS= read -r root; do
		[[ -n "$root" ]] || continue
		prune_args=("${prune_args[@]}" -o -path "$HW_ROOT/$root")
	done < <(dist_prune_roots)
	find "$HW_ROOT" \( "${prune_args[@]}" \) -prune -o -type f -print 2>/dev/null \
		| sed "s|^$HW_ROOT/||" | sort
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

	local problem rel
	problem="$(hash_tree | awk -F'\t' -v rec="$record" '
		FILENAME == rec { want[$1] = $2; next }
		!($1 in want) { print "unlisted\t" $1; exit }
		want[$1] != $2 { print "modified\t" $1; exit }
	' "$record" -)"
	rel="${problem#*$'\t'}"
	case "$problem" in
	unlisted*)
		echo "ERROR: '$TARGET/$rel' is not listed in $RECORD_REL -- refusing to overwrite. Remove it manually if it is safe to regenerate." >&2
		return 1
		;;
	modified*)
		echo "ERROR: '$TARGET/$rel' was modified outside framework/generate-distribution.sh -- refusing to overwrite. Restore it from the generator's output or remove it manually." >&2
		return 1
		;;
	esac
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
	local failures="" checked=0 rel line_no target resolved dir
	while IFS=$'\t' read -r rel line_no target; do
		[[ -z "$target" ]] && continue
		case "$target" in
		'#'*) continue ;;
		[a-zA-Z]*:*) continue ;;
		esac
		target="${target%%#*}"
		[[ -z "$target" ]] && continue
		checked=$((checked + 1))
		dir="$TARGET/$rel"
		dir="${dir%/*}"
		resolved="$dir/$target"
		if [[ ! -e "$resolved" ]]; then
			failures="$failures
    $rel:$line_no: link target $target does not exist in the distribution"
		fi
	done < <(cd "$TARGET" && find . -type f -name '*.md' -exec awk '{
			t = $0
			while (match(t, /\]\([^)]*\)/)) {
				f = FILENAME
				sub(/^\.\//, "", f)
				print f "\t" FNR "\t" substr(t, RSTART + 2, RLENGTH - 3)
				t = substr(t, RSTART + RLENGTH)
			}
		}' {} + | sort -s -t $'\t' -k1,1)

	if [[ -n "$failures" ]]; then
		echo "  FAIL: cross-references do not resolve within the distribution"
		printf '%s\n' "$failures" | sed '/^$/d'
		return 1
	fi
	echo "  PASS: $checked cross-references resolve within the distribution"
	return 0
}

# Builds a verification tree outside the target: the distribution, plus this repository's
# framework, with the skills copied from the cross-agent tree they ship in to where the framework
# reads them. The repository has no development directories in it, so the tree proves the skills
# validate using only distribution contents and the framework. Prints the tree's root.
build_verification_tree() {
	local tree shipped_skills
	tree="$(mktemp -d "${TMPDIR:-/tmp}/highway-verify.XXXXXX")" || return 1
	cp -R "$TARGET/." "$tree/"
	shipped_skills="$(hw_rel "$HW_AGENT_CODEX")"
	if [[ -d "$tree/$shipped_skills" ]]; then
		mkdir -p "$(dirname "$(hw_at "$tree" "$HW_SKILLS")")"
		cp -R "$tree/$shipped_skills" "$(hw_at "$tree" "$HW_SKILLS")"
	fi
	cp -R "$HW_FRAMEWORK" "$(hw_at "$tree" "$HW_FRAMEWORK")"
	printf '%s\n' "$tree"
}

# Runs the framework's validator in the verification tree against every distributed skill, with
# no constitution override, so every document it reads comes from the tree.
verify_skill_validation() {
	local tree validator skill_md skill_dir count=0 output rc result=0
	tree="$(build_verification_tree)" || {
		echo "  FAIL: the skill validator did not succeed against the distribution"
		echo "    the verification tree could not be built"
		return 1
	}
	validator="$(hw_at "$tree" "$HW_FRAMEWORK")/validate-skill.sh"

	for skill_md in "$(hw_at "$tree" "$HW_SKILLS")"/*/SKILL.md; do
		[[ -f "$skill_md" ]] || continue
		skill_dir="${skill_md%/*}"
		output="$(env -u CONSTITUTION_FILE "$validator" "$skill_dir" 2>&1)"
		rc=$?
		if [[ $rc -ne 0 ]]; then
			echo "  FAIL: the skill validator did not succeed against the distribution"
			printf '%s\n' "$output" | sed 's/^/    /'
			result=1
			break
		fi
		count=$((count + 1))
	done

	if [[ $result -eq 0 && $count -eq 0 ]]; then
		echo "  FAIL: the skill validator did not succeed against the distribution"
		echo "    the distribution contains no skill to validate"
		result=1
	fi
	rm -rf "$tree"
	[[ $result -eq 0 ]] || return 1
	echo "  PASS: skill validator succeeded against $count skills using only distribution contents and the framework"
	return 0
}

# --- Produce ---

unclassified="$(dist_unclassified_paths "$HW_ROOT")"
if [[ -n "$unclassified" ]]; then
	echo "ERROR: unclassified paths -- every path must be declared in framework/.distribution-manifest:" >&2
	printf '%s\n' "$unclassified" | sed 's/^/    /' >&2
	exit 1
fi

check_no_drift || exit 1

echo "producing distribution at $TARGET"
mkdir -p "$TARGET"

included=0
while IFS=$'\t' read -r rel dest; do
	dir="$TARGET/$dest"
	dir="${dir%/*}"
	[[ -d "$dir" ]] || mkdir -p "$dir"
	cp "$HW_ROOT/$rel" "$TARGET/$dest"
	included=$((included + 1))
done < <(candidate_files | dist_classify_many | awk -F'\t' '$1 == "include" { print $2 }' | dist_destination_many)
echo "  included $included paths from framework/.distribution-manifest"

# Written last so it records the finished tree. Excluded from its own listing.
record="$TARGET/$RECORD_REL"
mkdir -p "${record%/*}"
hash_tree >"$record"

# --- Verify, and reject rather than warn (FR-011) ---

echo "verifying"
failed=0
verify_no_development_paths || failed=1
verify_cross_references || failed=1
verify_skill_validation || failed=1

if [[ $failed -ne 0 ]]; then
	rm -rf "$TARGET"
	echo "distribution rejected; target removed" >&2
	exit 1
fi

echo "distribution accepted: $TARGET"
exit 0
