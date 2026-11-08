# Feature Specification: NFR Safeguard Coverage

**Feature Branch**: `226-nfr-safeguard-coverage`

**Created**: 2026-11-07

**Status**: Draft

**Input**: User description: "In the highway-nfrs proposal, every safeguard should be covered by an operational expectation. When the operational expectation maps to a safeguard, I want the Why it matters rationale to be **Enforces your Safeguard, [Safeguard],** by [rationale]."

A safeguard is an accepted Control. An operational expectation is an NFR.

## Clarifications

### Session 2026-11-07

- Q: With more than five accepted safeguards, should the first recommendation set cover every safeguard, or keep the 3 to 5 limit and cover the rest in later sets? → A: Revised during planning: keep the 3 to 5 limit. Experience Standard X2.16 caps a recommendation set at five choices. Safeguards that do not fit are covered in the next set, which the queue message shows right after the person selects.
- Q: Should the recommendation set show a **Why it matters:** line for each expectation, or only where it is shown today? → A: Each recommendation in the set shows **Why it matters:**, and capture and review keep it.
- Q: At capture, if the person removes the only expectation that covers a safeguard, what happens before the write? → A: Write without it. The safeguard stays uncovered unless the person adds an expectation later at review.
- Q: When the person edits the rationale of a safeguard-based expectation, does the **Enforces your Safeguard, [Safeguard],** opening stay? → A: No. The person's rationale is used as written, even when it drops the opening.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Every safeguard has an operational expectation (Priority: P1)

A person who has accepted safeguards reaches the operational expectations proposal. Each accepted safeguard is covered by at least one proposed operational expectation, so no safeguard is left without an expectation that says how solutions behave to keep it true.

Every set keeps the 3 to 5 limit. Safeguard-based expectations come first, and the sets that follow keep offering them until every accepted safeguard is covered by a queued or captured expectation. An expectation that was shown and not selected does not cover its safeguard.

**Why this priority**: A safeguard with no operational expectation leaves solutions without guidance on how to keep it true.

**Independent Test**: With seven accepted safeguards and no NFRs, start the operational expectations flow. Select some of each set. Check that the following sets keep offering an expectation for each safeguard the queue does not cover yet.

**Acceptance Scenarios**:

1. **Given** accepted safeguards and no recorded NFRs, **When** the first proposal is shown, **Then** it shows 3 to 5 items, and every item other than **No system hosting** and **Direct purchase** covers an accepted safeguard.
2. **Given** seven accepted safeguards that need seven separate expectations, **When** the person selects every item in each set, **Then** the queue messages keep offering safeguard-based expectations until all seven safeguards are covered.
3. **Given** one operational expectation that keeps two safeguards true, **When** the proposal is shown, **Then** that one expectation covers both, and neither safeguard gets a second expectation only for coverage.
4. **Given** the person selects some expectations and not others, **When** the queue is shown, **Then** the next set offers an expectation again for the safeguards the queue does not cover yet, up to five items.
5. **Given** every accepted safeguard is covered by a queued or captured expectation, **When** another set is built, **Then** it shows 3 to 5 expectations from the profile, objectives, or an uncovered area, as today.

---

### User Story 2 - A safeguard-based rationale names the safeguard (Priority: P1)

A person reading an operational expectation that maps to a safeguard sees its rationale start with the safeguard it enforces. The rationale reads **Enforces your Safeguard, [Safeguard],** by [rationale], where [Safeguard] is the safeguard's title and [rationale] says how the expectation enforces it.

Each recommendation in the proposal shows a **Why it matters:** line under its sentence. Capture and review keep showing it.

**Why this priority**: The person accepted the safeguard earlier. Naming it shows why the expectation exists and that the two stay linked.

**Independent Test**: Accept a safeguard titled Data Backup, then start the operational expectations flow. Read the **Why it matters:** line of the expectation that maps to it in the proposal, at capture, and at review after it is written.

**Acceptance Scenarios**:

