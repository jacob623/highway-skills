# NFR Cleanup Contract

## Captured-NFR Review

Use this shape only when Highway materially interprets, classifies, normalizes, or synthesizes
user-authored NFR evidence:

```text
**Here's what I've captured as your NFR:**

**Title:**  
[Title]

**Statement:**  
[Statement]

**Why it matters:**  
[Rationale]

**Would you like to accept this NFR?**
```

Direct NFR statements and explicitly selected recommendations bypass this review. Direct capture
does not bypass validation, duplicate handling, identifier allocation, relationship handling, or
atomic persistence.

## Discovery Ordering

1. Resolve pending Control-derived recommendations.
2. Offer additional Profile-, Objective-, Control-, and existing-NFR-grounded recommendations.
3. Ask the exact broad fallback question only when no useful grounded recommendation exists:
   `Are there any qualities or operational expectations you'd like future solutions to meet?`

Rationale is synthesized from accepted evidence and grounding. It is not a separate discovery
dimension.

## Record Boundary

The NFR record keeps only its existing version `2.0.0` structure and identifier-only `controls`
relationship. Recommendation Grounding remains on the originating Control and is not copied into
the NFR record.
