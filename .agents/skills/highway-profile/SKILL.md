---
name: highway-profile
description: "Manages the repository-wide organizational Profile and its contextual guidance."
usage: "Invoke as /highway-profile."
compatibility: all
metadata:
  version: 14.0.0
---

# highway-profile

## Purpose

Collects the organizational Profile when setup delegates this skill.

## When to use

- `highway-setup` delegates this skill at the start of setup.
- `highway-setup` delegates this skill when setup runs again.

## When not to use

Do not create Controls, NFRs, Objectives, governance rules, or Highway identity.
Do not treat proposed evidence as organizational fact.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.

## Inputs

- Project root containing `.highway/`.
- `library/knowledge/profile.md` when present.
- `.highway/library/templates/output/profile-record.md`.
- `.highway/library/knowledge/highway-identity.md` as shared, non-normative context.
- `.highway/governance/experience-standard.md`.
- Delegation from `highway-setup`.
- Material the person supplies, including a public website when retrieval is available.

## Outputs

The complete structure is `.highway/library/templates/output/profile-record.md`.

- An updated `library/knowledge/profile.md` after a review edit.
- A new `library/knowledge/profile.md` after the guided flow writes it.
- `Finished` returned to `highway-setup` after review acceptance or a successful guided write.
- `Finished` is not shown to the person.

## Procedure

User-visible interaction follows the Highway Experience Standard. Repository ownership stays with the person.

X2.21 does not apply. The accepted proposal bullets are the retained domain, so Profile does not show a second capture heading.

Emit only the active template. Follow this order: `review` when `profile.md` exists; otherwise `name`, `offer`, Identity, Vision, Competitive Path, Guiding Principles, then `write`. Follow `.highway/governance/experience-standard.md` for attribution and acceptance wording. Use accepted Organization Name in templates. Use Repository Name until an Organization Name is accepted. Repository Name does not become Organization Name.

### Entry

1. Read `library/knowledge/profile.md` from the repository root. Do not read, copy, or review `.highway/library/knowledge/profile.md`.
2. If `library/knowledge/profile.md` is present and readable, go to `review`.
3. If that file is absent, go to `name`.
4. If that file is present and unreadable, stop. Say the Profile could not be read. Leave the file unchanged. Do not return `Finished`.

### Classify

Classify the latest reply before any other action.

- `edit`: adds, removes, corrects, splits, combines, or replaces substance.
- `accept`: affirms the current block and adds no fact.
- `unknown`: the person says they do not know.
- `question`: the person asks for an explanation.
- `decline`: the person explicitly leaves the active domain unresolved.

`unknown` is not `decline`.

### review

Show the file body. Omit frontmatter. Then emit the validation block.

- `edit`: emit one consequence sentence. Rewrite the file with that edit. Preserve every section the person left unchanged. Show the updated body and emit the validation block. Stay on `review`.
- `accept`: return `Finished`. Emit nothing else.
- `unknown`: show the body and emit the validation block. Stay on `review`.
- `question`: answer in one sentence. Show the body and emit the validation block. Stay on `review`.

Validation block:

**What would you add, correct, or remove?**

If this is accurate, just say so.

### name

Emit:

#### Let's get to know your organization

**What would you like to call your Highway repository?**

Using your organization's name is often a good choice.

Store the reply as Repository Name. Go to `offer`.

### offer

Emit:

**Do you already have something I can use to start understanding [Repository Name]?**

You can share a website link, an overview or description, a strategy document, or an assistant export. If you don't have anything handy, say so and we can work through it together.

- A URL or document: retrieve it. Store a supplied URL as Organization URL. Facts from it stay proposed until accepted in that domain's proposal. Go to `identity.review` when the material supports at least one Identity finding. Otherwise go to `identity.ask`.
- The person has nothing: go to `identity.ask`.
- Retrieval is unavailable: go to `identity.ask`. Do not mention the missing retrieval.

Use supplied material across every later domain. Do not ask the person to repeat it. Do not use model memory or prior-agent memory as organizational evidence.

### Domain order

Run Identity, Vision, Competitive Path, then Guiding Principles.

Each domain uses `start` when a proposal can be shown. Identity uses `ask` only when no supported starting point exists. Vision, Competitive Path, and Guiding Principles always use `start`. Do not put a question template in the same message as a starting point.

1. `identity.review` or `identity.ask`
2. `vision.start`
3. `path.start`
4. `principles.start`
5. `write`

Hold each accepted bullet list until `write`. Do not write the file before `write`.

### Shared replies

Apply these on every domain step.

