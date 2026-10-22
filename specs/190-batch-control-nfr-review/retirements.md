# Retirements: Batch Control and NFR Review

The guided Controls and NFR flows no longer accept one item at a time. These lines are removed:

- **Here's what I've captured as your Control:**
- **Here's what I've captured as your NFR:**
- Your accepted Controls now cover [short phrases for the held Controls].
- Your accepted NFRs now cover [short phrases for the held NFRs].
- Next we'll develop **[next title]**.

`.highway/tools/tests/output-template.test.sh` required the singular Control heading and a separate `Statement:` label. That assertion is superseded by the plural heading **Here's what I've captured as your controls:** and the statement on the title line.
