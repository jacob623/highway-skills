# Feature 091 Coverage

Implementation coverage is tracked by the focused contract tests and the repository-wide compliance suite.

| Area | Evidence |
|---|---|
| Adaptive five-domain collection | `profile-adaptive.test.sh`, `fixtures/profile-091/adaptive-corpus.md` |
| Markdown structure and deterministic rendering | `profile-markdown-contract.test.sh`, `validate-profile.sh` |
| Proposal/accepted lifecycle and legacy YAML isolation | `profile-lifecycle.test.sh`, `profile-behavior.test.sh` |
| Setup ownership and resume routing | `highway-setup.test.sh`, `highway-setup-executable.test.sh` |
| Repository Context participation | `profile-participation.test.sh`, constitutional compliance review |
| Full repository integrity | `.highway/tools/tests/run-all.sh` |
