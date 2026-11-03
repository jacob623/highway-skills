# Contract: Config Menu

Invocation `/highway-codify-config` with no title emits:

```markdown
### How would you like to configure Highway Codify?

1. **View or Update Platforms** highway considers for automation and self-service.
2. **View or Update Coding Standards** highway uses for coding.
3. **Resolve Codify Conflicts** so highway can provide more accurate and consistent proposals.
```

- A choice begins with one consequence sentence, then opens `platforms`, `standards`, or `conflicts`.
- Options 1 and 2 show their catalog, with list cells as ordered lists, then ask **What would you add, correct, or remove?** and "If you'd like to cancel, just say so."
- Cancel at any step writes nothing and re-emits this menu.
- `/highway-codify-config [Platform]` skips the menu (R5).
- `/highway-codify configure` is no longer recognized by codify. Codify points to `/highway-codify-config`.
