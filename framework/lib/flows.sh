#!/usr/bin/env bash
# Shared shell functions to read a skill's flows table and its flow files. The flows table sits in
# the Procedure introduction of SKILL.md, after the sentence FL_SENTENCE, with the header
# `| File | Steps |`. A File cell is one inline-code path `references/<name>.md`; a Steps cell lists
# inline-code step names. A skill without the table has no flow files, and every function here
# prints nothing for it. This is the only parser of the table: the validator, the harness
# inventory, and the tests all read it through these functions.

FL_SENTENCE="Before a step in this table, read its file and follow it to the end."

# Prints `<file>\t<step>` for every step the flows table lists, in table order. <file> is relative
# to the skill folder. Lines inside fenced blocks are ignored.
# Usage: fl_table <skill-dir>
fl_table() {
	local skill="$1"
	[[ -f "$skill/SKILL.md" ]] || return 0
	awk -v sentence="$FL_SENTENCE" '
		/^[ \t]*```/ { fence = !fence; next }
		fence { next }
		{ sub(/\r$/, "") }
		!seen && $0 == sentence { seen = 1; next }
		seen && !table && /^\|[ \t]*File[ \t]*\|[ \t]*Steps[ \t]*\|[ \t]*$/ { table = 1; next }
		seen && !table && $0 != "" { exit }
		table && /^\|[ \t:|-]*$/ { next }
		table && /^\|/ {
			n = split($0, cell, "|")
			file = cell[2]
			gsub(/[ \t`]/, "", file)
			steps = cell[3]
			while (match(steps, /`[^`]+`/)) {
				printf "%s\t%s\n", file, substr(steps, RSTART + 1, RLENGTH - 2)
				steps = substr(steps, RSTART + RLENGTH)
			}
			next
		}
		table { exit }
	' "$skill/SKILL.md"
}

# Prints each flow file the flows table names, relative to the skill folder, once, in table order.
# Usage: fl_files <skill-dir>
fl_files() {
	fl_table "$1" | cut -f1 | awk '!seen[$0]++'
}

# Prints the name of every step in a file: each level-3 heading outside a fenced block, in order.
# Usage: fl_steps <file>
fl_steps() {
	awk '
		/^[ \t]*```/ { fence = !fence; next }
		fence { next }
		/^### / {
			line = $0
			sub(/\r$/, "", line)
			line = substr(line, 5)
			sub(/^[ \t]+/, "", line)
			sub(/[ \t]+$/, "", line)
			print line
		}
	' "$1"
}

# Prints a skill's whole text: SKILL.md, then each flow file in table order, so a check can search
# the skill wherever a step now lives.
# Usage: fl_skill_text <skill-dir>
fl_skill_text() {
	local skill="$1" file
	cat "$skill/SKILL.md"
	while IFS= read -r file; do
		[[ -n "$file" && -f "$skill/$file" ]] || continue
		printf '\n'
		cat "$skill/$file"
	done <<< "$(fl_files "$skill")"
}

# Prints the path of a file holding fl_skill_text for a skill, for a check that reads a file. The
# file is named by a hash of its content under ${TMPDIR:-/tmp}/highway-skill-text, so it is
# written once per content and is never edited; a check must not edit it either.
# Usage: fl_skill_text_file <skill-dir>
fl_skill_text_file() {
	local dir="${TMPDIR:-/tmp}/highway-skill-text" text sum
	text="$(fl_skill_text "$1")"
	sum="$(printf '%s\n' "$text" | shasum -a 256 | cut -c1-16)"
	mkdir -p "$dir"
	if [[ ! -f "$dir/$sum.md" ]]; then
		printf '%s\n' "$text" >"$dir/$sum.$$" && mv -f "$dir/$sum.$$" "$dir/$sum.md"
	fi
	printf '%s\n' "$dir/$sum.md"
}
