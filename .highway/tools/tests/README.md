# Highway Test Harness

Tests in this directory are Bash 3.2-compatible executable checks for canonical Highway sources.

Feature 038 adds separate evidence classes:

- executable owner behavior from disposable fixtures
- Setup routing from captured owner responses
- static contract and planning-record checks
- generated catalog and adapter correspondence
- requirement coverage
- documented limitations

The canonical behavior sources remain under `.highway/skills/`. Generated agent trees and catalogs
are validation targets and must not be edited directly. Shared Feature 038 fixture operations live
in `feature-038-helpers.sh`.

Feature 092 focused checks use the `feature-092-*` test names and the disposable fixture tree at
`fixtures/profile-092/`. The launcher discovers these checks through the existing `*.test.sh`
dispatch, so adding a focused check does not require a second registry.
