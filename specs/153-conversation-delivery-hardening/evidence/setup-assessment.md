# Setup Assessment — Post-Spec-152 Round

**Date:** 2026-10-08
**Transcripts:** `setup-cursor-gemini-1.md`, `setup-cursor-gemini-02.md`, `setup-codex-luna-1.md`, `setup-codex-luna-2.md`, `setup-copilot-luna-1.md`, `setup-copilot-luna-2.md`
**Baseline:** Experience Standard `11.0.0`, `highway-profile` `11.0.0`

---

## 1. Headline

Spec 152's core literal landed. The capture heading and the single validation question
appeared in **22 of 24** domain presentations across six runs and three hosts. The
behaviors 152 delivered as *emitted literals* held up. The behaviors it delivered as
*rules only* did not.

That split is the whole story of this round, and it confirms the Research D1 prediction
rather than contradicting it:

| Delivery mechanism | Observed conformance |
|---|---|
| Emitted literal in the skill (capture heading, validation question) | 22/24 |
| Skill-owned procedure (Vision/Competitive Path boundary, carry-forward) | 2/6 runs |
| Rule-only in the Experience Standard (X2.36 internal narration) | 2/6 runs |

**The strongest remaining defect is a rule that already existed before 152** — X2.36,
internal narration — and it is failing because `highway-profile` has no point-of-use text
for it. This is precisely the gap FR-029a deferred to a later feature. The deferral is now
measurably costing conformance.

---

## 2. Conformance matrix

| Behavior | Rule | Cursor 1 | Cursor 2 | Codex 1 | Codex 2 | Copilot 1 | Copilot 2 |
|---|---|---|---|---|---|---|---|
| Capture heading on every domain | X2.58 | 4/4 | 4/4 | 4/4 | 4/4 | 4/4 | **2/4** |
| Validation question emphasized | X2.67 | pass | pass | pass | **fail** | pass | pass |
| No unchanged re-presentation | X2.60 | pass | pass | **fail** | pass | pass | pass |
| Change marked distinguishably | X2.56 | n/a | pass | weak | pass | n/a | pass |
| No internal narration | X2.36 | pass | **fail** | pass | **fail** | **fail** | **fail** |
| Vision excludes method/sequencing | Profile procedure | **fail** | **fail** | pass | pass | **fail** | **fail** |
| Cross-domain carry-forward | Profile procedure | n/a | n/a | pass | pass | n/a | n/a |
| Acknowledgment adds understanding | X2.65 | pass | pass | pass | pass | weak | weak |
| No second confirmation awaited | X2.59 | pass | pass | pass | pass | weak | **fail** |

---

## 3. Defects, most severe first

### 3.1 Copilot 2 retained two domains with no Converged Proposal — X2.58

The most serious finding in the round. Competitive Path and Guiding Principles were both
persisted without ever being presented under the capture heading:

> I'm taking "all of your suggestions" as acceptance of the proposed Competitive Path and
> recording it now.

There is no `**Here's what I've captured as your Competitive Path:**` block anywhere in that
transcript. The same happens for Guiding Principles. X2.58 requires retained substance to
cross an explicit acceptance boundary tracing to "a response in which the person accepted
**that specific candidate**." The person accepted a bulleted list of *possibilities*, not a
candidate. Two of four Profile domains were written from material the user never saw in
final form.

This is a correctness failure, not a style failure.

### 3.2 Internal narration is the dominant cross-agent defect — X2.36

Four of six runs leak workflow internals. X2.36 has existed since before this feature and
is unambiguous, yet:

- **Copilot 1** (worst): "I'm recording only the accepted Identity, repository name, and
  supplied website context in the Profile, then I'll continue with the next Profile
  domain"; "I'm persisting it alongside the accepted Identity"; "validating the Profile,
  and then I'll open the final Profile domain"; "I'll begin the Objectives domain with its
  required transition."
- **Codex 2**: "I've loaded Highway's identity and interaction rules. I'm checking the
  Profile owner's readiness contract and current repository context first, then I'll follow
  the setup order."
- **Copilot 2**: "Your approval crosses the Profile acceptance boundary." — this leaks our
  own specification vocabulary verbatim into the user's face.
- **Cursor 2**: `*(Persisted profile to .highway/library/knowledge/profile.md)*`

Your Copilot 1 note — "Internal talk. Am I loading the correct agent file for copilot?" —
is diagnosing the symptom correctly but the cause is not adapter loading. The adapters are
byte-identical copies, verified. The cause is that 152 added "does not name readiness
statuses, next actions, blocking reasons, domain states, or persistence steps" to the
**Readiness** and **Operations** sections only. The leakage is happening in the
**transitions between domains**, where Profile carries no such text. The rule is in the
Standard; the point-of-use reminder is not where the agent is writing.

