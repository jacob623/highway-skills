# Contract: Suggestion List

Owner: `highway-codify`, `### suggest`

## Emitted block

```markdown
**Based on the current state of [Product, platform, or application], automating these tasks may be worth visiting:**

1. **[Action title]:**

   [One sentence that expands on the action.]

**Would you like to explore any of these options?**

If you have another idea, provide a brief description and we'll work through it together.
```

[Product, platform, or application] is the one Technology Choice `Choice:` value, or the implementation title when there are none or several.

## Empty list

Say that no suggestion is grounded in this implementation. Then emit the invitation line above, word for word.

## Rules kept from 3.0.0

- At most five items. Drop items from the end.
- No id as a label.
- Running-instance ordering, defined in this section, applies to the source capability titles.
- A listed number, title, or summary selects one suggestion. The person's own idea selects their own automation. Its title is their action and its summary is one sentence that expands on it.
- Two actions keep one. The other waits for another run.
- A number that is not on the list asks again. Nothing is written.

## Removed strings

- `**Based on the current state of this implementation, these may be worth visiting:**`
- `You can also provide your own.`
