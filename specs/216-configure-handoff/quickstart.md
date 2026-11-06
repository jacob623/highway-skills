# Quickstart: Configure Handoff

From the repository root:

```sh
bash .highway/tools/tests/configure-handoff.test.sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-onboarding
bash .highway/tools/validate-skill.sh .highway/skills/highway-implementation
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify-config
bash .highway/tools/tests/run-all.sh
```

The new test prints `PASS: onboarding and implementation hand off to configuration and return`. The suite ends with 0 failed. See [contracts/handoff-steps.md](contracts/handoff-steps.md) for the exact sentences.