Also note Cursor 2's path `.highway/library/knowledge/profile.md` does not match the
declared record location. Either the agent invented it or the record location is being
mis-resolved — worth confirming independently, because a narration defect masked a possible
persistence defect.

### 3.3 Vision absorbs approach and sequencing — Profile procedure, 4/6 fail

152 added: *"Vision does not elicit or retain the approach, sequencing, or organizational
method for reaching that future; those belong to Competitive Path."* It holds on Codex
(2/2) and fails everywhere else (4/4):

- Cursor 2 Vision: "whose classes and gatherings serve as a living foundation—testing,
  refining, and inspiring..." — that is the method.
- Copilot 1 Vision: "...can develop and refine its classes... from lived local experience
  **before extending** those offerings" — that is sequencing.
- Copilot 2 Vision: "**By building that community first**, Grow Creative will create the
  foundation for..." — sequencing again.

Codex 1 is the model of correct behavior here and shows the rule is achievable:

> That adds the approach you intend to take... **I'll carry those plans into the discussion
> of how Grow Creative will get there.** I've kept the Vision focused on the future
> community you want to create.

This is your own Codex 1 observation inverted. You wrote that you crossed the boundary and
"the model acknowledged what I said, but presented the same vision. It could have said...
that it would cover that when we talk about how we'll get there." It *did* say exactly
that. The defect you actually hit was the next one.

### 3.4 Codex 1 re-presented an unchanged Vision — X2.60

After carrying the expansion plans forward, Codex 1 reprinted the Vision **byte-identical**
and asked for validation again. X2.60 requires a re-presented candidate to name what
changed; nothing changed, so it should not have been re-presented at all. The correct move
was to state the carry-forward and proceed to Competitive Path.

This is the single clearest instance in the round of a 152 rule being violated outright.

### 3.5 The shared validation question leaked outside Profile — new risk introduced by 152

Codex 1's Objectives opener:

> A possibility grounded in your Profile is to grow the local community... That is a
> direction to react to, not an objective you've chosen.
>
> **What would you add, correct, or remove from this direction?**

Nothing had been captured. The question that 152 defined as the *acceptance boundary for a
Converged Proposal* is being used to solicit reaction to a speculative prompt. By making
one question shared and prominent, we raised the odds of it being applied where no
candidate exists.

This also explains your reaction — "I'm not sure if the last response was a hallucination
or the start of objectives. I didn't see a heading change." Two compounding causes:

1. The Objectives opener in `highway-setup` is **bold text**, not a `###` heading, while
   every Profile domain opens with `###`. The visual rhythm breaks exactly at the handoff.
2. The validation question appearing there implied a captured candidate that did not exist.

This is a real gap and it is in `highway-setup`, not `highway-objectives`.

### 3.6 Codex 2 did not emphasize several questions — X2.67

Your favorite run is the one that fails the emphasis rule. At least five questions are
unbolded, including two validation questions:

> What would you add, correct, or remove from that description of what your organization does?
> What part would you change, or what's missing?

Worth stating plainly: **perceived conversational quality and mechanical conformance are
independent.** Codex 2 scored highest with you and fails a rule Copilot 1 passes. We should
not let conformance scoring become a proxy for the experience you actually want.

### 3.7 Copilot asks twice after acceptance — X2.59

Copilot 2, twice:

> **User:** What you've suggested is pretty good.
> **Assistant:** What part, if any, would you add, correct, or remove?

X2.59 requires unambiguous approval to be treated as acceptance regardless of wording.
"Pretty good" is approval. Contrast Codex 2, which handled genuine partial acceptance
correctly under X2.50:

> **User:** That's pretty close
> **Assistant:** What part would you change, or what's missing?

"Pretty close" signals reservation; "pretty good" does not. The distinction is fine but
real, and only Codex drew it correctly.

### 3.8 Amendment form is underspecified — X2.56

X2.56 says the change must be "visibly marked" but does not say how. The two Codex runs
chose differently and you preferred one:

- **Codex 1**: a separate `**Changed:**` paragraph appended after the candidate. Your note:
  "it could have just incorporated the change instead of adding it as its own thing."
- **Codex 2**: the change bolded **inline** within the otherwise unchanged text. Your note:
  "That was helpful."

Codex 2's form is also the better reading of X2.63 (retain the accepted content's original
form). The rule should name the inline form.

---

## 4. Your three general requests

These are new requirements, not defects. Each needs a different owner.

### 4.1 Reassurance after the validation question — settled

Final wording:

> If this is accurate, just say so. If you don't know, say "I don't know" and we'll work
> through it together.

Your revision resolves the objection I raised against the first draft. "Let me know"
invited a bare yes/no; "just say so" asks for an affirmative statement and gives
"I don't know" an explicit, named path. That matters because a yes/no instinct is what
produces the thin acceptances seen throughout this round — "looks good", "this looks good",
"that looks good" — which satisfy X2.59 but carry no substance.

