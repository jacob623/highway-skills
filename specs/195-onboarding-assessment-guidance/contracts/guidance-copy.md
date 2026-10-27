# Contract: Onboarding and Assessment Copy

## Onboarding overview

Emitted once, before the first capability list. "What we'll do together" is a level-3 heading.

```markdown
What we'll do together

This is where Highway helps you navigate your technology landscape.

We'll connect existing capabilities so future recommendations align with [Name]'s target direction.

During onboarding we'll:

- **Identify important business capabilities** your organization relies on.
- **Understand the platforms and processes** that support those capabilities today.
- **Validate Highway's understanding** before any architecture knowledge is created.
- **Capture accepted knowledge** as connected architecture and implementation context.

You don't need to have everything documented in advance. We'll build that understanding together, one capability at a time.

Now, let's get started.

---
```

## Capability starting point

```markdown
**Here are the capabilities Highway believes you have today:**

1. **AI-Assisted Engineering and Planning:**

   Using AI systems to assist with research, architecture, planning, governance, or implementation activities.

2. **[Capability title]:**

   [What the organization does.]
```

Inclusion rule: Include the AI-Assisted Engineering and Planning line on the first capability list. Omit it when an accepted ADR already records this capability for the same agent-platform name. The person may correct or remove the line before accept. A removed AI-Assisted Engineering and Planning line is not placed on the capability queue.

## Mapping transition

Emitted once, before the first capability mapping.

```markdown
**We've identified the capabilities that matter to your organization. Now let's look at how those capabilities are provided today.**

For each capability, we'll identify the platforms, services, processes, or people that help deliver it.

---
```

## Mapping block

```markdown
**[Capability title]:**

[What the organization does.]

**Business Purpose:**

[Business purpose.]

**Provider:**

[observed platform, or `Unknown`]
```

Provider rule: When the capability title is AI-Assisted Engineering and Planning and the session identifies the agent platform by name, that name is the provider.

## Assessment opening

Emitted once, before the first list. The first line is a level-3 heading.

```markdown
Let's see what your repository may be telling us.

Highway will review accepted knowledge, surface observations that may be worth your attention, and suggest opportunities, improvements, or next steps where they may create value.
```

## List of findings

```markdown
**Based on what Highway knows, these may be worth visiting:**

1. **Finding:**

   [One-sentence summary of the finding.]

   **Complexity:**

   [Low, Medium, or High.]

**Would you like to explore any of these findings in more detail?**

If you'd like to see additional findings, just say so.
```

The last line appears only when more findings remain than are shown.

## Finding details closing

```markdown
**Would you like to explore a solution now?**

If you'd like to go back to the list of findings, just say so.
```

## Removed copy

- The capabilities-step heading "This is where Highway helps you navigate your technology landscape" and its sentence, as capabilities-step copy
- **Highway:** Connect accepted business goals, decisions, architecture, and implementation work into a single traceable system of knowledge.
- If you want to save this for later, or discard it entirely, just say so.
- The separate list of Open findings and the retained-findings list
