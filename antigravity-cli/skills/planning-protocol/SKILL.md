---
name: planning-protocol
description: "Use when creating, reviewing, or validating technical implementation plans. Invoke when: Plan agent creates architecture plan, Build needs to understand implementation phases, QA needs to verify against plan, or any agent needs to understand planning workflow standards."
license: MIT
compatibility: opencode
metadata:
  author: alejandrocabeza
  workflow: planning
---

# Planning Protocol

This skill defines the **universal standards** for plan structure and format. It is the single source of truth for what a technical plan MUST contain.

## When to Use This Skill

- **Creating plans**: Any agent writing a technical implementation plan
- **Reviewing plans**: Validating plan structure and completeness
- **Implementing from plans**: Build ensuring code matches plan phases
- **Verifying completion**: QA checking phases are executed in order

---

## 1. Plan Structure (Mandatory)

Every technical plan MUST follow this exact structure. Missing sections = invalid plan.

### 1.1 Architecture Overview
- **Stack Definition**: Explicit list of technologies, frameworks, and versions
- **Pattern**: Architectural pattern being used (MVC, microservices, serverless, etc.)
- **Component Diagram**: Mermaid.js diagram showing high-level components and their interactions
- **Data Flow**: How data moves through the system

### 1.2 Data Model (ERD)
- **Mermaid.js Entity-Relationship Diagram**: Complete database schema
- **Table Definitions**: Each table with columns, types, constraints
- **Relationships**: Foreign keys, one-to-many, many-to-many
- **Indexes**: Performance-critical indexes

### 1.3 Security Architecture
- **Authentication**: Strategy (JWT, OAuth2, sessions), token lifecycle
- **Authorization**: Role-based access, permissions model
- **Input Validation**: Patterns for sanitizing user input
- **Rate Limiting**: Configuration for API endpoints
- **Data Protection**: Encryption at rest/transit, PII handling

### 1.4 Implementation Roadmap
Table format with dependencies:

| Phase | Tasks | Dependencies | Estimated Complexity | Risk |
|-------|-------|--------------|---------------------|------|
| 1 | [Task list] | None | Low/Med/High | [Risk assessment] |
| 2 | [Task list] | Phase 1 | Low/Med/High | [Risk assessment] |

Include:
- **Critical Path**: Tasks that block others
- **Parallel Work**: Tasks that can run simultaneously
- **Milestones**: Key deliverables per phase

### 1.5 Testing Strategy
- **Unit Tests**: What functions/methods to test
- **Integration Tests**: Module interaction boundaries
- **Security Tests**: OWASP Top 10 coverage
- **Performance Tests**: Load testing approach

---

## 2. Quality Rules (Non-Negotiable)

### Stack Definition Rule
❌ **BAD**: "Use a modern stack"
✅ **GOOD**: "Node.js 20 LTS, Express 4.18, PostgreSQL 16, Redis 7.2"

### Dependency Rule
Every task (except Phase 1) MUST list explicit dependencies. No implicit ordering.

### Complexity Estimation Rule
Every task MUST have a complexity estimate:
- **Low**: < 4 hours, single file change
- **Medium**: 4-16 hours, multiple files, some integration
- **High**: > 16 hours, architectural changes, multiple systems

### Risk Assessment Rule
Every phase MUST identify at least one risk and mitigation strategy.

---

## 3. Anti-Patterns (What NOT to Do)

| Anti-Pattern | Why It's Bad | Fix |
|--------------|--------------|-----|
| "Implement the backend" | Too vague | Break into specific endpoints/services |
| Missing dependencies | Unclear ordering | Always list what blocks what |
| No complexity estimates | Can't plan resources | Always estimate effort |
| "Add security later" | Security is architectural | Define in Security Architecture phase |
| No risk assessment | Surprises derail timeline | Always identify risks upfront |

---

## 4. Cross-Agent Validation Protocol

### When Plan Agent Creates a Plan
1. Load this skill for structure and quality rules
2. Follow the mandatory structure (all 5 sections)
3. Apply all quality rules
4. Avoid all anti-patterns
5. Output: `/tmp/opencode/plan-[feature].md` (TEMPORARY)

### When Build Agent Implements
Before coding, validate against plan:
- [ ] Understand the architecture overview
- [ ] Know which phase you're in
- [ ] Understand dependencies between tasks
- [ ] Know the testing strategy
- If plan is ambiguous → Request clarification before implementing

### When QA Agent Verifies
Use plan as verification checklist:
- [ ] Architecture matches implementation
- [ ] Security measures are implemented
- [ ] All phases completed in order
- [ ] Testing strategy executed
- If implementation doesn't match plan → File as plan violation, not bug

---

## 5. Output Format

Plans MUST be saved to: `/tmp/opencode/plan-[feature].md`

File naming convention:
- Use lowercase with hyphens: `user-authentication-plan.md`
- NOT: `User Authentication Plan.md`
- NOT: `auth_plan.md`

---

## 6. Integration with Engram

When a plan is approved:
1. Save key architectural decisions to Engram
2. Save technology choices (for future reference)
3. Note any deviations from standard patterns (with justification)

This ensures future sessions can reference why certain decisions were made.