Worth noting the interaction with X2.37 and X2.41: both require a Substantive Contribution
before a Converged Proposal, and approval alone does not count. Naming "I don't know" as a
legitimate response gives the person a way to signal they have nothing to add *without*
manufacturing a fake contribution. That is a genuine improvement to the rule's workability,
not just to tone.

The reassurance must stay **unemphasized** so the question remains the only bolded element
under X2.67. Mechanically this touches the shared block in `highway-profile`, its test
assertions, and the four adapter copies. `#### Domain completeness` is at 216/400 words, so
there is room.

### 4.2 Advisor, not scribe — corrected and specified

I misread this. You were not pointing at the select boxes. The target is
**`setup-cursor-gemini-02.md` line 151**, the Competitive Path Contribution Opportunity:

> Drawing from your accepted Identity and Vision, a grounded strategic path centers on using
> your physical studio classes to incubate, test, and refine kits and curricula directly
> with students and families, packaging those proven lessons into scalable kits and modular
> educational offerings, and **distributing them through direct-to-consumer channels and
> partnerships with homeschool networks and schools**.

Your explanation is the key to the whole problem: *"There were things I didn't say... I may
only be selling in a local craft store and have curriculum in one school right now, but that
suggestion expands my thinking."*

That reframes the requirement. The advisor behavior is **not** a better question about what
the person already said. It is a grounded extension *past* what they said — naming a
reachable option they had not articulated. Codex 2's distinction-forcing question, which I
held up last round, is a different and lesser thing: it clarifies existing material. It is
good, and it satisfies X2.50, but it does not expand thinking. Cursor 2 line 151 does.

#### The sequence you described

| Step | What happens | Governing rule |
|---|---|---|
| 1 | Person makes a Substantive Contribution | X2.37, X2.41 |
| 2 | Agent acknowledges and builds on it, one foot on the ground | X2.38, X2.42 |
| 3 | **The acknowledgment and the built-on reasoning are written to the screen** | *no rule* |
| 4 | Agent takes all of step 3 and either asks targeted questions or presents a candidate carrying the new possibility | X2.42, X2.50 |

#### The gap is step 3, and it is precise

X2.38 and X2.42 both exist and both already license this behavior. Neither requires it to
be **visible**:

- **X2.38** mandates re-evaluation after a Substantive Contribution — then says outright:
  *"internal re-evaluation need not be narrated."*
- **X2.42** is a **prohibition**, not a requirement. It forbids converging while grounded
  non-redundant reasoning could improve the Working Idea. It does not oblige the workflow to
  *emit* that reasoning.

So an agent fully conforms to X2.38 and X2.42 by re-evaluating silently and asking a plain
question. That is exactly the scribe behavior in Cursor 1, Copilot 1, and Copilot 2 — all
three are conformant and all three are flat. **This is why the round felt analyst-like: the
Standard permits the advisor and requires the scribe.**

X2.65, added by 152, gets close but not there. It requires an acknowledgment to add
"an implication, consequence, tension, or connection absent from the person's own words" —
all of which look *inward* at what was said. Line 151 looks *outward* to options not yet
considered. X2.42 already names the right vocabulary for this and it is unused in any
requirement: **alternatives, opportunities, recommendations, combinations, redirections.**

#### Recommended rule

Framing matters here, and "make the reasoning visible" was the wrong frame. It describes
Highway's internal process and points straight at the X2.36 defect in §3.2 — an agent told
to show its reasoning will narrate itself. X2.38 already says internal re-evaluation need
not be narrated, and it is right to say so.

The correct frame is **contribution**:

*When grounded non-redundant reasoning would materially improve the relevant Working Idea,
an Interactive Workflow MUST contribute one useful addition to the person's thinking —
either a distinction latent in what they have already said, or an extension beyond it.*

Observable: the response offers a single distinction, implication, tension, connection,
alternative, opportunity, recommendation, or redirection traceable to accepted context and
absent from the person's own words; optional detail, repetition, unsupported speculation,
manufactured alternatives, ceremony, or low-value addition does not satisfy it.

This frame is better on three counts. It describes an **output the person receives** rather
than an internal state exposed. It cannot be satisfied by narrating process. And it makes
the quality bar *usefulness to the person*, not completeness of disclosure — line 151 is
valuable because it named a reachable option, not because it showed work.

#### Two kinds of contribution, and the latent one is stronger

A later review named a gap this section had: the strongest moments in the round were not
always recommendations. Sometimes the workflow **surfaced structure that was already in the
person's material but never explicitly named**. That is a different act from extension, and
the rule above now covers both:

| Kind | What it does | Source of the content |
|---|---|---|
| **Distinction** | names structure latent in what was said | the person's own material, reorganized |
| **Extension** | names a reachable option not yet said | accepted context, reached past |

