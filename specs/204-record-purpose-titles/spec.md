# Feature Specification: Record Purpose Titles

**Feature Branch**: `204-record-purpose-titles`

**Created**: 2026-11-01

**Status**: Draft

**Input**: User description: "Stop copying the decision title onto the architecture and the implementation. Drop Adopt. The architecture title is the purpose, such as Teacher scheduling. The implementation title is the product, such as Notion or Flodesk. Keep every named product when the decision names more than one. When no single product is named, use the mechanism the decision names. When that implementation title is already used, add the purpose."

## Clarifications

### Session 2026-11-01

- Q: What should happen to the architectures and implementations that already exist? → A: Backward compatibility is not required. Existing records are not converted, and no migration is provided. Records are recreated under the new titles when needed.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Name the architecture by its purpose (Priority: P1)

A person accepts an architecture for a decision whose title is "Adopt Notion for teacher scheduling." The architecture they see and save is "Teacher scheduling." It does not say Adopt, and it does not name Notion. The same split applies to the other decisions already in view: the purpose after "for" is the architecture, and the product stays on the decision.

**Why this priority**: The architecture is the conceptual design. Copying "Adopt Notion for teacher scheduling" makes every later list repeat the decision, and it puts a product on a record that is not allowed to name one.

**Independent Test**: Accept an architecture for "Adopt Flodesk for the community newsletter." The proposal and the saved record are titled "The community newsletter." The words Adopt and Flodesk do not appear in the title.

**Acceptance Scenarios**:

1. **Given** the decision "Adopt Notion for teacher scheduling", **When** the architecture proposal is shown, **Then** its title is "Teacher scheduling".
2. **Given** the decision "Adopt Sawyer for class registration, class payments, and family records", **When** the architecture is saved, **Then** its title is "Class registration, class payments, and family records".
3. **Given** the decision "Adopt Shopify for online kit sales, kit payments, and the website", **When** the architecture is saved, **Then** its title is "Online kit sales, kit payments, and the website".
4. **Given** the decision "Adopt Amazon for marketplace kit sales and kit order fulfillment", **When** the architecture is saved, **Then** its title is "Marketplace kit sales and kit order fulfillment".
5. **Given** the decision "Adopt Cursor for AI-assisted engineering and planning", **When** the architecture is saved, **Then** its title is "AI-assisted engineering and planning".
6. **Given** the decision "Adopt the factory for kit prototypes", **When** the architecture is saved, **Then** its title is "Kit prototypes".
7. **Given** the decision "Adopt Time Machine and Google Drive for MacBook backups", **When** the architecture is saved, **Then** its title is "MacBook backups".
8. **Given** the decision "Adopt local MacBook design apps for kit design", **When** the architecture is saved, **Then** its title is "Kit design".
9. **Given** any of these decisions, **When** the architecture title is read, **Then** it does not start with Adopt and it does not name the product.
10. **Given** the person edits the architecture title to a product name, **When** the proposal is shown again, **Then** the product is left out and the purpose remains the title.

---

### User Story 2 - Name the implementation by its product (Priority: P1)

A person accepts the implementation of an architecture. The implementation title is the product the decision named, not the architecture's purpose and not the decision title. "Adopt Notion for teacher scheduling" becomes "Notion." "Adopt Flodesk for the community newsletter" becomes "Flodesk."

**Why this priority**: The implementation is where the product belongs. Copying the architecture title, once that title is the purpose, would hide which product was chosen.

**Independent Test**: Accept the implementation for the Notion decision. The proposal and the saved record are titled "Notion." Accept the Flodesk one and the title is "Flodesk." Neither title contains Adopt or the purpose.

**Acceptance Scenarios**:

1. **Given** the decision "Adopt Notion for teacher scheduling" and its architecture "Teacher scheduling", **When** the implementation proposal is shown, **Then** its title is "Notion".
2. **Given** "Adopt Flodesk for the community newsletter", **When** the implementation is saved, **Then** its title is "Flodesk".
3. **Given** "Adopt Sawyer for class registration, class payments, and family records", **When** the implementation is saved, **Then** its title is "Sawyer".
4. **Given** "Adopt Shopify for online kit sales, kit payments, and the website", **When** the implementation is saved, **Then** its title is "Shopify".
5. **Given** "Adopt Amazon for marketplace kit sales and kit order fulfillment", **When** the implementation is saved, **Then** its title is "Amazon".
6. **Given** "Adopt Cursor for AI-assisted engineering and planning", **When** the implementation is saved, **Then** its title is "Cursor".
7. **Given** "Adopt the factory for kit prototypes", **When** the implementation is saved, **Then** its title is "The factory".
8. **Given** a decision that names one product, **When** the implementation title is read, **Then** it is that product and it does not repeat the purpose.

---

### User Story 3 - Keep a title clear when the product is not one name (Priority: P1)

Some decisions name two products, name no single product, or reuse a product that already has an implementation. The title still says what was accepted, without falling back to the full decision title.

**Why this priority**: A one-word product rule that drops "Google Drive," or that collides with an existing "Notion," produces a record people cannot tell apart.

**Independent Test**: Save the backup decision and the design-apps decision. The first implementation is "Time Machine and Google Drive." The second is "Local MacBook design apps." Save a second Notion decision for a different architecture after one Notion implementation exists. The new title is "Notion for teacher scheduling" because "Notion" is already taken. When "Notion" is free, the title stays "Notion."

**Acceptance Scenarios**:

