# Contract: Profile Skill Wording

**Feature**: 150 | **Date**: 2026-10-07

The exact user-visible wording to be written into `.highway/skills/highway-profile/SKILL.md`.
Profile carries output wording, never rule text. It gains no `MUST`-level rule and cites no X
identifier.

## Frontmatter

| Field | Before | After |
|---|---|---|
| `metadata.version` | `9.0.0` | `10.0.0` |

## Default acceptance sentences

Each replaces a closed yes/no question. The trailing user-authored alternative line is retained
byte-identical in all four cases — it already satisfies the Standard's user-authored alternative
rule and four tests assert it.

| Domain | Removed | Added | Retained |
|---|---|---|---|
| Identity | `**Is this an accurate description of your organization?**` | `**What's missing or wrong in this description of [Organization Name]?**` | `You can also change it or provide your own description.` |
| Vision | `**Does this accurately reflect where you'd like [Organization Name] to go?**` | `**What's missing or wrong about where [Organization Name] is going?**` | `You can also change it or provide your own vision.` |
| Competitive Path | `**Does this accurately reflect how [Organization Name] plans to get there?**` | `**What's missing or wrong about how [Organization Name] gets there?**` | `You can also change it or provide your own approach.` |
| Guiding Principles | `**Does this accurately reflect what should guide decisions at [Organization Name]?**` | `**What's missing or wrong about what guides decisions at [Organization Name]?**` | `You can also change it or provide your own principles.` |

The surrounding sentence shape is unchanged. Identity keeps `After convergence, validate with`;
the other three keep `Validate the Converged Proposal with`. Four tests assert
`Validate the Converged Proposal with` and it must survive.

## Permitted substitution

One sentence added once, in the `#### Domain completeness` section beneath
`Profile-specific validation questions apply to the domain's Converged Proposal.`:

> A sharper open question drawn from the conversation may replace the default validation sentence
> for its domain.

The constraint that the replacement cannot be answered by agreement alone lives in the Experience
Standard. Profile does not repeat it.

## Opening with possibilities

Each of the three later domain sections gains one sentence immediately after its existing
`When entering unresolved ...` sentence.

| Section | Added sentence |
|---|---|
| `##### Vision` | `Open that subject with grounded possibilities drawn from accepted Profile evidence before asking the Vision question.` |
| `##### Competitive Path` | `Open that subject with grounded possibilities drawn from accepted Profile evidence before asking the Competitive Path question.` |
| `##### Guiding Principles` | `Open that subject with grounded possibilities drawn from accepted Profile evidence before asking the Guiding Principles question.` |

Identity gains no such sentence: Contribution Opportunities for Identity are conditional, because
Identity is usually driven by the person's own description.

What a grounded possibility is, that it is material to react to rather than a set to choose from,
and what to do when none exists, are all Standard-owned and not repeated here.

## Deletion

Removed from `##### Identity`:

> When Profile materially assembles Identity from multiple sources or substantial interpretation,
> present meaningful organizational facets provisionally before final synthesis when that helps
> inspection.

Nothing replaces it. The obligation now lives in the Experience Standard with a factual trigger,
and no test asserts this sentence.

The two preceding Identity sentences are retained byte-identical:

> Identity establishes who the organization is and what it meaningfully encompasses, including
> durable activity and purpose. It is not a technology-landscape inventory.

## Unchanged

- All four canonical domain questions.
- `### Let's get to know your organization`, the Repository Name question, and the acquisition
  offer.
- The three subject headings `### Where you're going`, `### How you'll get there`,
  `### What will guide your decisions`.
- Readiness, Domain model, Operations, Verification, Error Handling, Example, Inputs, Outputs.
- Every sentence asserted by `profile-runtime-separation`, `feature-140`, `feature-138`,
  `feature-137`, `feature-136`, `feature-134`, `feature-092`, and `profile-structure` other than
  the version string and the four removed questions.

## Regeneration

`.github/`, `.claude/`, `.cursor/`, and `.agents/` adapters for `highway-profile` must be byte
identical to the amended source. Four tests compare them with `cmp -s`.