- `edit`: emit one sentence stating a consequence the person did not state. Re-emit the same template with the edit applied. Stay.
- `accept` on `review` or `start`: hold the current bullets. Advance.
- `accept` on `identity.ask`: hold the answer as the Identity bullets. Advance. Do not emit a capture paragraph.
- `unknown` on `review` or `start`: re-emit that template. Stay.
- `unknown` on `identity.ask`: re-emit the question template. Stay.
- `question`: answer in one sentence. Re-emit the same template. Stay.
- `decline`: store no narrative for this domain. Advance.

`unknown` does not finish a domain.

### Domain rules

Identity states who the organization is and what it provides. Omit a technology inventory.

Vision states the future the organization is creating. Omit method, sequencing, and organizational approach. When the person supplies those, emit this sentence, hold that material for Competitive Path, and stay on Vision:

**That is an important part of how you will get there. I will carry it forward when we reach Competitive Path, and return to Vision.**

Competitive Path states the broad approach toward the accepted Vision. Omit Controls, NFRs, safeguards, architecture, implementation requirements, and plans. Keep only the broad strategic meaning of volunteered detail.

Guiding Principles state enduring decision-making values. Do not write an enforceable Control.

Open Vision, Competitive Path, and Guiding Principles by naming accepted substance from the previous captured domain. Always emit the proposal. Infer a slot, including the Competitive Path tradeoff, from accepted context when the person has not stated it. Do not replace the proposal with a question.

### Templates

Identity review:

Here's what Highway believes [Name] does.

**[Short activity name]:**
[One sentence: who receives it, and what they receive.]

Emit 3 to 6 findings. Omit a finding the source does not support.

Identity question:

**What does [Name] do?**

If you don't know, say "I don't know" and we'll work through it together.

Vision opening and starting point:

Emit this level-3 heading, then the sentence under it:

Where you're going

With [accepted Identity substance], let's explore the future you are working to create.

**Here is a proposed starting point for your Vision:**

- **Future Direction**

  [Inferred from accepted context.]

- **Desired Impact**

  [Inferred from accepted context.]

- **Future State**

  [Inferred from accepted context.]

**What would you add, correct, or remove?**

If this is accurate, just say so. If you don't know, say "I don't know" and we'll work through it together.

Competitive Path opening and starting point:

Emit this level-3 heading, then the sentence under it:

How you'll get there

To advance toward [accepted Vision substance], let's explore how [Name] plans to get there.

**Here is a proposed starting point for your Competitive Path:**

- **Primary Approach**

  [Inferred from accepted context.]

- **Strategic Advantage**

  [Inferred from accepted context.]

- **Important Tradeoff**

  [Inferred from accepted context.]

**What would you add, correct, or remove?**

If this is accurate, just say so. If you don't know, say "I don't know" and we'll work through it together.

Guiding Principles opening and starting point:

Emit this level-3 heading, then the sentence under it:

What will guide your decisions

With your competitive path grounded in [accepted Competitive Path substance], let's explore what principles guide [Name]'s decisions.

**Here is a proposed starting point for your Guiding Principles:**

- **[Short principle name]**

  [Accepted-evidence decision-making value.]

Emit 3 to 5 principles. Infer each principle from accepted context when the person has not stated it. The label is a short principle name.

**What would you add, correct, or remove?**

If this is accurate, just say so. If you don't know, say "I don't know" and we'll work through it together.

When the previous domain was declined, replace the bracketed accepted substance with: Nothing has been accepted for [previous domain] yet.

Bold only the question in each block.

### write

Write `library/knowledge/profile.md` from the repository root once, in the shape required by `.highway/library/templates/output/profile-record.md`. Create `library/knowledge/` when it is absent. Do not write `.highway/library/knowledge/profile.md`.

- A captured domain is `discussed` and its narrative section contains the held bullets. Omit a term the person rejected.
- A declined domain is `bounded` and its narrative section is omitted.
- Write `## Context` with Repository Name.
- Write Organization URL, Organization Name, and Organizational Context only when the person supplied or accepted that value.
- Emit nothing after a successful write.
- Return `Finished`.

## Verification

- An existing readable `profile.md` is shown with **What would you add, correct, or remove?**
- Acceptance of that review returns `Finished` and emits nothing else.
- A review edit rewrites the file and shows the updated body with the same question.
- An absent `profile.md` begins at the repository-name template.
- A starting-point message contains no canonical question.
- The file is written once, after Guiding Principles is captured or declined.
- A successful guided write returns `Finished` and emits nothing else.
- The written file matches `.highway/library/templates/output/profile-record.md`.
- Setup receives `Finished` and the person does not see that word.

## Error Handling

- An unreadable `profile.md` stops the skill, leaves the file unchanged, and does not return `Finished`.
- A failed review rewrite leaves the file unchanged, says what failed in terms the person can act on, and stays on `review`.
- A failed guided write leaves the file absent, says what failed in terms the person can act on, and stays on `write`.
- Unavailable retrieval continues at `identity.ask` without mentioning the missing capability.

## Example

`/highway-setup`