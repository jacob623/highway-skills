# Quickstart: Codify Config Skill

1. `bash .highway/tools/tests/codify-config-skill.test.sh` passes.
2. `bash .highway/tools/validate-skill.sh .highway/skills/highway-codify-config` and the three changed skills pass.
3. `bash .highway/tools/validate-library.sh` passes on the five templates.
4. Run `/highway-codify-config`. The menu shows three options. Option 1 shows the platform table and asks **What would you add, correct, or remove?**
5. Add an accepted implementation. The proposal shows When to use and When not to use as ordered lists, then Consequences and Conflicts.
6. Run `/highway-codify` on an implementation. Each task shows **Standards:** as an ordered list.
7. `bash .highway/tools/tests/run-all.sh` reports 0 failed.
