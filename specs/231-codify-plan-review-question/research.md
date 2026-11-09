# Research: Codify Plan Review Question

## R1. Where the review lives

- **Decision**: A new `### review` step between `### menu` and `### tasks`. The menu's `1` reply becomes "go to `review`". The Procedure order line names `review` when chosen.
- **Rationale**: The review now has its own question and five reply paths. As its own step it mirrors highway-onboarding's `review`, keeps `menu` a short choice, and lets a test pin the question's position by section. `codify-feature-wording.test.sh` checks only that its listed steps appear in order, so a step between `menu` and `tasks` passes.
- **Alternatives considered**: Nesting the question and its replies inside the menu's `1` bullet. Rejected: a bold question and a reply list nested in one bullet is hard to read, and the position would be pinned only by word order.

## R2. Reply classification

- **Decision**: Add to `### Classify`: On `review`, a change to the plan is `edit`, and "no", "nothing", or "looks good" is `accept`.
- **Rationale**: Classify defines `edit` as a change to proposal text and `decline` as stopping. Without the line, "no" in reply to "What would you add, correct, or remove?" could be read as stopping. The spec says it means nothing needs changing. The line follows the existing "On `revise`, "looks good" is `accept`."
- **Alternatives considered**: Defining the classes inside `review`. Rejected: Classify is where every step's replies are defined.

## R3. Reply paths

- **Decision**:
  - `accept` emits the menu.
  - `edit` emits one consequence sentence, regenerates the plan, and goes to `check`, which goes to `menu`.
  - `question` answers, then asks again.
  - `unknown` asks again.
  - `decline` stops and writes nothing.
- **Rationale**: `edit` reuses the menu's stated-edit path, so the plan check runs on every plan change. The other paths match how other skills answer a shown record.
- **Alternatives considered**: Re-asking the review question after an edit. Rejected in the spec: the menu returns, and the person can review again.

## R4. Versions and moved pins (D3.5)

| Artifact | From | To | Reason |
|---|---|---|---|
| `highway-codify` | 14.0.0 | 14.1.0 | MINOR: a new step and question. Its Inputs, Outputs, and every earlier reply path hold |

Moved pins, each superseding the version only: `version: 14.0.0` for highway-codify in `code-project`, `codify-platform-catalog`, `codify-config-skill`, `delivery-platform-handoff`, `codify-feature-wording`, `codify-deterministic-steps`, `codify-products`, `codify-write-refactor`, `codify-file-layout`, `establish-from-record`, `propose-edit-lines` (2), `single-noun-capabilities`, `codify-closing-guide`, and `storage-contract`.