The distinction form is the safer and probably the more valuable of the two. It cannot
manufacture novelty, because its raw material is entirely the person's own — which means
the over-specification risk raised below applies far more weakly to it. And it is closer to
what `highway-identity.md` already describes as contextual intelligence making implications,
tensions, and connections visible.

**One correction on the exemplar.** The review offered *"community is upstream of
curriculum"* as the illustration. In the transcript that insight is **the user's**, at
`setup-codex-luna-2.md` line 125 — *"for us, everything starts with community... From there,
we learn from the community."* The agent received it rather than produced it. An exemplar
has to be built from a move the agent actually made, and there are three good ones, all in
Codex 2:

- **Line 85** — *"Your online community idea suggests carrying the character of those local
  relationships into a new setting, rather than simply putting classes online."* A
  distinction drawn out of the single word *resembles*.
- **Line 151** — *"A possible guiding idea... is that the community should shape what Grow
  Creative teaches and creates."* Latent structure named as an organizing principle.
- **Line 157** — *"That adds an important decision lens: growth should be judged by the
  quality and value of the work... rather than by scale."* A stated preference reframed as a
  criterion.

All three close with attribution — *"That's my interpretation," "That's my synthesis, not
wording you've accepted as a principle"* — so they satisfy X2.52 and X2.54 without being
told to. They are better exemplar material than anything in the extension family, and they
come from the run you rated highest.

Worth noting what this does to the §4.1 reassurance. If the workflow reliably surfaces
distinctions, *"I don't know"* stops being a dead end — the next move is to name the
structure already present and ask the person to confirm or break it.

#### Two corrections to an earlier draft of this rule

A review of this assessment caught that the first version — *"MUST contribute a useful
extension when accepted context supports one"* — borrowed X2.42's vocabulary while leaving
behind the two things that make X2.42 safe. The objection is correct and the rule above is
the repair.

**Defect 1: the trigger was too weak.** "When accepted context supports one" is nearly
always true — accepted context will almost always support *some* extension. A condition that
never fails turns a conditional MUST into an unconditional one, and an unconditional
obligation to be novel produces manufactured novelty. X2.42's real threshold is
*materially improve the relevant Working Idea*, and it belongs in the rule verbatim. X2.42
also carries an exclusion list — *"optional detail, repetition, unsupported speculation,
manufactured disagreement, ceremony, or low-value detail alone does not"* — which I dropped
entirely. It is restored.

**Defect 2: "at least one" invited padding.** The failure mode the review names is concrete:

> Here's an opportunity... Here's another opportunity... Here's a third opportunity...

152 already set the precedent against this. X2.66 requires *one* acknowledgment per
Substantive Contribution, not at least one, and explicitly says it "does not follow
responses that do not" supply such information. The new rule should mirror that exactly:
**one** extension, and none when the threshold is not met.

The exemplar supports the restraint. Cursor 2 line 151 offers a single extension woven into
the Contribution Opportunity's prose — not an enumerated list of strategic options. The
behavior worth reproducing is already quantity-disciplined.

**Why the threshold does not re-create the scribe problem.** X2.42 has carried this exact
threshold all along and the round was still flat. Flatness came from X2.42's *prohibition
form*, not its threshold — a MUST NOT on converging obliges nothing. Converting to a
requirement while keeping the threshold preserves the fix and restores the brake. The two
changes are independent.

#### The volume risk is not covered by the existing brakes

Worth stating plainly, because it is the part of the critique that §4.2's brake quartet does
**not** answer. X2.52, X2.53, X2.54 and X2.43 all police *groundedness* — whether an
extension traces to accepted context and whether it may enter a candidate. None of them
polices *volume*. Three well-grounded opportunities are three grounded opportunities, and
every brake passes.

The advisor problem and the invention problem genuinely do live next to each other, and the
distance between them is mostly quantity and threshold. Those are the two controls the
revised rule adds.

#### The symmetry this exposes

The Standard defines **Substantive Contribution** as something only the *person* makes.
X2.37 and X2.41 both require it from them before convergence. Nothing anywhere requires a
contribution from **Highway**.

That asymmetry is the structural cause of the scribe problem. The workflow is obliged to
extract substance and obliged not to converge prematurely, but never obliged to *add*
anything. The proposed rule is the reciprocal obligation — collaboration in both directions
rather than interrogation in one.

It needs point-of-use text in `highway-profile`; per §1, a rule-only delivery will not
survive.

#### Two artifacts, not one rule

A review of this assessment pushed back on treating §4.2 as a missing Standard rule alone,
and the correction is right. There are **two deliverables**, and shipping either without the
other reproduces the variance in §2:

| Artifact | Owner | What it does |
|---|---|---|
| Requirement | Experience Standard | Creates the **obligation** |
| Worked exemplar | `highway-profile` | Creates the **behavior** |

