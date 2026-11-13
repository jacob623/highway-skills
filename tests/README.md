# Highway Test Harness

Tests in this directory are Bash 3.2-compatible executable checks for canonical Highway sources.

Feature 038 adds separate evidence classes:

- executable owner behavior from disposable fixtures
- Setup routing from captured owner responses
- static contract and planning-record checks
- generated catalog and adapter correspondence
- requirement coverage
- documented limitations

The canonical behavior sources remain under `skills/`. Generated agent trees, catalogs, and the
Agent Plugins build in `highway-agent-plugin/` are validation targets and must not be edited
directly. `agent-plugin.test.sh` checks the plugin's shipped set, its currency, the generator's
refusals, and `framework/validate-plugin.sh` against a seeded defect of each kind; it works in a
copy of the repository, so it never writes the working tree. Shared Feature 038 fixture operations live
in `feature-038-helpers.sh`.

Feature 092 focused checks use the `feature-092-*` test names and the disposable fixture tree at
`fixtures/profile-092/`. The launcher discovers these checks through the existing `*.test.sh`
dispatch, so adding a focused check does not require a second registry.
