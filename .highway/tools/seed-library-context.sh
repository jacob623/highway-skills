#!/usr/bin/env bash
set -u

HIGHWAY_ROOT="${HIGHWAY_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
KNOWLEDGE_DIR="$HIGHWAY_ROOT/.highway/library/knowledge"
source_names=(
	highway-identity.md
	highway-platform-objectives.md
	highway-vision.md
)
missing=0

for name in "${source_names[@]}"; do
	if [[ ! -f "$HIGHWAY_ROOT/$name" ]]; then
		echo "ERROR: missing source '$name'" >&2
		missing=1
	fi
done

if [[ "$missing" -ne 0 ]]; then
	exit 1
fi

if ! mkdir -p "$KNOWLEDGE_DIR"; then
	echo "ERROR: unable to create destination directory '$KNOWLEDGE_DIR'" >&2
	exit 1
fi

copy_failed=0
for name in "${source_names[@]}"; do
	if ! cp "$HIGHWAY_ROOT/$name" "$KNOWLEDGE_DIR/$name"; then
		echo "ERROR: unable to copy '$name'" >&2
		copy_failed=1
		continue
	fi
	if ! cmp -s "$HIGHWAY_ROOT/$name" "$KNOWLEDGE_DIR/$name"; then
		echo "ERROR: destination differs from source for '$name'" >&2
		copy_failed=1
	fi
done

if [[ "$copy_failed" -ne 0 ]]; then
	exit 1
fi

echo "Copied and verified ${#source_names[@]} Highway context documents in '$KNOWLEDGE_DIR'."
