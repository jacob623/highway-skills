# Feature Specification: Slim Highway Identity

**Feature Branch**: `260-slim-highway-identity`

**Created**: 2026-11-21

**Status**: Draft

**Input**: User description: "create a new spec to update highway-identity with your recommended wording."

Replace the long Highway Identity prose with a short agent-facing identity that steers behavior:
Highway is knowledge-centric and Git-native; prefer accepted repository knowledge; keep the
intent→…→generated-assets chain in view; keep clear boundaries (identity is framing only;
Experience Standard owns interaction; owning skills own workflows; the person owns acceptance and
the repository). Direct invocation of highway-experience still answers “what is Highway?” in at
most five sentences and ends with highway-help. The Experience Standard and storage contract are
out of scope for this change.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Agents get a short, actionable identity (Priority: P1)

A maintainer opens the Highway Identity reference used by highway-experience. It is a short
document (not an essay) that states what Highway is, that it is not freestanding codegen, the
knowledge chain at a glance, and the ownership boundaries. An agent reading it can steer away from
inventing organizational facts and toward tracing accepted repository knowledge.

**Why this priority**: The current identity is mostly brochure prose; agents need framing that
changes behavior, not repeated mission language.

**Independent Test**: Diff the identity reference against the prior long form; confirm the new
text matches the locked agent-facing content below and drops the redundant “why orgs lose
context / contextual intelligence / UX feel” essays.

**Acceptance Scenarios**:

1. **Given** the Highway Identity reference after this feature, **When** a maintainer reads it,
   **Then** it contains (in substance) the agent-facing content locked in this spec: what Highway
   is; knowledge-centric not freestanding codegen; the knowledge chain; boundaries for identity,
   Experience Standard, owning skills, and person/repository ownership.
2. **Given** that same reference, **When** compared to the previous identity, **Then** it no
   longer relies on extended mission essays (organizational context-loss narrative, “contextual
   intelligence” expansion, or separate UX-feel section) as the main body.
3. **Given** highway-experience’s activation path, **When** it still directs agents to the
   identity reference for “what Highway is” explanations, **Then** that reference is the slim
   document (same path unless this feature explicitly relocates it into the skill text).

---

### User Story 2 - Direct invoke still summarizes cleanly (Priority: P1)

A person invokes highway-experience directly to learn what Highway is. The skill still produces at
most five sentences ending with highway-help, grounded in the slim identity (and Experience
Standard as already required), without writing files or opening the repository gate.

**Why this priority**: Direct invoke is the user-facing use of identity; collapsing the doc must
not break that contract.

**Independent Test**: Read highway-experience’s direct-invoke procedure and confirm it still
requires a ≤5-sentence summary ending with highway-help, using the slim identity as source.

**Acceptance Scenarios**:

1. **Given** a direct invocation of highway-experience, **When** the procedure is followed,
   **Then** the person sees at most five sentences about what Highway is / why it exists, ending
   with highway-help, and no repository gate or file writes from that path.
2. **Given** the slim identity, **When** an agent prepares that summary, **Then** it can be drawn
   from the slim identity without needing the removed long-form sections.

---

### User Story 3 - Shared activation wording stays coherent (Priority: P2)

Other Highway skills that tell agents to follow highway-experience for Highway’s identity continue
to make sense: identity remains available through experience; no skill is required to re-embed the
long identity prose.

**Why this priority**: Avoid orphaned “read identity” instructions pointing at outdated length or
missing content.

**Independent Test**: Spot-check activating skills’ experience activation lines; confirm they still
name identity via experience and do not require the old long-form document.

**Acceptance Scenarios**:

1. **Given** Highway skills that activate highway-experience for identity, Experience Standard, and
   storage, **When** this feature completes, **Then** those activation instructions remain valid
   against the slim identity (update only if a path or name changes).
2. **Given** the Experience Standard and storage contract, **When** this feature completes,
   **Then** they are unchanged by this feature’s scope.

---

### Edge Cases

