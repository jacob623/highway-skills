#!/usr/bin/env bash
# One check per enforceable constitution rule, plus the registry that binds rule ids to checks.
# Requires body-scan.sh and constitution.sh to be sourced first.
#
# Check contract: rc_check_<id> <file>
#   prints zero or more finding messages to stdout (one per line, no rule id prefix)
#   returns 0 = pass, 1 = fail, 2 = not applicable
# A check must never exit the calling shell.

# rule_id <TAB> check_function <TAB> na_condition
# na_condition is the permitted not-applicable condition the check cites, or "-" if the check
# always applies. Conditions are defined by the constitution's Compliance Review Protocol.
rc_registry() {
	cat <<-'EOF'
		P1.1	rc_check_P1_1	-
		P1.3	rc_check_P1_3	-
		P3.5	rc_check_P3_5	N2
		P4.2	rc_check_P4_2	N2
		P5.2	rc_check_P5_2	N2
		P5.3	rc_check_P5_3	N2
		P7.1	rc_check_P7_1	-
		P7.2	rc_check_P7_2	-
		P7.4	rc_check_P7_4	-
		P7.5	rc_check_P7_5	N2
		P8.1	rc_check_P8_1	N2
		P8.3	rc_check_P8_3	-
		P8.7	rc_check_P8_7	-
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

# Prints the rule ids every library file is exempt from, regardless of library type. P8.7's
# subject is a skill, which is copied into each agent adapter tree; a library file is never
# copied, so a relative link in one resolves. Reported N/A with a condition by the caller, not
# skipped silently.
# Usage: rc_library_exempt_ids
rc_library_exempt_ids() {
	printf '%s\n' P8.7
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
	out="$(bs_scan "$file" | awk -F'\t' -v want="$sections" '
		BEGIN { n = split(want, arr, "\n"); for (i = 1; i <= n; i++) keep[arr[i]] = 1 }
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
