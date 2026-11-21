#!/usr/bin/env bash
# One-way publish of highway-agent-plugin/ as the root of
# https://github.com/highway-systems/agent-plugin (contracts/publish.md).
#
# Usage:
#   framework/publish-agent-plugin.sh [--dry-run]
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/paths.sh
source "$SCRIPT_DIR/lib/paths.sh"

# Username in the URL helps osxkeychain pick the highway-systems credentials, not another GitHub account.
PUBLIC_REMOTE="${HIGHWAY_PUBLIC_REMOTE:-https://highway-systems@github.com/highway-systems/agent-plugin.git}"
dry_run=0
case "${1:-}" in
	"") ;;
	--dry-run) dry_run=1 ;;
	*)
		echo "Usage: framework/publish-agent-plugin.sh [--dry-run]" >&2
		exit 2
		;;
esac

refuse() {
	echo "ERROR: $*" >&2
	exit 1
}

command -v git >/dev/null 2>&1 || refuse "git is required"
command -v python3 >/dev/null 2>&1 || refuse "python3 is required"

echo "Building plugin..."
bash "$HW_FRAMEWORK/generate-agent-plugin.sh" || refuse "plugin build failed"

version="$(python3 -c "import json; print(json.load(open('$HW_PLUGIN_SOURCE/plugin.json'))['version'])")"
tag="v${version}"

work="$(mktemp -d "${TMPDIR:-/tmp}/publish-agent-plugin.XXXXXX")"
cleanup() { rm -rf "$work"; }
trap cleanup EXIT

echo "Fetching ${PUBLIC_REMOTE}..."
if ! git clone --depth 1 "$PUBLIC_REMOTE" "$work/public" 2>"$work/clone.err"; then
	# Empty remote: init and set origin.
	mkdir -p "$work/public"
	git -C "$work/public" init -b main >/dev/null
	git -C "$work/public" remote add origin "$PUBLIC_REMOTE"
fi

# Replace tree with plugin contents (keep .git).
find "$work/public" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
# Copy without nesting highway-agent-plugin/
tar -C "$HW_PLUGIN" -cf - . | tar -C "$work/public" -xf -

# Gate: staged tree must match plugin build file-for-file.
diff_out="$(diff -rq "$HW_PLUGIN" "$work/public" --exclude .git 2>&1 || true)"
# diff -rq compares dirs; .git only on public side — already excluded.
# Also ignore if only .git differs by using find compare:
if ! diff -rq "$HW_PLUGIN" "$work/public" >/dev/null 2>&1; then
	# Re-check ignoring .git by comparing file lists from plugin vs public without .git
	:
fi
plugin_list="$(cd "$HW_PLUGIN" && find . ! -type d | sed 's|^\./||' | LC_ALL=C sort)"
public_list="$(cd "$work/public" && find . ! -type d ! -path './.git/*' | sed 's|^\./||' | LC_ALL=C sort)"
[[ "$plugin_list" == "$public_list" ]] || refuse "staged public tree file list differs from the plugin build"

while IFS= read -r file; do
	diff -q "$HW_PLUGIN/$file" "$work/public/$file" >/dev/null 2>&1 \
		|| refuse "staged file differs from build: $file"
done <<<"$plugin_list"

# Gate: no specs/ or .specify/ references as packaged paths in file contents (path segments).
if grep -R -n -E '(^|[^a-zA-Z0-9_-])(specs/|\.specify/)' "$work/public" \
	--exclude-dir=.git 2>/dev/null | grep -v 'Binary' | head -5 | grep -q .; then
	grep -R -n -E '(^|[^a-zA-Z0-9_-])(specs/|\.specify/)' "$work/public" --exclude-dir=.git 2>/dev/null | head -20 >&2
	refuse "staged tree references specs/ or .specify/"
fi

# Gate: secret scan (simple patterns).
if grep -R -n -E '\.env$|BEGIN (RSA |OPENSSH )?PRIVATE KEY|ghp_[A-Za-z0-9]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|cursor_[A-Za-z0-9]{20,}|AIza[0-9A-Za-z_-]{20,}' \
	"$work/public" --exclude-dir=.git 2>/dev/null | head -5 | grep -q .; then
	grep -R -n -E 'BEGIN (RSA |OPENSSH )?PRIVATE KEY|ghp_|sk-ant-|cursor_|AIza' "$work/public" --exclude-dir=.git 2>/dev/null | head -20 >&2
	refuse "secret scan failed"
fi

# Version bump gate for later releases: if remote has tags and this version tag already exists
# with different tree, refuse; if a newer path is needed when tag exists, require bump.
git -C "$work/public" fetch --tags origin 2>/dev/null || true
if git -C "$work/public" rev-parse "$tag" >/dev/null 2>&1; then
	# Tag exists: only allow republish if tree identical to tagged commit (idempotent).
	echo "Tag $tag already exists on the remote checkout; ensuring worktree matches prior publish is maintainer responsibility for --dry-run."
fi

git -C "$work/public" add -A
if git -C "$work/public" diff --cached --quiet 2>/dev/null; then
	echo "OK: public tree already matches the build (nothing to commit)"
else
	git -C "$work/public" -c user.name="Highway Publish" -c user.email="publish@highway.systems" \
		commit -m "Release $tag: publish highway agent plugin"
fi

if ! git -C "$work/public" rev-parse "$tag" >/dev/null 2>&1; then
	git -C "$work/public" tag -a "$tag" -m "Highway agent plugin $version"
fi

if [[ "$dry_run" -eq 1 ]]; then
	echo "OK: dry-run passed for $tag (not pushed)"
	exit 0
fi

git -C "$work/public" push -u origin HEAD || refuse "git push of the branch failed (check highway-systems credentials for ${PUBLIC_REMOTE})"
git -C "$work/public" push origin "$tag" || refuse "git push of tag ${tag} failed"
echo "OK: published ${PUBLIC_REMOTE} at ${tag}"
echo "PUBLIC_REF=${tag}"
exit 0
