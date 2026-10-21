# Check retirements

Each entry names a superseded behavior from `contracts/check-retirement.md`.

## Superseded behaviors

- Readiness fields Status, Summary, Next Action, Blocking Reason, Missing, Complete, and Blocked in the twelve promoted skills.
- Sequential next-identifier allocation, including `Next ID`, in the promoted catalogs.
- The previous architecture identifier prefix `ARCH`.
- Transcript locks on the previous Profile, Objectives, Controls, Non-Functional Requirements, Setup, Request, Discovery, Decision, architecture, implementation, onboarding, and assessment wording.

## Retired checks

| Check | Superseded behavior |
|---|---|
| `feature-092-contract.test.sh` | Previous Profile setup and readiness transcript |
| `feature-122-profile-experience-synchronization.test.sh` | Previous Profile transcript |
| `feature-134-profile-contribution-opportunity.test.sh` | Previous Profile transcript |
| `feature-136-profile-substantive-re-evaluation.test.sh` | Previous Profile transcript |
| `feature-137-profile-acquisition-expression-persistence.test.sh` | Previous Profile transcript |
| `feature-138-visible-profile-structure.test.sh` | Previous Profile transcript |
| `feature-140-profile-convergence-alignment.test.sh` | Previous Profile transcript |
| `feature-150-collaborative-convergence.test.sh` | Previous Profile transcript |
| `feature-152-profile-conversation-conformance.test.sh` | Previous Profile transcript |
| `feature-153-delivery-sites.test.sh` | Previous Profile transcript |
| `feature-154-delivery-sites.test.sh` | Previous Profile transcript |
| `feature-155-profile-possibility-lists.test.sh` | Previous Profile transcript |
| `feature-156-structure-revealing-advisory-contributions.test.sh` | Previous Profile transcript |
| `feature-157-profile-response-support-text.test.sh` | Previous Profile transcript |
| `feature-158-interpretation-confidence.test.sh` | Previous Profile transcript |
| `feature-159-objectives-advisory.test.sh` | Previous Objectives transcript |
| `feature-160-objectives-structural-refinement.test.sh` | Previous Objectives transcript |
| `feature-161-objectives-synthesis-lifecycle.test.sh` | Previous Objectives transcript |
| `feature-163-objectives-deduplication.test.sh` | Previous Objectives transcript |
| `feature-164-objective-portfolio-continuity.test.sh` | Previous Objectives transcript |
| `feature-165-identity-discovery-review.test.sh` | Previous Profile transcript |
| `feature-166-objective-archetypes.test.sh` | Previous Objectives transcript |
| `feature-167-profile-structured-proposals.test.sh` | Previous Profile transcript |
| `feature-168-profile-question-simplification.test.sh` | Previous Profile transcript |
| `feature-169-profile-simplification.test.sh` | Previous Profile transcript |
| `feature-174-recommendation-exploration-simplification.test.sh` | Previous recommendation transcript |
| `governance-routing.test.sh` | Previous Controls and NFR routing transcript |
| `highway-adr.test.sh` | Previous Decision transcript |
| `highway-architecture-onboarding.test.sh` | Previous architecture transcript |
| `highway-assessment.test.sh` | Previous assessment transcript |
| `highway-controls-onboarding.test.sh` | Previous Controls transcript and readiness |
| `highway-discovery.test.sh` | Previous Discovery transcript |
| `highway-implementation-onboarding.test.sh` | Previous implementation transcript |
| `highway-nfr-onboarding.test.sh` | Previous NFR transcript and readiness |
| `highway-onboarding.test.sh` | Previous onboarding transcript |
| `highway-setup.test.sh` | Previous Setup transcript and readiness |
| `highway-setup-executable.test.sh` | Previous Setup readiness routing |
| `implementation-compatibility.test.sh` | Previous implementation transcript |
| `nfr-management.test.sh` | Previous NFR transcript |
| `objective-management.test.sh` | Previous Objectives transcript and sequential identifiers |
| `profile-behavior.test.sh` | Previous Profile transcript |
| `profile-context-contract.test.sh` | Previous Profile and Controls readiness transcript |
| `profile-lifecycle.test.sh` | Previous Profile transcript |
| `profile-participation.test.sh` | Previous Profile transcript |
| `profile-runtime-separation.test.sh` | Previous Profile transcript |
| `profile-structure.test.sh` | Previous Profile transcript |
| `readiness-contract.test.sh` | Readiness fields in the promoted skills |
| `readiness-owner-states.test.sh` | Readiness fields in the promoted skills |
| `readiness-ownership.test.sh` | Readiness fields in the promoted skills |
| `readiness-executable.test.sh` | Readiness execution for the promoted skills |
| `setup-owner-loop-contract.test.sh` | Previous Setup readiness loop |
| `control-derived-nfr.test.sh` | Previous Controls and NFR lifecycle transcript |
| `objective-management.test.sh` path required by `.highway/tools/audit-objective-rename.sh` | Previous Objectives transcript. The audit now only rejects the stale plural test name. |

## Edited checks

| Check | What changed |
|---|---|
| `output-template.test.sh` | Dropped `Next ID` and the previous request, control, and discovery transcript locks. Request citations now read `highway-request`. |
| `capability-catalog.test.sh` | Dropped sequential `CAP######` and `Next ID`. The check now requires `CAP` plus eight hex digits and no `Next ID`. |
| `highway-new.test.sh` | Now checks that the reserved skill writes no request and names `highway-request`. |
