# Quickstart: Business Request Intake

## Prerequisites

- Run from the repository root.
- Bash 3.2-compatible repository tooling.
- `.highway/skills/highway-new/SKILL.md` authored and validated.
- Generated catalog and agent adapters regenerated from the source skill.

## 1. Validate the source skill

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-new
```

Expected result: exit 0 with no `ERROR:` lines.

## 2. Generate repository outputs

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
```

Expected result: the catalog contains `highway-new`; adapters exist at:

- `.github/skills/highway-new/SKILL.md`
- `.claude/skills/highway-new/SKILL.md`
- `.cursor/rules/highway-new.mdc`

## 3. Exercise initial intake

Start `highway-new` with an initial business description that covers fewer than six domains.

Expected result: the skill evaluates all six domains, selects the first incomplete domain, asks exactly one question, and presents one to three examples.

## 4. Exercise deterministic completion

Answer the six prompts with stable inputs, including an explicit `No business constraints` response.

Expected result: the skill creates one `requests/REQ000001.md` record when the catalog is absent, initializes `requests/requests.md` with `Version: 1.0.0` and `Next ID: REQ000001` before allocation, and writes the request with `status: proposed` and `Completeness: Complete`.

## 5. Exercise privacy and failure behavior

Run the privacy and transaction test scenarios with input containing a secret or regulated personal data.

Expected result: excluded content is not written; the requester receives a prompt for business-relevant replacement text. A validation or catalog conflict failure writes neither artifact and preserves original bytes.

## 6. Run focused and full validation

```sh
.highway/tools/tests/highway-new.test.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/run-all.sh
```

Expected result: the focused test proves intake, allocation, privacy, transaction, and determinism; generation leaves no drift; correspondence and the full suite pass with zero failures.

Baseline note: before Feature 047 implementation, the full suite had 36 passes and two unrelated failures in `constitution-inventory.test.sh` and `distribution-packaging.test.sh`; final validation must report whether those baseline failures remain unchanged.
