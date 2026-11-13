#!/usr/bin/env bash
# One check per enforceable constitution rule, plus the registry that binds rule ids to checks.
# Requires body-scan.sh and constitution.sh to be sourced first.
#
# Check contract: rc_check_<id> <file>
#   prints zero or more finding messages to stdout (one per line, no rule id prefix)
#   returns 0 = pass, 1 = fail, 2 = not applicable
# A check must never exit the calling shell.

[[ -n "${HW_ROOT:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/paths.sh"

# rule_id <TAB> check_function <TAB> na_condition
# na_condition is the permitted not-applicable condition the check cites, or "-" if the check
# always applies. Conditions are defined by the constitution's Compliance Review Protocol.
rc_registry() {
	cat <<-'EOF'
		P1.1	rc_check_P1_1	-
		P1.3	rc_check_P1_3	-
		P2.6	rc_check_P2_6	-
		P3.5	rc_check_P3_5	N2
		P4.2	rc_check_P4_2	N2
		P5.2	rc_check_P5_2	N2
		P5.3	rc_check_P5_3	N2
		P5.15	rc_check_P5_15	N4
		P6.4	rc_check_P6_4	-
		P7.1	rc_check_P7_1	-
		P7.2	rc_check_P7_2	-
		P7.4	rc_check_P7_4	-
		P7.5	rc_check_P7_5	N2
		P8.1	rc_check_P8_1	N2
		P8.3	rc_check_P8_3	-
		P8.7	rc_check_P8_7	-
		P9.1	rc_check_P9_1	N4
		P9.5	rc_check_P9_5	N3
		P14.1	rc_check_P14_1	N4
		P14.2	rc_check_P14_2	N4
		P14.3	rc_check_P14_3	N4
		P14.4	rc_check_P14_4	N4
	EOF
}

# Prints the registered check function for a rule id, or nothing.
rc_check_fn() {
	rc_registry | awk -F'\t' -v id="$1" '$1 == id { print $2; exit }'
}

# Prints the na_condition for a rule id.
rc_na_condition() {
	rc_registry | awk -F'\t' -v id="$1" '$1 == id { print $3; exit }'
}

# Prints every registered rule id.
rc_registered_ids() {
	rc_registry | cut -f1
}

# Prints the rule ids a template-type content file is exempt from: the four checks built on
# bs_normative_lines, whose placeholder "MUST"/"SHOULD" text can misfire (research.md Decision
# 1). Reported N/A with condition N2 by the caller, not skipped silently.
# Usage: rc_template_exempt_ids
rc_template_exempt_ids() {
	printf '%s\n' P1.1 P1.3 P7.4 P7.5
}

# Prints the rule ids a reference is exempt from, beyond rc_bundled_exempt_ids. The rule-shape
# rules judge a skill's own instructions; a reference such as the Experience Standard defines
# rules for others in table rows that exceed them. P7.1 judges a SKILL.md Purpose, and P7.2 a
# frontmatter version, which a reference does not have.
# Usage: rc_reference_exempt_ids
rc_reference_exempt_ids() {
	rc_template_exempt_ids
	printf '%s\n' P7.1 P7.2
}

# Prints the rule ids every file a skill bundles is exempt from, template or reference. P8.7's
# subject is a skill's own text; a bundled file is copied with its skill folder, so a relative
# link inside the folder still resolves. P2.6 limits what an agent does while following a skill,
# and a bundled file is content a skill reads or copies.
# Usage: rc_bundled_exempt_ids
rc_bundled_exempt_ids() {
	printf '%s
' P8.7 P6.4 P2.6
}

# Prints the rule ids a flow file is exempt from. A flow file holds steps moved out of SKILL.md, so
# every rule that judges a skill's instructions judges it too. P7.1 and P7.2 judge the Purpose and
# the version, which the router SKILL.md carries for the whole skill; P8.7's subject is SKILL.md.
# Usage: rc_flow_exempt_ids
rc_flow_exempt_ids() {
	printf '%s\n' P7.1 P7.2 P8.7
}

# --- P1.1: each normative line carries exactly one keyword -------------------------------

rc_check_P1_1() {
	local file="$1" found=0 out
	out="$(bs_normative_lines "$file" | awk -F'\t' '
		{
			t = $7
			gsub(/MUST-level/, "", t)
			mn = gsub(/MUST NOT/, "", t)
			m  = gsub(/MUST/, "", t)
			s  = gsub(/SHOULD/, "", t)
			total = mn + m + s
			if (total != 1) printf("line %d: normative rule carries %d keywords, expected exactly 1\n", $1, total)
		}
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# --- P1.3: each normative line is 25 words or fewer --------------------------------------

rc_check_P1_3() {
	local file="$1" found=0 out
	out="$(bs_normative_lines "$file" | awk -F'\t' '
		{
			n = split($7, w, /[[:space:]]+/)
			count = 0
			for (i = 1; i <= n; i++) if (w[i] != "") count++
			if (count > 25) printf("line %d: normative rule is %d words, limit is 25\n", $1, count)
		}
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# --- P2.6: the skill reaches the repository only through the storage contract --------------
# Only lines outside fenced blocks are examined. A fenced block in a skill is a specimen of content
# the skill shows or writes, and the rule limits what the agent does, not what a written file
# holds. A slash command has no second slash and a URL's slashes follow a colon, so neither reads
# as an absolute path. `.gitignore` and `GitHub` are not the word `git`.

rc_check_P2_6() {
	local file="$1" found=0 out
	out="$(bs_scan "$file" | awk -F'\t' '
		$3 == 1 { next }
		{
			t = $7
			l = tolower(t)
			if (t ~ /(^|[^A-Za-z0-9_.\/-])framework\// || t ~ /[A-Za-z0-9_-]\.(sh|bash|ps1|py)([^A-Za-z0-9]|$)/)
				printf("line %d: names a script for the agent to run\n", $1)
			if (t ~ /(^|[^A-Za-z0-9_.\/-])git([[:space:]`]|$)/)
				printf("line %d: names a git command\n", $1)
			if (t ~ /(^|[[:space:]`"(])(~\/|\/[A-Za-z0-9._-]+\/)/ || t ~ /(^|[^A-Za-z])[A-Za-z]:\\/)
				printf("line %d: names an absolute path\n", $1)
			if (l ~ /(modified|modification|creation|created|access|accessed) (time|date)|last[ -]modified|(^|[^a-z])mtime([^a-z]|$)|file.?s? timestamp|timestamp of (the|a|each) file/)
				printf("line %d: decides from a file time\n", $1)
		}
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# --- P3.5: every citation matches the Citation Format and resolves to AS-1..AS-6 ----------

rc_check_P3_5() {
	local file="$1" found=0 out total
	total="$(bs_scan "$file" | awk -F'\t' '$3 == 0 { print $7 }' | grep -oE 'AS-[0-9]+' | wc -l | tr -d ' ')"
	[[ "$total" -eq 0 ]] && return 2
	out="$(bs_scan "$file" | awk -F'\t' '
		$3 == 0 && $7 ~ /AS-[0-9]+/ {
			t = $7
			while (match(t, /AS-[0-9]+/)) {
				tok = substr(t, RSTART, RLENGTH)
				before = substr(t, 1, RSTART - 1)
				rest = substr(t, RSTART + RLENGTH)
				if (before !~ /\[$/ || rest !~ /^:[[:space:]]*[^]]+\]/)
					printf("line %d: citation %s does not match the Citation Format [AS-N: identifier]\n", $1, tok)
				else if (tok !~ /^AS-[1-6]$/)
					printf("line %d: citation %s does not resolve to AS-1 through AS-6\n", $1, tok)
				t = rest
			}
		}
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# --- P4.2: the Verification section states no unmeasurable quality claim ------------------

rc_check_P4_2() {
	local file="$1" found=0 out
	if [[ -z "$(bs_section "$file" "Verification")" ]]; then
		return 2
	fi
	out="$(bs_section "$file" "Verification" | awk -F'\t' '
		{
			t = tolower($7)
			if (t ~ /secure/)      printf("line %d: acceptance criterion uses \"secure\" as a quality claim\n", $1)
			if (t ~ /performant/)  printf("line %d: acceptance criterion uses \"performant\" as a quality claim\n", $1)
			if (t ~ /maintainable/) printf("line %d: acceptance criterion uses \"maintainable\" as a quality claim\n", $1)
		}
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# --- P5.2: each Error Handling list item names one of the four permitted next actions ------

rc_check_P5_2() {
	local file="$1" found=0 out items
	items="$(bs_section "$file" "Error Handling" | awk -F'\t' '$4 == 1 { print }')"
	[[ -z "$items" ]] && return 2
	out="$(printf '%s\n' "$items" | awk -F'\t' '
		{
			t = tolower($7)
			n = 0
			if (t ~ /retry/) n++
			if (t ~ /abort/) n++
			if (t ~ /escalate/) n++
			if (t ~ /fall back/ || t ~ /fallback/) n++
			if (n == 0) printf("line %d: failure condition names none of retry, abort, escalate, fall back\n", $1)
			else if (n > 1) printf("line %d: failure condition names %d next actions, expected exactly 1\n", $1, n)
		}
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# --- P5.3: a retry instruction states a maximum attempt count -----------------------------

rc_check_P5_3() {
	local file="$1" found=0 out lines
	lines="$(bs_scan "$file" | awk -F'\t' '$3 == 0 && tolower($7) ~ /retry/ { print }')"
	[[ -z "$lines" ]] && return 2
	out="$(printf '%s\n' "$lines" | awk -F'\t' '
		$7 !~ /[0-9]/ { printf("line %d: retry instruction states no maximum attempt count\n", $1) }
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# --- P5.15: the description says when to use the skill ---------------------------------

# Only a SKILL.md carries the description a client reads to decide activation; a template in
# assets/ has a description of the record it shapes. An empty description is the schema check's
# finding, not a second one here.
rc_check_P5_15() {
	local file="$1" description
	[[ "$(basename "$file")" == "SKILL.md" ]] || return 2
	description="$(fm_get "$file" description || true)"
	[[ -z "$description" ]] && return 0
	if [[ ! "$description" =~ (^|[.!?][[:space:]]+)Use\ when[[:space:]] ]]; then
		echo 'description has no sentence beginning "Use when"'
		return 1
	fi
	return 0
}

# --- P7.1: a Purpose section holds exactly one sentence -----------------------------------
# Presence of the section is reported by the required-section check, tagged with this rule id.

rc_check_P7_1() {
	local file="$1" body count
	body="$(bs_section "$file" "Purpose" | awk -F'\t' '$7 != "" { print $7 }')"
	[[ -z "$body" ]] && return 0
	count="$(printf '%s ' "$body" | grep -oE '[.!?]' | wc -l | tr -d ' ')"
	if [[ "$count" -ne 1 ]]; then
		echo "Purpose section contains $count sentences, expected exactly 1"
		return 1
	fi
	return 0
}

# --- P7.2: the skill carries a semantic version -------------------------------------------

rc_check_P7_2() {
	local file="$1" version
	version="$(fm_get_nested "$file" metadata version || true)"
	if [[ -z "$version" ]]; then
		echo "missing required field 'metadata.version'"
		return 1
	fi
	if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		echo "field 'metadata.version' (\"$version\") does not match MAJOR.MINOR.PATCH"
		return 1
	fi
	return 0
}

# --- P7.4: no more than 12 MUST-level rules -----------------------------------------------

rc_check_P7_4() {
	local file="$1" count
	count="$(bs_normative_lines "$file" | awk -F'\t' '
		{ t = $7; gsub(/MUST-level/, "", t); if (t ~ /MUST/) c++ }
		END { print c + 0 }
	')"
	if [[ "$count" -gt 12 ]]; then
		echo "skill declares $count MUST-level rules, limit is 12"
		return 1
	fi
	return 0
}

# --- P7.5: no normative section exceeds 400 words ------------------------------------------

rc_check_P7_5() {
	local file="$1" found=0 out sections
	sections="$(bs_normative_lines "$file" | cut -f2 | sort -u | grep -v '^$')"
	[[ -z "$sections" ]] && return 2
	sections="$(printf '%s\n' "$sections" | tr '\n' '\034')"
	out="$(bs_scan "$file" | awk -F'\t' -v want="$sections" '
		BEGIN { n = split(want, arr, "\034"); for (i = 1; i <= n; i++) keep[arr[i]] = 1 }
		$2 != "" && ($2 in keep) && $7 !~ /^## / {
			c = split($7, w, /[[:space:]]+/)
			for (i = 1; i <= c; i++) if (w[i] != "") words[$2]++
		}
		END { for (s in words) if (words[s] > 400) printf("section \"%s\" is %d words, limit is 400\n", s, words[s]) }
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# --- P8.1: ordered list items are sequentially numbered ------------------------------------

rc_check_P8_1() {
	local file="$1" found=0 out items
	items="$(bs_scan "$file" | awk -F'\t' '$5 == 1 { print }')"
	[[ -z "$items" ]] && return 2
	out="$(printf '%s\n' "$items" | awk -F'\t' '
		BEGIN { prev_line = -10; expect = 1 }
		{
			if ($1 != prev_line + 1) expect = 1
			if ($6 != expect) printf("line %d: ordered step is numbered %d, expected %d\n", $1, $6, expect)
			expect = $6 + 1
			prev_line = $1
		}
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# --- P8.3: a Verification section names something checkable --------------------------------
# Presence of the section is reported by the required-section check, tagged with this rule id.

rc_check_P8_3() {
	local file="$1" body
	body="$(bs_section "$file" "Verification" | awk -F'\t' '$7 != "" { print $7 }')"
	[[ -z "$body" ]] && return 0
	return 0
}

# --- P8.7: no Markdown link target is a relative filesystem path ---------------------------
# A SKILL.md is copied byte-for-byte into every agent adapter tree, and no sibling file travels
# with it, so a relative target resolves in the source tree and nowhere else. Only link targets
# are examined: a path inside a fenced block or inline code is a command example, correct as
# written. An absolute URL and a same-document anchor both resolve everywhere and are permitted.

rc_check_P8_7() {
	local file="$1" out found=0
	out="$(bs_scan "$file" | awk -F'\t' '
		$3 == 0 && $7 ~ /\]\(/ {
			t = $7
			while (match(t, /\]\([^)]*\)/)) {
				tok = substr(t, RSTART + 2, RLENGTH - 3)
				t = substr(t, RSTART + RLENGTH)
				if (tok == "") continue
				if (tok ~ /^#/) continue
				if (tok ~ /^[a-zA-Z][a-zA-Z0-9+.-]*:/) continue
				printf("line %d: link target %s is a relative path and resolves only in the source tree\n", $1, tok)
			}
		}
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# --- P9.1: file-emitting skills cite a complete output template in their assets/ -----------------
# A skill with no declared file path is not subject to this rule. A cited file under the skill's own
# assets/ counts as a template, and Outputs naming only files highway-setup seeds needs none: the
# seeded skeleton is the shape. The semantic comparison of a cited template with a produced artifact
# remains an agent-checkable X/D review.
rc_check_P9_1() {
	local file="$1" outputs outputs_without_links
	outputs="$(awk '
		/^## Outputs[[:space:]]*$/ { capture = 1; next }
		capture && /^## / { exit }
		capture { print }
	' "$file")"
	outputs_without_links="$(printf '%s\n' "$outputs" | sed -E 's/\[[^]]*\]\([^)]*\)//g')"

	if [[ -z "$outputs_without_links" || "$outputs_without_links" != *\.md* ]]; then
		return 2
	fi

	local cited dir
	dir="$(dirname "$file")"
	while IFS= read -r cited; do
		[[ -n "$cited" && -f "$dir/$cited" ]] && return 0
	done <<EOF
$(printf '%s\n' "$outputs_without_links" | grep -oE '(^|[^A-Za-z0-9_./-])assets/[^[:space:]`]+\.md' | sed -E 's/^[^a]*//')
EOF

	local named seeded only_seeded=1
	seeded="$(hw_seeded | cut -f2)"
	while IFS= read -r named; do
		[[ -n "$named" ]] || continue
		if ! printf '%s\n' "$seeded" | grep -Fqx -- "$named"; then
			only_seeded=0
			break
		fi
	done <<EOF
$(printf '%s\n' "$outputs_without_links" | grep -oE '[A-Za-z0-9_./<>-]+\.md')
EOF
	((only_seeded)) && return 0

	echo "Outputs section emits a file but cites no complete template in the skill's assets/, and names a file highway-setup does not seed"
	return 1
}

# Resolves the constitution the way validate-skill.sh does, so a token list is read from the same
# document the rules came from and CONSTITUTION_FILE overrides behave identically. Needed because
# a check receives only the file under test.
rc_constitution_file() {
	if [[ -n "${CONSTITUTION_FILE:-}" ]]; then
		printf '%s' "$CONSTITUTION_FILE"
		return 0
	fi
	printf '%s' "$(hw_doc constitution)"
}

# The sections that state when a skill does and does not apply. A decision criterion lives in one
# of these, so scoping structurally avoids having to recognise a criterion by meaning.
RC_P6_4_SECTIONS="When to use|When not to use"

rc_check_P6_4() {
	local file="$1" found=0 out tokens
	tokens="$(con_token_list "$(rc_constitution_file)" "Prohibited Nondeterministic Criterion Tokens")"
	# No list means nothing to enforce; a missing list is the inventory test's concern, not this.
	[[ -n "$tokens" ]] || return 0
	# Flattened to one line: awk -v rejects an embedded newline, and does so by failing the whole
	# program rather than the assignment, which reads as every artifact passing.
	tokens="$(printf '%s' "$tokens" | tr '\n' '|')"

	out="$(bs_scan "$file" | awk -F'\t' -v toks="$tokens" -v secs="$RC_P6_4_SECTIONS" '
		BEGIN { n = split(toks, T, "|") }
		$3 == 1 { next }
		$2 !~ "^(" secs ")$" { next }
		$7 ~ /^##[[:space:]]/ { next }
		{
			line = tolower($7)
			for (i = 1; i <= n; i++) {
				tok = tolower(T[i])
				if (tok == "") continue
				# Whole-word match, so "prefer" does not also fire on "preferred".
				if (line ~ ("(^|[^a-z])" tok "([^a-z]|$)")) {
					printf("line %d: decision criterion references \047%s\047, which makes the decision depend on when it is read, on chance, or on taste\n", $1, T[i])
					next
				}
			}
		}
	')"
	[[ -n "$out" ]] && { printf '%s\n' "$out"; found=1; }
	return $found
}

# P9.5 -- a specimen agrees with the metadata it repeats.
# The Example section is a recorded specimen of the skill's output. Where it repeats a value the
# frontmatter also declares, the two must match. Returns 2 where the Example repeats no such value.
# Superseded reported identifier: X1.4. The verdict is unchanged.
rc_check_P9_5() {
	local file="$1" declared shown
	declared="$(awk '/^  version:/ { sub(/^  version:[[:space:]]*/, ""); print; exit }' "$file")"
	shown="$(awk '/^## Example/ { f = 1 } f && /^Version:/ { sub(/^Version:[[:space:]]*/, ""); print; exit }' "$file")"

	[[ -z "$declared" || -z "$shown" ]] && return 2

	if [[ "$declared" != "$shown" ]]; then
		echo "Example shows version '$shown' but the skill declares '$declared'"
		return 1
	fi
	return 0
}

# --- Principle XIV: the flow pattern -------------------------------------------------------
# P14.1 to P14.4 each judge a whole skill folder from its SKILL.md, reading the flows table only
# through flows.sh. A file that is not SKILL.md is not applicable (N4), so a breach is reported
# once per skill and never again when a flow file, reference, or template is judged. A
# cross-skill handoff resolves against the skill folders beside this one. Each finding ends with
# the Phase 13 boundary it breaks.

declare -F fl_files >/dev/null || source "$HW_LIB/flows.sh"

RC_P14_MAX_LINES=500
RC_P14_MAX_CHARS=20000
RC_P14_MAX_FLOWS=6
RC_P14_MIN_FLOW_LINES=25

# Prints `local\t<step>` or `cross\t<skill>\t<step>` for every step reference in a file.
rc_p14_step_refs() {
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
rc_p14_turn_refs() {
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
rc_p14_skill_steps() {
	local dir="$1" f
	fl_steps "$dir/SKILL.md"
	while IFS= read -r f; do
		[[ -n "$f" && -f "$dir/$f" ]] && fl_steps "$dir/$f"
	done <<< "$(fl_files "$dir")"
}

# Prints its input and returns 1 when there is any, so a check ends `rc_p14_verdict "$out"`.
rc_p14_verdict() {
	[[ -n "$1" ]] || return 0
	printf '%s\n' "$1"
	return 1
}

# --- P14.1: SKILL.md and each flow file stay within the size limits (boundary 1) ------------

rc_check_P14_1() {
	local file="$1" dir f lines chars out
	[[ "$(basename "$file")" == "SKILL.md" ]] || return 2
	dir="$(dirname "$file")"
	out="$(
		for f in SKILL.md $(fl_files "$dir"); do
			[[ -f "$dir/$f" ]] || continue
			lines="$(wc -l < "$dir/$f" | tr -d ' ')"
			chars="$(wc -c < "$dir/$f" | tr -d ' ')"
			[[ "$lines" -le "$RC_P14_MAX_LINES" ]] || echo "$f has $lines lines, limit is $RC_P14_MAX_LINES (boundary 1)"
			[[ "$chars" -le "$RC_P14_MAX_CHARS" ]] || echo "$f has $chars characters, limit is $RC_P14_MAX_CHARS (boundary 1)"
		done
	)"
	rc_p14_verdict "$out"
}

# --- P14.2: flow files keep their place, number, length, and shape (boundaries 2 to 4) -------
# A skill with no flow files has nothing out of place.

rc_check_P14_2() {
	local file="$1" dir files f lines count out
	[[ "$(basename "$file")" == "SKILL.md" ]] || return 2
	dir="$(dirname "$file")"
	files="$(fl_files "$dir")"
	[[ -n "$files" ]] || return 0
	out="$(
		while IFS= read -r f; do
			[[ "$f" =~ ^references/[^/]+\.md$ ]] || echo "$f is not a Markdown file directly in references/ (boundary 2)"
		done <<< "$files"

		count="$(printf '%s\n' "$files" | wc -l | tr -d ' ')"
		[[ "$count" -le "$RC_P14_MAX_FLOWS" ]] || echo "the skill has $count flow files, limit is $RC_P14_MAX_FLOWS (boundary 3)"
		while IFS= read -r f; do
			[[ -f "$dir/$f" ]] || continue
			lines="$(wc -l < "$dir/$f" | tr -d ' ')"
			[[ "$lines" -ge "$RC_P14_MIN_FLOW_LINES" ]] || echo "$f has $lines lines, minimum is $RC_P14_MIN_FLOW_LINES (boundary 3)"
		done <<< "$files"

		while IFS= read -r f; do
			[[ -f "$dir/$f" ]] || continue
			awk -v f="$f" '
				NR == 1 && !/^# / { print f " does not start with a level-1 heading (boundary 4)" }
				/^[ \t]*```/ { fence = !fence; next }
				fence { next }
				/^# / { h1++ }
				/^## / {
					if ($0 != "## Verification") print f " has level-2 heading \"" $0 "\" (boundary 4)"
					else verif = 1
					next
				}
				verif && /^#/ { print f " has a heading after ## Verification (boundary 4)" }
				verif && /^- / { bullets++ }
				END {
					if (h1 != 1) print f " has " h1 + 0 " level-1 headings, expected 1 (boundary 4)"
					if (!verif) print f " has no ## Verification (boundary 4)"
					else if (!bullets) print f " has an empty ## Verification (boundary 4)"
				}
			' "$dir/$f"
		done <<< "$files"
	)"
	rc_p14_verdict "$out"
}

# --- P14.3: SKILL.md is the one route to each step (boundaries 5 to 8) -----------------------

rc_check_P14_3() {
	local file="$1" dir md table files f name count out
	[[ "$(basename "$file")" == "SKILL.md" ]] || return 2
	dir="$(dirname "$file")"
	md="$file"
	table="$(fl_table "$dir")"
	files="$(fl_files "$dir")"
	out="$(
		rc_p14_skill_steps "$dir" | sort | uniq -d | while IFS= read -r name; do
			echo "step $name is a step in more than one place (boundary 5)"
		done

		if [[ -n "$files" ]]; then
			while IFS= read -r f; do
				[[ -f "$dir/$f" ]] || continue
				fl_steps "$dir/$f" | grep -Ex 'Entry|Classify' | while IFS= read -r name; do
					echo "step $name is in $f, not SKILL.md (boundary 6)"
				done
			done <<< "$files"

			count="$(grep -c '^|[ 	]*File[ 	]*|[ 	]*Steps[ 	]*|[ 	]*$' "$md")"
			[[ "$count" -eq 1 ]] || echo "SKILL.md has $count File and Steps tables, expected 1 (boundary 7)"
			while IFS= read -r f; do
				[[ -f "$dir/$f" ]] || continue
				if [[ "$(printf '%s\n' "$table" | awk -F'\t' -v f="$f" '$1 == f { print $2 }')" != "$(fl_steps "$dir/$f")" ]]; then
					echo "the Steps cell for $f does not list its steps in file order (boundary 7)"
				fi
			done <<< "$files"

			awk -v sentence="$FL_SENTENCE" '
				$0 == sentence { s = 1; next }
				s == 1 && /^\|/ { next }
				s == 1 && $0 != "" && !/^\|/ { s = 2 }
				/references\// { print "SKILL.md line " NR " names a file in references/ outside the flows table (boundary 8)" }
			' "$md"
			for f in "$dir"/references/*; do
				[[ -f "$f" ]] || continue
				printf '%s\n' "$files" | grep -qxF "references/$(basename "$f")" \
					|| echo "references/$(basename "$f") has no row in the flows table (boundary 8)"
			done
			while IFS= read -r f; do
				[[ -f "$dir/$f" ]] || echo "the flows table names $f, which does not exist (boundary 8)"
			done <<< "$files"
		else
			grep -q '^|[ 	]*File[ 	]*|[ 	]*Steps[ 	]*|' "$md" \
				&& echo "SKILL.md has a File and Steps table not preceded by the flows sentence (boundary 7)"
			for f in "$dir"/references/*; do
				[[ -f "$f" ]] || continue
				grep -q "^Read \`references/$(basename "$f")\`" "$md" \
					|| echo "references/$(basename "$f") is not named by a line beginning \"Read \`references/$(basename "$f")\`\" (boundary 8)"
			done
		fi
	)"
	rc_p14_verdict "$out"
}

# --- P14.4: step references resolve one file reference from SKILL.md (boundaries 9 to 12) ----

rc_check_P14_4() {
	local file="$1" dir root files f g others steps cross_steps kind target name out
	[[ "$(basename "$file")" == "SKILL.md" ]] || return 2
	dir="$(dirname "$file")"
	root="$(dirname "$dir")"
	files="$(fl_files "$dir")"
	steps="$(rc_p14_skill_steps "$dir")"
	out="$(
		if [[ -n "$files" ]]; then
			while IFS= read -r f; do
				[[ -f "$dir/$f" ]] || continue
				grep -q 'references/' "$dir/$f" && echo "$f names a file in references/ (boundary 9)"
			done <<< "$files"
		fi

		for f in SKILL.md $files; do
			[[ -f "$dir/$f" ]] || continue
			while IFS="$(printf '\t')" read -r kind target name; do
				[[ -n "$kind" ]] || continue
				if [[ "$kind" == "local" ]]; then
					printf '%s\n' "$steps" | grep -qxF "$target" \
						|| echo "$f hands off to \`$target\`, which is not a step of this skill (boundary 10)"
					continue
				fi
				if [[ ! -f "$root/$target/SKILL.md" ]]; then
					echo "$f hands off to \`$name\` in \`$target\`, which is not a skill (boundary 11)"
					continue
				fi
				if [[ "$target" == "$(basename "$dir")" ]]; then
					cross_steps="$steps"
				else
					cross_steps="$(rc_p14_skill_steps "$root/$target")"
				fi
				printf '%s\n' "$cross_steps" | grep -qxF "$name" \
					|| echo "$f hands off to \`$name\` in \`$target\`, which is not a step of that skill (boundary 11)"
			done <<< "$(rc_p14_step_refs "$dir/$f")"
		done

		if [[ -n "$files" ]]; then
			while IFS= read -r f; do
				[[ -f "$dir/$f" ]] || continue
				others="$(while IFS= read -r g; do [[ "$g" != "$f" && -f "$dir/$g" ]] && fl_steps "$dir/$g"; done <<< "$files")"
				rc_p14_turn_refs "$dir/$f" | sort -u | while IFS= read -r name; do
					printf '%s\n' "$others" | grep -qxF "$name" \
						&& echo "$f hands off to \`$name\` in another flow file outside a reply line (boundary 12)"
				done
			done <<< "$files"
		fi
	)"
	rc_p14_verdict "$out"
}
