# Feature Specification: Current Proposal Rules

**Feature Branch**: `211-config-live-rules`

**Created**: 2026-11-04

**Status**: Draft

**Input**: User description: "Before a platform or coding standard proposal, check the live documentation so current capabilities are captured. In the proposal, When to use and When not to use are concise, deterministic rules, and each entry has a Why it matters line that is not saved in the catalog. Propose each coding standard rule as a must. Always include a rule that externalizes encoded or encrypted credentials, preferring encryption when a supported solution is available. After a standard write with no conflicts, state the consequence and return to the menu."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A proposal reflects current capabilities (Priority: P1)

Before Highway shows a platform proposal or a coding standard proposal, it reads that technology's current documentation. The proposal includes the capabilities that documentation describes now, and it leaves out a capability the documentation no longer describes.

**Why this priority**: A proposal built from memory drifts as the platform or language changes. The person accepts guidance that is already out of date.

**Independent Test**: Add or update a platform, and add or update a coding standard, after the technology's documentation has dropped a capability the current record still mentions. That capability is absent from the proposal. A capability the documentation describes and the accepted implementation realizes is present.

**Acceptance Scenarios**:

1. **Given** an accepted implementation to add or update, **When** the platform proposal is prepared, **Then** Highway has read that platform's current documentation before the proposal is shown.
2. **Given** a language or platform to add or update, **When** the coding standard proposal is prepared, **Then** Highway has read that technology's current documentation before the proposal is shown.
3. **Given** the current documentation describes a capability the accepted implementation realizes, **When** the platform proposal appears, **Then** that capability is captured in the proposal.
4. **Given** the current documentation no longer describes a capability, **When** the proposal appears, **Then** that capability is not proposed.
5. **Given** the current documentation cannot be read, **When** the proposal is prepared, **Then** Highway says so, adds no capability as current, and continues from the accepted implementation and the catalogs already present.

---

### User Story 2 - Each use rule is deterministic, and its reason stays on the proposal (Priority: P1)

On a platform proposal and on a coding standard proposal, each When to use entry and each When not to use entry is one concise rule a reviewer can apply the same way every time. The next line explains that rule in everyday language under **Why it matters:**. Accepting the proposal saves the rule and does not save the explanation.

**Why this priority**: A vague use rule makes the next automation proposal choose differently each time. The reason helps the person decide, and saving it would make the catalog carry text it does not use.

**Independent Test**: Open either proposal. Each use entry is one sentence naming a condition and an outcome, and the following line begins with **Why it matters:**. Accept it. The saved catalog contains the rule and does not contain **Why it matters:**. The catalog view shows the rule without that line.

**Acceptance Scenarios**:

1. **Given** a platform proposal or a coding standard proposal, **When** it shows When to use or When not to use, **Then** each entry is one sentence that names a condition and the required outcome.
2. **Given** one of those entries, **When** it is shown, **Then** the next line is **Why it matters:** followed by one sentence in everyday language.
3. **Given** the person accepts, **When** the catalog is written, **Then** the saved entry is the rule, and the Why it matters line is not in the catalog.
4. **Given** the catalog view, **When** it shows When to use or When not to use, **Then** it shows the rules and does not show Why it matters.
5. **Given** a conflict check, **When** it quotes a When to use or When not to use entry, **Then** it quotes the rule and does not quote Why it matters.

---

### User Story 3 - Every coding rule is a must, including credentials (Priority: P1)

A coding standard proposal states each rule as a must. A reviewer given the same file reaches the same yes or no. One of those rules always requires encoded or encrypted credentials to be kept outside the files the standard covers, and requires encryption when the technology's current documentation names a supported way to do that.

**Why this priority**: A rule written as a preference is applied differently by each reviewer. Credentials left in files, including credentials that are only encoded, are the case this must not leave to taste.

**Independent Test**: Propose a new coding standard, and update one that does not yet contain the credential rule. Every rule contains "must". One rule requires those credentials to be kept outside the standard's files, and it requires encryption when the documentation names a supported solution. The proposal has at most ten rules.

**Acceptance Scenarios**:

1. **Given** a coding standard add or update, **When** the proposal appears, **Then** each rule contains "must" and states one outcome a reviewer reaches every time the condition holds.
2. **Given** that proposal, **When** the rules are listed, **Then** one rule requires encoded or encrypted credentials to be kept outside the files the standard covers.
3. **Given** the current documentation names a supported way to encrypt or store those credentials, **When** that rule is proposed, **Then** the rule requires that way rather than encoding alone.
4. **Given** the current documentation names no such way, **When** that rule is proposed, **Then** the rule still requires the credentials to be kept outside the files and does not name a product.
5. **Given** the person accepts, **When** the standard file is written, **Then** the file keeps each rule as a must, including the credential rule.
6. **Given** the current standard already states that credential rule, **When** the proposal appears, **Then** it includes that rule once.

---

### User Story 4 - A saved standard with no conflict returns to the menu (Priority: P2)

After a coding standard is saved and the proposal listed no conflicts, Highway states the consequence of that change in one sentence and shows the configuration menu.

**Why this priority**: The person is done with the standard. Sending them back through the standards list asks them to continue a change they already accepted.

**Independent Test**: Accept a coding standard proposal whose Conflicts are None. The reply is one sentence of what changed, then the three-option menu. The standards list is not shown.

