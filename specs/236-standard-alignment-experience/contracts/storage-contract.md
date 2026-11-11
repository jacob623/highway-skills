# Contract: highway-experience's storage contract

`skills/highway-experience/references/storage-contract.md`, version `1.1.0`.

## Carried over unchanged in meaning

- The four operations table, with its Local, Remote (Option A), and Chat (Option B) columns.
- The paths rule: every path is relative to the repository root.
- The modes list, and "Only Local is supported."
- What a skill does not do: run a script, run a `git` command, use a path that starts at the
  filesystem root or the home folder, decide from a file time.
- Written content is not limited by that list.

## Added

1. Scope states that a skill reading its own bundled files, and a skill activating highway-experience,
   are not repository operations, and that the four operations govern every read and write of the
   project.
2. `## Mode record`:
   - The project records its mode in `library/knowledge/storage.md`.
   - Before its first other repository operation, a skill reads that file with "Read a file".
   - An absent record means Local.
   - A record that names a mode other than Local stops the skill before any other repository read or
     write. The skill says the recorded mode is not supported yet and names Local as the supported
     mode.
3. Modes: "Every run uses Local." becomes "A run uses Local unless the mode record names another
   mode."

## Checked by

`tests/storage-contract.test.sh`:

- the four operation rows and their "not supported yet" cells;
- the carried-over sentences;
- each added sentence;
- that the contract ships in the distribution;
- that P2.6 names highway-experience's storage contract;
- the P2.6 seeded cases.