1. **Given** a recommendation set, **When** it is shown, **Then** each recommendation shows its bold title, one sentence, and a **Why it matters:** line.
2. **Given** an expectation that maps to the safeguard Data Backup, **When** its rationale is shown in the proposal, at capture, or at review, **Then** it reads **Why it matters:** **Enforces your Safeguard, Data Backup,** by [how the expectation enforces it].
3. **Given** an expectation that maps to Data Backup and Access Review, **When** its rationale is shown, **Then** it reads **Why it matters:** **Enforces your Safeguards, Data Backup and Access Review,** by [how the expectation enforces them].
4. **Given** an expectation that maps to no safeguard, such as **No system hosting**, **When** its rationale is shown, **Then** it keeps its current wording.
5. **Given** a recommendation in the proposal that maps to no safeguard and is not a limit, **When** it is shown, **Then** its **Why it matters:** line is one line grounded in the accepted Profile and Objectives.
6. **Given** a recommendation the person selects, **When** it reaches capture, **Then** its **Why it matters:** line matches the one shown in the proposal.
7. **Given** an accepted expectation that maps to a safeguard and whose proposed rationale was not edited, **When** it is written and later shown at review, **Then** the stored rationale keeps the **Enforces your Safeguard** wording.
8. **Given** the person edits the rationale of a safeguard-based expectation, **When** the edit is applied, **Then** the person's rationale is used and stored exactly as written, even when it drops the **Enforces your Safeguard** opening.

---

### Edge Cases

- No accepted safeguards: no expectation maps to one, and every rationale keeps its current wording.
- A safeguard removed after an expectation was written: the expectation keeps its stored rationale until the person edits it at review.
- A person adds their own expectation that keeps an accepted safeguard true: it maps to that safeguard, and Highway proposes its rationale with the new wording.
- A person removes the only expectation that covers a safeguard at capture: the write proceeds without it, with no extra prompt. The safeguard stays uncovered unless the person adds an expectation later at review.
- Three or more safeguards: they are named in a list joined by commas, with "and" before the last.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: While any accepted safeguard is not covered by a queued or captured operational expectation, each recommendation set MUST offer only safeguard-based expectations, plus **No system hosting** and **Direct purchase** in the first set.
- **FR-002**: One operational expectation MAY cover more than one safeguard.
- **FR-003**: A safeguard covered only by an expectation the person did not select MUST be offered again in a later set. A shown recommendation does not cover a safeguard.
- **FR-003a**: Every recommendation set MUST keep the 3 to 5 limit.
- **FR-003b**: Capture MUST NOT block or add a prompt when the person removes the only expectation that covers a safeguard. Coverage applies to the recommendation sets, not to the write.
- **FR-004**: When an operational expectation maps to one safeguard, its Highway-proposed rationale MUST read **Enforces your Safeguard, [Safeguard],** by [rationale].
- **FR-005**: When an operational expectation maps to more than one safeguard, its Highway-proposed rationale MUST read **Enforces your Safeguards, [Safeguard list],** by [rationale].
- **FR-006**: [Safeguard] MUST be the safeguard's accepted title.
- **FR-007**: An expectation that maps to no safeguard MUST keep its current rationale wording.
- **FR-008**: The stored rationale MUST keep the wording shown at acceptance.
- **FR-008a**: A rationale the person edits MUST be used as written. Highway MUST NOT re-add the **Enforces your Safeguard** opening.
- **FR-009**: The safeguards an expectation maps to MUST be the safeguards recorded as influencing it.
- **FR-010**: Each recommendation in a recommendation set MUST show a **Why it matters:** line under its sentence.
- **FR-011**: The **Why it matters:** line shown in the proposal MUST be the rationale shown at capture, unless the person edits it.

### Key Entities

- **Safeguard**: An accepted Control. It has a title the person recognizes.
- **Operational expectation**: An NFR. It has a title, a statement, a rationale, and the safeguards that influenced it.
- **Coverage**: A safeguard is covered when at least one queued or captured operational expectation maps to it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of accepted safeguards are offered an operational expectation before any expectation from another source is offered, and an uncovered safeguard keeps being offered until the queue covers it or the person reviews the queue.
- **SC-001b**: 0 recommendation sets show more than 5 items.
- **SC-001a**: 100% of recommendations in every set show a **Why it matters:** line.
- **SC-002**: 100% of Highway-proposed rationales for expectations that map to a safeguard open with **Enforces your Safeguard** or **Enforces your Safeguards** and name every mapped safeguard by title.
- **SC-003**: 0 rationales for expectations that map to no safeguard use the **Enforces your Safeguard** opening.
- **SC-004**: A person reading a safeguard-based expectation can name the safeguard it enforces without opening another record.

## Assumptions

- A safeguard is an accepted Control. The person sees the word safeguard.
- The expectations that map to a safeguard are those whose recorded Controls include it.
- The [rationale] after "by" is a lowercase clause that says how the expectation keeps the safeguard true.
- **No system hosting** and **Direct purchase** map to no safeguard. Their rationales are unchanged.
- Existing NFR records are not rewritten. Backward compatibility is not required.
- The record and catalog shapes are unchanged. Only the rationale wording and the recommendation rules change.
