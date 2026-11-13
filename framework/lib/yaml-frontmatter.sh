#!/usr/bin/env bash
# Parses a SKILL.md frontmatter block with a strict YAML parser: python3 with PyYAML. This and
# lib/plugin-manifest.sh are the only callers of python3 (development constitution, Declared
# Toolchain). The line
# readers in lib/frontmatter.sh stay the fast path; the validator compares the two.

# The program prints one line per field: scope<TAB>key<TAB>type<TAB>value. scope is "top" or
# "metadata"; type is the YAML type the value resolves to; value has backslash, newline, and tab
# escaped. A parse failure prints one "ERROR: [SCHEMA] ..." line and exits 1.
readonly _YF_PROGRAM='
import sys, datetime
try:
    import yaml
except ImportError:
    sys.exit(3)

class Loader(yaml.SafeLoader):
    pass

def mapping(loader, node, deep=False):
    seen = set()
    for key_node, _ in node.value:
        key = loader.construct_object(key_node, deep=deep)
        if key in seen:
            raise yaml.YAMLError("duplicate key %r" % (key,))
        seen.add(key)
    return loader.construct_mapping(node, deep=deep)

Loader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, mapping)

def kind(v):
    if isinstance(v, bool): return "bool"
    if isinstance(v, int): return "int"
    if isinstance(v, float): return "float"
    if v is None: return "null"
    if isinstance(v, (datetime.date, datetime.datetime)): return "date"
    if isinstance(v, str): return "str"
    if isinstance(v, dict): return "map"
    if isinstance(v, list): return "list"
    return "other"

def esc(v):
    if not isinstance(v, str): v = "" if isinstance(v, (dict, list)) or v is None else str(v)
    return v.replace("\\", "\\\\").replace("\n", "\\n").replace("\t", "\\t")

def fail(msg):
    print("ERROR: [SCHEMA] " + msg)
    sys.exit(1)

lines = sys.stdin.read().split("\n")
if not lines or lines[0].rstrip() != "---":
    fail("SKILL.md must start with a frontmatter block between two \x27---\x27 lines")
end = next((i for i in range(1, len(lines)) if lines[i].rstrip() == "---"), None)
if end is None:
    fail("SKILL.md must start with a frontmatter block between two \x27---\x27 lines")
try:
    data = yaml.load("\n".join(lines[1:end]), Loader=Loader)
except yaml.YAMLError as e:
    msg = str(e).split("\n")[0]
    if msg.startswith("duplicate key "):
        fail("duplicate key %s in frontmatter" % msg[len("duplicate key "):].replace("\"", "\x27"))
    problem = getattr(e, "problem", None) or msg
    mark = getattr(e, "problem_mark", None)
    if mark is not None:
        problem += " (line %d)" % (mark.line + 2)
    fail("frontmatter is not valid YAML: " + problem)
if not isinstance(data, dict):
    fail("frontmatter must be a YAML mapping")
for k, v in data.items():
    print("top\t%s\t%s\t%s" % (esc(k), kind(v), esc(v)))
    if k == "metadata" and isinstance(v, dict):
        for mk, mv in v.items():
            print("metadata\t%s\t%s\t%s" % (esc(mk), kind(mv), esc(mv)))
'

# Prints the parsed fields of <file>'s frontmatter, or one ERROR line. Returns 1 on any failure.
# Usage: yf_parse <file>
yf_parse() {
	local file="$1" out status
	out="$(python3 -c "$_YF_PROGRAM" < "$file" 2>/dev/null)"
	status=$?
	if [[ $status -eq 3 || $status -eq 127 ]] || ! command -v python3 >/dev/null 2>&1; then
		echo "ERROR: [SCHEMA] the YAML parser is unavailable: framework/validate-skill.sh needs python3 with the PyYAML module"
		return 1
	fi
	printf '%s\n' "$out"
	[[ $status -eq 0 ]]
}

# Prints the type of one parsed field, or nothing when it is absent.
# Usage: yf_type <parsed> <scope> <key>
yf_type() {
	printf '%s\n' "$1" | awk -F'\t' -v s="$2" -v k="$3" '$1 == s && $2 == k { print $3; exit }'
}

# Prints the unescaped value of one parsed field, or nothing when it is absent.
# Usage: yf_value <parsed> <scope> <key>
yf_value() {
	printf '%s\n' "$1" | awk -F'\t' -v s="$2" -v k="$3" '
		$1 == s && $2 == k {
			v = ""; s4 = $4
			for (i = 1; i <= length(s4); i++) {
				c = substr(s4, i, 1)
				if (c == "\\" && i < length(s4)) {
					i++; c = substr(s4, i, 1)
					if (c == "n") c = "\n"; else if (c == "t") c = "\t"
				}
				v = v c
			}
			printf "%s", v; exit
		}'
}

# Prints the keys parsed at one scope, one per line, in file order.
# Usage: yf_keys <parsed> <scope>
yf_keys() {
	printf '%s\n' "$1" | awk -F'\t' -v s="$2" '$1 == s { print $2 }'
}
