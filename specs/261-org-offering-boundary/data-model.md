# Data Model: Organization and Offering Boundary

## Organization

| Field | Rule |
| --- | --- |
| Name | Accepted reply to the organization-name question, or a name the person accepts from supplied material. Never the Repository Name copied forward. Never invented. |
| Identity finding | One finding: who the organization is. Subject of Vision. |

## Offering

| Field | Rule |
| --- | --- |
| Name | Person's words for the kind of thing, after dropping the product proper name, feature list, and how it is built. |
| Evidence | A detailed product supports an offering. It is not stored as the offering or as the organization. |
| Count | One kind → one offering. Different kinds → one offering each. No category word → one question, no coined name. |
| Identity finding | Its own finding under the existing Identity section. No new Profile section. |

## Profile

| Field | Rule |
| --- | --- |
| Sections | Unchanged. Identity narrative remains `## Who We Are`. |
| Split | Restated before write. Accept writes. A merge that is not an explicit same-subject statement does not write. |
| Existing file | Not rewritten unprompted. Review remains available. |

## Contradiction

| State | Next |
| --- | --- |
| Person separates a fused organization and offering during onboarding, objectives, or assessment | Stop. Offer to revise the Profile. Add no dependent record. |
| Accept | Run `highway-profile` review before any other record. |
| Decline | Stay stopped. No new objective, capability, or finding. |
| No separation | Continue on the accepted Profile. |

## Capability

| Field | Rule |
| --- | --- |
| Source | An operation the person says the organization runs. |
| Excluded | A product behavior, feature, or packaging choice, unless the person says the organization operates it. |

## Shared name

When the organization name contains the offering's distinguishing name, organizational sentences use
the full organization name. The short name is only the offering. A generic shared word is not the
distinguishing name.
