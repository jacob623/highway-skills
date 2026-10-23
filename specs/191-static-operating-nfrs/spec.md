# Feature Specification: Static Operating NFRs

**Feature Branch**: `191-static-operating-nfrs`

**Created**: 2026-10-22

**Status**: Draft

**Input**: User description: "Implement the 2 static NFR candidates as discussed."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See two operating limits in the NFR review (Priority: P1)

A person reviewing a new set of NFRs sees two operating limits in that same review, along with the NFRs they selected. One limit is about hosting. One is about buying. Each can be accepted, corrected, or removed with the rest of the set.

**Why this priority**: A person who runs the business and its technology was offered only solutions they would have to host. The limit has to be accepted before a Request is written, and it must not become a vision or an objective.

**Independent Test**: Start an NFR review with no accepted material about hosting or purchasing. The review contains both default limits, plus the selected NFRs. The person can remove one and accept the other.

**Acceptance Scenarios**:

1. **Given** a new NFR review and no accepted material about hosting or purchasing, **When** the review is shown, **Then** it includes **No system hosting** and **Direct purchase** with their default statements and rationales.
2. **Given** accepted material that names who hosts the systems, **When** the hosting limit is shown, **Then** its statement uses that material and does not use the managed-service default.
3. **Given** accepted material that describes a buying process, **When** the purchase limit is shown, **Then** its statement uses that process and does not use the direct-purchase default.
4. **Given** the review, **When** the person removes one limit and accepts the set, **Then** only the remaining limit is stored, and the removed limit is not stored.
5. **Given** a later review of NFRs already stored, **When** the person removed one of these limits earlier, **Then** that limit is not added back.

---

### User Story 2 - Copy an accepted limit into the Request (Priority: P2)

A Request proposal fills the named solution limits from those two accepted NFRs. The person can see the filled values and correct them. A removed NFR does not reappear as a guessed limit.

**Why this priority**: Leaving the fields unknown lets Discovery keep solutions the person cannot host or buy. The Request must name the fields. A general instruction to use accepted context is not enough.

**Independent Test**: Accept **No system hosting** and **Direct purchase**, then start a Request. The proposal sets hosting, solution class, procurement, and vendor from those NFRs. None of those four values is unknown.

**Acceptance Scenarios**:

1. **Given** an accepted **No system hosting** NFR, **When** a Request proposal is shown, **Then** the hosting restriction is that NFR's statement and the allowed solution class is a managed service.
2. **Given** an accepted **Direct purchase** NFR, **When** a Request proposal is shown, **Then** the procurement constraint and the vendor restriction are that NFR's statement.
3. **Given** the person corrected the statement and kept the title, **When** the Request proposal is shown, **Then** the filled fields use the corrected statement.
4. **Given** the person removed **No system hosting**, **When** a Request proposal is shown, **Then** the hosting restriction and the allowed solution class stay unknown unless the request material itself states that limit.
5. **Given** other accepted NFRs and no copy of these two, **When** a Request proposal is shown, **Then** those other NFRs do not fill hosting, solution class, procurement, or vendor.

---

### Edge Cases

- Accepted material shows the organization already hosts systems. The hosting limit says that, and the allowed solution class follows that statement.
- Accepted material names a required buying step. The purchase limit states that step.
- The person changes the title of one limit. The Request copies a limit only when the stored title remains **No system hosting** or **Direct purchase**.
- Neither limit has been accepted yet. The Request leaves hosting, solution class, procurement, and vendor unknown.
- The request material states a hosting or buying limit that differs from the accepted NFR. The proposal shows the request material for that field, and the person can correct it.
- A request that cannot be met without hosting still says so. The limit does not invent a managed-service option that cannot satisfy the request.
- Profile, Vision, Competitive Path, Objectives, and Controls do not gain these limits as direction or outcomes.
- Discovery keeps excluding an option that violates a filled hosting, procurement, or vendor restriction, and it keeps filtering by a known solution class. This feature does not add a second interpretation of the NFRs inside Discovery.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A new NFR review MUST include two operating limits in the same review as the selected NFRs: **No system hosting** and **Direct purchase**.
- **FR-002**: When accepted material states who hosts the systems, or that the organization will not host them, the hosting limit MUST use that material.
- **FR-003**: When accepted material does not state a hosting limit, the hosting limit MUST use this default: solutions are delivered as managed services the organization does not host or operate, because the owner runs the business and its technology.
- **FR-004**: When accepted material describes a buying process or a vendor requirement, the purchase limit MUST use that material.
- **FR-005**: When accepted material does not state a buying limit, the purchase limit MUST use this default: the owner buys the service directly from the vendor that operates it, with no proposal, approval board, or mandated vendor.
- **FR-006**: NFRs MUST NOT ask a question in place of either limit, and MUST NOT drop either limit because the material is silent.
- **FR-007**: The person MUST be able to accept, correct, or remove each limit with the rest of the NFR set. A removed limit MUST NOT be stored and MUST NOT be added back during a later review of stored NFRs.
- **FR-008**: When an accepted NFR is titled **No system hosting**, a Request proposal MUST set the hosting restriction to that statement and the allowed solution class to a managed service. It MUST NOT leave either value unknown.
- **FR-009**: When an accepted NFR is titled **Direct purchase**, a Request proposal MUST set the procurement constraint and the vendor restriction to that statement. It MUST NOT leave either value unknown.
- **FR-010**: A corrected statement under the same title MUST be the statement copied into the Request.
- **FR-011**: A removed or retitled limit MUST NOT be recreated from another NFR. Its Request fields stay unknown unless the request material itself states that limit.
- **FR-012**: Request material that states a hosting or buying limit MUST be shown for that field instead of the accepted NFR statement.
- **FR-013**: Profile, Vision, Competitive Path, Objectives, and Controls MUST NOT treat these limits as direction or outcomes.
- **FR-014**: Discovery MUST keep its current exclusion and class filtering once the Request fields are filled. It MUST NOT infer these fields from NFRs on its own.

### Key Entities *(include if feature involves data)*

- **No system hosting**: An NFR the person can accept. Its statement is the hosting limit. Its default says solutions are managed services the organization does not host or operate.
- **Direct purchase**: An NFR the person can accept. Its statement is the buying limit. Its default says the owner buys directly from the operating vendor.
- **Request solution limits**: The hosting restriction, allowed solution class, procurement constraint, and vendor restriction shown on a Request proposal.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: An NFR review with no hosting or buying evidence shows both default limits, and 0 of them are replaced by a question.
- **SC-002**: Removing 1 limit stores the other limit and 0 copies of the removed limit.
- **SC-003**: After both limits are accepted, a Request proposal has 0 unknown values among hosting restriction, allowed solution class, procurement constraint, and vendor restriction.
- **SC-004**: After **No system hosting** is removed, a Request with no hosting statement of its own leaves both the hosting restriction and the allowed solution class unknown.
- **SC-005**: A reliability NFR, or any other NFR that is not one of these two titles, fills 0 of those four Request fields.

## Assumptions

- The two limits appear in the new-set NFR review. They are not a separate review and they do not replace the selected NFRs.
- The stored titles used for copying are exactly **No system hosting** and **Direct purchase**.
- A managed service is the allowed solution class only for the default hosting limit or for an accepted hosting statement that says the organization does not host. A statement that the organization hosts uses a class consistent with that statement.
- The default rationales are the ones stated in FR-003 and FR-005.
- Regulatory restrictions, required platforms, preferred platforms, and known systems do not gain a default.
- Discovery's existing rule is sufficient once the Request fields are filled: options that violate hosting, procurement, or vendor restrictions are excluded, and a known solution class is the class filter.
