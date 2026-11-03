# Research: Codify Config Skill

## R1. Platform catalog shape

- **Decision**: `library/coding-standards/codify-platforms.md`, one table: `| Platform | Implementation ID | When to use | When not to use |`. List cells hold entries separated by `; `. An empty list is a blank cell. Rows stay in the order added. The Source column and `own` rows are removed.
- **Rationale**: Adding a platform now requires an accepted implementation, so every row has an `RI` id.
- **Alternatives considered**: One section per record. Rejected in clarification.

## R2. Coding standards catalog and standard files

- **Decision**: A new template, `coding-standards-catalog.md`, with the table `| Standard Title | Technology | File Patterns | Summary | When to use | When not to use | Inherits From | Standard Path |`. Inherits From lists Standard Titles separated by `; `. A new template, `coding-standard.md`, has `# <Standard Title>`, `## Scope`, `## Rules` (at most ten numbered rules), and `## Tests` with `Tests: required` and one sentence, or `Tests: not required`. The seeded catalog gains the three columns. Its Terraform row gets grounded When to use and When not to use, and a blank Inherits From.
- **Rationale**: The skill writes both files the same way each time. `terraform.md` already fits the standard template.

## R3. Lists are stored delimited and presented ordered

- **Decision**: Every proposal shows When to use, When not to use, and Inherits From as ordered lists under their bold labels, one entry per item. The same applies to a task's Standards list. Writing joins the accepted items with `; `. Reading splits on `;` and trims spaces.
- **Rationale**: The person reviews lists. The catalog stays one scannable table.

## R4. Skill layout

- **Decision**: `highway-codify-config` sections: `Entry`, `Classify`, `menu`, `platforms`, `platform proposal`, `standards`, `standard proposal`, `conflicts`, and `resolve`. Every proposal ends with **What would you add or correct?** and "If you'd like to cancel, just say so." `decline` (cancel) writes nothing and returns to `menu`. Picking an option, and every `edit`, begins with one consequence sentence.
- **Rationale**: Each section stays under 400 words, and replies are classified the same way the other skills classify them.

## R5. Entry with a platform title

- **Decision**: `/highway-codify-config [Platform]` skips the menu. An accepted implementation title opens `platform proposal`: update when listed, add otherwise. Any other title opens the add check in `platforms`.
- **Rationale**: It is the return path from onboarding and from implementation inclusion.

## R6. Onboarding hand-off

- **Decision**: When the person agrees to onboard a missing platform, codify config follows `highway-onboarding` from `overview` in the same conversation, for that platform. Onboarding's summary for that run ends with "Run `/highway-codify-config [Platform]` to finish adding [Platform]."
- **Rationale**: Onboarding needs no new invocation form. The hand-off is visible in the conversation.

## R7. Provider selection

- **Decision**: A named platform is the Provider. Otherwise, the earliest catalog row whose When to use fits the action and whose When not to use does not. Otherwise, this implementation's row. Otherwise, the first row. Otherwise, unset. A blank row is never chosen by fit.
- **Rationale**: This keeps the spec 205 fallback and adds fit ahead of it.

## R8. Task standards

- **Decision**: A new codify section, `### standards`, sits between `start` and `align`, so `align` corrects each method against the task's whole list. For each task, candidates are rows whose File Patterns match a file the method names, or whose Technology names the method or the Provider. Drop a row whose When not to use matches the task. Order a standard before every standard it inherits from, and the platform before the language. Add each inherited standard once, after the one that inherits it. The task shows `**Standards:**` as an ordered list, or `No coding standard applies.` `align` corrects the method against the whole list. An `edit` can add, remove, or reorder. A title not in the catalog is reported, left out, and points to `/highway-codify-config`.
- **Task list**: A `[Task N]` line names task N's accepted Standards paths, in order. An `[Executor]` line names the Standards of the first task whose list has a standard whose File Patterns match the file. A test task follows when the first listed standard says `Tests: required`. The earlier standard wins a disagreement while coding.
- **Rationale**: The person sees and owns precedence. The `write` section gets shorter.

## R9. Conflicts

- **Decision**: Assess platforms first, then standards, in catalog order. A conflict is any of the following, with overlap judged by meaning:
  - When to use entries that overlap across two platforms.
  - An entry whose meaning appears in both When to use and When not to use of one record.
  - Two standards whose File Patterns overlap, with overlapping When to use, where neither inherits from the other.
  - An Inherits From title that names no listed standard.
  - An inheritance cycle.

  Each overlap quotes both entries and names both records. A resolution proposal lists each record in bold, then lettered changes. Accepting writes only those cells and reassesses.
- **Rationale**: The clarification chose meaning over exact wording. Quoting both entries keeps every finding checkable.

## R10. Inclusion question

- **Decision**: The `platforms` step in `highway-implementation` writes the row to the new path with blank guidance. It emits "**[Platform] is included as a platform that can start automation.**" and then asks "**Would you like to configure [Platform] for automation?**" Yes emits "Run `/highway-codify-config [Platform]` to configure it." Either answer goes to `close`. Onboarding asks the same question, collects the yes answers, and lists one pointer per yes at the end of `summary`.
- **Rationale**: This follows clarifications 6 and 8.

## R11. Replaced assertions (D3.5)

- `codify-platform-catalog.test.sh`:
  - The header `| Platform | Implementation ID | Source |` becomes `| Platform | Implementation ID | When to use | When not to use |`.
  - The template version becomes 2.0.0.
  - The implementation inclusion sentence becomes "is included as a platform that can start automation." plus the configure question.
  - `library/knowledge/codify-platforms.md` becomes `library/coding-standards/codify-platforms.md`.
  - The implementation version becomes 7.0.0, and the onboarding version 9.0.0.
  - The codify `### configure`, the `configure` entry step, and the two `/highway-codify configure` sentences move to `highway-codify-config` with `/highway-codify-config` wording.
  - The codify version becomes 7.0.0, the record 6.0.0, and the tasks template 3.0.0.

  Reason: configure moved, and the platform catalog was relocated and reshaped. The Provider and diagram checks are unchanged.
- `codify-closing-guide.test.sh`: the codify pin becomes 7.0.0, and the record pin 6.0.0. Reason: MAJOR bumps only. The closing checks are unchanged.
- `output-template.test.sh`: the expected count of template-citing skills goes from 12 to 13, and `highway-codify-config` joins the citing list. Reason: a new citing skill.
- `record-purpose-titles.test.sh`: the `highway-implementation` pin becomes 7.0.0. Reason: a MAJOR bump. The title checks are unchanged.

## R12. Distribution

- **Decision**: Add `include .<agent>/skills/highway-codify-config -` for `.claude`, `.cursor`, `.github`, and `.agents`. `.highway/skills` and `.highway/library` are already included.
- **Rationale**: Any unclassified path fails the shipped-tree check.
