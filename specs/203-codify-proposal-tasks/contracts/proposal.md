# Contract: Proposal

Owner: `highway-codify`, `### propose`. The saved record follows the same order (`codify-record.md` 3.0.0).

## Emitted block

````markdown
**Here is a proposed starting point for your automation:**

**Title:** [Selected title.]

**Summary:** [Selected summary.]

**Description:** [What this one automation does, for whom, and what it returns.]

**Acceptance criteria:**

- [One observable result of this automation.]

**Diagram:**

```flowchart
flowchart TB
  E["[Executor]"] -->|[First action]| T1["[First target]"]
  T1 -->|[Next action]| T2["[Next target]"]
```

**Tasks:**

1. **[First action]:**
   - **Scope:** [What the task does.]
   - **Provider:** [Who or what completes it.]
   - **Method:** [How, naming plugins, modules, libraries, MCP servers, or APIs.]
   - **Assumptions:**
     - [Network access, access level, authentication method, credential source, or None.]

**What would you add, correct, or remove?**

If this is accurate, just say so.
````

## Rules

- The diagram's first node is the executor and is not a task. Each task is one arrow and its target node, in task order. The arrow label and the task's action are the same text and start with a verb. Every target has its own node.
- Each task is one action against one platform, object, or API. A step with two targets is two tasks.
- Assumptions list only what is not an earlier task.
- A provider is the person, or something the accepted architecture or the implementation names.

## Replies

- `edit`: one consequence sentence. An edit that changes a provider or method goes to `align` for that task. Show the block again with the diagram and tasks still matching. A second action waits for another run. The person can switch to another accepted architecture by title. Removing the last task or the last acceptance criterion says at least one is needed. Stay on `propose`.
- `accept`: go to `identifier` when the block has one action, at least one task, at least one acceptance criterion, and an accepted architecture. Otherwise stay on `propose`.
- `unknown`, `question`: answer when asked, then show the block again.
- `decline`: stop. Write nothing.

## Removed from the proposal and the record

`**Components:**`, `Responsibility:`, `Boundary:`, `**Current state:**`, `**Action:**`, `**Day:**`, `**Means:**`, `flowchart LR`.
