# Contract: Scenario Scripts

Keys match by the first unused reply, in file order, whose key appears in the message. Put
specific keys before the generic **What would you add, correct, or remove?**. Unused replies do
not fail a run. Rewritten scripts drop the trailing `[unknown]` catch-all. Openings, titles, and
the unreachable link stay (FR-016). `writes:` and `expect:` lines are unchanged unless noted.

| Scenario | Finding | Change |
| --- | --- | --- |
| profile-smoke | F4 | Identity accept; Vision edit, then accept; Competitive Path accept; Guiding Principles accept. Drop `[unknown]`. |
| setup-smoke | F4 | Four Profile accepts, then `ask-pattern: Which of these outcomes would you like to pursue` → `[decline]`. |
| chain-setup | F4, F5 | Four Profile accepts, then three per governance skill. Each skill's "Would you like to select any…" reply stays `[accept] I'm ready to review.`. |
| codify-config-smoke | F4 | After the coding-standards decline: `ask-pattern: If you'd like to cancel` → `[decline] Nothing else.`, then `ask-pattern: How would you like to configure Highway Codify` → `[decline] Nothing else for now.`. Drop `[unknown]`. |
| onboarding-smoke | F4 | First review: `[edit] Remove AI-Augmented Technology Development.`. Five generic accepts cover the re-emitted list, up to three `map` blocks, and `mapping`. A purpose answer if asked. Configure decline, then next-step decline. Drop `[unknown]`. |
| chain-implementation | F4 | The same onboarding replies. Configure: `[accept] Yes.`. codify-config edit and accept, the coding-standards decline, then the platform list and menu declines (specific keys first). Next step: the implementation opening, start accept, then the configure decline. |
| implementation-onboards-platform | F4, F9 | Jenkins edit; onboarding's AI removal; generic accepts; purpose answer; two configure declines. |
| implementation-smoke | F1, F9 | Fixture `implementation`. Start accept, configure decline. Remove the return-question reply. |
| codify-needed-language | F9 | `ask: What would you add, correct, or remove?` → `[decline] Let's stop here.`; `ask: Would you like to return and provide these details now?` → `[decline] No.` |
| codify-platform-no-row | F14 | The same two replies as codify-needed-language. |
| discovery-smoke | F1, F5 | `ask: Which option would you like to explore, or would you like to see a comparison matrix?` → `[decline] Not now.` only. |
| chain-discovery | F5 | `ask: Which would you like to work on?` → `[select] 1`, then the same `start` decline. |
| chain-architecture | F5 | Keep the ADR replies. Add `ask: What should this architecture be called?` → `Weekly Restock Alerts`. Drop the catch-all. |

`tests/harness-scenarios.test.sh` and `tests/harness-coverage.test.sh` must still pass: each
scenario parses, and its `covers:` hashes still match.