**The rule cannot produce the behavior.** X2.42 has licensed this move since before 152 and
produced it in one run out of six. A rule tells an agent that something is required; it does
not show what the thing looks like. That is the empty third row in §6 — and the reason the
capture heading held 22/24 is that the skill contained the exact string.

**The exemplar cannot create the obligation.** Without a rule, an example is decoration an
agent may skip, with no oracle to test against and no basis for asking why a run was flat.

Both, or neither works. Item 2 in §7 should be read as two work items.

#### Two cautions on the exemplar's shape

The review sketched the exemplar as:

> You said X. One possibility I see is Y. That might imply Z. **Am I looking at that
> correctly?**

The first three sentences are right. "One possibility I see" carries attribution and
satisfies X2.52 directly. The closing question has a problem.

**It is a closed yes/no question** — precisely the instinct removed from the validation
question in §4.1. You replaced "let me know" with "just say so" to kill the yes/no reflex;
"Am I looking at that correctly?" reinstates it one turn earlier. It also asks the person to
grade *Highway's* interpretation rather than contribute their own, which works against X2.37
and X2.41: a yes is approval, and approval is explicitly not a Substantive Contribution.

The working exemplar closes the other way. Cursor 2 line 151 ends on **"How does Grow
Creative plan to get there?"** — open, and it produced your most substantive reply of that
run. The extension should land inside a Contribution Opportunity that ends on an open
question.

**The exemplar must be concrete, not a placeholder skeleton.** X/Y/Z shapes invite mechanical
filling, and the round already shows that failure. Your Codex 1 note — *"The model may be
following too closely to examples or something. It seems awkward"* — is the symptom. A
worked example using real Profile content is far likelier to transfer as behavior than a
template is; a template transfers as a form to complete.

#### The brake

"One foot on the ground" is already enforceable and should be cited explicitly so the new
rule cannot be read as license to invent:

- **X2.52** — introduced claims attributed. Line 151 does this: *"Drawing from your accepted
  Identity and Vision..."*
- **X2.54** — recommendations not grounded in accepted evidence marked speculative. Line 151
  does not need marking: direct-to-consumer channels and homeschool partnerships both trace
  to the accepted Identity, which already contains kit sales and curriculum for homeschool
  families and schools. The extension was *reachable from accepted context*, which is the
  boundary.
- **X2.53** — attributed terms the person has not adopted MUST NOT enter a Converged
  Proposal. This is the real safeguard: the agent may raise "direct-to-consumer channels" in
  a Contribution Opportunity, but cannot write it into the candidate until you adopt it.
- **X2.43** — a Contribution Opportunity MUST NOT be presented as a candidate. Line 151 is
  correctly placed: it carries no capture heading and no acceptance request.

That quartet already draws the line between *expanding your thinking* and *putting words in
your mouth*. The new rule can lean on them rather than re-litigating the boundary — but only
for groundedness. Quantity and threshold are not among them, which is why the rule carries
its own.

### 4.3 Continuity signal between domains

You want, before the `### How you'll get there` heading:

> Now that we know where you're going, let's talk about how you'll get there.

I first framed this as **missing transition language**. A later review argued it is
**missing continuity signal**, and that is the better reading. The difference is what the
sentence is made of:

| Framing | Example | What it proves |
|---|---|---|
| Navigation | "Identity complete. Next: where you're going." | the workflow knows its own sequence |
| Continuity | "You mentioned community several times while describing Grow Creative. If community remains central, what future are you trying to create through it?" | the workflow carried your material forward |

Only the second is evidence of anything. A generic transition sentence is navigation wearing
a friendlier voice, and it would pass a test that asserts a sentence exists while leaving the
experience unchanged. The requirement should be that the transition **carries accepted
substance from the closed domain into the opening question of the next one.**

The round contains a working instance. Codex 2 line 185 opens Objectives with *"Your Profile
makes growing the local community a clear outcome to consider, since you've said community
is the priority and the foundation for learning through classes and workshops"* — the handoff
that confused you elsewhere, done as carry-forward.

This also changes what §3.2 is. Currently `highway-profile` defines the four headings but no
transition sentence, and the gap is being filled with internal narration — Copilot literally
announces "I'll continue with the next Profile domain." Both defects are the same vacuum,
and they are the same sentence seen from two sides: the agent reaches for continuity, finds
nothing specified, and narrates its own workflow state instead. **Giving it accepted
substance to carry forward removes the reason to narrate.** That makes items 3 and 4 in §7
one fix, not two.

You note this "will probably extend beyond" Profile. It should: the Profile→Objectives
handoff in `highway-setup` is the one that confused you, and it has the heading-level
inconsistency too. Recommend specifying transitions as a shared contract across Interactive
Workflows and then giving each skill point-of-use text — otherwise we reproduce exactly the
rule-only failure documented in §1.

