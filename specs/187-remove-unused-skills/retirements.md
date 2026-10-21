# Check retirements

Each entry names the removed skill the check served.

| Check | Skill it served |
|---|---|
| `.highway/tools/tests/highway-clarify.test.sh` | `highway-clarify` |
| `.highway/tools/tests/highway-new.test.sh` | `highway-new` |
| `.highway/tools/tests/relationship-integrity.test.sh` | `highway-relationships` |

`highway-inquiry` had no dedicated test file. Its skill directory and requirements-inquiry template are removed with it.

Edited checks:

| Check | What changed |
|---|---|
| `.highway/tools/tests/output-template.test.sh` | Stopped requiring the clarification templates and `highway-clarify`. Request template checks stay on `highway-request`. |
| `.highway/tools/tests/highway-ux-alignment.test.sh` | Stopped requiring `highway-new` and `highway-clarify`. |
| `.highway/tools/tests/adapter-coverage.test.sh` | The seeded probe now uses `highway-help` because `highway-inquiry` is gone. |
