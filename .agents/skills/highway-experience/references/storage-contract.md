# Highway Storage Contract

Version `1.1.0`.

## Scope

This document defines how a Highway skill reads and writes the repository. A skill reaches the
repository only through the four operations below. Each mode column states what an operation does
in that mode. A new mode fills its column, and no skill changes.

The four operations govern every read and write of the project. A skill reading its own bundled
files, and a skill activating highway-experience, are not repository operations.

## Paths

Every path is relative to the repository root. A path never starts at the filesystem root or the
home folder.

## Modes

- **Local**: the repository is the person's working tree. The person handles every git step.
- **Remote (Option A)**: a local clone of the person's repository that Highway commits to and
  pushes.
- **Chat (Option B)**: calls to the git host's API, for a surface with no working tree.

Only Local is supported. A run uses Local unless the mode record names another mode.

## Mode record

The project records its mode in `library/knowledge/storage.md`. Before its first other repository
operation, a skill reads that file with "Read a file".

- An absent record means Local.
- A record that names Local means Local.
- A record that names a mode other than Local stops the skill before any other repository read or
  write. The skill says the recorded mode is not supported yet and names Local as the supported
  mode.

## Operations

| Operation | Local | Remote (Option A) | Chat (Option B) |
|---|---|---|---|
| Read a file | Reads the file at the path in the working tree. An absent file is reported as absent. | not supported yet | not supported yet |
| Check a file exists | Reports whether a file is at the path in the working tree. | not supported yet | not supported yet |
| List a folder | Returns the names of the files and folders directly inside the folder in the working tree. An absent folder lists nothing. | not supported yet | not supported yet |
| Write a group of files together | Writes each file in the group to the working tree. Nothing is committed. The person handles any git step. A failed write names the files already written and the file that failed. | not supported yet | not supported yet |

A skill lists a folder only when no index or record already holds the answer.

## What a skill does not do

- Run a script.
- Run a `git` command.
- Use a path that starts at the filesystem root or the home folder.
- Decide anything from a file's modified, created, or accessed time.

Content a skill writes into a file, such as product code, a pipeline, or a README, is not limited
by this list.
