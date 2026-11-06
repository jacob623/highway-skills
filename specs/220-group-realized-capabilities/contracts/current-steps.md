# Contract: highway-codify-config 3.2.3 `current`

Steps 1 through 3 keep their 3.2.2 text. Steps 4 through 9:

```markdown
4. Group captured platform capabilities that perform the same automation. Judge sameness by meaning.
5. Name that automation in the title, as one noun phrase of five words or fewer. Count a hyphenated word as one word. Put a product name and a handoff, such as a pull request, a comment, or a ticket, in the evidence.
6. For a platform, mark each grouped capability that the implementation's Realized Capabilities do not already mean as a new realized capability. Judge that by meaning.
7. Do not propose a capability the documentation no longer describes.
8. When the documentation cannot be read, say: The current documentation could not be read. Add no capability as current. Mark no new realized capability. Continue from the accepted implementation and the catalogs already present.
9. Then go to the proposal named with this step.
```

## Verification

```markdown
- `current` groups the automation capabilities the platform documentation describes by meaning. Each group the implementation does not already mean appears once under New Realized Capabilities, titled by the automation in five words or fewer, with the product and the handoff in the evidence. After the write, configuration follows `highway-implementation` to record them, with the return step `platform written`.
```

## Rejected text

- `do not list as a new realized capability`
- `7. Then go to the proposal named with this step.`
