# Quickstart: Remove Repository Name

## Instruction presence

```bash
bash tests/remove-repository-name.test.sh
```

Expected: exit 0. Checks first-question wording, no Repository Name instructions in Profile and naming skills, and Context headings without Repository Name.

## Related pins

```bash
bash tests/org-offering-boundary.test.sh
bash tests/harness-failure-resolutions.test.sh
bash tests/output-template.test.sh
```

Expected: exit 0 with Profile `14.7.0`, offer routes that go to Identity without `organization-name`, and Context headings that omit Repository Name.

## Finish order

`skills/` changes, so close with the plugin finish order. See [framework/README.md](../../framework/README.md).

```bash
bash tests/run-all.sh --exclude-plugin-gen
# bump framework/plugin/plugin.json from 0.1.3 to 0.1.4 if not already bumped with the skill edits
bash framework/generate-catalog.sh
bash framework/generate-agent-adapters.sh
bash framework/generate-agent-plugin.sh
bash tests/run-all.sh --plugin-gen-only
```

Expected: both suite commands exit 0.
