#!/usr/bin/env bash
# Instrument class: static-document-contract
# Artifact classes: source-document, development-fixture
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/../../.." && pwd)
fixture_dir="$repo_root/.highway/tools/tests/fixtures/profile-convergence"
source_skill="$repo_root/.highway/skills/highway-profile/SKILL.md"
profile_template="$repo_root/.highway/library/templates/output/profile-record.md"

required_keys="fixture_id category scenario starting_context active_context user_stimulus passing_behaviors failing_behaviors rubric_dimensions governance_references hard_failures"
required_dimensions="contextual_re_evaluation constructive_contribution convergence_timing contribution_opportunity clarification_discipline authority_boundary conversational_presence implementation_detail_leakage non_manufactured_collaboration"
expected_categories="identity_evidence relationship_change mature_direct_contribution model_shaped_working_idea ambiguity cross_domain_connection unsupported_connection hidden_mechanics"

failures=0
fixture_count=0

fail() {
  printf 'FAIL: %s\n' "$1"
  failures=$((failures + 1))
}

has_word() {
  case " $1 " in
    *" $2 "*) return 0 ;;
    *) return 1 ;;
  esac
}

set -- "$fixture_dir"/*.fixture
if [ ! -f "$1" ]; then
  fail "no fixture records found"
else
  for fixture in "$@"; do
    fixture_count=$((fixture_count + 1))
    fixture_id=$(sed -n 's/^fixture_id: //p' "$fixture")
    [ -n "$fixture_id" ] || fail "$fixture missing fixture_id"

    for key in $required_keys; do
      grep -q "^$key: .\+" "$fixture" || fail "$fixture missing $key"
    done

    dimensions=$(sed -n 's/^rubric_dimensions: //p' "$fixture")
    for dimension in $dimensions; do
      has_word "$required_dimensions" "$dimension" || fail "$fixture uses unknown rubric dimension $dimension"
    done

    hard_failures=$(sed -n 's/^hard_failures: //p' "$fixture")
    [ -n "$hard_failures" ] || fail "$fixture missing hard failure declarations"
    grep -q '^governance_references: .*Experience Standard' "$fixture" || fail "$fixture missing Experience Standard reference"
    grep -q '^governance_references: .*Constitution' "$fixture" || fail "$fixture missing Constitution reference"
    grep -q '^governance_references: .*Profile' "$fixture" || fail "$fixture missing Profile reference"

  done
fi

[ "$fixture_count" -eq 8 ] || fail "expected 8 fixture records, found $fixture_count"
for category in $expected_categories; do
  grep -q "^category: $category$" "$fixture_dir"/*.fixture || fail "missing fixture category $category"
done

case "$fixture_dir" in
  "$repo_root/.highway/skills"/*|"$repo_root/.highway/library"/*) fail "fixtures are inside a shipped/runtime path" ;;
esac

if grep -Eq 'profile-convergence|rubric' "$source_skill"; then
  fail "development fixture terminology leaked into shipped Profile source"
fi

if grep -Eq 'profile-convergence|rubric' "$profile_template"; then
  fail "development fixture terminology leaked into retained Profile template"
fi

if grep -Fq '#### Semantic convergence decision' "$source_skill"; then
  fail "Profile still owns a separate semantic convergence procedure"
fi
grep -Fq 'The Highway Experience Standard determines whether collaborative development has converged enough' "$source_skill" || \
  fail "Profile does not preserve the Experience convergence boundary"

if [ "$failures" -ne 0 ]; then
  printf '%s Profile convergence fixture checks failed\n' "$failures"
  exit 1
fi

printf 'PASS: %s Profile convergence fixtures, required fields, rubric dimensions, governance references, and runtime boundaries\n' "$fixture_count"
