# Highway Setup Owner Delegation Contract

| Setup condition | Delegated owner workflow | Continue condition | Stop or pause condition |
|---|---|---|---|
| Profile missing or `organization.name` empty | `/highway-profile` setup | Profile owner recognizes a valid profile | Declined, failed, malformed, or still incomplete |
| Profile complete; Objectives missing or empty | `/highway-objectives` setup | Objective owner recognizes at least one valid objective | Declined, failed, malformed, or still incomplete |
| Objectives complete; Controls missing or empty | `/highway-controls` creation | Control owner recognizes an initial valid baseline | Declined, failed, malformed, or still incomplete |
| Controls complete; no NFR proposal started | Control-owned NFR proposal path, preserving `/highway-nfrs` ownership | Proposal is invoked | Report NFRs Missing before proposal invocation |
| Control-owned NFR proposal pending | Control-owned NFR proposal path, preserving `/highway-nfrs` ownership | Author accepts proposal and NFR owner recognizes valid artifacts | Report NFRs In Progress and withhold completion |
| All four baselines complete | No owner workflow | Emit complete dashboard | Not applicable |

`highway-setup` may inspect repository state and route work, but it MUST NOT write owner artifacts directly.

## Ownership Review Checklist

- [ ] Profile writes occur only through `/highway-profile`.
- [ ] Objective records and catalogs occur only through `/highway-objectives`.
- [ ] Control records and Control-owned NFR proposals occur only through `/highway-controls`.
- [ ] Accepted NFR records and NFR baseline changes occur only through `/highway-nfrs`.
- [ ] Setup does not create a second Profile, Objective, Control, or NFR artifact store.
- [ ] Declined, failed, malformed, incomplete, or pending owner results cannot emit `Setup: Complete`.
