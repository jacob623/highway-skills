#!/usr/bin/env bash
# Tests that every skill conforms to the Agent Skills specification and that the validator
# enforces each of its rules (D3.9): every skill validates, carries license Apache-2.0, and reads
# the same in the strict parser and the line readers; a seeded violation of each specification
# rule fails; skill text names skills without an agent's invocation prefix outside `## Example`;
# and the retired word list and dependency check are gone.
set -u
# Instrument class: executed-behavior
# Artifact classes: source-document
# Seeded failure probe: --probe <class> seeds a defect and observes detection; --probe <class>
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
# shellcheck source=../framework/lib/frontmatter.sh
source "$HW_LIB/frontmatter.sh"
# shellcheck source=../framework/lib/yaml-frontmatter.sh
source "$HW_LIB/yaml-frontmatter.sh"
VALIDATE="$HW_FRAMEWORK/validate-skill.sh"
BASE="$HW_FIXTURES/valid-skill/SKILL.md"

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

fail=0

# Prints each line of the skill folder's text files that puts an agent's invocation prefix before
# a highway skill name outside a `## Example` section, as <file>:<line>: <text>.
invocation_findings() {
	local dir="$1" file
	find "$dir" -type f -name '*.md' | sort | while IFS= read -r file; do
		awk -v f="$file" '
			/^## / { ex = ($0 ~ /^## Example[[:space:]]*$/) }
			!ex && (/(^|[^A-Za-z0-9_.\/-])\/highway-[a-z]/ || /[$]highway-[a-z]/ || /highway:highway-/) {
				print f ":" NR ": " $0
			}
		' "$file"
	done
}

# Prints a finding for each way a skill folder breaks the specification: a validator failure or an
# invocation prefix outside `## Example`. Returns 1 when there is any finding.
skill_findings() {
	local dir="$1" out found=0
	if ! out="$(bash "$VALIDATE" --no-cache "$dir" 2>&1)"; then
		printf '%s\n' "$out" | grep '^ERROR:'
		found=1
	fi
	out="$(invocation_findings "$dir")"
	if [[ -n "$out" ]]; then
		printf '%s\n' "$out"
		found=1
	fi
	return $found
}

# Copies the conforming fixture into <tmp>/<case>/<id>/SKILL.md, renamed to <id>, and prints the
# folder.
seed_copy() {
	local case_name="$1" id="${2:-valid-skill}" dir
	dir="$tmp_root/$case_name/$id"
	mkdir -p "$dir"
	sed "s/^name: valid-skill\$/name: $id/" "$BASE" >"$dir/SKILL.md"
	printf '%s' "$dir"
}

# Replaces the line matching <pattern> in a skill's frontmatter with <replacement> (which may span
# lines). An empty replacement deletes the line.
seed_replace() {
	local file="$1" pattern="$2" replacement="$3"
	REPL="$replacement" awk -v pat="$pattern" '
		/^---[[:space:]]*$/ { delim++ }
		delim == 1 && $0 ~ pat { if (ENVIRON["REPL"] != "") print ENVIRON["REPL"]; next }
		{ print }
	' "$file" >"$file.tmp" && mv "$file.tmp" "$file"
}

# --- Probe mode -----------------------------------------------------------------------------------

# A field the specification does not define, in an otherwise conforming copy.
probe_source_document() {
	local dir
	dir="$(seed_copy probe)"
	if [[ "$neutralise" -eq 0 ]]; then
		seed_replace "$dir/SKILL.md" '^license:' "$(printf 'license: Apache-2.0\npriority: high')"
	fi
	skill_findings "$dir" >/dev/null
}

if [[ -n "$probe_class" ]]; then
	case "$probe_class" in
		source-document) probe_source_document; exit $? ;;
	esac
fi

# --- Every shipped skill conforms ------------------------------------------------------------------

