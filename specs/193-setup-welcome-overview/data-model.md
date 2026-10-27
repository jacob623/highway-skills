# Data Model: Setup Welcome Overview

## Welcome

Shown once, before Profile, when `library/knowledge/profile.md` is absent.

| Part | Rule |
|---|---|
| Heading | Welcome to Highway, level 2. Unchanged |
| Tagline | *Turn organizational knowledge into connected decisions.* Unchanged |
| Ownership | **Your context stays yours.** and its paragraph. Unchanged |
| Overview | The text in [contracts/welcome-overview.md](contracts/welcome-overview.md). Replaces the separator and "Let's get started." |

## Overview

| Part | Rule |
|---|---|
| Opening rule | `---` |
| Heading | During setup we'll:, level 3 |
| Items | Four bullets in setup order: organization (Profile), outcomes (Objectives), safeguards (Controls), operational expectations (NFRs) |
| Reassurance | One paragraph |
| Close | Now, let's get started. |
| Closing rule | `---` |

## State

1. Setup starts.
2. When `profile.md` is absent, the welcome is shown, ending with the overview.
3. Setup delegates Profile with no added transition.
4. When `profile.md` exists, the welcome and the overview are skipped.
