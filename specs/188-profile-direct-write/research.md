# Research: Profile Direct Write

## Decision: Always propose Vision, Competitive Path, and Guiding Principles

- **Decision**: Delete the three fallback questions and the instruction to emit them when a starting point cannot be filled. Those domains always emit the proposal, including an inferred tradeoff or principle. The correction question stays.
- **Rationale**: The "accepted-evidence" slot and the fallback question caused models to withhold a proposal they could already make. The person corrects the proposal instead of answering a blank question.
- **Alternatives considered**: Keeping the fallback for a completely empty repository was rejected. Identity remains the only domain that may ask what the organization does when no supported starting point exists.

## Decision: Store the accepted bullets and drop the capture paragraph

- **Decision**: Remove the capture template. On acceptance, hold the current bullets. Write those bullets under the domain heading. An Identity question answer is formed into those bullets and held without a second confirmation.
- **Rationale**: The capture step accepted the same content twice and rewrote it into a paragraph that could add a claim.
- **Alternatives considered**: Writing the file after every domain was rejected. The file is still written once, after Guiding Principles is accepted or declined.

## Decision: Write `library/knowledge/profile.md` from the repository root

- **Decision**: Profile, Setup, Objectives, Controls, NFRs, and `profile_path` in `.highway/tools/lib/profile.sh` use `library/knowledge/profile.md`. They do not read or copy `.highway/library/knowledge/profile.md`. The constitution rationale that names the old path is updated in the same change, with a Sync Impact Report and a MINOR version bump. `profile-record.md` says each narrative section is the accepted bullets.
- **Rationale**: The profile is the person's organizational context. The spec places it in their repository. The constitution sentence is live documentation of that location.
- **Alternatives considered**: Migrating an old profile was rejected because backward compatibility is unnecessary. Leaving the constitution path unchanged was rejected because it would describe a file the skills no longer use.

## Decision: Amend the profile behavior checks

- **Decision**: Tests that require the old path, the capture paragraph, or the three fallback questions are updated to the new contract. The superseded behavior is the second acceptance and the fallback questions.
- **Rationale**: D3.3 requires a test change for the new behavior. D3.5 requires the old assertion's removal to name what it no longer enforces.
- **Alternatives considered**: Deleting every profile test was rejected because the path and the one-confirmation rule still need a check.
