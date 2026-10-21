---
name: highway-setup
description: "Orchestrates initial highway setup through the owning governance skills."
usage: "Invoke as /highway-setup."
compatibility: all
metadata:
  version: 9.0.0
---

# highway-setup

## Purpose

Orchestrates Profile, Objectives, Controls, and NFRs in order when the person runs setup.

## When to use

- The person invokes `/highway-setup` and `.highway/library/knowledge/profile.md` is absent.
- The person invokes `/highway-setup` again after a prior setup run.

## When not to use

Do not collect Profile, Objective, Control, or NFR evidence.
Do not write those records or catalogs.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.
Do not show `Finished` to the person.

## Inputs

- Project root containing `.highway/`.
- `highway-profile`.
- `highway-objectives`.
- `highway-controls`.
- `highway-nfrs`.
- `.highway/library/knowledge/profile.md` when present.
- `.highway/governance/experience-standard.md`.
- The person's request to run setup.

## Outputs

- The welcome, once, when Profile has not been written.
- One domain transition before Objectives, Controls, and NFRs.
- The closing conclusion, once, after NFRs returns `Finished`.
- No repository file written by Setup.

## Procedure

User-visible interaction follows the Highway Experience Standard.

Delegate each owner in this order: Profile, Objectives, Controls, NFRs. Stay with the current owner until it returns `Finished`. Render that owner's messages as written. Do not answer its question, restate its recommendations, or add a second question.

`Finished` is the only result that advances. Do not show that word. An owner that stops without `Finished` ends Setup. Do not delegate a later owner, and do not emit the conclusion.

### Welcome

When `.highway/library/knowledge/profile.md` is absent, emit this level-2 heading, then the lines under it, before Profile. Do not emit it when that file exists.

Welcome to Highway
*Turn organizational knowledge into connected decisions.*
**Your context stays yours.**

Highway builds on information you choose to accept into your repository. Your repository remains the authoritative source of truth, and you retain ownership of the context and artifacts created through Highway.

---

Let's get started.

Then delegate `highway-profile`.

### Profile

Delegate `highway-profile`. Profile opens the organization conversation. Do not add a transition before it.

When Profile returns `Finished`, emit the Objectives transition and delegate `highway-objectives` in that same moment.

### Objectives

---

**Let's identify some outcomes worth pursuing.**

These give Highway something concrete to connect future decisions back to.

When Objectives returns `Finished`, emit the Controls transition and delegate `highway-controls`.

### Controls

---

**Now let's establish the safeguards that should guide future technology decisions.**

These help Highway keep future recommendations aligned with what needs to remain true.

When Controls returns `Finished`, emit the NFR transition and delegate `highway-nfrs`.

### NFRs

---

**Now let's consider the operational expectations future solutions should meet.**

These help connect your safeguards to how solutions need to behave in practice.

When NFRs returns `Finished`, emit the conclusion.

### Conclusion

Emit this once.

**Your foundational Highway context is now in place.**

Highway now has organizational context, business objectives, safeguards, and operational expectations it can build on in future work.

**Where would you like to go next?**

Run `/highway-onboarding` to inform Highway of your current technology landscape. This aids Highway in providing cohesive recommendations.

Run /highway-help to explore what Highway can help you do.

## Resume

Every `/highway-setup` run starts at Profile. Setup stores no checkpoint. When `profile.md` already exists, skip the welcome and still delegate Profile, then Objectives, Controls, and NFRs. Each owner reviews what it already holds before returning `Finished`.

## Verification

- Owner order is Profile, Objectives, Controls, NFRs.
- The welcome is emitted once, and only when `profile.md` is absent.
- Profile is always delegated.
- Each later owner is delegated only after the previous owner returns `Finished`.
- The Objectives, Controls, and NFR transitions are each emitted once, directly before that owner's first message.
- Setup does not add a question to an owner's message.
- Setup does not add a synthesis between owners.
- `Finished` is not shown.
- An owner that stops without `Finished` ends Setup before the next owner.
- The conclusion is emitted once, after NFRs returns `Finished`.
- The conclusion directs the person to `/highway-onboarding` before `/highway-help`.
- Setup writes no repository file.

## Error Handling

- An owner that stops without `Finished` ends Setup. The owner's message is the person's explanation. Do not delegate a later owner and do not emit the conclusion.
- An unexpected orchestration failure stops Setup without claiming completion and says what the person can do next.

## Example

`/highway-setup`