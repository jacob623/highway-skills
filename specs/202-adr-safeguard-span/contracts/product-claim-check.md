# Contract: Product Claim Check

Applies to `.highway/skills/highway-discovery/SKILL.md` and `.highway/library/templates/output/discovery-record.md`. See [data-model.md](../data-model.md) for the check results.

## Where it runs

In `analyze`, after constraint exclusions and before the two-to-five cap and scoring. The cap applies to the options that remain. Ids for removed and held options are derived so the elimination log can name them. Those options are not scored.

Opening a discovery id does not run the check. An option the person adds or replaces does not run the check.

## Check

For each generated option that relies on a named product or feature, read the vendor's current public documentation, product pages, and release notes. Send only the product or feature name and the vendor name. An option with no named product or feature is unchanged.

| What is found | Result |
|---|---|
| The vendor says it is deprecated, retired, or no longer offered | `contradicted`. Remove the option. Record every vendor page used, including one that still describes it |
| The vendor describes it, and no vendor page says it is no longer offered | `confirmed`. Keep the option. Do not change its score |
| Nothing from the vendor, only a blog, forum, or comparison, or the check cannot be completed | `inconclusive`. Keep the option. Do not treat it as confirmed |

## Required platform

When `existing_platforms_required` names a platform and the option depends on it, hold the option out of the scored options unless the accepted request, clarification, profile, objectives, controls, NFRs, or reference architectures say that platform supports it. Vendor documentation does not count. When required platforms are unknown, hold nothing.

## Record

`## Research Findings` keeps findings from the closed request and adds one entry per check:

Claim: [product or feature]
Source: [vendor documentation, or `None`]
Result: contradicted | confirmed | inconclusive

The entry is not accepted repository evidence.

The Candidate Elimination Log gains one `Excluded` row per removed option, category `product currency`, value the source, and one per held option, category `required platform`, value the platform name.

## Before the option list

When at least two options remain, after the current-implementation notice if there is one:

[Option title] was left out. [Vendor] says [product or feature] is no longer offered. Source: [source].

[Option title] was left out. Accepted evidence does not say [platform] supports it.

When fewer than two options remain, say the request does not support two viable options, name each removed or held option the same way, and write nothing.

## Unchanged

- Scores of options that remain, and the weights that produce them.
- Accepted controls, NFRs, and constraints.
- Clarification does not change which options exist.
- The person can add an option through the existing edit.
