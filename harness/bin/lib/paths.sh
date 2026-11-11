#!/usr/bin/env bash
# Harness bootstrap: every harness/bin script sources this file, which sources the framework's
# paths helper. This is the one line that knows where the harness sits relative to the helper.
# shellcheck source=../../../framework/lib/paths.sh
. "$(dirname "${BASH_SOURCE[0]}")/../../../framework/lib/paths.sh"
