#!/usr/bin/env bash
# Tests that every skill keeps the router and flow file pattern: the eleven boundaries of Phase 13
# in standard-alignment.md, and boundary 12 of Phase 14. A flow file is a file in references/ that
# the flows table names; a step is a level-3 heading outside a fenced block; a step reference is a
# backticked name after "go to", "return to", "follow", "resume at", or "stay on" with no `/` or
# `.` that does not start with highway-. A reply line is a list item that starts with a backticked
# reply class and a colon. Each breach prints `skill-flow-pattern: <skill>: boundary <n>: <detail>`.
set -u
# Instrument class: executed-behavior
# Artifact classes: source-document
# Seeded failure probe: --probe <class> seeds one breach of each boundary into a copy of the
# flow-skill fixture and observes that exactly that boundary is reported; --probe <class>
# --neutralise runs the identical path unseeded and requires a clean pass. See the Feature 041
# probe-mode contract.

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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
FIXTURE="$HW_FIXTURES/flow-skill"

MAX_LINES=500
MAX_CHARS=20000
MAX_FLOWS=6
MIN_FLOW_LINES=25

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

# Prints `local\t<step>` or `cross\t<skill>\t<step>` for every step reference in a file.
step_refs() {
	awk '
		/^[ \t]*```/ { fence = !fence; next }
		fence { next }
		{
			line = $0
			while (match(tolower(line), /(go to|return to|follow|resume at|stay on) `[^`]+`/)) {
				hit = substr(line, RSTART, RLENGTH)
				rest = substr(line, RSTART + RLENGTH)
				line = rest
				name = hit
				sub(/^[^`]*`/, "", name)
				sub(/`$/, "", name)
				if (name ~ /[\/.]/ || name ~ /^highway-/) continue
				if (match(rest, /^ in `highway-[a-z0-9-]+`/)) {
					target = substr(rest, RSTART + 5, RLENGTH - 6)
					printf "cross\t%s\t%s\n", target, name
				} else {
					printf "local\t%s\n", name
				}
			}
		}
	' "$1"
}

# Prints every step a file hands off to outside a reply line, so within one turn.
turn_refs() {
	awk '
		/^[ \t]*```/ { fence = !fence; next }
		fence || /^[ \t]*- `[^`]+`:/ { next }
		{
			line = $0
			while (match(tolower(line), /(go to|return to|follow|resume at) `[^`]+`/)) {
				hit = substr(line, RSTART, RLENGTH)
				rest = substr(line, RSTART + RLENGTH)
				line = rest
				name = hit
				sub(/^[^`]*`/, "", name)
				sub(/`$/, "", name)
				if (name ~ /[\/.]/ || name ~ /^highway-/ || rest ~ /^ in `highway-/) continue
				print name
			}
		}
	' "$1"
}

# Prints every step name of a skill folder: SKILL.md, then each flow file.
skill_steps() {
	local dir="$1" f
	fl_steps "$dir/SKILL.md"
	while IFS= read -r f; do
		[[ -n "$f" && -f "$dir/$f" ]] && fl_steps "$dir/$f"
	done <<< "$(fl_files "$dir")"
}

