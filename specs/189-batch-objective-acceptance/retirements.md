# Retirements: Batch Objective Acceptance

The guided objectives flow no longer accepts one objective at a time. These lines are removed from `.highway/skills/highway-objectives/SKILL.md`:

- **Here's what I've captured as your objective:**
- Your accepted Objectives now cover [short phrases for the held Objectives].
- Next we'll develop **[next title]**.

No existing test asserted those lines. The new contract check forbids the singular heading and "Next we'll develop".
