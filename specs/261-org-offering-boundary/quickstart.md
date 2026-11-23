# Quickstart: Organization and Offering Boundary

## Instruction presence

```bash
bash tests/org-offering-boundary.test.sh
```

Expected: the test exits 0. It checks the Experience Standard row, Profile's name and split steps,
and the stop and capability lines in onboarding, objectives, and assessment.

## Version pins

```bash
bash tests/harness-failure-resolutions.test.sh
bash tests/harness-failure-followups.test.sh
```

Expected: both exit 0 with experience `1.6.0` and objectives `8.9.0`.

## Finish order

`skills/` changes, so close with the plugin finish order. See [framework/README.md](../../framework/README.md).

```bash
bash tests/run-all.sh --exclude-plugin-gen
# then bump framework/plugin/plugin.json from 0.1.2 to 0.1.3
bash framework/generate-catalog.sh
bash framework/generate-agent-adapters.sh
bash framework/generate-agent-plugin.sh
bash tests/run-all.sh --plugin-gen-only
```

Expected: both suite commands exit 0.
