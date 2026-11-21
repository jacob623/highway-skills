# Highway Storage Contract

Version `1.4.0`.

## Scope

This document defines how a Highway skill reads and writes the Highway knowledge repository. A
skill reaches that repository only through the four operations below. Each mode column states what
an operation does in that mode. A new mode fills its column, and no skill changes.

The four operations govern every read and write of Highway knowledge records. A skill reading its
own bundled files, and a skill activating highway-experience, are not repository operations.

## Effective Highway knowledge root

Before the mode check and before any other repository operation, `highway-experience` resolves one
**effective Highway knowledge root** for the run. After that, every storage path is relative to
that root. "Do not use paths outside the repository root" means outside the **effective** root,
not necessarily outside the open project where the person invoked the skill.

A directory is a **Highway knowledge root** when it has a readable `library/knowledge/profile.md`
or a readable `library/knowledge/storage.md` (either is enough).

### Resolution order

1. If the open project has a **usable** local pointer (see Pointer files) → that directory is the
   effective root.
2. Else if the open project itself is a Highway knowledge root → the open project is the effective
   root.
3. Else if the open project has only a committed repository URL pointer → Local mode does **not**
   treat that URL as a working tree. Experience stops with URL-only guidance (open or clone and
   set a local path, or use Remote/Chat when those modes exist). Do not write Highway catalogs
   into the open project as if it were the knowledge root.
4. Else → experience runs the setup-or-pointer gate (see highway-experience).

**Setup-here override:** when the activating skill is `highway-setup` and the person chooses to
set up Highway in this project, the effective root for that setup run is the **open project**,
even if a local pointer file also exists.

`highway-experience` alone owns resolve-root and the not-ready gate. Other skills must not
duplicate them.

## Paths

Every storage-operation path is relative to the effective Highway knowledge root. A
storage-operation path never starts at the filesystem root or the home folder.

## Pointer files

Pointer files live in the **open project** (invocation tree), not inside the knowledge tree they
name (unless those are the same tree).

These files are **Highway knowledge** pointers only. They must not store product or codify code
repository locations (reserved for a later external code-target feature).

### Committed pointer — `hw-repository.md`

Shared identity for teammates. Intended to be committed. This feature must not add it to the
project's ignore file.

```text
# Highway repository

repository: https://github.com/org/highway
```

Required field: `repository:` followed by a repository URL (not a filesystem path).

### Local pointer — `hw-repository.local.md`

Personal checkout path on this machine. When experience writes this file, it must also ensure
`hw-repository.local.md` is listed in the project's ignore file.

```text
# Highway repository (local)

path: /absolute/or/relative/path/to/highway-checkout
```

Required field: `path:` absolute, or relative to the open project root.

The `path` value is **configuration that sets** the effective root. It is not a storage-operation
argument. After the root is set, skills use only relative storage-operation paths under that root.

A local pointer path is **usable** only when it resolves to a readable directory that is already a
Highway knowledge root. Otherwise experience rejects it: it must not become the effective root,
and must not fall back to treating an open non-knowledge project as the knowledge root.

## Modes

- **Local**: the repository is the effective knowledge root's working tree. The person handles
  every git step. When the agent's file tool is the shell, in-project reads and writes may go
  through that shell. The skill still must not run `git`, use storage-operation paths outside the
  effective root, or treat network or package installs as storage operations.
- **Remote (Option A)**: a local clone of the person's repository that Highway commits to and
  pushes. When implemented, prefer the committed `repository:` URL as the remote identity when
  present.
- **Chat (Option B)**: calls to the git host's API, for a surface with no working tree. When
  implemented, align the host repo preference with the committed `repository:` URL when present.

Only Local is supported. A run uses Local unless the mode record names another mode.

## Mode record

The project records its mode in `library/knowledge/storage.md` under the **effective** knowledge
root. Before its first other repository operation, a skill reads that file with "Read a file".

- An absent record means Local.
- A record that names Local means Local.
- A record that names a mode other than Local stops the skill before any other repository read or
  write. The skill says the recorded mode is not supported yet and names Local as the supported
  mode.

## Operations

| Operation | Local | Remote (Option A) | Chat (Option B) |
|---|---|---|---|
| Read a file | Reads the file at the path in the effective root's working tree. An absent file is reported as absent. | not supported yet | not supported yet |
| Check a file exists | Reports whether a file is at the path in the effective root's working tree. | not supported yet | not supported yet |
| List a folder | Returns the names of the files and folders directly inside the folder in the effective root's working tree. An absent folder lists nothing. | not supported yet | not supported yet |
| Write a group of files together | Writes each file in the group to the effective root's working tree. Nothing is committed. The person handles any git step. A failed write names the files already written and the file that failed. | not supported yet | not supported yet |

A skill lists a folder only when no index or record already holds the answer.

"Read a file" and "Check a file exists" act on the exact path. A search or pattern tool does not decide whether a file exists. A file is absent only when one of those two operations reports it absent at its path.

A folder is created by writing a file in it.

## What a skill does not do

- Run a script.
- Run a shell command except when Local mode uses the agent's shell as the file tool for
  in-project reads and writes (see Modes). Arbitrary scripts and network or package installs are
  still out of scope for storage.
- Run a `git` command.
- Decide that a file is absent from a search or pattern result.
- Use a storage-operation path that starts at the filesystem root or the home folder.
- Decide anything from a file's modified, created, or accessed time.

Content a skill writes into a file, such as product code, a pipeline, or a README, is not limited
by this list. Editing the project's ignore file to list the local pointer file is a normal file
write, not a `git` command.
