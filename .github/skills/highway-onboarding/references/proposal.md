# Proposal

### overview

Emit the lines below once, before the first capability list. Emit "Let's get to know your technology landscape" as a level-3 heading. Emit every other line as written. [Name] is the accepted Organization Name. Use the Repository Name when no Organization Name has been accepted.

Let's get to know your technology landscape

We'll connect existing capabilities so future recommendations align with [Name]'s target direction.

During onboarding we'll:

- **Identify the technology capabilities** that support your business.
- **Understand the platforms and processes** that support those capabilities today.
- **Validate Highway's understanding** before any architecture knowledge is created.
- **Capture accepted knowledge** as connected architecture and implementation context.

You don't need to have everything documented in advance. We'll build that understanding together, one capability at a time.

Now, let's get started.

---

Then go to `capabilities`.

### capabilities

Build a starting point from accepted repository context. Do not ask the person to invent the list.

A technology capability is something software, a platform, a service, or infrastructure does for the organization. For each business activity that accepted context names, propose the technology capability that activity relies on, including when context names no system. Title it for what the technology does, such as Online Payments, not for the business function, such as Sales. The title is not a product or vendor. Leave out an activity that no technology supports. When two activities rely on one technology, propose each as its own capability. Follow `capability title` in `highway-implementation` for each title, then return to `capabilities`.

On an edit, re-emit only the starting point.

**Here are the capabilities Highway believes you have today:**

1. **AI-Augmented Technology Development:**

   Using AI systems to assist with research, planning, and implementation of technology solutions.

2. **[Capability title]:**

   [What the technology does for the organization.]

Include the AI-Augmented Technology Development line on the first capability list. Omit it when an accepted ADR already records this capability for the same agent-platform name. The person may correct or remove the line before accept. A removed AI-Augmented Technology Development line is not placed on the capability queue.

Emit one numbered item per other capability, numbered in order. Each item names one capability. When context joins two activities in one capability, propose each as its own item. Keep the person's own wording when they add or correct a capability. Do not include a provider.

**What would you add, correct, or remove?**

If this is accurate, just say so. If you don't know, say "I don't know" and we'll work through it together.

- `edit`: follow `capability title` in `highway-implementation` for each capability the edit adds or corrects, then return here. Emit one consequence sentence, or the one `capability title` gave. Re-emit the starting point with the edit applied. Stay on `capabilities`.
- `accept`: place the capabilities on the capability queue, in displayed order. Go to `map`.
- `unknown`: re-emit the starting point. Stay on `capabilities`.
- `question`: answer, then re-emit the starting point. Stay on `capabilities`.
- `decline`: stop. Write nothing.

### map

Take the first capability on the capability queue.

On the first capability, emit this before the block. Do not emit it again.

**We've identified the capabilities that matter to your organization. Now let's look at how those capabilities are provided today.**

For each capability, we'll identify the platforms, services, processes, or people that help deliver it.

---

**[Capability title]:**

[What the technology does for the organization.]

**Business Purpose:**

[Business purpose.]

**Provider:**

[observed platform, or `Unknown`]

When the capability title is AI-Augmented Technology Development and the session identifies the agent platform by name, that name is the provider. Cursor, VS Code, Claude, and Codex are names the session may identify. Do not guess a name. When no name is identified, the provider is `Unknown`. A corrected name replaces the provider. Do not assign this provider to a capability the platform does not operate.

When the provider is `Unknown`, emit this line immediately above the question:

Highway was unable to infer a platform for this capability. Please provide the application or platform. If you don't know, say "I don't know" and we'll work through it together.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Apply the edit and re-emit this block. When the person says the capability does not exist, remove it from the capability queue and do not include it in the mapping. When the person says the provider does not exist, set the provider to `Does not exist`. Stay on `map` until the person accepts a block whose provider is known or `Does not exist`.
- `accept`: when the provider is `Unknown`, re-emit this block, including the unable-to-infer line. Otherwise remove this capability from the capability queue. A provider marked `Does not exist` does not enter the provider queue. When the queue still has a capability, re-enter `map`. When it is empty, go to `mapping`.
- `unknown`: re-emit this block, including the unable-to-infer line. Stay on `map`.
- `question`: answer, then re-emit this block. Stay on `map`.
- `decline`: stop. Write nothing.

### mapping

Group the accepted mappings by provider. Do not create an inventory record.

**Here is the mapping of your capabilities by provider:**

**[Provider] (Primary):**
- [Capability]

**[Provider]:**
- [Capability]

A capability whose provider is `Does not exist` is omitted from this mapping and does not enter the provider queue. Emit this line immediately above the question:

If you notice something is missing, describe what you know and I'll add it.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Re-emit this block with the edit applied. Stay on `mapping`.
- `accept`: place each provider that has at least one capability on the provider queue. Put the primary provider first. Go to `orchestrate`.
- `unknown`: re-emit this block. Stay on `mapping`.
- `question`: answer, then re-emit this block. Stay on `mapping`.
- `decline`: stop. Write nothing.

## Verification

- The overview is shown once, before the first capability list, and opens with the level-3 heading "Let's get to know your technology landscape".
- Each proposed capability names what a technology does for the organization. An activity that no technology supports is not proposed. An activity with no named system still yields its technology capability, and `map` asks for the provider.
- Each capability is its own numbered item, with its bold title, a blank line, then its description.
- The capability starting point includes **AI-Augmented Technology Development:** Using AI systems to assist with research, planning, and implementation of technology solutions.
- A removed AI-Augmented Technology Development line is not placed on the capability queue.
- Each capability title follows `capability title` in `highway-implementation`. Two activities that rely on one technology are two capabilities.
- The AI-Augmented Technology Development provider is the agent platform the session identifies by name. An unidentified name uses the unable-to-infer prompt.
- The mapping transition is shown once, before the first capability mapping.
- Each mapping label is bold, followed by a blank line and its value.
- The agent platform is not assigned to a capability it does not operate.
- The capability starting point is accepted before any platform question.
- Each capability is mapped before the provider groups are shown.
