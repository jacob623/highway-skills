# Contract: Point-of-Use Wording

Exact text added to skill documents, and exact strings removed. Every entry is an **emitted literal**
or a **skill-owned procedure** — never a restated obligation, per P7.3 and Research D1.

---

## 1. `highway-profile` — shared literals

Defined once under `#### Domain completeness`, referenced by all four domain subsections (FR-014,
Research D2).

### Capture heading

```text
**Here's what I've captured as your [domain]:**
```

`[domain]` is the domain name: `Identity`, `Vision`, `Competitive Path`, `Guiding Principles`.

**Applicable sites**: 4. Currently realized: **0** — this literal appears in `highway-controls`,
`highway-nfrs`, and `highway-objectives`, but not in `highway-profile`. That asymmetry is the
feature's strongest single piece of evidence.

### Validation question

```text
**What would you add, correct, or remove?**
```

**Applicable sites**: 4. Defined once; each domain references it by name.

**Superseded strings — removed outright, not deprecated (FR-030)**. Each must be absent from the
repository after the change, asserted with `require_absent`:

| Domain | Removed string |
|---|---|
| Identity | `**What's missing or wrong in this description of [Organization Name]?**` |
| Vision | `**What's missing or wrong about where [Organization Name] is going?**` |
| Competitive Path | `**What's missing or wrong about how [Organization Name] gets there?**` |
| Guiding Principles | `**What's missing or wrong about what guides decisions at [Organization Name]?**` |

The four trailing sentences (`You can also change it or provide your own description.` and its three
variants) are also removed; the single question replaces the whole construction.

### Domain opening headings — unchanged

| Domain | Heading |
|---|---|
| Identity | none; fallback question `**What does [Organization Name] do?**` |
| Vision | `### Where you're going` |
| Competitive Path | `### How you'll get there` |
| Guiding Principles | `### What will guide your decisions` |

---

## 2. `highway-profile` — per-domain procedure

### Vision — negative boundary (FR-027)

Vision currently has no negative clause. Competitive Path has a strong one. Add a boundary clause to
Vision's meaning paragraph in the same form, stating what Vision does not elicit or retain —
specifically, the approach, sequencing, and organizational method that belong to Competitive Path.

### All four domains — cross-domain preservation (FR-028)

Relocate the obligation currently stated only as a `## Verification` bullet:

```text
- Supported cross-domain implications are preserved for the appropriate unresolved domain.
```

into the domain instructions at the point of composition, where it applies. The gate bullet remains;
the point of use is new. This is the exact shape the feature argues for — a rule that existed only as
a gate and never as an instruction.

---

## 3. `highway-profile` — `## Readiness` and `## Operations`

### FR-024 — how completeness is obtained

`## Readiness` currently says Profile *determines* domain completeness but never says it is obtained
by reading the retained Profile artifact. One observed run filled that gap by inventing a command,
then described its own behavior as using "an unsupported command surface". The defect is an
under-specified instruction.

Add, naming the artifact explicitly as P1.5 requires: domain completeness is obtained by reading the
retained Profile record at its declared path. No command is invoked to determine readiness.

### FR-025 — persistence names its operation

`## Operations` says acceptance "authorizes the mutation" and that the mutation must be performed,
but never names the operation. Name it: the mutation is a write to the retained Profile record.

### FR-026 — authorization stays local

No general permission and no general prohibition is added anywhere. Both statements above are scoped
to the section that owns them. Nothing is added to the Experience Standard, the constitution, or any
other skill on this subject.

---

## 4. `highway-profile` — `## Verification` gate bullets

One bullet per behavior this feature adds or amends.

**Rewritten** (FR-013):

| Before | After |
|---|---|
| `- Each domain's validation question asks what is missing or wrong in the candidate.` | `- Each domain uses the single defined validation question.` |

**Added**: one bullet for each of the capture heading, the acceptance boundary, the re-presentation
ceiling, rejected vocabulary, amendment form, acknowledgment, emphasis, the Vision boundary, and the
readiness and persistence operations.

**Unchanged**: the remaining existing bullets, including the cross-domain bullet, which keeps its
gate while gaining a point of use.

---

## 5. Skills outside this feature

**No skill other than `highway-profile` is modified by this feature.**

Planning did locate a pre-existing conformance gap elsewhere: `highway-controls` and `highway-nfrs`
still emit closed acceptance questions answerable by bare agreement. That finding is recorded in
Research D4 as a handoff, not as work. It is deliberately **out of scope** and will be addressed in a
separate spec covering the remaining skills.

`highway-objectives` was checked and is clean: it carries the capture heading and emits no closed
acceptance question.

Task T068 asserts the boundary mechanically — `git diff --name-only -- .highway/skills/` must name
only the Profile skill.

---

## 6. Test assertion inventory

| Assertion | Helper | Count |
|---|---|---|
| Each added rule row present | `require_text` on the standard | 10 |
| Each amended Observable present | `require_flowed` on the standard | 2 |
| Rule total equals 59 | `grep -cE` | 1 |
| Capture heading at each domain site | `require_text` + site count | 4 + 1 |
| Validation question defined once | `grep -c` equals expected definition count | 1 |
| Each superseded string absent | `require_absent` | 6 |
| Each gate bullet present | `require_text` on the skill | ~10 |
| Vision boundary clause present | `require_flowed` | 1 |
| Cross-domain text at point of use | `require_flowed` | 1 |
| Readiness and persistence operations named | `require_flowed` | 2 |
| Adapters byte-identical to source | `cmp -s` | 4 |

The site-count assertions are load-bearing. Without them, a reference-based implementation could
collapse four point-of-use sites into one and still satisfy every `require_text` call. See
Research D8.