for skill_dir in "$HW_SKILLS"/*/; do
	skill_dir="${skill_dir%/}"
	id="$(basename "$skill_dir")"
	if ! out="$(skill_findings "$skill_dir")"; then
		echo "FAIL: $id breaks the Agent Skills format:"
		printf '%s\n' "$out" | sed 's/^/    /'
		fail=1
	fi
	parsed="$(yf_parse "$skill_dir/SKILL.md")" || { echo "FAIL: $id: $parsed"; fail=1; continue; }
	if [[ "$(yf_value "$parsed" top license)" != "Apache-2.0" ]]; then
		echo "FAIL: $id does not declare license Apache-2.0"
		fail=1
	fi
	for pair in top:name top:description top:license metadata:version metadata:usage; do
		scope="${pair%%:*}"
		key="${pair#*:}"
		if [[ "$scope" == "top" ]]; then
			line_value="$(fm_get "$skill_dir/SKILL.md" "$key" || true)"
		else
			line_value="$(fm_get_nested "$skill_dir/SKILL.md" metadata "$key" || true)"
		fi
		if [[ "$(yf_value "$parsed" "$scope" "$key")" != "$line_value" ]]; then
			echo "FAIL: $id: the strict parser and the line reader disagree on '$key'"
			fail=1
		fi
	done
done

# --- A seeded violation of each specification rule fails -------------------------------------------

# expect_finding <case> <dir> <expected text>
expect_finding() {
	local case_name="$1" dir="$2" expected="$3" out
	if out="$(bash "$VALIDATE" --no-cache "$dir" 2>&1)"; then
		echo "FAIL[$case_name]: expected the validator to reject the seeded violation"
		fail=1
		return
	fi
	if [[ "$out" != *"$expected"* ]]; then
		echo "FAIL[$case_name]: expected a finding containing: $expected. Got:"
		printf '%s\n' "$out" | grep '^ERROR:' | sed 's/^/    /'
		fail=1
	fi
}

# expect_valid <case> <dir>
expect_valid() {
	local case_name="$1" dir="$2" out
	if ! out="$(bash "$VALIDATE" --no-cache "$dir" 2>&1)"; then
		echo "FAIL[$case_name]: expected the validator to accept an optional specification field. Got:"
		printf '%s\n' "$out" | grep '^ERROR:' | sed 's/^/    /'
		fail=1
	fi
}

long_text() { awk -v n="$1" 'BEGIN { s = ""; for (i = 0; i < n; i++) s = s "x"; printf "%s", s }'; }

d="$(seed_copy unknown-field)"
seed_replace "$d/SKILL.md" '^license:' "$(printf 'license: Apache-2.0\npriority: high')"
expect_finding "unknown field" "$d" "undeclared top-level key 'priority'"

d="$(seed_copy unknown-metadata)"
seed_replace "$d/SKILL.md" '^  usage:' "$(printf '  usage: "Not invoked directly."\n  dependencies: "none"')"
expect_finding "unknown metadata key" "$d" "undeclared metadata key 'metadata.dependencies'"

d="$(seed_copy allowed-tools)"
seed_replace "$d/SKILL.md" '^license:' "$(printf 'license: Apache-2.0\nallowed-tools: Read')"
expect_valid "allowed-tools accepted" "$d"

d="$(seed_copy compatibility)"
seed_replace "$d/SKILL.md" '^license:' "$(printf 'license: Apache-2.0\ncompatibility: "Requires git."')"
expect_valid "compatibility accepted" "$d"

d="$(seed_copy compatibility-long)"
seed_replace "$d/SKILL.md" '^license:' "$(printf 'license: Apache-2.0\ncompatibility: "%s"' "$(long_text 501)")"
expect_finding "compatibility over 500" "$d" "field 'compatibility' exceeds 500 characters"

d="$(seed_copy compatibility-empty)"
seed_replace "$d/SKILL.md" '^license:' "$(printf 'license: Apache-2.0\ncompatibility: ""')"
expect_finding "compatibility empty" "$d" "field 'compatibility' is shorter than the minimum 1"

d="$(seed_copy metadata-int)"
seed_replace "$d/SKILL.md" '^  usage:' '  usage: 42'
expect_finding "non-string metadata value" "$d" "field 'metadata.usage' must be a string (YAML reads it as int)"

d="$(seed_copy license-int)"
seed_replace "$d/SKILL.md" '^license:' 'license: 2026'
expect_finding "non-string field" "$d" "field 'license' must be a string (YAML reads it as int)"

d="$(seed_copy metadata-list)"
seed_replace "$d/SKILL.md" '^metadata:' 'metadata: [one]'
seed_replace "$d/SKILL.md" '^  ' ''
seed_replace "$d/SKILL.md" '^  ' ''
expect_finding "metadata not a mapping" "$d" "field 'metadata' must be a mapping"

long_id="a$(long_text 64 | tr x a)"
d="$(seed_copy name-long "$long_id")"
expect_finding "name over 64" "$d" "field 'name' exceeds 64 characters"

d="$(seed_copy name-upper)"
seed_replace "$d/SKILL.md" '^name:' 'name: Valid-Skill'
expect_finding "name uppercase" "$d" "does not match directory-derived id"

d="$(seed_copy name-double-hyphen valid--skill)"
expect_finding "name consecutive hyphens" "$d" "invalid id 'valid--skill'"

d="$(seed_copy name-trailing-hyphen valid-skill-)"
expect_finding "name trailing hyphen" "$d" "invalid id 'valid-skill-'"

d="$(seed_copy description-empty)"
seed_replace "$d/SKILL.md" '^description:' 'description: ""'
expect_finding "description empty" "$d" "missing required field 'description'"

d="$(seed_copy description-long)"
seed_replace "$d/SKILL.md" '^description:' "description: \"Use when testing. $(long_text 1010)\""
expect_finding "description over 1024" "$d" "field 'description' exceeds 1024 characters"

d="$(seed_copy license-missing)"
seed_replace "$d/SKILL.md" '^license:' ''
expect_finding "license missing" "$d" "missing required field 'license'"

d="$(seed_copy usage-missing)"
seed_replace "$d/SKILL.md" '^  usage:' ''
expect_finding "metadata.usage missing" "$d" "missing required field 'metadata.usage'"

d="$(seed_copy yaml-syntax)"
seed_replace "$d/SKILL.md" '^license:' 'license: [Apache-2.0'
expect_finding "YAML syntax error" "$d" "frontmatter is not valid YAML"

d="$(seed_copy duplicate-key)"
seed_replace "$d/SKILL.md" '^license:' "$(printf 'license: Apache-2.0\nlicense: Apache-2.0')"
expect_finding "duplicate key" "$d" "duplicate key 'license' in frontmatter"

d="$(seed_copy not-mapping)"
printf -- '---\n- valid-skill\n---\n\n' >"$d/SKILL.md"
expect_finding "frontmatter not a mapping" "$d" "frontmatter must be a YAML mapping"

d="$(seed_copy folded-description)"
seed_replace "$d/SKILL.md" '^description:' "$(printf 'description: >-\n  A folded description. Use when testing.')"
expect_finding "parser and line reader disagree" "$d" "field 'description' reads differently in a strict YAML parser"

d="$(seed_copy no-use-when)"
seed_replace "$d/SKILL.md" '^description:' 'description: "A fixture skill whose description omits the activation sentence."'
expect_finding "description without Use when" "$d" "[P5.15]"

d="$(seed_copy slash-invocation)"
printf '\n## Notes\n\nRun /highway-adr next.\n' >>"$d/SKILL.md"
if [[ -z "$(invocation_findings "$d")" ]]; then
	echo "FAIL[invocation prefix]: a /highway-adr line outside ## Example was not detected"
	fail=1
fi

d="$(seed_copy example-invocation)"
printf '\n`/highway-adr DISC3f2a9c10`\n' >>"$d/SKILL.md"
if [[ -n "$(invocation_findings "$d")" ]]; then
	echo "FAIL[invocation in Example]: a slash invocation inside ## Example was reported"
	fail=1
fi

# --- Retired features are gone ---------------------------------------------------------------------

for retired in "$HW_FRAMEWORK/frontmatter-lexicon.txt" "$HW_LIB/frontmatter-lexicon.sh" "$HW_LIB/dependency-check.sh"; do
	if [[ -e "$retired" ]]; then
		echo "FAIL: retired file still present: $(hw_rel "$retired")"
		fail=1
	fi
done
for fn in fm_get_dependencies fm_get_agent_exceptions dc_validate_dependencies fl_check_field sv_validate_agent_exceptions; do
	if grep -rqw -- "$fn" "$HW_FRAMEWORK"; then
		echo "FAIL: retired function still referenced under framework/: $fn"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then
	exit 1
fi
echo "PASS: every skill conforms to the Agent Skills format, and the validator rejects each seeded violation."
