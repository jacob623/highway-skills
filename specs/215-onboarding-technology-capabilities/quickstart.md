# Quickstart: Onboarding Technology Capabilities

From the repository root:

```sh
bash .highway/tools/tests/onboarding-technology-capabilities.test.sh
bash .highway/tools/tests/onboarding-assessment-guidance.test.sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-onboarding
bash .highway/tools/tests/run-all.sh
```

The new test prints `PASS: onboarding proposes technology capabilities`. The suite ends with 0 failed. See [contracts/onboarding-capabilities.md](contracts/onboarding-capabilities.md) for the exact lines.
