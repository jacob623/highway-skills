#!/usr/bin/env bash
# Reads, renders, and checks the plugin's manifests:
#
#   - pm_check checks a plugin.json against the Agent Plugins 1.0.0 manifest rules;
#   - pm_listing_check checks framework/plugin/listing.json, the fields only one agent reads;
#   - pm_render writes the five agent manifests from plugin.json and the listing file;
#   - pm_check_agents checks a plugin folder's agent manifests and its closed list of entries.
#
# Every file is read with python3's standard-library json module, as a client's strict JSON parser
# reads it, rejecting a repeated key, which json would otherwise resolve silently to the last
# value. This and lib/yaml-frontmatter.sh are the only callers of python3 (development
# constitution, Declared Toolchain).

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

# The agent formats: each manifest's path, leading constants, shared keys (and the author keys it
# accepts), trailing constants, and listing fields in output order. The renderer and the checks
# both read this one table, so they cannot disagree on a field list. A listing field typed None is
# derived from plugin.json and never read from the listing file.
readonly _PM_AGENTS='
import json, os, re, sys

SHARED = ("name", "version", "description", "author", "homepage", "repository", "license", "keywords")
AUTHOR = ("name", "email", "url")
ANTIGRAVITY_SCHEMA = "https://antigravity.google/schemas/v1/plugin.json"
TEXT = "a string"
TEXTS = "a list of strings"
DERIVED = {"developerName": ("author", "name"), "websiteURL": ("homepage", None)}
CODEX_INTERFACE = (("displayName", TEXT), ("shortDescription", TEXT), ("longDescription", TEXT),
                   ("developerName", None), ("category", TEXT), ("capabilities", TEXTS),
                   ("websiteURL", None), ("defaultPrompt", TEXTS), ("brandColor", TEXT),
                   ("privacyPolicyURL", TEXT), ("termsOfServiceURL", TEXT), ("composerIcon", TEXT),
                   ("logo", TEXT), ("screenshots", TEXTS))
FORMATS = (
    {"agent": "claude", "path": ".claude-plugin/plugin.json", "lead": (), "shared": SHARED,
     "author": AUTHOR, "trail": (), "listing": None, "required": ("name",)},
    {"agent": "codex", "path": ".codex-plugin/plugin.json", "lead": (), "shared": SHARED,
     "author": AUTHOR, "trail": (("skills", "./skills/"),),
     "listing": (("interface", CODEX_INTERFACE),),
     "required": ("name", "interface.displayName", "interface.shortDescription",
                  "interface.developerName", "interface.category")},
    {"agent": "cursor", "path": ".cursor-plugin/plugin.json", "lead": (), "shared": SHARED,
     "author": ("name", "email"), "trail": (("skills", "./skills/"),),
     "listing": (("logo", TEXT),), "required": ("name",)},
    {"agent": "antigravity", "path": ".antigravity-plugin/plugin.json",
     "lead": (("$schema", ANTIGRAVITY_SCHEMA),), "shared": SHARED, "author": AUTHOR, "trail": (),
     "listing": (("displayName", TEXT), ("logo", TEXT), ("suggestedPrompts", TEXTS)),
     "required": ("name",)},
    {"agent": "gemini", "path": "gemini-extension.json", "lead": (),
     "shared": ("name", "version", "description"), "author": (), "trail": (), "listing": None,
     "required": ("name", "version", "description")},
)
LISTING_AGENTS = tuple(f["agent"] for f in FORMATS if f["listing"])
LIMITS = {"antigravity.suggestedPrompts": 3}
LOGO_FIELDS = ("logo", "composerIcon")
IMAGES = (".png", ".svg", ".jpg", ".jpeg", ".webp")
ANTIGRAVITY_NAME = re.compile(r"^[a-zA-Z0-9_-]+$")

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

def load(path):
    try:
        with open(path, encoding="utf-8") as f:
            data = json.load(f, object_pairs_hook=pairs, parse_constant=constant)
    except FileNotFoundError:
        return None, "is missing"
    except Repeated as e:
        return None, str(e)
    except (OSError, ValueError, UnicodeDecodeError) as e:
        return None, "is not valid JSON: %s" % str(e).split("\n")[0]
    if not isinstance(data, dict):
        return None, "must hold one JSON object"
    return data, None

