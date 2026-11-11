#!/usr/bin/env bash
# Every Highway skill gets Highway's identity, the Experience Standard, and the storage contract from
# highway-experience: each other skill activates it as the first line of its Procedure, no skill
# names the old governance or identity paths, and the always-on instructions are gone.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: --probe source-document copies highway-help into a temporary skills folder
# with its first Procedure line changed and requires a finding; --probe source-document --neutralise
# copies it unchanged and requires none.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

ACTIVATION="Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract."
OLD_PATHS='\.highway/governance/|\.highway/library/knowledge/highway-identity\.md'
EXPERIENCE_ID="$(basename "$HW_EXPERIENCE")"

# activation_problems <skills folder>: one line per Highway skill that names an old path, or, other
# than highway-experience, whose first Procedure line is not the activation sentence.
activation_problems() {
	local f id first
	for f in "$1"/highway-*/SKILL.md; do
		[[ -f "$f" ]] || continue
		id="$(basename "$(dirname "$f")")"
		if grep -qE "$OLD_PATHS" "$f"; then
			echo "$id names an old path: $(grep -nE "$OLD_PATHS" "$f" | head -n 1)"
		fi
		[[ "$id" == "$EXPERIENCE_ID" ]] && continue
		first="$(awk '$0 == "## Procedure" { p = 1; next } p && /^## / { exit } p && NF { print; exit }' "$f")"
		if [[ "$first" != "$ACTIVATION" ]]; then
			echo "$id: the first Procedure line is not the activation sentence: ${first:-no Procedure}"
		fi
	done
}

if [[ -n "$probe_class" ]]; then
	probe_dir="$(mktemp -d "${TMPDIR:-/tmp}/experience-activation-probe.XXXXXX")"
	trap 'rm -rf "$probe_dir"' EXIT
	mkdir -p "$probe_dir/highway-help"
	if [[ $neutralise -eq 1 ]]; then
		cp "$HW_SKILLS/highway-help/SKILL.md" "$probe_dir/highway-help/SKILL.md"
	else
		ACTIVATION="$ACTIVATION" awk '$0 == ENVIRON["ACTIVATION"] { print "Probe line."; next } { print }' \
			"$HW_SKILLS/highway-help/SKILL.md" >"$probe_dir/highway-help/SKILL.md"
	fi
	found="$(activation_problems "$probe_dir")"
	if [[ -n "$found" ]]; then
		echo "FAIL: probe finding: $found"
		exit 1
	fi
	echo "OK: probe clean"
	exit 0
fi

fail=0

# --- highway-experience holds exactly its skill file and three references ------------------------

expected="$(printf '%s\n' SKILL.md references/experience-standard.md references/highway-identity.md references/storage-contract.md)"
actual="$(cd "$HW_EXPERIENCE" 2>/dev/null && find . -type f | sed 's|^\./||' | LC_ALL=C sort)"
if [[ "$actual" != "$expected" ]]; then
	echo "FAIL: $(hw_rel "$HW_EXPERIENCE") holds:"
	printf '%s\n' "${actual:-nothing}" | sed 's/^/    /'
	echo "  expected:"
	printf '%s\n' "$expected" | sed 's/^/    /'
	fail=1
fi
for doc in experience-standard storage highway-identity; do
	if [[ ! -f "$(hw_doc "$doc")" ]]; then
		echo "FAIL: hw_doc $doc does not resolve to a file: $(hw_doc "$doc")"
		fail=1
	fi
done

SKILL="$HW_EXPERIENCE/SKILL.md"
for text in \
	'Loaded by every other highway skill' \
	'When a Highway skill applies, defer the workflow, artifact ownership, inputs, outputs, persistence, and decisions to that skill.' \
	'Do not treat Highway identity or experience guidance as organizational facts' \
	'Read `references/experience-standard.md` before any output the person sees' \
	'Read `references/storage-contract.md` before the first repository read or write.' \
	'Start no workflow. Write no file.'; do
	if ! grep -Fq -- "$text" "$SKILL" 2>/dev/null; then
		echo "FAIL: $(hw_rel "$SKILL") omits: $text"
		fail=1
	fi
done
if grep -Fq -- "$ACTIVATION" "$SKILL" 2>/dev/null; then
	echo "FAIL: highway-experience activates itself"
	fail=1
fi

# --- Every other skill activates it first, and no skill names an old path -------------------------

checked=0
for f in "$HW_SKILLS"/highway-*/SKILL.md; do
	[[ "$(basename "$(dirname "$f")")" == "$EXPERIENCE_ID" ]] || checked=$((checked + 1))
done
if [[ "$checked" -lt 15 ]]; then
	echo "FAIL: only $checked skills besides highway-experience were found; expected at least 15"
	fail=1
fi
found="$(activation_problems "$HW_SKILLS")"
if [[ -n "$found" ]]; then
	printf '%s\n' "$found" | sed 's/^/FAIL: /'
	fail=1
fi

# --- The always-on instructions and the old governance folder are gone ----------------------------

# shellcheck source=../lib/distribution.sh
source "$HW_LIB/distribution.sh"
DIST_MANIFEST="$HW_FRAMEWORK/.distribution-manifest"
for rel in \
	.highway/instructions \
	.highway/governance \
	framework/generate-instructions.sh \
	framework/.instruction-manifest \
	AGENTS.md \
	.cursor/rules/highway-agent-context.mdc \
	.claude/CLAUDE.md \
	.github/copilot-instructions.md; do
	if [[ -e "$HW_ROOT/$rel" ]]; then
		echo "FAIL: $rel still exists"
		fail=1
	fi
	if awk -F'\t' -v p="$rel" 'NF && $1 !~ /^#/ && ($2 == p || index($2, p "/") == 1) { f = 1 } END { exit !f }' "$DIST_MANIFEST"; then
		echo "FAIL: the distribution manifest still has a row for $rel"
		fail=1
	fi
done
if [[ "$(dist_classify "$(hw_rel "$SKILL")")" != "include" ]]; then
	echo "FAIL: highway-experience does not ship"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: every Highway skill activates highway-experience first, and the always-on instructions are gone"
