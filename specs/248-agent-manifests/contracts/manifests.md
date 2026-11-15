# Contract: The Manifest Set

Every manifest is `json.dumps(indent=2, ensure_ascii=False)` plus one newline. Keys appear in the
order below, whatever order the source and listing files use. An optional field with no value is
left out (FR-004). Sources per field are in [research.md](../research.md).

## Key order per format

Shared keys, in this order: `name`, `version`, `description`, `author`, `homepage`, `repository`,
`license`, `keywords`.

| Manifest | Leading | Shared keys | Author keys | Trailing | Listing keys, in order |
| --- | --- | --- | --- | --- | --- |
| `.claude-plugin/plugin.json` | none | all | name, email, url | none | none |
| `.codex-plugin/plugin.json` | none | all | name, email, url | `"skills": "./skills/"` | `interface` |
| `.cursor-plugin/plugin.json` | none | all | name, email | `"skills": "./skills/"` | `logo` |
| `.antigravity-plugin/plugin.json` | `"$schema": "https://antigravity.google/schemas/v1/plugin.json"` | all | name, email, url | none | `displayName`, `logo`, `suggestedPrompts` |
| `gemini-extension.json` | none | name, version, description | none | none | none |

Codex `interface` key order: `displayName`, `shortDescription`, `longDescription`,
`developerName` (derived from `author.name`), `category`, `capabilities`, `websiteURL` (derived
from `homepage`), `defaultPrompt`, `composerIcon`, `logo`.

Author keys outside a format's list are dropped: Cursor's author is `{ "name": "Highway" }`. A
shared key the source does not hold is left out.

## Listing file

```json
{
  "codex": {
    "interface": {
      "displayName": "<text>",
      "shortDescription": "<text>",
      "longDescription": "<text>",
      "category": "Developer Tools",
      "capabilities": ["Interactive", "Read", "Write"],
      "defaultPrompt": ["<prompt>", "<prompt>", "<prompt>"],
      "composerIcon": "./assets/logo.svg",
      "logo": "./assets/logo.svg"
    }
  },
  "cursor": { "logo": "assets/logo.svg" },
  "antigravity": {
    "displayName": "<text>",
    "logo": "assets/logo.svg",
    "suggestedPrompts": ["<prompt>", "<prompt>", "<prompt>"]
  }
}
```

Allowed listing fields per agent:

- `codex.interface`: `displayName`, `shortDescription`, `longDescription`, `category`,
  `capabilities`, `defaultPrompt`, `composerIcon`, `logo`, `brandColor`, `privacyPolicyURL`,
  `termsOfServiceURL`, `screenshots`. Strings, except `capabilities`, `defaultPrompt`, and
  `screenshots`, which are lists of strings.
- `cursor`: `logo` (string).
- `antigravity`: `displayName` (string), `logo` (string), `suggestedPrompts` (list of at most 3
  strings).

Forbidden in every entry: the shared keys, `$schema`, `skills`, and the derived
`developerName` and `websiteURL`. No manifest ever holds `hooks`, `mcpServers`, `rules`,
`commands`, `agents`, or `contextFileName` (FR-009); none of them is an allowed listing field.

## Changing a field

- A shared field or the version: edit `framework/plugin/plugin.json`, run
  `framework/generate-agent-plugin.sh`.
- An agent-only field: edit `framework/plugin/listing.json`, run the generator.
- The logo: replace `framework/plugin/assets/logo.svg` under the same name, run the generator.
- Never edit a file under `highway-agent-plugin/`.
