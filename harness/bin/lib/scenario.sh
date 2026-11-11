#!/usr/bin/env bash
# Reader for harness scenario files (harness/scenarios/<skill>/<id>.scenario).
# Bash 3.2 and the Declared Toolchain only. Source this file; it defines functions and runs nothing.
#
# Format: one `key: value` per line. Blank lines and lines starting with `#` are ignored.

# scenario_list <harness dir>: every scenario file, one per line, sorted.
scenario_list() {
	if [ ! -d "$1/scenarios" ]; then
		return 0
	fi
	find "$1/scenarios" -type f -name '*.scenario' | LC_ALL=C sort
}

# scenario_entries <file>: `<line>\t<key>\t<value>` for every entry. A non-blank, non-comment line
# that is not `key: value` prints with the key `!malformed` so callers can report it.
scenario_entries() {
	awk '
		/^[ \t]*$/ { next }
		/^[ \t]*#/ { next }
		{
			line = $0
			sub(/\r$/, "", line)
			if (match(line, /^[a-z][a-z-]*:/)) {
				key = substr(line, 1, RLENGTH - 1)
				value = substr(line, RLENGTH + 1)
				sub(/^[ \t]+/, "", value)
				sub(/[ \t]+$/, "", value)
				printf "%d\t%s\t%s\n", NR, key, value
			} else {
				printf "%d\t!malformed\t%s\n", NR, line
			}
		}
	' "$1"
}

# scenario_values <file> <key>: each value of <key>, one per line, in file order.
scenario_values() {
	scenario_entries "$1" | awk -F '\t' -v k="$2" '$2 == k { print $3 }'
}

# scenario_value <file> <key>: the first value of <key>, or nothing.
scenario_value() {
	scenario_values "$1" "$2" | head -n 1
}

# scenario_id_from_path <file>: the file name without `.scenario`.
scenario_id_from_path() {
	basename "$1" .scenario
}

# scenario_glob_regex <glob>: an extended regex for a `writes:` or `expect` glob, anchored. `**`
# crosses folders, `*` stays within one folder, and `?` matches one character within a folder.
scenario_glob_regex() {
	printf '%s\n' "$1" | awk '
		{
			s = $0
			out = "^"
			i = 1
			n = length(s)
			while (i <= n) {
				c = substr(s, i, 1)
				if (c == "*" && substr(s, i + 1, 1) == "*") {
					if (substr(s, i + 2, 1) == "/") {
						out = out "(.*/)?"
						i += 3
					} else {
						out = out ".*"
						i += 2
					}
					continue
				}
				if (c == "*") { out = out "[^/]*"; i++; continue }
				if (c == "?") { out = out "[^/]"; i++; continue }
				if (index(".+()[]{}|^$\\", c) > 0) { out = out "\\" c; i++; continue }
				out = out c
				i++
			}
			print out "$"
		}
	'
}
