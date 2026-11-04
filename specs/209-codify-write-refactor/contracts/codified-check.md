# Contract: Codified Check

`### codified` follows `### suggest`. It writes nothing.

1. Read the accepted rows of `code/code.md` whose Implementation ID is the selected implementation. Skip removed rows and other implementations' rows. With no catalog, leave nothing out.
2. A suggestion whose title is the same words, in the same order, as an Automation Title, ignoring case, is left out. Its record is not opened.
3. Otherwise, when an Automation Title means the suggestion may already be implemented, read `codify.md` at that row's Automation Path. Leave the suggestion out when the record's title, Summary, or Description is that action. Keep it when the record is a different action or the file is absent.
4. A named action and the person's own idea are not refused.

`suggest` leaves out what `codified` removes, then keeps at most five.

When every grounded suggestion was left out, `suggest` says:

`Each action grounded in this implementation is already codified.`

Then it emits the invitation line.
