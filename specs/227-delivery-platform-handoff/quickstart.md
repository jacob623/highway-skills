# Quickstart: Delivery Platform Handoff

Run from the repository root.

## Static checks

```bash
bash .highway/tools/tests/delivery-platform-handoff.test.sh
bash .highway/tools/tests/codify-platform-catalog.test.sh
bash .highway/tools/tests/establish-from-record.test.sh
for s in highway-codify highway-implementation highway-onboarding; do bash .highway/tools/validate-skill.sh .highway/skills/$s; done
```

Expected: every test prints PASS, and the validator reports no failures.

## Walkthrough

Onboard one platform, then run `/highway-codify` for it.

1. The onboarded implementation stores `Deployed by: Needed`, `Managed by: Needed`, `Language: None`.
2. Choose the establish action. The empty-platform message appears, with no proposal.
3. Say yes. See "Let's set the preferred delivery platforms for [Product Title].", then the five-field view.
4. Name a configured platform for Deployed by and Managed by, and accept. See the return line. The proposal appears with that Executor.
5. Run `/highway-codify` again on a second onboarded platform. Name a platform at the message. The proposal uses it, and the record still says `Needed`. A third run shows the message again.

See [contracts/wording.md](contracts/wording.md) for every line.
