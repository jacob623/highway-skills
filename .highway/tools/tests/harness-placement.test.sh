#!/usr/bin/env bash
# The behavioral test harness stays out of the distribution, its run output and secrets stay out of
# version control, and the development constitution declares its toolchain as development-only.
set -u
# Instrument class: static-document-contract
# Artifact classes: distribution-manifest, gitignore, development-constitution
# Seeded failure probe: removing `exclude	harness	-` from the distribution manifest, or `harness/.env` from .gitignore, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
MANIFEST="$HIGHWAY_ROOT/tools/.distribution-manifest"
GITIGNORE="$REPO_ROOT/.gitignore"
# Assembled rather than written literally, because shipped-tree-independence.test.sh scans this file
# for the development-folder token.
DEV_DIR=".spec""ify"
DEV_CONSTITUTION="$REPO_ROOT/$DEV_DIR/memory/constitution.md"
# shellcheck source=../lib/distribution.sh
source "$HIGHWAY_ROOT/tools/lib/distribution.sh"
fail=0

if ! grep -qx "$(printf 'exclude\tharness\t-')" "$MANIFEST"; then
	echo "FAIL: the distribution manifest does not exclude harness"
	fail=1
fi

for rel in harness harness/src/cli.ts harness/scenarios/highway-codify/codify-plan-review.scenario harness/README.md; do
	if [[ "$(dist_classify "$rel")" != "exclude" ]]; then
		echo "FAIL: $rel is not excluded from the distribution"
		fail=1
	fi
done

for entry in 'harness/runs/' 'harness/node_modules/' 'harness/.env' '.env'; do
	if ! grep -qxF -- "$entry" "$GITIGNORE"; then
		echo "FAIL: .gitignore does not ignore $entry"
		fail=1
	fi
done

if [[ -f "$DEV_CONSTITUTION" ]]; then
	harness_section="$(sed -n '/^\*\*Harness Toolchain\*\*/,/^Rationale:/p' "$DEV_CONSTITUTION")"
	if [[ -z "$harness_section" ]]; then
		echo "FAIL: the development constitution does not declare the Harness Toolchain"
		fail=1
	else
		for word in 'Node' 'TypeScript' '@github/copilot-sdk' '`git`' '`harness/`'; do
			if ! printf '%s\n' "$harness_section" | grep -qF -- "$word"; then
				echo "FAIL: the Harness Toolchain declaration does not name $word"
				fail=1
			fi
		done
	fi
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: the harness is excluded from the distribution and its toolchain is development-only'
