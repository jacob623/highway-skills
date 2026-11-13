# Highway

Highway is a Git-native governance, architecture, traceability, and platform engineering system,
delivered as a set of agent skills. It turns business intent, governance knowledge, architecture,
and engineering expertise into governed, traceable, reusable, and deployable capabilities, and it
keeps every downstream record connected to the decisions and requirements that produced it.

This repository is an [Agent Plugins](https://agent-plugins.org) 1.0 plugin. Every skill in
`skills/` follows the [Agent Skills specification](https://agentskills.io/specification).

## Install

Install the plugin with your agent's plugin command, pointing it at this repository. For example,
with GitHub Copilot CLI:

```sh
copilot plugin install jacob623/highway-skills
```

Highway keeps its records in the project you work on. Start with `highway-setup` in that project,
or ask `highway-help` for the list of skills.

## Skills

| Skill | What it does |
| --- | --- |
| `highway-setup` | Sets up Highway in a repository through the governance skills, or revises the setup |
| `highway-profile` | Manages the organizational Profile and its contextual guidance |
| `highway-objectives` | Manages the business objective baseline and its traceability references |
| `highway-controls` | Manages the control baseline |
| `highway-nfrs` | Manages the non-functional requirement baseline |
| `highway-request` | Records one business problem, idea, or desired change as a request |
| `highway-discovery` | Explores the options for one complete request |
| `highway-adr` | Records one architecture decision for one discovery |
| `highway-architecture` | Manages the reference architecture that realizes one accepted ADR |
| `highway-implementation` | Manages the reference implementation that realizes one accepted architecture |
| `highway-onboarding` | Onboards one capability in a single pass: decision, architecture, and implementation |
| `highway-codify-config` | Sets up or updates the platforms highway-codify writes for |
| `highway-codify` | Produces working code for one accepted reference implementation |
| `highway-assessment` | Assesses how the accepted architectures, implementations, or portfolio stand |
| `highway-help` | Lists every skill, or shows how to run one |
| `highway-experience` | Holds Highway's identity, Experience Standard, and storage contract; every other skill loads it first |

## License

[Apache License 2.0](LICENSE)