def has_type(value, kind):
    if kind == TEXT:
        return isinstance(value, str)
    return isinstance(value, list) and all(isinstance(v, str) for v in value)

def shared_value(fmt, key, root):
    value = root[key]
    if key == "author" and isinstance(value, dict):
        value = dict((k, value[k]) for k in fmt["author"] if k in value)
    return value

def derived_value(field, root):
    key, sub = DERIVED[field]
    value = root.get(key)
    if sub is not None:
        value = value.get(sub) if isinstance(value, dict) else None
    return value

def render_one(fmt, root, listing):
    out = {}
    for key, value in fmt["lead"]:
        out[key] = value
    for key in fmt["shared"]:
        if key in root:
            out[key] = shared_value(fmt, key, root)
    for key, value in fmt["trail"]:
        out[key] = value
    entry = listing.get(fmt["agent"], {})
    for key, kind in fmt["listing"] or ():
        if isinstance(kind, tuple):
            source = entry.get(key, {})
            block = {}
            for sub, subkind in kind:
                if subkind is None:
                    value = derived_value(sub, root)
                    if value is not None:
                        block[sub] = value
                elif sub in source:
                    block[sub] = source[sub]
            if block:
                out[key] = block
        elif key in entry:
            out[key] = entry[key]
    return out

def listing_findings(root_path, listing_path):
    found = []
    def finding(field, problem):
        found.append("ERROR: [LISTING] %s: %s" % (field, problem))
    root, problem = load(root_path)
    if problem:
        finding("plugin.json", problem)
    listing, problem = load(listing_path)
    if problem:
        finding("listing.json", problem)
        return found, root, listing
    formats = dict((f["agent"], f) for f in FORMATS)
    for agent, entry in listing.items():
        if agent not in LISTING_AGENTS:
            finding(agent, "is not an agent with listing fields; use %s" % ", ".join(LISTING_AGENTS))
            continue
        if not isinstance(entry, dict):
            finding(agent, "must be an object")
            continue
        allowed = dict(formats[agent]["listing"])
        for field, value in entry.items():
            name = "%s.%s" % (agent, field)
            if field in SHARED:
                finding(name, "is a shared field; keep it in plugin.json")
            elif field not in allowed:
                finding(name, "is not a listing field for %s" % agent)
            elif isinstance(allowed[field], tuple):
                if not isinstance(value, dict):
                    finding(name, "must be an object")
                    continue
                subs = dict(allowed[field])
                for sub, subvalue in value.items():
                    subname = "%s.%s" % (name, sub)
                    if sub in DERIVED:
                        finding(subname, "is derived from %s in plugin.json; remove it" % (
                            ".".join(k for k in DERIVED[sub] if k)))
                    elif sub not in subs:
                        finding(subname, "is not a listing field for %s" % agent)
                    elif not has_type(subvalue, subs[sub]):
                        finding(subname, "must be %s" % subs[sub])
            elif not has_type(value, allowed[field]):
                finding(name, "must be %s" % allowed[field])
            elif name in LIMITS and len(value) > LIMITS[name]:
                finding(name, "must hold at most %d entries" % LIMITS[name])
    return found, root, listing

def render(root_path, listing_path, dest):
    found, root, listing = listing_findings(root_path, listing_path)
    if found:
        print("\n".join(found))
        return 1
    for fmt in FORMATS:
        path = os.path.join(dest, fmt["path"])
        os.makedirs(os.path.dirname(path) or dest, exist_ok=True)
        text = json.dumps(render_one(fmt, root, listing), indent=2, ensure_ascii=False) + "\n"
        with open(path, "w", encoding="utf-8", newline="\n") as f:
            f.write(text)
    return 0

