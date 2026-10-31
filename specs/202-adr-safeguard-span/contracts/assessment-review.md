# Contract: Assessment Review Menu and Ready Records

Applies to `.highway/skills/highway-assessment/SKILL.md`. See [data-model.md](../data-model.md) for readiness rules.

## Order

Entry → `review` → `list of findings` (gaps) or `ready records` (ready).

`list of findings`, `finding`, `write`, and `summary` are unchanged.

## New reply classes

- `gaps`: chooses observed gaps, by number or in words.
- `ready`: chooses accepted artifacts ready for the next stage, by number or in words.
- `advance`: chooses a listed ready record, by category number and letter or by its title.
- `menu`: asks to return to the main menu.

The existing `select`, `more`, and other class lines stay word for word.

## review

**What would you like to review?**

1. Observed gaps against accepted architectures.
2. Accepted artifacts ready for progression to the next stage (requests, discoveries, decisions, architectures, and implementations).

| Reply | Result |
|---|---|
| `gaps` | Go to `list of findings` |
| `ready` | Go to `ready records` |
| `unknown` | Show this menu again |
| `decline` | Go to `summary` |

Nothing is written on this step.

## ready records

Read `requests/requests.md`, `discoveries/discoveries.md`, `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, and `code/code.md`. Do not open records. Write nothing.

**Based on what Highway knows, these records are ready for the next stage:**

**1. Requests**

**a. [Request title]:** Ready for discovery.

**2. Implementations**

**a. [Implementation title]:** Ready for codify.

**Which record would you like to advance?**

If you'd like to see more records, just say so. *(only when more remain)*

If you'd like to return to the main menu, just say so.

When nothing is ready, say no accepted record is ready for the next stage, then the return line.

| Reply | Result |
|---|---|
| `advance` | Continue as the next skill for that record, per [data-model.md](../data-model.md). Do not create the next record |
| `more` | Show the next records, at most five per category, after those already shown |
| `menu` | Go to `review` |
| A number alone, or a letter alone with more than one category shown | Ask again. Write nothing |
| A record not in the view | Ask again. Write nothing |
| `question` | Answer, then show this view again |
| `unknown` | Show this view again |
| `decline` | Go to `summary` |

## Forbidden

- Writing a ready record to the findings file.
- The literal `/highway-codify` anywhere in this skill.
- An id as the label of a record.
