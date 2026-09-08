---
name: requirements-inquiry
description: "The requirements discovery questions Highway skills ask, ordered as they are asked and maintained through the highway-inquiry skill."
metadata:
  version: 1.0.0
---

## Purpose

This questionnaire holds the requirements discovery questions Highway skills ask, in the order
they are asked.

## Verification

- Run `.highway/tools/validate-library.sh .highway/library/templates/requirements-inquiry.md` and
  confirm exit 0.
- Confirm question numbering runs contiguously from 1 to the last question, across all sections
  rather than restarting in each.
- Confirm no two questions have identical text.

## How to change these questions

Ask the `highway-inquiry` skill. It renumbers, keeps this file conformant, and confirms before
discarding anything.

Editing this file by hand works too, and is expected. Keep the numbering contiguous and the
question text unique, or the skill will repair it on its next write.

These questions are a starting point rather than a recommendation. They are meant to be changed to
suit the organisation using them.

A note on formatting: each question is written as a bold number followed by its text, not as a
Markdown ordered list. Numbering runs across the whole file so a question can be named without
also naming its section, and a Markdown ordered list is read as a sequence of workflow steps that
restarts in each section.

## Business Context

**1.** What problem is this system intended to solve, and for whom?

**2.** What happens today without it, and what does that cost?

**3.** Who decides whether this system is a success, and what will they measure?

**4.** What is the deadline, and what drives it?

## Research Inputs

**5.** What existing systems does this replace, extend, or sit beside?

**6.** What has already been tried, and why did it not settle the matter?

**7.** What constraints are already fixed and not open to change?

## Functional Requirements

**8.** What must a user be able to do that they cannot do today?

**9.** What are the most frequent interactions, and how often do they occur?

**10.** Which behaviours are mandatory, and which are desirable?

**11.** What must the system explicitly not do?

## Architecture Drivers

**12.** What is the expected load at launch, and what is it expected to reach?

**13.** Which parts of the system must remain available when other parts fail?

**14.** What data must be kept, for how long, and where may it reside?

**15.** Which external systems must be integrated with, and who owns each?

## Security and Compliance

**16.** What regulatory obligations apply, and which authority enforces each?

**17.** What is the most sensitive data handled, and who may see it?

**18.** How are users authenticated, and how are their permissions decided?

**19.** What must be auditable, and who reviews the audit record?

## Operations

**20.** What is the recovery time objective, and the recovery point objective?

**21.** Who is on call, and what do they need to diagnose a failure?

**22.** What must be monitored, and what threshold triggers a response?

**23.** How are changes released, and how are they reversed?

## Delivery

**24.** Who is building this, and what are they able to support afterwards?

**25.** What is the budget, and which parts of it are already committed?

**26.** What must ship first for the system to be useful at all?

## Governance

**27.** Who approves an architectural decision, and how is that decision recorded?

**28.** Which decisions may the delivery team make without escalation?

**29.** What review must happen before this system carries production data?
