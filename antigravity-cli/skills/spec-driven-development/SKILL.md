---
name: spec-driven-development
description: "Use when creating, reviewing, validating, or implementing from technical specifications. Invoke when: user describes a new feature, Plan needs to validate requirements against a spec, Build needs to implement per spec constraints, QA needs to verify against acceptance criteria, or any agent needs to understand spec-driven workflow standards."
license: MIT
compatibility: opencode
metadata:
  author: alejandrocabeza
  workflow: specification
---

# Spec-Driven Development Protocol

This skill defines the **universal standards** for creating and validating high-quality technical specifications. It is the single source of truth for spec structure, quality rules, and cross-agent validation.

## When to Use This Skill

- **Creating specs**: Any agent writing a `.spec.md` file
- **Reviewing specs**: Plan, Build, or QA validating against spec quality
- **Implementing from specs**: Build ensuring code matches spec constraints
- **Verifying completion**: QA checking acceptance criteria are met

---

## 1. Specification Structure (Mandatory)

Every `.spec.md` MUST follow this exact structure. Missing sections = invalid spec.

```markdown
# [Feature Name] - Technical Specification

## 1. Feature Overview
**Why**: [Business justification — 1-2 sentences max]
**What**: [High-level description — what does this feature do?]
**Scope**: [Explicit boundaries — what's IN and what's OUT]

## 2. User Stories
Format: `As a [persona], I want [action], so that [benefit].`
Each story MUST have acceptance criteria (see section 5).

## 3. Functional Requirements
- [ ] [Requirement] — MUST be testable and measurable
- [ ] [Requirement] — Include edge cases
- [ ] [Requirement] — Reference specific APIs or data structures

## 4. Technical Constraints
- Stack: [Specific technologies/patterns to use]
- Architecture: [Patterns to follow — e.g., "Use Express middleware"]
- Performance: [Specific thresholds — e.g., "< 200ms response time"]
- Security: [Requirements — e.g., "JWT with 15min expiry"]
- Integration: [External services, APIs, or existing code to integrate with]

## 5. Success Criteria (Definition of Done)
- [ ] [Measurable criterion — e.g., "All unit tests pass"]
- [ ] [Measurable criterion — e.g., "Lighthouse score > 90"]
- [ ] [Measurable criterion — e.g., "API handles 1000 concurrent users"]

## 6. Edge Cases & Error Handling
| Scenario | Expected Behavior |
|----------|-------------------|
| [Edge case 1] | [How system responds] |
| [Edge case 2] | [How system responds] |

## 7. Data Model (if applicable)
[Mermaid ERD or schema definition]

## 8. API Contract (if applicable)
[Endpoints, request/response formats]

## 9. Security Considerations
[Authentication, authorization, input validation, rate limiting]
```

---

## 2. Quality Rules (Non-Negotiable)

### Precision Rule
❌ **BAD**: "The UI should be fast"
✅ **GOOD**: "Initial page load < 200ms on 3G connection"

❌ **BAD**: "Handle errors gracefully"
✅ **GOOD**: "Show toast notification with error message; log to Sentry; retry button for 5xx errors"

### Testability Rule
Every functional requirement MUST answer: "How would I write a test for this?"
If you can't write a test, the requirement is too vague.

### Scope Rule
Every spec MUST have an explicit "Out of Scope" section. If it's not listed, it's not being built.

### No Assumptions Rule
If the user says "make it secure," ask: "Secure how? JWT? OAuth2? Rate limiting? Input validation?" Never assume.

---

## 3. Anti-Patterns (What NOT to Do)

| Anti-Pattern | Why It's Bad | Fix |
|--------------|--------------|-----|
| "It should be user-friendly" | Not measurable | Define specific UX metrics |
| "Support all browsers" | Too broad | List: "Chrome 90+, Firefox 88+, Safari 14+" |
| "Make it scalable" | Vague | Define: "Handle 10k concurrent users" |
| "Add proper error handling" | Unspecific | List each error scenario and response |
| Missing "Out of Scope" | Scope creep | Always define boundaries |
| No acceptance criteria | Can't verify done | Every story needs criteria |
| Technical constraints as suggestions | Build ignores them | Use "MUST" not "should" |

---

## 4. Cross-Agent Validation Protocol

### When Spec Agent Creates a Spec
1. Load this skill for structure and quality rules
2. Follow the mandatory structure (Section 1)
3. Apply all quality rules (Section 2)
4. Avoid all anti-patterns (Section 3)
5. Output: `.opencode/plans/[feature].spec.md`

### When Plan Agent Reviews a Spec
Before creating the technical plan, validate the spec:
- [ ] All sections present (Section 1)
- [ ] Every requirement is testable (Section 2)
- [ ] No anti-patterns present (Section 3)
- [ ] Technical constraints are specific and actionable
- [ ] Success criteria are measurable
- If spec is invalid → Request spec revision before planning

### When Build Agent Implements
Before coding, validate against spec:
- [ ] Understand all functional requirements
- [ ] Know all technical constraints
- [ ] Have clear success criteria to target
- [ ] Know what edge cases to handle
- If spec is ambiguous → Request clarification before implementing

### When QA Agent Verifies
Use spec as the verification checklist:
- [ ] Every success criterion has a corresponding test
- [ ] Every edge case from spec is tested
- [ ] Performance thresholds are validated
- [ ] Security requirements are verified
- If implementation doesn't match spec → File as spec violation, not bug

---

## 5. Spec Quality Checklist

Use this checklist before approving any spec:

### Structure
- [ ] All 9 sections present (or N/A with justification)
- [ ] Feature Overview has clear Why + What + Scope
- [ ] User Stories follow "As a... I want... So that..." format
- [ ] Out of Scope section exists

### Requirements
- [ ] Every requirement starts with a verb (Add, Remove, Validate, etc.)
- [ ] Every requirement is testable (can write a test for it)
- [ ] Every requirement is measurable (has numbers, not adjectives)
- [ ] Edge cases are listed with expected behaviors

### Technical
- [ ] Stack is explicitly named (not "modern stack")
- [ ] Performance thresholds have numbers (not "fast")
- [ ] Security requirements are specific (not "secure")
- [ ] Integration points are documented

### Completeness
- [ ] Data model included (if applicable)
- [ ] API contract included (if applicable)
- [ ] Success criteria are measurable and verifiable
- [ ] All assumptions are documented

---

## 6. Output Format

Specs MUST be saved to: `.opencode/plans/[feature_name].spec.md`

File naming convention:
- Use lowercase with hyphens: `user-authentication.spec.md`
- NOT: `User Authentication Spec.md`
- NOT: `auth_spec.md`

---

## 7. Integration with Engram

When a spec is approved:
1. Save key decisions to Engram (architectural choices, constraints)
2. Save patterns used (for future reference)
3. Note any deviations from standard patterns (with justification)

This ensures future sessions can reference why certain decisions were made.