def check(plugin, skills_rel):
    found = []
    root, problem = load(os.path.join(plugin, "plugin.json"))
    named = set()

    def logo(path, field, value):
        name = "[AGENT] %s: %s" % (path, field)
        if not isinstance(value, str):
            found.append("ERROR: %s: must be a string" % name)
            return
        rel = value[2:] if value.startswith("./") else value
        if value.startswith("/") or ".." in rel.split("/"):
            found.append("ERROR: %s: must be a relative path inside the plugin" % name)
        elif not rel.lower().endswith(IMAGES):
            found.append("ERROR: %s: must name a %s image" % (name, ", ".join(IMAGES)))
        elif os.path.islink(os.path.join(plugin, rel)) or not os.path.isfile(os.path.join(plugin, rel)):
            found.append("ERROR: %s: names %s, which is not a file in the plugin" % (name, value))
        else:
            named.add(rel)

    for fmt in FORMATS:
        path = fmt["path"]
        def finding(field, problem):
            found.append("ERROR: [AGENT] %s: %s: %s" % (path, field, problem))
        data, problem = load(os.path.join(plugin, path))
        if problem:
            found.append("ERROR: [AGENT] %s: %s" % (path, problem))
            continue
        listing = dict(fmt["listing"] or ())
        allowed = [k for k, _ in fmt["lead"]] + list(fmt["shared"]) + [k for k, _ in fmt["trail"]] + list(listing)
        for key in data:
            if key not in allowed:
                finding(key, "is not accepted in this manifest")
        required = set(r for r in fmt["required"] if "." not in r)
        if root is not None:
            required.update(k for k in fmt["shared"] if k in root)
        for key in [k for k in allowed if k in required and k not in data]:
            finding(key, "is required")
        if root is not None:
            for key in fmt["shared"]:
                if key in root and key in data and data[key] != shared_value(fmt, key, root):
                    finding(key, "must equal %s in plugin.json" % key)
        for key, value in fmt["lead"]:
            if key in data and data[key] != value:
                finding(key, "must be %s" % value)
            elif key not in data:
                finding(key, "is required")
        for key, value in fmt["trail"]:
            if key == "skills":
                given = data.get(key)
                rel = given[2:] if isinstance(given, str) and given.startswith("./") else given
                if not isinstance(rel, str) or rel.rstrip("/") != skills_rel or not os.path.isdir(os.path.join(plugin, skills_rel)):
                    finding(key, "must lead to the skills folder, ./%s/" % skills_rel)
        if fmt["agent"] == "antigravity" and isinstance(data.get("name"), str) and not ANTIGRAVITY_NAME.match(data["name"]):
            finding("name", "must match ^[a-zA-Z0-9_-]+$")
        for key, kind in listing.items():
            if key not in data:
                continue
            value = data[key]
            if isinstance(kind, tuple):
                if not isinstance(value, dict):
                    finding(key, "must be an object")
                    continue
                subs = dict(kind)
                for sub, subvalue in value.items():
                    if sub not in subs:
                        finding("%s.%s" % (key, sub), "is not accepted in this manifest")
                    elif subs[sub] is not None and not has_type(subvalue, subs[sub]):
                        finding("%s.%s" % (key, sub), "must be %s" % subs[sub])
                    elif sub in LOGO_FIELDS:
                        logo(path, "%s.%s" % (key, sub), subvalue)
                for req in fmt["required"]:
                    if req.startswith(key + ".") and req.split(".", 1)[1] not in value:
                        finding(req, "is required")
                if root is not None:
                    for sub in DERIVED:
                        expected = derived_value(sub, root)
                        if sub in value and value[sub] != expected:
                            finding("%s.%s" % (key, sub), "must equal %s in plugin.json" % ".".join(k for k in DERIVED[sub] if k))
            elif not has_type(value, kind):
                finding(key, "must be %s" % kind)
            else:
                limit = LIMITS.get("%s.%s" % (fmt["agent"], key))
                if limit is not None and len(value) > limit:
                    finding(key, "must hold at most %d entries" % limit)
                if key in LOGO_FIELDS:
                    logo(path, key, value)
        if "interface" in listing and "interface" not in data:
            finding("interface", "is required")

    folders = sorted(set(f["path"].split("/")[0] for f in FORMATS if "/" in f["path"]))
    # Marketplace catalogs ship beside agent overlays (Phase 10 / publish-public-install).
    marketplaces = {
        ".cursor-plugin": set(["plugin.json", "marketplace.json"]),
        ".claude-plugin": set(["plugin.json", "marketplace.json"]),
        ".codex-plugin": set(["plugin.json"]),
        ".antigravity-plugin": set(["plugin.json"]),
        ".agents": set(["plugins"]),
        ".github": set(["plugin"]),
    }
    shipped = set(["plugin.json", "README.md", "LICENSE", skills_rel, "assets",
                   ".agents", ".github"] + folders +
                  [f["path"] for f in FORMATS if "/" not in f["path"]])
    for entry in sorted(os.listdir(plugin)):
        if entry not in shipped:
            found.append("ERROR: [LAYOUT] %s: is not in the shipped set" % entry)
    for folder in folders:
        if os.path.isdir(os.path.join(plugin, folder)):
            allowed = marketplaces.get(folder, set(["plugin.json"]))
            for entry in sorted(os.listdir(os.path.join(plugin, folder))):
                if entry not in allowed:
                    found.append("ERROR: [LAYOUT] %s/%s: is not in the shipped set" % (folder, entry))
    agents_plugins = os.path.join(plugin, ".agents", "plugins")
    if os.path.isdir(agents_plugins):
        for entry in sorted(os.listdir(agents_plugins)):
            if entry != "marketplace.json":
                found.append("ERROR: [LAYOUT] .agents/plugins/%s: is not in the shipped set" % entry)
    elif os.path.isdir(os.path.join(plugin, ".agents")):
        found.append("ERROR: [LAYOUT] .agents/plugins: is missing")
    github_plugin = os.path.join(plugin, ".github", "plugin")
    if os.path.isdir(github_plugin):
        for entry in sorted(os.listdir(github_plugin)):
            if entry != "marketplace.json":
                found.append("ERROR: [LAYOUT] .github/plugin/%s: is not in the shipped set" % entry)
    elif os.path.isdir(os.path.join(plugin, ".github")):
        found.append("ERROR: [LAYOUT] .github/plugin: is missing")
    assets = os.path.join(plugin, "assets")
    if os.path.isdir(assets) and not os.path.islink(assets):
        for base, dirs, files in os.walk(assets):
            dirs.sort()
            for name in sorted(files):
                rel = os.path.relpath(os.path.join(base, name), plugin)
                if rel not in named:
                    found.append("ERROR: [LAYOUT] %s: is not named by any manifest" % rel)
    if found:
        print("\n".join(found))
    return 1 if found else 0

