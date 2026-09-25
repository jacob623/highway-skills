# Setup Routing Contract

`highway-setup` is orchestration-only. It requests Profile readiness and routes to the first incomplete owner in the existing Profile, Objectives, Controls, and NFR order.

- No authoritative Profile: Profile owner starts Identity collection; collection is transient.
- Valid incomplete Profile: Profile owner resumes at the first `not_discussed` domain.
- Complete Profile: Setup advances to Objectives.
- Malformed Profile: Setup reports Blocked and does not overwrite the artifact.

Setup does not inspect Profile metadata, recompute readiness, create checkpoints, restore unanswered questions, or write owner artifacts.
