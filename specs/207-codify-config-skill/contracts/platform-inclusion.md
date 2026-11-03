# Contract: Platform Inclusion

`highway-implementation` `platforms`, after writing the row with blank guidance:

```markdown
**[Platform] is included as a platform that can start automation.**

**Would you like to configure [Platform] for automation?**
```

- Yes: "Run `/highway-codify-config [Platform]` to configure it." Then `close`.
- No: `close`.

`highway-onboarding`: the same two lines for each platform that can start automation. The answer is collected and onboarding continues. The `summary` ends with one "Run `/highway-codify-config [Platform]` to configure it for automation." per yes. When codify config handed off the run, it also ends with "Run `/highway-codify-config [Platform]` to finish adding [Platform]."
