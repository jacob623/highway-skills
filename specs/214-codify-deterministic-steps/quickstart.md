# Quickstart: Codify Deterministic Steps

From the repository root:

```sh
bash .highway/tools/tests/codify-deterministic-steps.test.sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify
bash .highway/tools/validate-library.sh .highway/library/templates/output/codify-plan.md
bash .highway/tools/tests/run-all.sh
```

The new test prints `PASS: codify matches rows and stories by name`. The suite ends with 0 failed. Every `###` step of `highway-codify` is at or under 400 words, and `rank`, `suggest`, `draft`, `provider`, `resume`, `join`, and `folder` are at or under 250.
