# Data Model: Publish and Public Install

## Entities

### Plugin identity (source)

| Field | Rules |
| --- | --- |
| `name` | `highway` (unchanged) |
| `version` | Semver string in `framework/plugin/plugin.json`. First publish may be `0.1.0`. Later publish requires value > last published public tag. |
| `repository` | MUST be `https://github.com/highway-systems/agent-plugin` |
| `homepage` | MUST remain `https://www.highway.systems` |

Relationships: generator copies/renders into every shipped manifest that carries these fields.

### Marketplace catalog entry

| Field | Rules |
| --- | --- |
| Marketplace `name` | Stable id such as `highway` or host-required name |
| Plugin `name` | `highway` |
| `source` | Local plugin root: `./` (or host object form with path `./`) |
| `policy.installation` | `AVAILABLE` where the format requires it |
| `policy.authentication` | `ON_INSTALL` or host default where required |
| `category` | Present only when the host schema includes it (`Developer Tools` preferred) |

Four catalog files are generated; none are hand-edited.

### Public release

| Field | Rules |
| --- | --- |
| Remote | `https://github.com/highway-systems/agent-plugin.git` |
| Tree | Exact byte match of a fresh `highway-agent-plugin/` build at repository root |
| Tag | Annotated `v<version>` for the version being published when that tag does not yet exist |
| Pin for smoke | Tag name or full commit SHA after push |

State transitions:

```text
built locally → gates pass → committed on public default branch → tagged → pushed
                                    ↓ fail
                              no public update
```

### Harness plugin resolution

| Field | Rules |
| --- | --- |
| `pluginSource` | `local` (default) or `public` |
| `pluginRef` | Required if `public`: tag or commit SHA |
| Resolved dir | Local build path, or clone of public repo at `pluginRef` |

### URL guard allowlist

Paths that may still contain `jacob623/highway-skills` without failing: historical `specs/**`,
`harness-model-findings.md`, and any other paths explicitly listed in the test. Install examples
and `repository` fields outside the allowlist must not use the old URL.
