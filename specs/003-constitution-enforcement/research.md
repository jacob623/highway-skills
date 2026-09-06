# Phase 0 Research: Mechanical Enforcement of the Constitution

Resolves the open technical questions before design. No `NEEDS CLARIFICATION` markers remain in
the specification; the items below are technical decisions rather than requirement gaps.

## Decision 1: Derive the rule inventory by parsing the constitution's rule tables

**Decision**: Read rule IDs and tier tags at run time from the constitution's Markdown tables,
which use a fixed four-column shape: `| P<n>.<m> | rule text | observable | [tier] |`. The
tooling stores no rule text, no tier, and no token list of its own.

**Rationale**: FR-001 and FR-033 require the tooling to hold no normative content, and P7.3
prohibits restating rules defined elsewhere. Parsing also gives drift protection for free: if
an amendment adds a rule ID, the inventory grows and the new ID appears as unchecked (FR-002)
rather than being silently ignored.

**Contract this depends on**: the four-column table shape and the `[auto]` / `[agent-checkable]`
/ `[human-review]` tier tokens. Both are already relied on by the verification commands used
during the 2.0.0 and 2.0.1 amendments, so this is an existing, exercised format rather than a
new one. A test asserts the parse returns 48 rules, so a format change fails loudly.

**Alternatives rejected**:
- *Hardcode the rule list in the tooling*: fastest, but duplicates normative content and drifts
  on every amendment. This is precisely the defect US2 exists to remove from the authoring
  standard; reintroducing it in the tooling would be worse.
- *Generate a rule manifest file at build time*: adds a generated artifact that can go stale
  between amendment and regeneration, and adds a build step the framework does not otherwise
  have.

## Decision 2: One shared body scanner, not per-check Markdown parsing

**Decision**: Add a single scanner that walks a skill body once and emits one annotated record
per line: line number, current section heading, whether the line is inside a fenced code block,
whether it is a list item, and whether it is inside an ordered list. Every rule check consumes
this stream.

**Rationale**: Eleven checks need overlapping structural facts. FR-008 requires excluding fenced
blocks from normative-rule counting; FR-024 needs ordered lists; FR-025 needs list items within
one named section; FR-026 needs one named section. Without a shared scanner each check would
re-implement fence tracking, and a fence-handling bug would have to be fixed eleven times.

**Alternatives rejected**:
- *Per-check `grep`/`awk` one-liners*: simplest per check, but fence state cannot be tracked by
  a stateless line match, so every check that ignores fences would be subtly wrong on any skill
  containing an example.
- *Convert Markdown to an intermediate format first*: would need a parser dependency, which the
  no-new-runtime constraint forbids.

## Decision 3: A rule-ID-to-check registry, with unchecked rules reported rather than assumed

**Decision**: Maintain an explicit registry mapping each rule ID to the function that decides
it. At run time, compare the registry against the parsed inventory and report three disjoint
groups: checked, deferred (tier is not machine-decidable), and unchecked (machine-decidable but
no registered check).

**Rationale**: FR-002 and FR-004 require an author to be able to tell verified conformance from
unverified conformance. An empty result must never read as a pass. Reporting the three groups
separately makes the boundary visible at the moment of use, rather than requiring the author to
know which rules the tooling happens to implement.

**Exit status decision**: unchecked and deferred rules do NOT fail validation. Only a failed
check fails validation. Rationale: this feature deliberately enforces 13 of 48 rules, so
treating unchecked as failure would make every skill fail forever. The spec's cost asymmetry
also applies — a false positive that blocks a real skill is worse than a missed violation.

**Alternatives rejected**:
- *Implicitly treat unregistered rules as passing*: silently overstates conformance, and would
  make SC-006 unverifiable.
- *Fail on any unchecked rule*: correct in principle, unusable in practice at 13 of 48.

## Decision 4: Bash 3.2 data handling without associative arrays

**Decision**: Carry the rule inventory and the annotated line stream as newline-delimited text
piped through `awk`, not as shell arrays. Where the shell must hold a list, use a single
indexed array with a separately tracked count, and never expand a possibly-empty array under
`set -u`.

**Rationale**: bash 3.2 has no associative arrays, and the existing tooling already hit the
empty-array expansion failure during feature 001. Keeping the data in `awk` sidesteps both
limits and keeps the per-line work in one process rather than a shell loop per line, which also
serves the interactive-speed goal.

**Alternatives rejected**:
- *Require bash 4+*: breaks the stated macOS-default-shell floor.
- *Shell loops over lines*: measurably slower and reintroduces the array pitfalls the existing
  code was already fixed for.

## Decision 5: Prohibited token lists are read from the constitution, not embedded

**Decision**: Parse the Prohibited Vagueness List from its blockquote in the constitution, and
parse the prohibited time/randomness/preference token list from the equivalent block that
amendment 2.0.2 will add. Apply the constitution's own stated exclusions when scanning: the
list block itself, and the Illustrative Examples section.

**Rationale**: Same as Decision 1. The lists are normative content. The constitution already
states the exclusions, so encoding them in the tooling instead would fork the rule.

**Prerequisite**: FR-027 cannot be implemented until amendment 2.0.2 defines the second list,
and FR-028 depends on that amendment retagging the example-labeling rule. Everything else in
this feature is independent of 2.0.2. Sequencing consequence recorded in Decision 7.

## Decision 6: Rewrite fixtures in the same change as the checks

**Decision**: Fixture rewrites and new checks land together, not in sequence.

**Rationale**: The four fixtures and the worked example currently violate the rules being
added — no Purpose section, one scenario where two are required, error handling naming none of
the four permitted actions. Three test suites copy `valid-skill/SKILL.md` as their input, so
adding checks first reds the catalog and adapter suites, and rewriting fixtures first leaves
nothing asserting the new shape. This is stated in the spec as a schedule coupling and is the
reason the lowest-value user story is nonetheless on the critical path.

**Alternatives rejected**:
- *Temporarily exempt fixtures from validation*: creates a second, weaker standard for exactly
  the artifacts authors copy from.

## Decision 7: Sequencing against the prerequisite constitution amendment

**Decision**: Implement in two groups. Group A is everything independent of amendment 2.0.2:
the inventory parser, body scanner, registry, the nine directly enforceable rules, the three
conditional rules, the Purpose section, fixtures, path integrity, and the authoring standard.
Group B is FR-027 and FR-028, which wait for 2.0.2.

**Rationale**: Group A delivers 12 of the 13 enforceable rules with no external dependency. If
2.0.2 is deferred or declined, Group A still ships and the remaining rule is simply reported as
unchecked, which the design already handles. This keeps a governance decision off the critical
path of an implementation feature.

**Alternatives rejected**:
- *Block the whole feature on 2.0.2*: makes 12 checks wait on 1.
- *Embed the token list in the tooling now and move it to the constitution later*: violates
  FR-033 in the interim and tends not to get moved back.

## Decision 8: Report format is a contract, because tests assert on it

**Decision**: Fix the reported line format and record it in `contracts/validation-output.md`.
Failures keep the existing `ERROR: ` prefix so current expectations hold, with the rule ID
added in brackets.

**Rationale**: FR-003 and FR-004 describe what must be reported, and the test suite asserts on
the output. Leaving the format implicit would make every test brittle against cosmetic wording
changes. Preserving the `ERROR: ` prefix keeps the existing validator tests meaningful rather
than rewriting them wholesale.

**Alternatives rejected**:
- *Structured output such as JSON*: nothing consumes it programmatically yet, and the
  compliance review artifact that would have consumed it is deferred out of this feature.
