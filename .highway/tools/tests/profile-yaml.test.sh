#!/usr/bin/env bash
# Tests that the canonical profile and malformed YAML fixtures are handled by a standard parser.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PROFILE="$HIGHWAY_ROOT/library/templates/output/profile.yaml"
FIXTURE="$SCRIPT_DIR/fixtures/profile-yaml/invalid-indentation.yaml"

if ! command -v ruby >/dev/null 2>&1; then
	echo "FAIL: ruby is required for profile YAML syntax validation" >&2
	exit 1
fi

if ! ruby -e 'require "yaml"; YAML.load_file(ARGV[0])' "$PROFILE" >/dev/null 2>&1; then
	echo "FAIL: canonical profile is not valid YAML: $PROFILE" >&2
	exit 1
fi

if ruby -e 'require "yaml"; YAML.load_file(ARGV[0])' "$FIXTURE" >/dev/null 2>&1; then
	echo "FAIL: malformed YAML fixture was accepted: $FIXTURE" >&2
	exit 1
fi

echo "OK: profile YAML syntax fixtures pass"
