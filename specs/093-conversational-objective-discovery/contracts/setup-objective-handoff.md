# Contract: Setup-to-Objectives Handoff

## Ownership

Setup owns only the purpose introduction, readiness routing, delegation, and forwarding. Objectives owns every Objective question, decision, interpretation, artifact mutation, identifier, catalog, and completion claim.

## Missing Objective baseline

After terminal-success Profile readiness, Setup requests Objective readiness. When the result is non-terminal with `Next Action: /highway-objectives setup`, Setup emits exactly:

> **Let's identify some explicit outcomes worth pursuing.**
>
> These give Highway something concrete to connect future decisions back to and help us evaluate whether you're accomplishing what you set out to do.

It then delegates to Objectives, which supplies its complete opening exactly once.

## Complete Objective baseline

When Objective readiness is `Complete`, Setup emits no Objective-purpose introduction and no Objective discovery question. It proceeds to Controls readiness according to the existing orchestration contract.

## Forwarding and failure

Setup forwards owner questions, decisions, errors, and results without rewriting or interpreting them. Setup does not claim completion when Objectives exits, blocks, declines, aborts, or fails. After verified owner completion, Setup re-reads fresh Objective readiness before advancing.

## Resume

A new Setup invocation derives its route from persisted owner readiness. It never restores an unanswered Objective question, proposed Objective, collection-loop question, draft, or Setup checkpoint.
