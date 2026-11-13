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

[[ -n "${HW_ROOT:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/paths.sh"

# Prints the cache directory, or nothing when no usable directory exists.
#
# Held outside the repository so it needs no ignore entry and cannot be packaged. A cache path
# that somehow resolves inside the tree is refused rather than used.
#
# The cache also refuses to operate when any document override is set. An override repoints
# validation at a different constitution, experience standard, or manifest, so a key derived from the
# repository's own documents would name a verdict that was never reached under them.
vc_dir() {
	local repo_root="$1" base dir
	if [[ -n "${CONSTITUTION_FILE:-}" || -n "${EXPERIENCE_FILE:-}" \
		|| -n "${FRONTMATTER_CONTRACT_FILE:-}" ]]; then
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

# Succeeds when $1 is a SHA-256 hash: 64 lowercase hex characters.
vc_is_hash() {
	[[ "$1" =~ ^[0-9a-f]{64}$ ]]
}

# Hashes each existing file in a newline-separated list of paths read from stdin, printing one
# `<hash>  <path>` line per file. A path that names no file is skipped. The paths are passed as
# arguments rather than through xargs, which fails in some sandboxes. Prints nothing and returns 1
# unless every file was hashed: a failure that still printed would leave inputs out of the key and
# let two skills share one.
vc_hash_list() {
	local paths=() path out
	while IFS= read -r path; do
		[[ -f "$path" ]] && paths+=("$path")
	done
	[[ ${#paths[@]} -gt 0 ]] || return 1
	if command -v sha256sum >/dev/null 2>&1; then
		out="$(sha256sum "${paths[@]}" 2>/dev/null)" || return 1
	else
		out="$(shasum -a 256 "${paths[@]}" 2>/dev/null)" || return 1
	fi
	[[ "$(printf '%s\n' "$out" | grep -cE '^[0-9a-f]{64} ')" -eq ${#paths[@]} ]] || return 1
	printf '%s\n' "$out"
}

# Prints each other skill a cross-skill handoff in this skill names, once. Its steps decide the
# Handoff integrity rule, so its files are inputs to this skill's verdict.
vc_handoff_targets() {
	local skill_dir="$1"
	cat "$skill_dir/SKILL.md" "$skill_dir"/references/*.md 2>/dev/null \
		| grep -oE 'in `highway-[a-z0-9-]+`' | sed -E 's/^in `//; s/`$//' \
		| grep -vxF "$(basename "$skill_dir")" | LC_ALL=C sort -u
}

VC_ENVIRONMENT_HASH=""

# Prints a hash of every input validation consults other than the skill itself.
#
# Editing any governance document or any validator library changes this and
# so invalidates every skill's record at once. That is the intended behavior: a constitution
# change can turn a previously valid skill invalid.
#
# Every file under these directories is hashed regardless of extension. An earlier draft filtered
# to `*.sh` and `*.md` and silently excluded a real input -- the contract manifest, which is a
# dotfile -- which could have changed a verdict without changing the key.
#
# Prints nothing and returns 1 when any input cannot be hashed. A failure is not memoised.
vc_environment_hash() {
	local root="$1" listing hash
	if [[ -n "$VC_ENVIRONMENT_HASH" ]]; then
		printf '%s' "$VC_ENVIRONMENT_HASH"
		return 0
	fi
	listing="$(
		{
			printf '%s\n' "$(hw_at "$root" "$HW_FRAMEWORK")/validate-skill.sh"
			printf '%s\n' "$(hw_at "$root" "$HW_FRAMEWORK")/.frontmatter-contract"
			hw_at "$root" "$(hw_doc constitution)"
			hw_at "$root" "$(hw_doc experience-standard)"
			find "$(hw_at "$root" "$HW_LIB")" -type f 2>/dev/null
		} | sort | vc_hash_list
	)" || return 1
	hash="$(printf '%s\n' "$listing" | vc_hash_stdin)"
	vc_is_hash "$hash" || return 1
	VC_ENVIRONMENT_HASH="$hash"
	printf '%s' "$hash"
}

# Prints the record key for one skill file, or nothing and returns 1 when any input cannot be
# hashed. A caller with no key validates in full and records nothing.
vc_key() {
	local skill_file="$1" root="$2" skill_dir skills_root listing skill_hash env_hash key
	skill_dir="$(dirname "$skill_file")"
	skills_root="$(dirname "$skill_dir")"
	# The skill's assets/ and references/ are inputs too: validate-skill.sh checks the files there.
	# So are the SKILL.md and references/ of each skill a handoff names. Each path is kept relative
	# to the skills folder: the verdict depends on the skill's folder name, which its name must
	# match, but not on where the skills folder sits.
	listing="$(
		{
			printf '%s\n' "$skill_file"
			find "$skill_dir/assets" "$skill_dir/references" -type f 2>/dev/null | LC_ALL=C sort
			vc_handoff_targets "$skill_dir" | while IFS= read -r target; do
				printf '%s\n' "$skills_root/$target/SKILL.md"
				find "$skills_root/$target/references" -type f 2>/dev/null | LC_ALL=C sort
			done
		} | vc_hash_list
	)" || return 1
	skill_hash="$(printf '%s\n' "$listing" | awk -v p="$skills_root/" '{
		path = $2
		if (index(path, p) == 1) path = substr(path, length(p) + 1)
		print $1, path
	}' | vc_hash_stdin)"
	env_hash="$(vc_environment_hash "$root")" || return 1
	vc_is_hash "$skill_hash" && vc_is_hash "$env_hash" || return 1
	key="$(printf '%s%s' "$skill_hash" "$env_hash" | vc_hash_stdin)"
	vc_is_hash "$key" || return 1
	printf '%s' "$key"
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