1. **Given** "Adopt Time Machine and Google Drive for MacBook backups", **When** the implementation is saved, **Then** its title is "Time Machine and Google Drive".
2. **Given** "Adopt local MacBook design apps for kit design", **When** the implementation is saved, **Then** its title is "Local MacBook design apps".
3. **Given** an accepted implementation titled "Notion" for one architecture, **When** an implementation of a different architecture would also be titled "Notion", **Then** the new title is "Notion" plus the purpose, as in "Notion for teacher scheduling".
4. **Given** the product name is free, **When** the implementation is titled, **Then** the purpose is not added.
5. **Given** a decision title with no "for", **When** the two titles are derived, **Then** a leading Adopt is still removed, the architecture title does not name a product, and the implementation title is the product when one is named.

---

### Edge Cases

- The person supplies a title. That title is used. A supplied architecture title that names a product is not used, and the purpose remains.
- The decision title has no "for". A leading Adopt is removed. The architecture title is what remains after any product name is removed. The implementation title is the product the decision names, or what remains when it names none.
- The purpose is empty once Adopt and the product are removed. The architecture title stays the decision title with a leading Adopt removed, and the person is asked for a purpose title before it is saved.
- Two products are joined by "and". Both stay in the implementation title, in the order the decision names them.
- A leading "the" that belongs to the product stays, capitalized, as in "The factory". A leading "the" that belongs to the purpose stays, as in "The community newsletter".
- The first letter of each derived title is capitalized. The remaining words stay as written in the decision.
- The same title already belongs to this same record. The record is reused and is not renamed.
- Opening an accepted architecture or implementation does not rename it.
- Onboarding creates an architecture and an implementation for each provider. Both use these titles. A provider-based decision such as "Adopt Flodesk for the community newsletter" yields "The community newsletter" and "Flodesk".
- A removed record keeps its title. A new record may reuse that title only under the existing reuse rule.
- The person declines. Nothing is written.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: An architecture title MUST be the purpose of the decision. For a decision title of the form "Adopt [product] for [purpose]", the purpose is the text after "for", with its first letter capitalized. The title MUST NOT start with Adopt and MUST NOT name a platform, product, vendor, or specific technology.
- **FR-002**: An implementation title MUST be the product or products the decision names. For "Adopt [product] for [purpose]", the product is the text between Adopt and for, with its first letter capitalized. The title MUST NOT start with Adopt and MUST NOT repeat the purpose.
- **FR-003**: When the decision names more than one product, the implementation title MUST include every product, in the decision's order, including the word that joins them.
- **FR-004**: When the decision names no single product, the implementation title MUST be the mechanism the decision names, with a leading Adopt removed and its first letter capitalized.
- **FR-005**: When the derived implementation title is already the title of an implementation of a different architecture, the title MUST be the product followed by "for" and the purpose. When the product title is free, the purpose MUST NOT be added. The same title under the same architecture MUST reuse that record.
- **FR-006**: A title the person supplies MUST be kept, except an architecture title that names a product. That edit MUST be left out, the purpose MUST remain the architecture title, and the person MUST be told the product belongs on the implementation.
- **FR-007**: The derived title MUST be shown on the proposal before it is accepted. The saved record MUST use the accepted title. The decision title MUST remain unchanged.
- **FR-008**: A decision title with no "for" MUST still lose a leading Adopt. Its architecture title MUST NOT name a product. Its implementation title MUST be the named product, or the remaining title when no product is named.
- **FR-009**: When the purpose would be empty, the person MUST be asked for a purpose title and nothing is written until they give one.
- **FR-010**: Opening an accepted architecture or implementation MUST NOT rename it. The same title on the same record MUST reuse that record.
- **FR-011**: Onboarding MUST title the architecture and implementation it creates by these same rules.
- **FR-012**: Existing records MUST NOT be converted. No migration is provided.

### Key Entities

- **Decision title**: The accepted decision's title. It stays as written. It is the source of the purpose and the product.
- **Architecture title**: The purpose, with no product and no leading Adopt. It is what later lists show for the architecture.
- **Implementation title**: The product or products, or the named mechanism when no single product exists. It gains the purpose only when that product title is already taken.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: For each of the nine decision titles in the stories, the architecture title equals the stated purpose 1 time and contains Adopt 0 times.
- **SC-002**: For each decision that names one product, the implementation title equals that product 1 time and contains the purpose 0 times.
- **SC-003**: The backup decision saves the implementation title "Time Machine and Google Drive" 1 time. The kit-design decision saves "Local MacBook design apps" 1 time.
- **SC-004**: A second implementation whose product title is already taken gains the purpose 1 time. One whose product title is free gains the purpose 0 times.
- **SC-005**: Opening an accepted record changes its title 0 times. The decision title changes 0 times.

## Assumptions

- The nine decision titles in the stories are the pattern this feature must get right. Other decision titles follow the same split.
- "Adopt [product] for [purpose]" is matched without regard to case. The derived title capitalizes only its first letter and otherwise keeps the decision's words.
- A leading "the" stays with whichever side it belongs to. "The factory" is the product. "The community newsletter" is the purpose.
- "Local MacBook design apps" names no single product. The implementation title keeps the decision's words, "Local MacBook design apps," so the rule stays the same for every decision.
- An existing implementation with the same product title under a different architecture counts as taken. The same title under the same architecture is the same record and is reused.
- The person can still supply a title. An architecture title that names a product is refused, which is the rule the architecture proposal already follows.
- The derived title is shown on the proposal because that is the moment the person accepts what later lists will show.
- Backward compatibility is not required. Existing records are not converted, and no migration is provided. The new titles apply whenever an architecture or implementation is written.
- Onboarding writes its architectures and implementations by following the architecture and implementation rules, so it uses these titles without a separate rule.
- The record's identity follows its title, as it does today. Renaming is not performed by opening a record.
- The decision record, its catalog row, and every other field of the architecture and implementation stay as they are.
