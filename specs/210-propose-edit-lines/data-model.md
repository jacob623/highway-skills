# Data Model: Propose Edit Lines

No new artifact or field.

## Edit handling

The `edit` reply in `propose`. Its clauses are unchanged. Each kind of edit is one line.

| Kind | Consequence |
|---|---|
| Different Provider | Set on every task and in the diagram, then go to `standards`. |
| Changed method | Go to `standards`, then `align`, for that task. |
| Changed Standards list | Change only that list, then go to `align` for that task. |
| Files | Change only this automation. Leave out a path that is not relative. |
| Title not in the catalog | Leave it out, keep the rest, and point to `/highway-codify-config`. |
| Second action | Remove it and say it waits for another run. |
| Architecture | An accepted architecture can be selected by title. An unaccepted one is not added. |
| Preparation-only request | Stay one self-service action. |
| Last task or last acceptance criterion | Say at least one is needed. |

Every edit begins with one consequence sentence, shows the proposal again, and stays on `propose`.
