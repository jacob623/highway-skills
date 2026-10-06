# Profile Convergence Fixtures

These synthetic transcript records are development-only evaluation artifacts. They are discovered by `profile-convergence-behavior.test.sh` and are never loaded as Profile Inputs or runtime dependencies.

Each fixture uses `key: value` metadata with the following required keys:

- `fixture_id`
- `category`
- `scenario`
- `starting_context`
- `active_context`
- `user_stimulus`
- `passing_behaviors`
- `failing_behaviors`
- `rubric_dimensions`
- `governance_references`
- `hard_failures`
