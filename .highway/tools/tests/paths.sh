#!/usr/bin/env bash
# Test bootstrap: every test sources this file, which sources the paths helper. This is the one
# line that knows where the tests sit relative to the helper. Not a test: run-all.sh runs only
# *.test.sh files.
# shellcheck source=../lib/paths.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"
