#!/usr/bin/env bash
# Checks a plugin.json against the Agent Plugins 1.0.0 manifest rules. It reads the file with
# python3's standard-library json module, as a client's strict JSON parser reads it, and rejects a
# repeated key, which json would otherwise resolve silently to the last value. This and
# lib/yaml-frontmatter.sh are the only callers of python3 (development constitution, Declared
# Toolchain).

# The program prints one "ERROR: [MANIFEST] <field>: <problem> (Agent Plugins §<clause>)" line per
# finding. A file that is not JSON, or that repeats a key, yields one plugin.json finding.
readonly _PM_PROGRAM='
import json, re, sys

SCHEMA = "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json"
FIELDS = ("$schema", "name", "version", "description", "author", "homepage", "repository",
          "license", "keywords", "extensions")
STRINGS = ("version", "description", "homepage", "repository", "license")
AUTHOR = ("name", "email", "url")
NAME = re.compile(r"^[a-z0-9]([a-z0-9.-]{0,62}[a-z0-9])?$")

def finding(field, problem, clause):
    print("ERROR: [MANIFEST] %s: %s (Agent Plugins \u00a7%s)" % (field, problem, clause))

class Repeated(ValueError):
    pass

def pairs(items):
    seen = {}
    for key, value in items:
        if key in seen:
            raise Repeated("the key %r is repeated" % key)
        seen[key] = value
    return seen

def constant(name):
    raise ValueError("%s is not a JSON value" % name)

try:
    with open(sys.argv[1], encoding="utf-8") as f:
        data = json.load(f, object_pairs_hook=pairs, parse_constant=constant)
except Repeated as e:
    finding("plugin.json", str(e), "5.2")
    sys.exit(0)
except (ValueError, UnicodeDecodeError) as e:
    finding("plugin.json", "is not valid JSON: %s" % str(e).split("\n")[0], "5.2")
    sys.exit(0)

if not isinstance(data, dict):
    finding("plugin.json", "must hold one JSON object", "5.2")
    sys.exit(0)

for key in data:
    if key not in FIELDS:
        finding(key, "is not a manifest field", "5.2")

if "$schema" in data and data["$schema"] != SCHEMA:
    finding("$schema", "must be %s" % SCHEMA, "5.2")

name = data.get("name")
if "name" not in data:
    finding("name", "is required", "5.3")
elif not isinstance(name, str) or not NAME.match(name) or "--" in name or ".." in name:
    finding("name", "must be 1 to 64 characters from a-z, 0-9, hyphen, and period, start and end with a letter or digit, and hold no -- or ..", "5.5")

for key in STRINGS:
    if key in data and not isinstance(data[key], str):
        finding(key, "must be a string", "5.4")

if "keywords" in data:
    words = data["keywords"]
    if not isinstance(words, list) or not all(isinstance(w, str) for w in words):
        finding("keywords", "must be a list of strings", "5.4")

if "author" in data:
    author = data["author"]
    if not isinstance(author, dict):
        finding("author", "must be an object", "5.4")
    else:
        for key, value in author.items():
            if key not in AUTHOR:
                finding("author.%s" % key, "is not an author field; use name, email, or url", "5.4")
            elif not isinstance(value, str):
                finding("author.%s" % key, "must be a string", "5.4")

if "extensions" in data:
    extensions = data["extensions"]
    if not isinstance(extensions, dict):
        finding("extensions", "must be an object", "8.1")
    else:
        for key, value in extensions.items():
            if not isinstance(value, dict):
                finding("extensions.%s" % key, "must be an object", "8.1")
'

# Prints one ERROR line per manifest finding in <file>. Returns 0 when there is none, 1 when there
# is any, and 2 when python3 is unavailable.
# Usage: pm_check <file>
pm_check() {
	local file="$1" out
	if ! command -v python3 >/dev/null 2>&1; then
		return 2
	fi
	out="$(python3 -c "$_PM_PROGRAM" "$file" 2>/dev/null)" || return 2
	[[ -z "$out" ]] && return 0
	printf '%s\n' "$out"
	return 1
}
