# Data Model: Remove Repository Name

## Organization Name

| Field | Rule |
| --- | --- |
| Value | Accepted reply to the first guided Profile question. |
| Required for guided write | Yes. Decline and unknown do not accept a value. |
| Used by | Profile templates after acceptance; onboarding; objectives; controls; NFRs. |
| Invention | Forbidden when absent. |

## Repository Name

| Field | Rule |
| --- | --- |
| Status | Removed. Not asked. Not stored. Not used for naming. |
| Compatibility | None. |

## Profile Context

| Child | Rule |
| --- | --- |
| Organization Name | Written on successful guided write from the first-question reply. |
| Organization URL | Optional; unchanged. |
| Organizational Context | Optional; unchanged. |
| Repository Name | Omitted from the skeleton and from every write. |

## Profile domains

Identity, Vision, Competitive Path, and Guiding Principles are unchanged by this feature except that
name tokens in templates resolve to Organization Name only.

## Review state

Existing `review` when `profile.md` is present. No new state for missing Organization Name.