- Mentions of Highway Identity in constitution, authoring standard, help index, or tests that
  assert file presence or headings must be updated if they assumed the old long structure.
- If identity is inlined into the skill instead of a separate reference file, activation and
  direct-invoke paths must still find one authoritative short text (no duplicate conflicting
  copies).
- Plugin / adapter regenerate may be required if skill or reference files under `skills/` change
  (follow the repository’s plugin finish order when covered inputs change).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The authoritative Highway Identity content used by highway-experience MUST be
  replaced with the locked slim agent-facing wording (substance below), not a paraphrase that
  reintroduces the removed essay sections.
- **FR-002**: The slim identity MUST state that Highway is a Git-native system that keeps business
  intent, governance, architecture, implementation, and generated work connected in a repository
  the person owns.
- **FR-003**: The slim identity MUST state that Highway is knowledge-centric, not a freestanding
  codegen product, and that agents should prefer tracing and reusing accepted repository knowledge
  over inventing organizational facts or one-off artifacts.
- **FR-004**: The slim identity MUST include the knowledge chain at a glance: Intent → Objectives →
  Research → ADRs → Architectures → Capabilities → Controls → NFRs → Implementations → Plans →
  Tasks → Generated assets.
- **FR-005**: The slim identity MUST state boundaries: identity is framing only (not org facts,
  acceptance, or persistence); user-visible interaction is the Experience Standard; workflows and
  artifacts are the owning Highway skill; durable truth is accepted knowledge in the Git
  repository with the person as owner.
- **FR-006**: highway-experience’s direct-invoke path MUST still summarize what Highway is in at
  most five sentences, end with highway-help, start no repository gate, and write no file, using
  the slim identity as the framing source.
- **FR-007**: This feature MUST NOT change the Experience Standard’s rules or the storage
  contract’s obligations except for incidental cross-references to identity length or location if
  required for accuracy.
- **FR-008**: Tests, catalogs, or docs that assert the old long-form identity structure MUST be
  updated so the suite remains green.

### Locked slim content (authoritative substance)

The shipped identity MUST match this substance (headings may be adjusted for house style; body
meaning must not expand back into the removed essays):

```text
Highway is a Git-native system that keeps business intent, governance, architecture,
implementation, and generated work connected in a repository the person owns.

It is knowledge-centric, not a freestanding codegen product. Prefer tracing and reusing
accepted repository knowledge over inventing organizational facts or one-off artifacts.

Knowledge chain (downstream stays tied to upstream):
Intent → Objectives → Research → ADRs → Architectures → Capabilities → Controls → NFRs
→ Implementations → Plans → Tasks → Generated assets.

Boundaries:
- This identity is framing only — not org facts, not acceptance, not persistence.
- User-visible interaction: Experience Standard.
- Workflows and artifacts: the owning Highway skill.
- Durable truth: accepted knowledge in the Git repository; the person remains the owner.
```

### Key Entities

- **Highway Identity**: Short agent-facing framing document (or inlined equivalent) owned by
  highway-experience.
- **Experience Standard**: Unchanged interaction contract (out of scope except references).
- **Direct-invoke summary**: ≤5 sentences + highway-help for people who ask what Highway is.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A reader can finish the identity framing in under two minutes and state Highway’s
  role, knowledge-centric constraint, chain, and four boundaries without reading other docs.
- **SC-002**: 100% of suite checks that previously depended on identity content pass against the
  slim wording (or updated expectations).
- **SC-003**: Direct invoke of highway-experience still yields at most five sentences ending with
  highway-help with no gate or file writes on that path.
- **SC-004**: No owning skill is required to carry a second copy of the long identity essay.

## Assumptions

- The recommended wording from the prior design discussion is accepted as the locked substance
  (FR locked content).
- Keeping a separate reference file under highway-experience is the default; inlining into the
  skill is allowed only if a single authoritative copy remains and activation paths are updated.
- Experience Standard remains the interaction authority; this feature does not slim or relocate it.
- Plugin finish-order rules apply if covered skill/plugin inputs change as part of implement.
