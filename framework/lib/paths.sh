#!/usr/bin/env bash
# Paths helper: the one declaration of where every repository location lives.
#
# Sourced, never executed. Every tool, library, test, and harness script gets its locations from
# here rather than combining a root with a folder or file name itself, so moving a location means
# editing its line here and nothing else. path-construction.test.sh enforces that (D2.5).
#
# The root is resolved from this file's own position, so the same file works in any copy of the
# repository. Variables are not exported: a child script sources its own copy and resolves its
# own root.
#
# Usage:
#   source "<dir>/paths.sh"         sets HW_* for the root two folders above this file
#   hw_paths_init [root]            sets HW_* for another root
#   hw_template <name>              path of one output template, catalog skeleton, or skill asset, by base name
#   hw_doc <name>                   path of one framework or highway-experience document, by name
#   hw_seeded                       "<asset>\t<project path>" for each file highway-setup seeds
#   hw_at <root> <path>             <path> (under HW_ROOT) re-rooted under <root>
#   hw_rel <path>                   <path> relative to HW_ROOT
#
# Bash 3.2 and the Declared Toolchain only. Lookups use case and parameter expansion, no subshell.

hw_paths_init() {
	if [[ -n "${1:-}" ]]; then
		HW_ROOT="$1"
	else
		HW_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
	fi

	HW_SKILLS="$HW_ROOT/skills"
	HW_EXPERIENCE="$HW_SKILLS/highway-experience"
	HW_SETUP="$HW_SKILLS/highway-setup"
	HW_FRAMEWORK="$HW_ROOT/framework"
	HW_LIB="$HW_FRAMEWORK/lib"
	HW_SHARED_RULES="$HW_FRAMEWORK/shared-rules"
	HW_TESTS="$HW_ROOT/tests"
	HW_FIXTURES="$HW_TESTS/fixtures"
	HW_HIGHWAY="$HW_ROOT/.highway"
	HW_CATALOG="$HW_HIGHWAY/catalog"
	HW_LIBRARY="$HW_HIGHWAY/library"
	HW_OUTPUT_TEMPLATES="$HW_LIBRARY/templates/output"
	HW_HARNESS="$HW_ROOT/harness"

	HW_AGENT_COPILOT="$HW_ROOT/.github/skills"
	HW_AGENT_CLAUDE="$HW_ROOT/.claude/skills"
	HW_AGENT_CURSOR="$HW_ROOT/.cursor/skills"
	HW_AGENT_CODEX="$HW_ROOT/.agents/skills"
}