**Acceptance Scenarios**:

1. **Given** an accepted coding standard add, update, or removal, **When** the write succeeds and the proposal listed no conflicts, **Then** Highway states the consequence of that change in one sentence and shows the menu.
2. **Given** that success, **When** the menu appears, **Then** the standards list is not shown.
3. **Given** the proposal listed conflicts, **When** the write succeeds, **Then** Highway still asks whether the person would like help resolving them.
4. **Given** a platform write, **When** it succeeds, **Then** its follow-up is unchanged.

---

### Edge Cases

- A removal shows the current values. It does not read the live documentation, and it does not add Why it matters lines the catalog does not hold.
- A platform named on invocation still gets the documentation check before its proposal.
- When the documentation cannot be read, the coding standard proposal still includes the credential rule, and it does not name an encryption product.
- The proposal lists at most ten coding rules, and the credential rule is one of them. When the current standard already has ten rules and lacks it, the proposal keeps the credential rule, leaves out the current rule least supported by the current documentation, and names that omitted rule in Consequences.
- The person can correct or remove the credential rule before accepting, as with any other rule. The next add or update proposes it again.
- A failed write leaves the proposal open and does not show the menu.
- A capability the documentation describes, which the accepted implementation does not realize, is not proposed as a use of that platform.
- The file and folder structure of a new coding standard still comes from the current documentation.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Before a platform proposal or a coding standard proposal for an add or an update, Highway MUST read that technology's current documentation and MUST capture the capabilities that documentation describes. A capability the documentation no longer describes MUST NOT be proposed.
- **FR-002**: When that documentation cannot be read, Highway MUST say so, MUST add no capability as current, and MUST continue from the accepted implementation and the catalogs already present.
- **FR-003**: On a platform proposal and on a coding standard proposal, each When to use entry and each When not to use entry MUST be one sentence that names a condition and the required outcome. The next line MUST be **Why it matters:** and one sentence in everyday language.
- **FR-004**: Accepting a proposal MUST save the rule and MUST NOT save the Why it matters line. The catalog view and a conflict quote MUST show the rule without that line.
- **FR-005**: Each rule in a coding standard proposal MUST contain "must" and MUST state one outcome a reviewer reaches every time the condition holds. The saved standard file MUST keep that wording.
- **FR-006**: Every coding standard add or update proposal MUST include one rule that requires encoded or encrypted credentials to be kept outside the files the standard covers. When the current documentation names a supported way to encrypt or store them, that rule MUST require that way. When it names none, the rule MUST still require externalizing and MUST NOT name a product. The proposal MUST include that rule once and MUST list at most ten rules.
- **FR-007**: After a coding standard write succeeds and the proposal listed no conflicts, Highway MUST state the consequence of that accepted change in one sentence and MUST return to the menu. It MUST NOT return to the standards list.
- **FR-008**: When the proposal listed conflicts, the question offering help to resolve them MUST remain. A platform write's follow-up MUST remain as it is. A removal MUST show current values and MUST NOT read the live documentation.

### Key Entities

- **Current documentation**: The technology's present public documentation, read when an add or update proposal is prepared. It is the source for capabilities the proposal may call current.
- **Use rule**: One When to use or When not to use entry. It is the text saved in the catalog.
- **Why it matters**: The one-sentence explanation under a use rule. It is shown on the proposal and is not saved.
- **Must rule**: A coding standard rule that states a required outcome. The credential rule is one of these.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In a trial of one platform add and one coding standard add, every capability in the proposal is described by the current documentation, and every capability the documentation no longer describes is absent.
- **SC-002**: On both proposals, every When to use entry and every When not to use entry is one sentence, every such entry has a Why it matters line, and the saved catalog contains none of those Why it matters lines.
- **SC-003**: Every rule in a coding standard proposal contains "must", the proposal has at most ten rules, and exactly one of them is the credential rule.
- **SC-004**: After a coding standard is saved with no conflicts, the next reply is one consequence sentence and the three-option menu.
- **SC-005**: The full check suite passes with the same passing count as before, plus any new check this feature adds. No existing check is removed.

## Assumptions

- Current documentation means the technology's present public documentation. For a platform, a documented capability is proposed only when the accepted implementation realizes it.
- A use rule is deterministic when the same file or automation yields the same yes or no. It does not say should, consider, prefer, usually, or where appropriate. "Prefer encryption" is the must that requires the documented solution when one exists.
- Why it matters explains the rule above it. The proposal still ends with **What would you add or correct?** and the cancel line.
- The catalog continues to store each list as it does today. Only the rule text is stored.
- The credential rule is proposed on every coding standard add and update, including a standard that inherits from another. The person may correct it before accepting.
- When keeping the credential rule would pass ten rules, the proposal leaves out the current rule least supported by the current documentation and names it in Consequences.
- "Return to the menu" means the three-option configuration menu. This applies to a coding standard write. A platform write still offers conflict help, then coding standards for a platform that works with files, then the platform list.
- `highway-codify` is unchanged. It reads the saved rules and does not receive Why it matters, because that line is not in the catalog.
- The same platform or standard can now produce a different proposal, and a coding standard saved with no conflicts now returns to the menu, so `highway-codify-config` moves from `2.0.0` to `3.0.0`.
- The documentation check stands before the proposal. A removal does not perform it.
