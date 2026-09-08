# Contract: Governance Documentation

Defines where a rule is stated, where it is cited, and how it is discovered.

**Supersedes**: nothing. This contract is new.

## Where rule text lives

Exactly one document holds the text of any given rule. Every other document cites it by identifier.

| Document | Holds rule text | Cites rules | Ships |
|---|---|---|---|
| Highway Skills Constitution | Yes, for `P` rules | — | Yes |
| Highway Development Constitution | Yes, for `D` rules | Cites `P` rules by identifier | No |
| Authoring standard | No | Yes, by identifier | Yes |
| Repository front page | No | Names and links the governing documents | No |

A document that restates rule text creates a second copy that drifts. The authoring standard's
existing test already enforces this for that document, requiring a minimum count of distinct rule
identifiers and rejecting verbatim rule text.

## Discoverability requirement

An author must be able to learn a constraint by reading, not by failing.

| Path to the rule | Requirement |
|---|---|
| Front page → governing documents | The front page names and links both the constitution and the authoring standard |
| Authoring standard → rule | The standard makes the constraint discoverable and cites the rule by identifier |
| Rule identifier → rule text | The constitution holds the text |

The front page currently documents how to author, validate, catalog, and distribute a skill, and
says nothing about the rules a skill is judged by. A reader therefore has no route from "how do I
author a skill" to "what is my skill validated against" without already knowing where to look.

## Amendment requirements

When a rule is added to the Highway Skills Constitution:

| Requirement | Detail |
|---|---|
| Version increment | Matches the classification defined by that document's own versioning policy |
| Change report | Records the rule added and the classification reasoning |
| Classification verified | Checked against the policy text, not by analogy to a previous amendment |
| Conforming artifacts | Confirmed still conforming, since that is what distinguishes MINOR from MAJOR |

## Follow-up entries

The change report carries entries for outstanding work.

| Requirement | Detail |
|---|---|
| An entry describes work not yet done | An entry whose work is complete misleads every future reader |
| Removal records evidence | Naming what was checked and what was found |
| Removal is not completion | An entry may only be removed when its work is done or was never needed — never because it is inconvenient |

## Layer boundary

The rule added by this feature governs skills, which are distributed. It therefore belongs in the
document that is distributed alongside them, not in the document that governs how this repository
is built.

Placing it in the development constitution would put a rule about shipped content in a document
that does not ship, so the author of a skill could not read the rule they are held to. That is the
defect this feature exists to remove, relocated rather than fixed.

The two obligations remain distinct and neither restates the other:

| | Development constitution | Skills constitution |
|---|---|---|
| Subject | Live documentation in this repository | A skill |
| Exists in | One place | Four places |
| Question asked | Does this reference resolve here? | Can this reference resolve anywhere it is read? |

## Guarantees

1. No rule sentence appears in more than one document.
2. An author reading the authoring standard alone finds the constraint.
3. A reader starting at the front page reaches both governing documents by following links.
4. Every link added resolves within the tree containing the document that holds it.
5. Every remaining follow-up entry describes outstanding work.

## Non-goals

- This contract does not make the constitution a published contract for end users. Whether the
  distribution includes it is settled by the packaging feature.
- It does not change how rules are enforced, only where they are stated and cited.
- It does not govern the development constitution's own follow-up entries.