def main(mode, args):
    if mode == "listing":
        found = listing_findings(args[0], args[1])[0]
        if found:
            print("\n".join(found))
        return 1 if found else 0
    if mode == "render":
        return render(args[0], args[1], args[2])
    return check(args[0], args[1])

try:
    sys.exit(main(sys.argv[1], sys.argv[2:]))
except Exception as e:
    print("ERROR: the manifest program failed: %s" % e)
    sys.exit(2)
'

# Runs the agent program. Returns its status: 0 for no finding, 1 for a finding, and 2 when python3
# is unavailable or the program fails.
_pm_agents() {
	local out status
	if ! command -v python3 >/dev/null 2>&1; then
		return 2
	fi
	out="$(python3 -c "$_PM_AGENTS" "$@" 2>/dev/null)"
	status=$?
	[[ -n "$out" ]] && printf '%s\n' "$out"
	[[ $status -le 1 ]] && return $status
	return 2
}

# Prints one "ERROR: [LISTING] <agent>.<field>: <problem>" line per finding in the listing file,
# including a shared field it repeats or a field the generator derives.
# Usage: pm_listing_check <plugin.json> <listing.json>
pm_listing_check() {
	_pm_agents listing "$1" "$2"
}

# Writes the five agent manifests under <dest>, in a fixed key order with two-space indentation.
# Writes nothing and prints the findings when the listing check fails.
# Usage: pm_render <plugin.json> <listing.json> <dest>
pm_render() {
	_pm_agents render "$1" "$2" "$3"
}

# Prints one "ERROR: [AGENT] <manifest>: ..." line per finding in a plugin folder's agent manifests,
# then one "ERROR: [LAYOUT] <path>: ..." line per entry outside the closed list.
# Usage: pm_check_agents <plugin-dir> <skills folder, relative to the plugin>
pm_check_agents() {
	_pm_agents check "$1" "$2"
}
