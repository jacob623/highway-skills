# Research: Setup Welcome Overview

## Decision: Write the overview heading as a plain line with a stated level

- **Decision**: In the skill source, write "During setup we'll:" as a plain line. The Welcome instruction says to emit it as a level-3 heading. The person sees `### During setup we'll:`.
- **Rationale**: The Welcome section is itself `### Welcome`. A literal `###` line inside it would read as a new skill section. The welcome already handles "Welcome to Highway" this way, as a plain line emitted as a level-2 heading.
- **Alternatives considered**: A literal `###` line in the source was rejected because it splits the Welcome section. A fenced block was rejected because the welcome's other lines are not fenced.

## Decision: Keep both horizontal rules in the source

- **Decision**: The opening `---` stays where the old separator was. The closing `---` follows "Now, let's get started." and precedes "Then delegate `highway-profile`."
- **Rationale**: The supplied copy frames the overview with both rules. The Objectives, Controls, and NFRs transitions already use a literal `---` line in the source, so the rule does not split a section.
- **Alternatives considered**: Dropping the closing rule was rejected because it changes the supplied copy.

## Decision: MAJOR version bump

- **Decision**: `highway-setup` moves from `9.1.0` to `10.0.0`.
- **Rationale**: A first-run welcome that ended with "Let's get started." no longer conforms.
- **Alternatives considered**: A MINOR bump was rejected because the emitted welcome changes.

## Decision: One new contract test

- **Decision**: Add `setup-welcome-overview.test.sh`. It requires each overview line, the level-3 instruction, the closing rule before the Profile handoff, and the unchanged text above. It fails when a standalone "Let's get started." line remains.
- **Rationale**: D3.3 requires a test for the behavior change. No existing test covers the welcome text.
- **Alternatives considered**: Amending an existing setup test was rejected because none asserts the welcome copy.
