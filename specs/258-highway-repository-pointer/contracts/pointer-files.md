# Contract: Pointer file schemas

Files live in the **open project**.

## `hw-repository.md` (committed)

- Heading optional; required line: `repository: <git-url>`
- Must not be added to `.gitignore` by this feature
- Knowledge identity only

## `hw-repository.local.md` (local)

- Heading optional; required line: `path: <filesystem-path>`
- Path absolute or relative to open project root
- Must resolve to a Highway knowledge root before use or persist
- When written by experience, `.gitignore` MUST contain `hw-repository.local.md` (exact
  path entry)

## Parsing

- Trim whitespace around values
- First matching `repository:` / `path:` line wins
- Ignore fenced code and HTML comments if present (optional; plain files preferred)
