#!/usr/bin/env bash
# Reads .highway/tools/.distribution-manifest, the single declaration of which repository paths
# enter the user-facing distribution (D1.6).
#
# Two callers share this library: generate-distribution.sh, which copies what is included, and
# shipped-tree-independence.test.sh, which scans distributed files for development-only
# references. Neither keeps its own copy of the path set.
#
# Classification is by longest matching prefix, so a directory record covers its descendants and
# a more specific record overrides it. A path matching no record is 'unclassified' and is a
# failure rather than a default, because a silently unclassified path is how a new directory
# would go unnoticed.

DIST_MANIFEST_DEFAULT="${DIST_MANIFEST_DEFAULT:-}"

dist_manifest_file() {
	if [[ -n "$DIST_MANIFEST_DEFAULT" ]]; then
		echo "$DIST_MANIFEST_DEFAULT"
		return 0
	fi
	local lib_dir
	lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	echo "$lib_dir/../.distribution-manifest"
}

# Emits "classification<TAB>source<TAB>destination" for every record, comments and blanks removed.
dist_records() {
	local manifest
	manifest="$(dist_manifest_file)"
	[[ -f "$manifest" ]] || return 1
	awk -F'\t' '
		/^[[:space:]]*#/ { next }
		/^[[:space:]]*$/ { next }
		NF >= 2 { print $1 "\t" $2 "\t" (NF >= 3 ? $3 : "-") }
	' "$manifest"
}

# Classifies many paths in one process. Reads paths on stdin, one per line, and emits
# "classification<TAB>path" in input order.
#
# This exists because the single-path form loads and re-parses the manifest for every path it is
# asked about. Over a repository of several hundred files that is two awk processes per file, and
# the cost grows with the repository rather than with the manifest. Here the manifest is read once
# as awk's first input file and every path is matched against the in-memory record set.
dist_classify_many() {
	local manifest
	manifest="$(dist_manifest_file)"
	[[ -f "$manifest" ]] || return 1
	awk -F'\t' -v mf="$manifest" '
		FILENAME == mf {
			if ($0 ~ /^[[:space:]]*#/) next
			if ($0 ~ /^[[:space:]]*$/) next
			if (NF >= 2) { n++; cls[n] = $1; src[n] = $2; len[n] = length($2) }
			next
		}
		{
			best = ""; best_len = 0
			for (i = 1; i <= n; i++) {
				# A record matches the path itself or anything beneath it.
				if ($0 == src[i] || index($0, src[i] "/") == 1) {
					if (len[i] > best_len) { best_len = len[i]; best = cls[i] }
				}
			}
			print (best == "" ? "unclassified" : best) "\t" $0
		}
	' "$manifest" -
}

# include | exclude | unclassified, by longest matching prefix.
dist_classify() {
	local target_path="$1"
	printf '%s\n' "$target_path" | dist_classify_many | cut -f1
}

# Exclude records with no other record beneath them, so nothing inside them can be included.
#
# A walk may skip these entirely: descending into them can only ever yield more excluded paths.
# Derived from the manifest on every call rather than listed here, because a hardcoded list would
# silently stop matching the first time a record moved, and the walk would quietly start missing
# files it was supposed to classify.
dist_prune_roots() {
	dist_records | awk -F'\t' '
		{ cls[NR] = $1; src[NR] = $2; n = NR }
		END {
			for (i = 1; i <= n; i++) {
				if (cls[i] != "exclude") continue
				covered = 0
				for (j = 1; j <= n; j++) {
					if (j == i) continue
					if (index(src[j], src[i] "/") == 1) { covered = 1; break }
				}
				if (!covered) print src[i]
			}
		}
	'
}

dist_included_sources() {
	dist_records | awk -F'\t' '$1 == "include" { print $2 }'
}

# The path a source occupies in the distribution. Echoes the source when it lands unchanged.
dist_destination() {
	local source="$1"
	dist_records | awk -F'\t' -v s="$source" '
		$2 == s { print ($3 == "-" ? s : $3); found = 1; exit }
		END { if (!found) print s }
	'
}

# Repository paths matching no record. Walks top-level entries and descends only where a record
# distinguishes something beneath, so the walk stays proportional to the manifest.
dist_unclassified_paths() {
	local repo_root="$1"
	local entry rel
	for entry in "$repo_root"/* "$repo_root"/.[!.]*; do
		[[ -e "$entry" ]] || continue
		rel="${entry#"$repo_root"/}"
		[[ "$rel" == ".git" ]] && continue
		if [[ "$(dist_classify "$rel")" == "unclassified" ]]; then
			echo "$rel"
		fi
	done
}
