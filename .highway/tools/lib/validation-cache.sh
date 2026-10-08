#!/usr/bin/env bash
# Content-addressed record of successful skill validations.
#
# A record is keyed by the skill's content combined with a hash of everything validation depends
# on -- the validator, its libraries, and the governing documents. A hit means "these exact inputs
# already produced a successful verdict", so re-deriving that verdict is wasted work.
#
# The cache deliberately makes no claim about whether validation is *correct*. It asserts only
# that identical inputs yield an identical verdict, so any defect in the validator is preserved
# exactly rather than hidden. A skill edited to introduce a violation hashes differently and is
# validated in full.
#
# Failed validations are never recorded, so a defective skill is re-reported on every invocation.

# Prints the cache directory, or nothing when no usable directory exists.
#
# Held outside the repository so it needs no ignore entry and cannot be packaged. A cache path
# that somehow resolves inside the tree is refused rather than used.
#
# The cache also refuses to operate when any document override is set. An override repoints
# validation at a different constitution, lexicon, or manifest, so a key derived from the
# repository's own documents would name a verdict that was never reached under them.
vc_dir() {
	local repo_root="$1" base dir
	if [[ -n "${CONSTITUTION_FILE:-}" || -n "${EXPERIENCE_FILE:-}" \
		|| -n "${FRONTMATTER_CONTRACT_FILE:-}" || -n "${FRONTMATTER_LEXICON_FILE:-}" ]]; then
		return 0
	fi
	base="${TMPDIR:-/tmp}"
	base="${base%/}"
	dir="$base/highway-validation-cache"
	case "$dir" in
		"$repo_root"/*) return 0 ;;
	esac
	mkdir -p "$dir" 2>/dev/null || return 0
	[[ -w "$dir" ]] || return 0
	printf '%s' "$dir"
}

# Hashes stdin.
vc_hash_stdin() {
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum | awk '{print $1}'
	else
		shasum -a 256 | awk '{print $1}'
	fi
}

# Hashes one file.
vc_hash_file() {
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$1" | awk '{print $1}'
	else
		shasum -a 256 "$1" | awk '{print $1}'
	fi
}

# Hashes a newline-separated list of paths read from stdin.
vc_hash_list() {
	if command -v sha256sum >/dev/null 2>&1; then
		xargs sha256sum
	else
		xargs shasum -a 256
	fi
}

VC_ENVIRONMENT_HASH=""

# Prints a hash of every input validation consults other than the skill itself.
#
# Editing any governance document, any validator library, or any library content changes this and
# so invalidates every skill's record at once. That is the intended behavior: a constitution
# change can turn a previously valid skill invalid.
#
# Every file under these directories is hashed regardless of extension. An earlier draft filtered
# to `*.sh` and `*.md` and silently excluded two real inputs -- the frontmatter lexicon, which is a
# `.txt`, and the contract manifest, which is a dotfile -- either of which could have changed a
# verdict without changing the key.
vc_environment_hash() {
	local highway_root="$1"
	if [[ -n "$VC_ENVIRONMENT_HASH" ]]; then
		printf '%s' "$VC_ENVIRONMENT_HASH"
		return 0
	fi
	VC_ENVIRONMENT_HASH="$(
		{
			printf '%s\n' "$highway_root/tools/validate-skill.sh"
			printf '%s\n' "$highway_root/tools/.frontmatter-contract"
			find "$highway_root/tools/lib" "$highway_root/library" "$highway_root/governance" \
				-type f 2>/dev/null
		} | sort | vc_hash_list | vc_hash_stdin
	)"
	printf '%s' "$VC_ENVIRONMENT_HASH"
}

# Prints the record key for one skill file.
vc_key() {
	local skill_file="$1" highway_root="$2" skill_hash env_hash
	skill_hash="$(vc_hash_file "$skill_file")"
	env_hash="$(vc_environment_hash "$highway_root")"
	printf '%s%s' "$skill_hash" "$env_hash" | vc_hash_stdin
}

# Replays a recorded report on stdout and returns 0, or returns 1 on a miss.
#
# The report is replayed rather than regenerated because callers parse this output; a hit that
# printed nothing would be observably different from a full run and would break them.
vc_lookup() {
	local dir="$1" key="$2" record
	[[ -n "$dir" && -n "$key" ]] || return 1
	record="$dir/$key"
	[[ -f "$record" && -r "$record" ]] || return 1
	cat "$record" 2>/dev/null || return 1
	return 0
}

# Records a successful verdict.
#
# Written to a temporary name and moved into place, so a reader never sees a half-written report.
# Concurrent writers of the same key write identical bytes, so no lock is needed.
vc_record() {
	local dir="$1" key="$2" report="$3" tmp
	[[ -n "$dir" && -n "$key" ]] || return 0
	tmp="$(mktemp "$dir/.writing.XXXXXX" 2>/dev/null)" || return 0
	printf '%s' "$report" >"$tmp" 2>/dev/null || { rm -f "$tmp"; return 0; }
	mv "$tmp" "$dir/$key" 2>/dev/null || rm -f "$tmp"
	return 0
}
