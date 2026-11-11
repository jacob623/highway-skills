#!/usr/bin/env bash
# Structural template check: does a file carry the required parts of its output template?
#
# Usage: template-check.sh <template> <file>
#   <template> is an output template file name, looked up with hw_template, or a path.
#
# Required parts, read from the template:
#   - each top-level frontmatter key in the fence under `## File Frontmatter`;
#   - each `## ` heading and each table header row in the first fence under `## Body` or
#     `## Catalog Structure`.
# Skipped: headings and rows holding a `<placeholder>`, and a heading the template's prose says may be
# omitted (a sentence naming the heading with "only when", "omit", "omitted", or "optional").
#
# Prints `missing <field|heading|row>: <text>` for each absent part. Exit 0 when nothing is missing,
# 1 when something is, 2 on a usage error. Bash 3.2 and the Declared Toolchain only. This is the
# single implementation; harness-fixtures.test.sh and the runner's `template` assertion call it.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/paths.sh
. "$HERE/lib/paths.sh"

if [ "$#" -ne 2 ]; then
	printf 'usage: template-check.sh <template> <file>\n' >&2
	exit 2
fi

template="$1"
target="$2"
case "$template" in
*/*) ;;
*) template="$(hw_template "${template%.md}")" || exit 2 ;;
esac
if [ ! -f "$template" ]; then
	printf 'template-check: no template at %s\n' "$template" >&2
	exit 2
fi
if [ ! -f "$target" ]; then
	printf 'template-check: no file at %s\n' "$target" >&2
	exit 2
fi

# `<kind>\t<text>` for each required part of the template.
required="$(awk '
	function norm_row(s) {
		gsub(/[ \t]*\|[ \t]*/, "|", s)
		return s
	}
	function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
	{ sub(/\r$/, "") }
	/^```/ {
		if (!fence) {
			fence = 1
			role = ""
			if (section == "## File Frontmatter" && !fm_done) { role = "fm"; fm_done = 1 }
			else if ((section == "## Body" || section == "## Catalog Structure") && !body_done) { role = "body"; body_done = 1 }
			in_fm = 0
			prev = ""
		} else {
			fence = 0
			role = ""
		}
		next
	}
	!fence {
		if ($0 ~ /^## /) { section = $0; next }
		prose = prose " " $0
		next
	}
	role == "fm" {
		if ($0 == "---") { in_fm = !in_fm; next }
		if (in_fm && match($0, /^[A-Za-z_][A-Za-z0-9_-]*:/)) print "field\t" substr($0, 1, RLENGTH - 1)
		next
	}
	role == "body" {
		if ($0 ~ /^## / && $0 !~ /</) { nh++; heads[nh] = trim($0) }
		if ($0 ~ /^\|[ \t:|-]+\|[ \t]*$/ && $0 ~ /-/ && prev ~ /^\|/ && prev !~ /</) print "row\t" norm_row(trim(prev))
		prev = $0
		next
	}
	END {
		low = tolower(prose)
		n = split(low, sentences, /\. /)
		for (h = 1; h <= nh; h++) {
			name = tolower(substr(heads[h], 4))
			optional = 0
			for (s = 1; s <= n; s++) {
				if (index(sentences[s], name) == 0) continue
				if (sentences[s] ~ /only when|omit|optional/) { optional = 1; break }
			}
			if (!optional) print "heading\t" heads[h]
		}
	}
' "$template")"

missing=0
TAB="$(printf '\t')"
while IFS="$TAB" read -r kind text; do
	[ -n "$kind" ] || continue
	case "$kind" in
	field)
		if ! awk -v k="$text" '
			NR == 1 && $0 != "---" { exit 1 }
			NR > 1 && $0 == "---" { exit found ? 0 : 1 }
			NR > 1 && index($0, k ":") == 1 { found = 1 }
			END { exit found ? 0 : 1 }
		' "$target"; then
			printf 'missing field: %s\n' "$text"
			missing=1
		fi
		;;
	heading)
		if ! awk -v h="$text" '{ sub(/\r$/, ""); sub(/[ \t]+$/, "") } $0 == h { f = 1 } END { exit f ? 0 : 1 }' "$target"; then
			printf 'missing heading: %s\n' "$text"
			missing=1
		fi
		;;
	row)
		if ! awk -v r="$text" '
			{ sub(/\r$/, ""); s = $0; sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); gsub(/[ \t]*\|[ \t]*/, "|", s) }
			s == r { f = 1 }
			END { exit f ? 0 : 1 }
		' "$target"; then
			printf 'missing row: %s\n' "$text"
			missing=1
		fi
		;;
	esac
done <<EOF
$required
EOF

exit "$missing"