---

## 5. What I'd correct in your observations

- **Codex 1, Vision boundary.** You wrote the model "presented the same vision" and should
  have said it would cover the approach later. It *did* say that. The actual defect is that
  it then reprinted an unchanged candidate (X2.60). Worth separating, because the
  carry-forward behavior is working and should not be re-specified.
- **Copilot 1, adapter loading.** Skill adapters are verified byte-identical across all four
  trees. Grounding is a separate question, answered in §6 — the path is correct, the
  mechanism is weak.
- **Cursor 2, select boxes.** Withdrawn. You were pointing at line 151, not the select
  boxes. See the rewritten §4.2; my original reading sent the recommendation in the wrong
  direction.

---

## 6. Agent grounding — is `.github/copilot-instructions.md` correct?

**Yes, the path is correct.** It is the supported auto-loaded location for Copilot in VS
Code. Every host is covered, and `generate-instructions.sh` writes all four from one source:

| Host | Grounding file | Auto-loaded | Present |
|---|---|---|---|
| Copilot | `.github/copilot-instructions.md` | yes | yes |
| Claude | `.claude/CLAUDE.md` | yes | yes |
| Cursor | `.cursor/rules/highway-agent-context.mdc` (`alwaysApply: true`) | yes | yes |
| Codex | `AGENTS.md` (repo root) | yes | yes |

All four carry identical bodies. There is no loading defect.

### But the mechanism is weak, and the evidence shows it

All four files are the same 784-byte **pointer**. They contain no behavioral content — they
tell the agent to go read two files totaling 347 lines, including 59 numbered rules. Nothing
verifies the agent ever opened them.

The round gives a direct test. X2.36's point-of-use delivery in `highway-profile` is a
single Verification bullet — *"Internal readiness vocabulary does not appear in orchestrated
conversation"* — which covers readiness vocabulary and nothing else. Copilot 1's *"I'm
persisting it alongside the accepted Identity"* is persistence narration, outside that
bullet's scope and squarely inside X2.36's. The rule failed in 4 of 6 runs, across all three
hosts — including Cursor, which has the strongest grounding affordance (`alwaysApply: true`).
Meanwhile the capture heading and validation question, which live as literals **inside the
skill file the agent actually loads**, held 22 of 24.

Grounding mechanism did not predict conformance. Point-of-use did.

### Should the Standard be embedded directly?

**No — and the grounding file already says why**, in its own fourth bullet: *"Do not
reproduce, reinterpret, or create competing copies of their contracts."* Embedding would:

- create a second copy of a 59-rule document that drifts from the authoritative one, which
  is the exact failure `generate-instructions.sh` exists to prevent;
- conflict with constitution rule **P7.3**, which forbids restating a requirement owned
  outside the restating document — the same constraint that shaped all of Spec 152;
- load all 59 rules into every session for every skill, including ones where none apply.

### What to do instead

1. **Keep the pointer, strengthen its verb.** The file currently says *"Consult
   `.highway/governance/experience-standard.md` for applicable user-visible interaction and
   output requirements."* "Consult" is advisory and carries no trigger. Something closer to
   *read before producing user-visible output in an Interactive Workflow* names the moment.
   Cheap, no duplication, no constitution conflict.
2. **Put the weight in point-of-use text**, which is in-context by construction whenever the
   skill runs and costs nothing when it does not. This is the §1 finding and it is the only
   mechanism with evidence behind it.

The honest summary: grounding is correctly wired and doing less than it appears to. It is
not where the next fix belongs.

### Is the Experience Standard pointless, then?

No \u2014 but the question is fair, and the answer requires conceding something.

**What it is not:** a runtime behavioral control. Writing a rule into the Standard does not
make the rule happen. 152 demonstrated this and this round confirms it. Any plan that ends
at "we added the rule" is finished too early.

**What it is:** the single normative source and the verification oracle. Both jobs are
load-bearing, and neither can move into the skills:

- **One definition, twelve skills.** `highway-controls`, `highway-nfrs`, and
  `highway-objectives` all carry `Here's what I've captured as your ...` \u2014 the same literal
  as Profile. That consistency exists because one document defines the behavior. Delete the
  Standard and twelve skills drift into twelve dialects within a few features.
- **It is what the tests assert against.** The 76-test suite checks delivery sites, but the
  rules are what make a site *correct*. Without the Standard there is no oracle, only
  whatever each skill happens to say.
- **It settles conflicts.** When a skill and the Standard disagree, there is an authority.
- **It is where a behavior is reasoned about.** X2.42's vocabulary \u2014 alternatives,
  tensions, redirections \u2014 is what made \u00a74.2 specifiable at all. That thinking has to live
  somewhere, and it cannot live in four parallel copies.

