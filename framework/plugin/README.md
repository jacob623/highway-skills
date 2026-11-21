# Highway

Highway is a Git-native governance, architecture, and traceability system that
carries business intent through to working code, delivered as a set of agent skills.
It turns business intent, governance knowledge, architecture, and engineering expertise
into governed, traceable, reusable, and deployable capabilities, and it keeps every
downstream record connected to the decisions and requirements that produced it.

This repository is an [Agent Plugins](https://agent-plugins.org) 1.0 plugin. Every skill in
`skills/` follows the [Agent Skills specification](https://agentskills.io/specification).

## Install

Install Highway from this public repository (`highway-systems/agent-plugin`). No separate
Highway executable is required. After install, open your project and run `highway-setup`, or
ask `highway-help` for the skill list.

Records stay in **your** project repository. Storage today is **Local** mode: the agent reads and
writes your working tree; you handle git. Remote commit/push and Chat (no working tree) modes are
not claimed here yet.

### GitHub Copilot

```sh
copilot plugin marketplace add highway-systems/agent-plugin
copilot plugin install highway@highway-systems/agent-plugin
```

Or install from the repository URL if your Copilot build accepts it:

```sh
copilot plugin install highway-systems/agent-plugin
```

### Cursor

Add the marketplace from this repository (`.cursor-plugin/marketplace.json` at the root), then
install `highway`, or follow Cursor's plugin install from
`https://github.com/highway-systems/agent-plugin`.

### Claude Code

```sh
claude plugin marketplace add highway-systems/agent-plugin
claude plugin install highway@highway-systems/agent-plugin
```

### Codex / ChatGPT agents

```sh
codex plugin marketplace add highway-systems/agent-plugin
codex plugin add highway
```

### Antigravity

```sh
agy plugin install https://github.com/highway-systems/agent-plugin
```

### Gemini CLI

```sh
gemini extensions install https://github.com/highway-systems/agent-plugin
```

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
