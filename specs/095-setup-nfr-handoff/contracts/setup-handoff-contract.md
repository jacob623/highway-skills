# Setup Handoff Contract

## Controls-to-NFR transition

Setup emits the following message exactly once immediately before the first NFR-owned interaction
when either of these conditions holds:

- Controls collection returned `Finished` and fresh Controls readiness returned `Complete`.
- Controls readiness was already `Complete` when Setup reached the Controls stage.

The transition is not emitted for Controls `Continue`, fresh Controls `Missing` or `Blocked`, direct
`/highway-nfrs` invocation, resumed NFR work, or an NFR terminal result that requires no user interaction.

```text
We've established the safeguards that should guide future technology decisions. Now let's consider what those decisions need to achieve in operation.
Based on the Controls we've defined, Highway may already have identified qualities or operational outcomes worth considering.
```

## NFR delegation

After the transition, Setup delegates to `/highway-nfrs`, renders the NFR owner's interaction
unchanged, and consumes its authoritative result without inspecting NFR internals. Setup does not
author NFR questions, recommendations, decisions, candidate handling, or completion logic.

## Successful conclusion

After every required owner reaches its contract-defined terminal result, Setup emits the following
conclusion instead of the former completion dashboard:

```text
**Your foundational Highway context is now in place.**

Highway understands more about your organization, what you're trying to accomplish, the safeguards that should guide future decisions, and the operational expectations those decisions may need to satisfy.

**This is where Highway starts becoming more useful.**
The context you've established can help Highway make future guidance more relevant, connect decisions back to your objectives and governance, and build on what it already knows instead of starting over each time.

**Where would you like to go next?**
Run `/highway-help` to explore what Highway can help you do.
```

The former `Highway Setup Complete`, `Profile`, `Business Objectives`, `Controls`, and `NFRs`
dashboard fields are absent. `/highway-help` is offered but not invoked automatically. Blocked,
incomplete, malformed, declined, aborted, and failed required-owner paths do not emit this conclusion.

## Resume contract

On a New interaction, Setup rereads authoritative owner state and resumes at the first incomplete
owner. It restores no unanswered questions, drafts, transition marker, or Setup checkpoint, and does
not replay the initial transition when resuming NFR work.