**The right mental model is source and build output.** The Standard is the source; the
skill's literals, procedure, and Verification bullets are the compiled artifact the agent
actually executes. A header file is not pointless because the linker is what produces the
binary. But you also do not ship the header and call it a program \u2014 which is the mistake
worth naming.

### The real defect is that propagation is manual and unverified

P7.3 forbids restating a requirement owned elsewhere, so delivery is restricted to emitted
literals, skill-owned procedure, and Verification bullets (Research D1). That architecture
is sound. What is missing is any check that propagation **happened**.

Nothing in the repository can answer: *which rules have a delivery site in which skills?*
X2.36's bullet covers readiness vocabulary and silently omits persistence narration. No test
caught that, because tests assert that written text exists \u2014 not that a rule is covered.
### Three delivery techniques, not one

A second opinion offered on this question framed the split as *standards are good at
constraints and bad at behaviors*, and proposed that the Standard own prohibitions while
skills own advisory behavior. The category distinction it draws — generation is not a weak
form of prohibition — is correct and useful. Its central claim is not: **in this round,
constraints are precisely what failed.**

| Rule type | Example | Result |
|---|---|---|
| Prohibition | X2.36 don't narrate persistence | **4/6 runs failed** |
| Prohibition | X2.59 don't ask for acceptance twice | Copilot 2 failed |
| Prohibition | X2.60 don't re-present unchanged | Codex 1 failed |
| Positive literal | emit capture heading + validation question | **22/24 held** |

The three prohibitions cited as things a standard "can effectively say" are verbatim the
three that broke, while the generative instruction — *write this exact sentence* — was the
most reliable behavior observed. The equivocation is between **expressibility** and
**efficacy**: a standard states a prohibition easily and causes it poorly.

The mechanical reason is the one already visible in X2.36. **A positive behavior has a
literal; a prohibition does not.** "Emit this heading" becomes text the agent types and a
test can assert. "Don't narrate internals" can only become a Verification bullet, whose
scope can quietly under-cover the rule it serves.

So the useful axis is not constraint vs. behavior. It is **definition vs. delivery**. Both
kinds of rule need central definition — for consistency and for an oracle — and both need
point-of-use delivery to actually occur. What differs is the technique available:

| Rule type | Delivery technique | Strength | Evidence |
|---|---|---|---|
| Positive behavior | emitted literal | strong | 22/24 |
| Prohibition | Verification bullet | weak; under-scopes silently | X2.36 |
| Generative behavior | *none exists* | absent | §4.2 |

The empty third row is the real finding, and it reaches the same destination the second
opinion proposed — skills should own examples and sharpening moves — by a different route.
Not because standards are bad at behaviors, but because **generative behavior is delivered
by exemplars, and exemplars are domain-specific.**

Stated plainly, because this is the operative conclusion of the whole assessment:

> **The rule creates the obligation. The exemplar creates the behavior.**
> Neither one alone is sufficient, and shipping only the rule is what produced §2's variance.

So the generative row needs a third delivery technique that does not exist today: a worked
example carrying real domain content, living in the skill where the domain is known. The
requirement that one is produced belongs in the Standard; what it looks like belongs in
`highway-profile`. See §4.2 for the two artifacts and the cautions on exemplar shape.

Two cautions against moving further than that:

- **The Standard is what made §4.2 specifiable.** X2.42 already supplied the vocabulary —
  alternatives, tensions, redirections, opportunities. Without it there was nothing to
  reason with. The Standard is good at *defining* behavior; it is simply not a delivery
  mechanism.
- **Advisory behavior with no central definition is unmeasurable.** If each skill owns its
  own sharpening moves, Profile sharpens one way and NFRs another, and the only available
  verdict is "Cursor 2 felt better" — which is where this round began. Host variance is
  already visible in §2; per-skill variance would compound it.

Worth noting that Highway already has the proposed architecture. P7.3 confines skills to
literals, procedure, and Verification bullets and forbids restating rules. The split is not
the thing to redesign; the unverified propagation across it is.

**Recommendation:** a rule-coverage report mapping every Standard rule to its delivery
site(s) per applicable skill, recording the technique used and carrying explicit
`not-applicable` entries. Highway already generates a skill catalog and a library catalog;
this is the same pattern. It would surface the seven prohibition bullets 152 added whose
coverage nobody has audited, and the empty generative row above. That is what
would make the Standard load-bearing instead of aspirational \u2014 and it addresses the real
problem, which is not the Standard's existence but the unverified gap between it and the
skills.
### The limit of delivery mechanisms — an unresolved design tension

This belongs here rather than buried in §3.6, because everything above is a delivery
argument and delivery does not reach the thing you actually reacted to:

> **Delivery mechanisms explain conformance; they do not fully explain perceived quality.**

