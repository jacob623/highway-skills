# Data Model: Codify Deterministic Steps

## Entry match

| Field | Rule |
|---|---|
| Entries | When to use and When not to use, split on `; `, trimmed |
| On its own | A boundary on each side: start, end, or a character that is not a letter or digit. Case is ignored |
| Blank | A blank When to use does not match |
| Platform text | The action and the method |
| Standard text | The action, the method, and the Provider |

## Provider

| Condition | Result |
|---|---|
| The person named a platform | That platform, including when it has no row |
| No name, one or more rows match | The earliest matching row |
| No name, no row matches | This implementation's row, then the first row |
| No name, no rows | Unset |

## Coding standard

A row is a candidate when its File Patterns match a file the method names, or its Technology names the method or the Provider. The entry match then keeps it. Inheritance order stays. The earlier kept standard wins a disagreement.

## Plan story

One per proposal task, in task order. Title is the task's action. Done when is the earliest acceptance criterion that contains that action, ignoring case, or the Scope sentence when none does. Scope, method, standards, and files are absent.

## Applied Control or NFR

The statement contains the task's target, a file name or path written in the task, or the mechanism the realization names. After layout, a placed path can add a match. A held match is not dropped. Controls first, in catalog order, then NFRs.

## Check gap

| Kind | Order |
|---|---|
| Story with no Done when | Plan order |
| Repeated story title | Plan order, the later story |
| Applied title that no story names | Proposal list order, after the stories |

The first five unanswered gaps are asked. Each later one is an assumption.

## Task line

A proposal task's line sits under the story whose title is that action. A story title that is not an action still has one line. A line that names work the proposal does not list is absent.
