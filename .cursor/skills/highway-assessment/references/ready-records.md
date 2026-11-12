# Ready Records

### ready records

Read `requests/requests.md`, `discoveries/discoveries.md`, `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, and `code/code.md`. Do not open records. Do not write a ready record to the findings file. Write nothing on this step.

A record is ready only when its row is `accepted` and:

- Request: no Discovery row names it. A removed row still counts. Stage: discovery.
- Discovery: no ADR row names it. A removed or superseded row still counts. Stage: a decision.
- Decision: its Architecture ID is `None` and no architecture row lists it. A removed row still counts. Stage: an architecture.
- Architecture: no accepted implementation row names it. Stage: an implementation.
- Implementation: no accepted automation row names it. Stage: codify.

Show the categories in that order, numbered from 1 in the order shown. Omit a category with nothing ready. Letter the records in each category from `a`, in catalog order. Show at most 5 records per category. Do not use an id as a label.

**Based on what Highway knows, these records are ready for the next stage:**

**1. Requests**

**a. [Record title]:** Ready for [stage].

**Which record would you like to advance?**

When more records remain than are shown, emit this line:

If you'd like to see more records, just say so.

Always emit this line last:

If you'd like to return to the main menu, just say so.

When nothing is ready, say no accepted record is ready for the next stage. Then emit the return line.

- `advance`: continue in the same message. For a request, continue as `highway-discovery` with its Request id. For a discovery, continue as `highway-adr` with its Discovery id. For a decision, continue as `highway-architecture` with its ADR id. For an architecture, continue as `highway-implementation` with its RA id. For an implementation, continue as `highway-codify` with its title. Do not create the next record in this skill.
- `more`: show the next records, at most 5 per category, after those already shown. Show only the categories that still have records, numbered from 1, and continue each category's letters. Stay on `ready records`.
- `menu`: go to `review`.
- A category number alone, or a letter alone when more than one category is shown, or a record not in the view: ask which record. Write nothing. Stay on `ready records`.
- `question`: answer. Then re-emit this view. Stay on `ready records`.
- `unknown`: re-emit this view. Stay on `ready records`.
- `decline`: go to `summary`.

## Verification

- Ready records come from the catalogs, are grouped as requests, discoveries, decisions, architectures, and implementations, and are never written as findings.
- Categories are numbered and records are lettered. Each category shows at most 5 records, labeled by title and the stage it is ready for. A category with nothing ready is omitted.
- The ready view asks which record to advance and always ends with the return line. Returning shows the menu again.
- Advancing a record continues in the skill for its next stage. This skill does not create that record.