The round proves this cleanly. **Codex 1 and Codex 2 ran the same host against the same
skill text at the same version.** Every literal, every procedure line, every Verification
bullet was identical. One felt awkward to you and one was your favourite. Delivery accounts
for none of that difference, because delivery did not vary. Codex 2 then fails X2.67 while
Copilot 1 passes it.

Your own note is the unanalysed evidence: *"The model may be following too closely to
examples or something. It seems awkward."* Codex 1's awkwardness reads as **visible
specification-following** — the `**Changed:**` block appended as its own object rather than
folded in, the byte-identical Vision re-presented because a validation step was due. Both are
the shape of an agent executing a procedure in front of you.

That creates a genuine tension with §1's conclusion, and it has no resolution in this
assessment:

> Behaviour must be consistent, and must not feel templated. Every increase in literal
> guidance buys conformance and risks paying for it in procedural compliance.

Three things keep it from being a reason to stop:

- **The tension is not uniform.** Literals for *fixed artefacts* — a capture heading, a
  validation question — are supposed to read the same every time; 22/24 identical headings
  cost nothing. The risk is concentrated in literals for *conversational moves*, which is
  exactly the §4.2 exemplar and the §4.3 continuity sentence.
- **The mitigation is to constrain the move, not the wording.** This cuts against my earlier
  caution. A single concrete exemplar transfers as behaviour, but it also transfers as a
  sentence to reuse. Several varied worked examples, with the Observable written against the
  *act* rather than the phrasing, is the better shape — Codex 2's three distinction moves
  (§4.2) are deliberately different from one another in form.
- **A specified continuity sentence is less templated than what replaces it**, because the
  vacuum is currently filled with workflow narration, which is the most mechanical output in
  the entire round.

What remains unsolved is measurement. "Follows the rules" has 76 tests. "Feels like Highway"
has your reading of a transcript, and the two verdicts diverged in both directions in this
round. Any spec that acts on §4.2 or §4.3 should expect to be judged by a reading, not by the
suite — and should say so rather than treating a passing suite as success.
---

## 7. Recommended scope for the next spec

Ordered by severity, not effort.

| # | Item | Owner | Severity |
|---|---|---|---|
| 1 | Converged Proposal required before retention — close the Copilot 2 hole | `highway-profile` point-of-use | **Critical** |
| 2a | Rule: contribute one distinction or extension above X2.42's threshold (§4.2) | Experience Standard | **High** |
| 2b | Several varied worked exemplars, distinction-first, real content, open close (§4.2) | `highway-profile` | **High** |
| 3 | Continuity signal carrying accepted substance into each next domain (§4.3) | shared contract + Profile | High |
| 4 | X2.36 delivery widened beyond readiness vocabulary to persistence and progression | `highway-profile` | High |
| 5 | Vision excludes method — strengthen from procedure to emitted cue | `highway-profile` | High |
| 6 | Validation question scoped to Converged Proposals only | `highway-profile` | Medium |
| 7 | Profile→Objectives handoff: heading level + transition | `highway-setup` | Medium |
| 8 | Rule-coverage report mapping rules to delivery sites (§6) | new generator | Medium |
| 9 | Reassurance sentence (§4.1) | `highway-profile` literal | Low |
| 10 | X2.56 names the inline amendment form | Experience Standard | Low |
| 11 | Grounding pointer verb (§6) | `generate-instructions.sh` source | Low |

Item 2 moved up after your clarification. It is no longer a tone improvement — it is the
difference between a workflow that records your thinking and one that extends it, and the
Standard currently requires the former. It is split into 2a and 2b deliberately: shipping
2a without 2b is the exact mistake that left X2.42 producing the behavior in one run of six.

Items 3 and 4 swapped and should be built together — per §4.3 the narration defect exists
because there is nothing specified to carry forward, so the continuity signal is the fix for
both.

Items 2a, 3, 4 and 5 are all the same underlying problem: **rules without point-of-use text
do not survive contact with a real agent.** The deferral in FR-029a was the right call for
152's scope, but the evidence now says point-of-use delivery is the mechanism that works
and should be the organizing principle of the next feature rather than an afterthought.

All of which is subject to the limit in §6: delivery buys conformance, not the feeling. Items
2b and 3 are the two most likely to pass a test and still read as procedure.

---

## 8. Evidence boundary

Six transcripts, one organization, three hosts, two runs each. These are **observed
conversations**, which is stronger evidence than the static document contracts in the 152
test suite — but the sample is small, single-domain, and every run used the same cooperative
user and the same website. None of the conformance figures in §2 should be read as a rate.
They are counts of what happened in six specific conversations.

No automated check exists for any behavior in §3. Every finding here was read by hand, and
the 76-test suite passes while four of six runs violate X2.36.

One further limit, from §6: perceived quality has no oracle at all. Codex 1 and Codex 2 ran
identical skill text and were rated differently; Codex 2 rated highest and fails X2.67.
Conformance counts in §2 are not a quality ranking and should not be used as one.
