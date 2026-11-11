#!/usr/bin/env bash
# Coverage inventory: prints `<skill>\t<kind>\t<id>\t<text>` for every step, Verification bullet,
# and Error Handling bullet of each skill.
#
# Usage: inventory.sh [--skills-dir <dir>] [skill...]
#   With no skill named, every skill under the skills directory is listed.
#
# kind is `step`, `verification`, or `error`. A step's id is its `###` heading text under
# `## Procedure`. A bullet is a `- ` line directly under `## Verification` or `## Error Handling`;
# its id is the first 12 hex digits of SHA-256 over its text with runs of spaces and tabs collapsed
# and the ends trimmed. Lines inside fenced blocks are ignored.
#
# Bash 3.2 and the Declared Toolchain only. This is the single implementation of the inventory; the
# runner and the bash suite both call it.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$HERE/../.." && pwd)"
SKILLS_DIR="$REPO_ROOT/.highway/skills"

if [ "${1:-}" = "--skills-dir" ]; then
	SKILLS_DIR="$2"
	shift 2
fi

if [ "$#" -eq 0 ]; then
	set --
	for d in "$SKILLS_DIR"/*/; do
		[ -f "$d/SKILL.md" ] || continue
		set -- "$@" "$(basename "$d")"
	done
fi

hash_stdin() {
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum | awk '{print $1}'
	else
		shasum -a 256 | awk '{print $1}'
	fi
}

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

for skill in "$@"; do
	file="$SKILLS_DIR/$skill/SKILL.md"
	if [ ! -f "$file" ]; then
		printf 'inventory: no SKILL.md for skill %s\n' "$skill" >&2
		exit 2
	fi
	# Pass 1: `<kind>\t<text>` in document order, text normalized.
	awk '
		/^[ \t]*```/ { fence = !fence; next }
		fence { next }
		/^## / { section = $0; next }
		{
			line = $0
			sub(/\r$/, "", line)
		}
		section == "## Procedure" && line ~ /^### / {
			text = substr(line, 5)
			gsub(/[ \t]+/, " ", text); sub(/^ /, "", text); sub(/ $/, "", text)
			printf "step\t%s\n", text
			next
		}
		(section == "## Verification" || section == "## Error Handling") && line ~ /^- / {
			text = substr(line, 3)
			gsub(/[ \t]+/, " ", text); sub(/^ /, "", text); sub(/ $/, "", text)
			kind = (section == "## Verification") ? "verification" : "error"
			printf "%s\t%s\n", kind, text
		}
	' "$file" >"$WORK/items"

	# Pass 2: hash every bullet in one batch, then join.
	: >"$WORK/hashes"
	n=0
	while IFS="$(printf '\t')" read -r kind text; do
		n=$((n + 1))
		if [ "$kind" != "step" ]; then
			printf '%s' "$text" | hash_stdin | cut -c1-12 >>"$WORK/hashes"
		else
			printf '%s\n' "-" >>"$WORK/hashes"
		fi
	done <"$WORK/items"

	awk -F '\t' -v skill="$skill" '
		NR == FNR { h[FNR] = $0; next }
		{
			id = ($1 == "step") ? $2 : h[FNR]
			printf "%s\t%s\t%s\t%s\n", skill, $1, id, $2
		}
	' "$WORK/hashes" "$WORK/items"
done