# One arm per template, so a later phase can move one template by editing one arm.
hw_template() {
	case "${1:-}" in
	adr-catalog) printf '%s\n' "$HW_SETUP/assets/adr-catalog.md" ;;
	adr-record) printf '%s\n' "$HW_OUTPUT_TEMPLATES/adr-record.md" ;;
	architecture-catalog) printf '%s\n' "$HW_SETUP/assets/architecture-catalog.md" ;;
	architecture-record) printf '%s\n' "$HW_OUTPUT_TEMPLATES/architecture-record.md" ;;
	assessment-findings) printf '%s\n' "$HW_SETUP/assets/assessment-findings.md" ;;
	capability-catalog) printf '%s\n' "$HW_SETUP/assets/capability-catalog.md" ;;
	codify-catalog) printf '%s\n' "$HW_SETUP/assets/codify-catalog.md" ;;
	codify-integrations) printf '%s\n' "$HW_SETUP/assets/codify-integrations.md" ;;
	codify-metadata) printf '%s\n' "$HW_OUTPUT_TEMPLATES/codify-metadata.md" ;;
	codify-plan) printf '%s\n' "$HW_OUTPUT_TEMPLATES/codify-plan.md" ;;
	codify-platforms) printf '%s\n' "$HW_SETUP/assets/codify-platforms.md" ;;
	codify-record) printf '%s\n' "$HW_OUTPUT_TEMPLATES/codify-record.md" ;;
	codify-tasks) printf '%s\n' "$HW_OUTPUT_TEMPLATES/codify-tasks.md" ;;
	coding-standard) printf '%s\n' "$HW_OUTPUT_TEMPLATES/coding-standard.md" ;;
	coding-standards-catalog) printf '%s\n' "$HW_SETUP/assets/coding-standards-catalog.md" ;;
	control-catalog) printf '%s\n' "$HW_SKILLS/highway-controls/assets/control-catalog.md" ;;
	control-record) printf '%s\n' "$HW_OUTPUT_TEMPLATES/control-record.md" ;;
	discovery-catalog) printf '%s\n' "$HW_SETUP/assets/discovery-catalog.md" ;;
	discovery-record) printf '%s\n' "$HW_OUTPUT_TEMPLATES/discovery-record.md" ;;
	implementation-catalog) printf '%s\n' "$HW_SETUP/assets/implementation-catalog.md" ;;
	implementation-record) printf '%s\n' "$HW_OUTPUT_TEMPLATES/implementation-record.md" ;;
	nfr-catalog) printf '%s\n' "$HW_SKILLS/highway-nfrs/assets/nfr-catalog.md" ;;
	nfr-record) printf '%s\n' "$HW_OUTPUT_TEMPLATES/nfr-record.md" ;;
	objective-catalog) printf '%s\n' "$HW_SKILLS/highway-objectives/assets/objective-catalog.md" ;;
	objective-record) printf '%s\n' "$HW_OUTPUT_TEMPLATES/objective-record.md" ;;
	profile-record) printf '%s\n' "$HW_OUTPUT_TEMPLATES/profile-record.md" ;;
	request-catalog) printf '%s\n' "$HW_SETUP/assets/request-catalog.md" ;;
	request-record) printf '%s\n' "$HW_OUTPUT_TEMPLATES/request-record.md" ;;
	storage) printf '%s\n' "$HW_SETUP/assets/storage.md" ;;
	*)
		printf 'hw_template: unknown template: %s\n' "${1:-}" >&2
		return 1
		;;
	esac
}

# The files highway-setup seeds into a project: one "<asset>\t<project path>" line each, in seeding
# order. The asset is a file name under $HW_SETUP/assets/; the project path is relative to the project root.
hw_seeded() {
	printf '%s\t%s\n' \
		request-catalog.md requests/requests.md \
		discovery-catalog.md discoveries/discoveries.md \
		adr-catalog.md adrs/adrs.md \
		architecture-catalog.md architectures/architectures.md \
		implementation-catalog.md implementations/implementations.md \
		capability-catalog.md implementations/capabilities.md \
		codify-catalog.md code/code.md \
		codify-integrations.md code/integrations.md \
		codify-platforms.md library/coding-standards/codify-platforms.md \
		coding-standards-catalog.md library/coding-standards/coding-standards.md \
		assessment-findings.md library/knowledge/assessment-findings.md \
		storage.md library/knowledge/storage.md
}

# One arm per document, so a later phase can move one document by editing one arm.
hw_doc() {
	case "${1:-}" in
	constitution) printf '%s\n' "$HW_FRAMEWORK/constitution.md" ;;
	authoring-standard) printf '%s\n' "$HW_FRAMEWORK/authoring-standard.md" ;;
	frontmatter-lexicon) printf '%s\n' "$HW_FRAMEWORK/frontmatter-lexicon.txt" ;;
	experience-standard) printf '%s\n' "$HW_EXPERIENCE/references/experience-standard.md" ;;
	storage) printf '%s\n' "$HW_EXPERIENCE/references/storage-contract.md" ;;
	highway-identity) printf '%s\n' "$HW_EXPERIENCE/references/highway-identity.md" ;;
	*)
		printf 'hw_doc: unknown document: %s\n' "${1:-}" >&2
		return 1
		;;
	esac
}

hw_at() {
	case "${2:-}" in
	"$HW_ROOT") printf '%s\n' "$1" ;;
	"$HW_ROOT"/*) printf '%s\n' "$1/${2#"$HW_ROOT"/}" ;;
	*)
		printf 'hw_at: not under %s: %s\n' "$HW_ROOT" "${2:-}" >&2
		return 1
		;;
	esac
}

hw_rel() {
	case "${1:-}" in
	"$HW_ROOT"/*) printf '%s\n' "${1#"$HW_ROOT"/}" ;;
	*)
		printf 'hw_rel: not under %s: %s\n' "$HW_ROOT" "${1:-}" >&2
		return 1
		;;
	esac
}

hw_paths_init
