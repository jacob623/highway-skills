# Contract: Codify `rank` (version 12.2.0)

Replaces the paragraph that begins `Each suggestion comes from one realized capability.`:

```text
When no instance is running, the first suggestion is `Establish [implementation title]`, drawn from the Implementation Summary. When an instance is running, do not suggest it. Each other suggestion comes from one realized capability, in Realized Capabilities order. When an instance is running and Realized Capabilities is empty, the only suggestion is `Run [implementation title]`.
```

In the next paragraph, `An establishing title starts with `Establish`.` becomes `A title from a realized capability does not start with `Establish`.`

Verification: `- Suggestions of the kind that fits whether an instance is running come first, then the other kind, each in Realized Capabilities order.` becomes `- With no instance running, `Establish [implementation title]` comes first. Every other suggestion comes from one realized capability, in Realized Capabilities order.`

Rejected after the change:

- `A capability title containing `establish``
- `the leading kind`

Kept: `The action is establishing when its title contains `establish`` in `provider`.
