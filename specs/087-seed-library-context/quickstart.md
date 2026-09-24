# Feature 087 Quickstart

## Prerequisites

Run from the repository root. The three source files must exist at the repository root:

- `highway-identity.md`
- `highway-platform-objectives.md`
- `highway-vision.md`

The destination directory is `.highway/library/knowledge/`. No new runtime dependency is required.

## Apply the copy

From the repository root, run:

```sh
.highway/tools/seed-library-context.sh
```

Expected result: all three sources are present, copied to the knowledge library, and verified
byte-for-byte. Missing sources cause a non-zero exit before successful completion.

## Focused validation

Run the focused feature test after implementation:

```sh
bash .highway/tools/tests/seed-library-context.test.sh
```

Expected result: the test exits 0 and confirms all three destinations exist, compare byte-for-byte with their sources, preserve source bytes, handle a missing source without successful completion, converge a conflicting destination, and leave an unrelated knowledge file unchanged.

## Manual byte verification

From the repository root, compare each source with its destination:

```sh
cmp -s highway-identity.md .highway/library/knowledge/highway-identity.md
cmp -s highway-platform-objectives.md .highway/library/knowledge/highway-platform-objectives.md
cmp -s highway-vision.md .highway/library/knowledge/highway-vision.md
```

Each command should exit 0. These comparisons must be performed before manually deleting the root seed files.

## Source cleanup verification

After the maintainer deletes the three root files manually, confirm the library copies remain:

```sh
test -f .highway/library/knowledge/highway-identity.md
test -f .highway/library/knowledge/highway-platform-objectives.md
test -f .highway/library/knowledge/highway-vision.md
```

Expected result: all three commands exit 0. The cleanup is intentionally manual and is not performed by this feature.

## Full validation

Run the repository suite:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: the existing suite exits 0, including the focused copy test.