# Prints `boundary <n>: <detail>` for each breach in one skill folder. <skills-root> resolves a
# cross-skill handoff.
check_skill() {
	local dir="$1" root="$2" md="$1/SKILL.md" table files f lines chars count ref kind target name
	table="$(fl_table "$dir")"
	files="$(fl_files "$dir")"

	# 1. Size.
	for f in SKILL.md $files; do
		[[ -f "$dir/$f" ]] || continue
		lines="$(wc -l < "$dir/$f" | tr -d ' ')"
		chars="$(wc -c < "$dir/$f" | tr -d ' ')"
		[[ "$lines" -le "$MAX_LINES" ]] || echo "boundary 1: $f has $lines lines, limit is $MAX_LINES"
		[[ "$chars" -le "$MAX_CHARS" ]] || echo "boundary 1: $f has $chars characters, limit is $MAX_CHARS"
	done

	if [[ -n "$files" ]]; then
		# 2. Place.
		while IFS= read -r f; do
			[[ "$f" =~ ^references/[^/]+\.md$ ]] || echo "boundary 2: $f is not a Markdown file directly in references/"
		done <<< "$files"

		# 3. Granularity.
		count="$(printf '%s\n' "$files" | wc -l | tr -d ' ')"
		[[ "$count" -le "$MAX_FLOWS" ]] || echo "boundary 3: $count flow files, limit is $MAX_FLOWS"
		while IFS= read -r f; do
			[[ -f "$dir/$f" ]] || continue
			lines="$(wc -l < "$dir/$f" | tr -d ' ')"
			[[ "$lines" -ge "$MIN_FLOW_LINES" ]] || echo "boundary 3: $f has $lines lines, minimum is $MIN_FLOW_LINES"
		done <<< "$files"

		# 4. Shape. 9. No chains.
		while IFS= read -r f; do
			[[ -f "$dir/$f" ]] || continue
			awk -v f="$f" '
				NR == 1 && !/^# / { print "boundary 4: " f " does not start with a level-1 heading" }
				/^[ \t]*```/ { fence = !fence; next }
				fence { next }
				/^# / { h1++ }
				/^## / {
					h2++
					if ($0 != "## Verification") print "boundary 4: " f " has level-2 heading \"" $0 "\""
					else verif = 1
					next
				}
				verif && /^#/ { print "boundary 4: " f " has a heading after ## Verification" }
				verif && /^- / { bullets++ }
				END {
					if (h1 != 1) print "boundary 4: " f " has " h1 + 0 " level-1 headings, expected 1"
					if (!verif) print "boundary 4: " f " has no ## Verification"
					else if (!bullets) print "boundary 4: " f " has an empty ## Verification"
				}
			' "$dir/$f"
			grep -q 'references/' "$dir/$f" && echo "boundary 9: $f names a file in references/"
		done <<< "$files"

		# 6. Router.
		while IFS= read -r f; do
			[[ -f "$dir/$f" ]] || continue
			fl_steps "$dir/$f" | grep -Ex 'Entry|Classify' | while IFS= read -r name; do
				echo "boundary 6: step $name is in $f, not SKILL.md"
			done
		done <<< "$files"

		# 7. Flows table.
		count="$(grep -c '^|[ 	]*File[ 	]*|[ 	]*Steps[ 	]*|[ 	]*$' "$md")"
		[[ "$count" -eq 1 ]] || echo "boundary 7: SKILL.md has $count File and Steps tables, expected 1"
		while IFS= read -r f; do
			[[ -f "$dir/$f" ]] || continue
			if [[ "$(printf '%s\n' "$table" | awk -F'\t' -v f="$f" '$1 == f { print $2 }')" != "$(fl_steps "$dir/$f")" ]]; then
				echo "boundary 7: the Steps cell for $f does not list its steps in file order"
			fi
		done <<< "$files"

		# 8. One pointer, with a table.
		awk -v sentence="$FL_SENTENCE" '
			$0 == sentence { s = 1; next }
			s == 1 && /^\|/ { next }
			s == 1 && $0 != "" && !/^\|/ { s = 2 }
			/references\// { print "boundary 8: SKILL.md line " NR " names a file in references/ outside the flows table" }
		' "$md"
		for f in "$dir"/references/*; do
			[[ -f "$f" ]] || continue
			printf '%s\n' "$files" | grep -qxF "references/$(basename "$f")" || echo "boundary 8: references/$(basename "$f") has no row in the flows table"
		done
		while IFS= read -r f; do
			[[ -f "$dir/$f" ]] || echo "boundary 8: the flows table names $f, which does not exist"
		done <<< "$files"

		# 12. A handoff within one turn stays in its file or goes to SKILL.md.
		local g others
		while IFS= read -r f; do
			[[ -f "$dir/$f" ]] || continue
			others="$(while IFS= read -r g; do [[ "$g" != "$f" && -f "$dir/$g" ]] && fl_steps "$dir/$g"; done <<< "$files")"
			turn_refs "$dir/$f" | sort -u | while IFS= read -r name; do
				printf '%s\n' "$others" | grep -qxF "$name" && echo "boundary 12: $f hands off to \`$name\` in another flow file outside a reply line"
			done
		done <<< "$files"
	else
		grep -q '^|[ 	]*File[ 	]*|[ 	]*Steps[ 	]*|' "$md" && echo "boundary 7: SKILL.md has a File and Steps table not preceded by the flows sentence"
		# 8. One pointer, without a table.
		for f in "$dir"/references/*; do
			[[ -f "$f" ]] || continue
			grep -q "^Read \`references/$(basename "$f")\`" "$md" || echo "boundary 8: references/$(basename "$f") is not named by a line beginning \"Read \`references/$(basename "$f")\`\""
		done
	fi

	# 5. One home per step.
	skill_steps "$dir" | sort | uniq -d | while IFS= read -r name; do
		echo "boundary 5: step $name is a step in more than one place"
	done

	# 10. Handoffs resolve. 11. Cross-skill handoffs resolve.
	local steps cross_steps
	steps="$(skill_steps "$dir")"
	for f in SKILL.md $files; do
		[[ -f "$dir/$f" ]] || continue
		while IFS="$(printf '\t')" read -r kind target name; do
			[[ -n "$kind" ]] || continue
			if [[ "$kind" == "local" ]]; then
				printf '%s\n' "$steps" | grep -qxF "$target" || echo "boundary 10: $f hands off to \`$target\`, which is not a step of this skill"
			else
				if [[ ! -f "$root/$target/SKILL.md" ]]; then
					echo "boundary 11: $f hands off to \`$name\` in \`$target\`, which is not a skill"
					continue
				fi
				if [[ "$target" == "$(basename "$dir")" ]]; then cross_steps="$steps"; else cross_steps="$(skill_steps "$root/$target")"; fi
				printf '%s\n' "$cross_steps" | grep -qxF "$name" || echo "boundary 11: $f hands off to \`$name\` in \`$target\`, which is not a step of that skill"
			fi
		done <<< "$(step_refs "$dir/$f")"
	done
}

fail=0

# --- Probe mode -------------------------------------------------------------------------------

# Applies seed <n> to a fresh copy of the fixture and prints its folder.
seed_copy() {
	local n="$1" copy="$tmp_root/seed-$1/flow-skill"
	mkdir -p "$(dirname "$copy")"
	cp -R "$FIXTURE" "$copy"
	[[ "$neutralise" -eq 1 ]] && { echo "$copy"; return; }
	case "$n" in
		1) awk 'NR == 2 { for (i = 0; i < 500; i++) print "Padding line." } { print }' "$copy/references/proposal.md" > "$copy/p" && mv "$copy/p" "$copy/references/proposal.md" ;;
		2) mkdir -p "$copy/references/sub" && mv "$copy/references/record.md" "$copy/references/sub/record.md" \
			&& sed 's#`references/record.md`#`references/sub/record.md`#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		3) grep -v '^$' "$copy/references/record.md" > "$copy/r" && mv "$copy/r" "$copy/references/record.md" ;;
		4) awk '/^## Verification/ { print "## Notes"; print ""; print "A note."; print "" } { print }' "$copy/references/record.md" > "$copy/r" && mv "$copy/r" "$copy/references/record.md" ;;
		5) awk '/^### close/ { print "### write"; print ""; print "Write again."; print "" } { print }' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		6) awk '/^### start/ { print "### Classify"; print ""; print "Classify again."; print "" } { print }' "$copy/references/proposal.md" > "$copy/p" && mv "$copy/p" "$copy/references/proposal.md" \
			&& awk '/^### Classify/ { skip = 1; next } skip && /^### / { skip = 0 } !skip' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" \
			&& sed 's#| `start`, `revise` |#| `Classify`, `start`, `revise` |#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" \
			&& sed 's#Go to `Classify`.#Go to `start`.#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		7) sed 's#| `start`, `revise` |#| `revise`, `start` |#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		8) sed 's#^Confirm the record and stop.#Confirm `references/record.md` and stop.#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		9) awk '/^## Verification/ { print "See `references/proposal.md`."; print "" } { print }' "$copy/references/record.md" > "$copy/r" && mv "$copy/r" "$copy/references/record.md" ;;
		10) sed 's#^Confirm the record and stop.#Confirm the record, then go to `nowhere`.#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		11) sed 's#^Confirm the record and stop.#Confirm the record, then follow `nowhere` in `highway-adr`.#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		12) sed 's#^3. Return to `close`.#3. Go to `revise`.#' "$copy/references/record.md" > "$copy/r" && mv "$copy/r" "$copy/references/record.md" ;;
	esac
	echo "$copy"
}

if [[ -n "$probe_class" ]]; then
	for n in 1 2 3 4 5 6 7 8 9 10 11 12; do
		copy="$(seed_copy "$n")"
		out="$(check_skill "$copy" "$HW_SKILLS")"
		if [[ "$neutralise" -eq 1 ]]; then
			[[ -z "$out" ]] || { echo "FAIL: neutralised copy $n reports a breach:"; printf '%s\n' "$out"; fail=1; }
			continue
		fi
		if ! printf '%s\n' "$out" | grep -q "^boundary $n: "; then
			echo "FAIL: seeded breach of boundary $n was not reported"
			printf '%s\n' "$out"
			fail=1
		fi
		other="$(printf '%s\n' "$out" | grep -v "^boundary $n: " | grep -v '^$')"
		[[ -z "$other" ]] || { echo "FAIL: seeded breach of boundary $n also reported:"; printf '%s\n' "$other"; fail=1; }
	done
	if [[ "$fail" -eq 0 ]]; then
		if [[ "$neutralise" -eq 1 ]]; then echo "PASS: skill-flow-pattern (neutralised)"; else echo "PASS: skill-flow-pattern (probe)"; fi
		exit 0
	fi
	exit 1
fi

# --- Every skill ------------------------------------------------------------------------------

out="$(check_skill "$FIXTURE" "$HW_SKILLS")"
if [[ -n "$out" ]]; then
	printf '%s\n' "$out" | sed 's/^/skill-flow-pattern: fixture flow-skill: /'
	fail=1
fi

breaches=0
for dir in "$HW_SKILLS"/*/; do
	dir="${dir%/}"
	[[ -f "$dir/SKILL.md" ]] || continue
	out="$(check_skill "$dir" "$HW_SKILLS")"
	[[ -n "$out" ]] || continue
	printf '%s\n' "$out" | sed "s/^/skill-flow-pattern: $(basename "$dir"): /"
	breaches=$((breaches + $(printf '%s\n' "$out" | wc -l | tr -d ' ')))
	fail=1
done

if [[ "$fail" -eq 0 ]]; then
	echo "PASS: skill-flow-pattern"
	exit 0
fi
echo "FAIL: skill-flow-pattern ($breaches breaches)"
exit 1
