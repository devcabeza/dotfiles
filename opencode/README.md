# Sistema de Agentes OpenCode

> Flujo de desarrollo autónomo impulsado por IA con Spec-Driven Development y TDD First

---

## Visión General

Este sistema es un **flujo de trabajo automatizado** que transforma una especificación del proyecto en código funcional, documentación y configuración de infraestructura, siguiendo el ciclo TDD completo.

```
[ESPECIFICACIÓN] → [PLAN] → [RESEARCH] → [🔴 TEST] → [🟢 BUILD] → [🔵 REFACTOR] → [QA] → [DEPLOY]
                                                                    ↑                         ↓
                                                                    └──────────────── [DOCS] ←┘
```

### Principios Fundamentales

| Principio | Descripción |
|-----------|-------------|
| **Spec como Fuente de Verdad** | Los agentes acceden a la skill `spec-driven-development` para conocer el contexto del proyecto |
| **TDD First (Estricto)** | 🔴 RED → 🟢 GREEN → 🔵 REFACTOR en cada feature |
| **Human-in-the-loop** | Tú defines la visión; los agentes ejecutan |
| **Branch-per-Change** | Nunca se opera en `main`; cada feature tiene su rama |
| **Quality Gate** | @QA valida todo antes de avanzar |

---

## 🎯 Ciclo TDD Implementado

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        🎯 TDD CYCLE                                        │
│                                                                             │
│   🔴 RED PHASE              🟢 GREEN PHASE           🔵 REFACTOR PHASE    │
│   ┌─────────────┐          ┌─────────────┐         ┌─────────────┐     │
│   │ @Tester     │ ───────► │ @Build      │ ───────► │ @CodeReview │     │
│   │             │          │             │          │             │     │
│   │ • Crea todos│          │ • Implementa│          │ • Aplica    │     │
│   │   los tests │          │   código    │          │   SOLID     │     │
│   │ • Tests     │          │ • Tests     │          │ • Clean     │     │
│   │   FALLAN    │          │   PASAN     │          │   Code      │     │
│   │ (expected)  │          │             │          │ • Tests     │     │
│   └─────────────┘          └─────────────┘         │   siguen    │     │
│                                                      │   pasando   │     │
│                                                      └─────────────┘     │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Flujo de Trabajo (10 Fases)

```
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 0: CONTEXT INITIALIZATION                                         │
│ @Orch busca contexto anterior en Engram + analiza proyecto              │
│ Output: Contexto cargado                                                │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 1: SPECIFICATION (USER APPROVAL GATE)                            │
│ @Spec define la feature                                                 │
│ Output: .opencode/plans/[feature].spec.md                               │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 2: PLANNING (USER APPROVAL GATE)                                 │
│ @Plan crea plan técnico + ERD + TDD Strategy                           │
│ Output: .opencode/plans/[feature]-plan.md                               │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 3: RESEARCH                                                       │
│ @Research explora codebase + patterns                                  │
│ Output: Hallazgos documentados                                          │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ 🔴 PHASE 4: TEST CREATION (TDD - RED PHASE)                            │
│ @Tester crea TODOS los tests (unit + integration + edge cases)         │
│ Output: Tests en /tests/ - Estado: RED (todos fallan como esperado)    │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ 🟢 PHASE 5: IMPLEMENTATION (TDD - GREEN PHASE)                         │
│ @Build implementa código para que los tests PASEN                       │
│ Output: Código + Tests pasando (Green)                                  │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ 🔵 PHASE 6: CODE QUALITY (TDD - REFACTOR PHASE)                        │
│ @CodeReview mejora código (SOLID + Clean Code) manteniendo tests       │
│ Output: Código refactorizado + Tests siguen pasando                    │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 7: TESTING & SECURITY                                            │
│ @QA valida funcionalidad + @Security escanea vulnerabilidades          │
│ Output: APPROVED o REJECTED                                             │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 8: PERFORMANCE                                                    │
│ @Perf verifica Core Web Vitals                                          │
│ Output: APPROVED o REJECTED                                             │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 9: INFRASTRUCTURE (CONDITIONAL)                                  │
│ @DevOps prepara Docker + CI/CD si es necesario                         │
│ Output: Dockerfile + docker-compose + workflows                         │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 10: DOCUMENTATION                                                 │
│ @Docs actualiza AGENTS.md + genera PR body                              │
│ Output: Documentación actualizada + Pull Request                        │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Agentes del Sistema

### @Orch (Orchestrator)
**Rol:** Master PM - Controla el flujo completo con TDD

- Detecta el tipo de request y crea la rama correcta
- Orquesta la secuencia de agentes (10 fases)
- Reporta estado: `[PHASE: X/10] [TDD: 🔴 RED|🟢 GREEN|🔵 REFACTOR]`
- **Nunca opera en main**

```
Exit Signal: "PIPELINE_COMPLETE: [Feature_Name]"
```

---

### @Spec (Specification Strategist)
**Rol:** Project Specification Lead

- Define la feature según visión del usuario
- Genera spec en `.opencode/plans/[feature].spec.md`
- Incluye: visión, requisitos, criterios de aceptación

```
Exit Signal: "SPEC_DEFINED: [feature]"
```

---

### @Plan (Planner)
**Rol:** Principal Product Architect

- **Stack Discovery:** Audita el repo para detectar frameworks y dependencias
- **Architectural Routing:** Determina si necesita UI (invoca @UX) o es headless
- **Technical Intelligence:** Invoca @Research para APIs y best practices
- **TDD Strategy:** Define estrategia de tests por fase

```
Subagents: @Research, @UX
Exit Signal: "PLAN_ESTABLISHED: [Plan_Filename]"
```

---

### @UX (Designer)
**Rol:** Lead UI/UX Engineer + Stitch Design Expert

- **Stitch First:** Genera diseños visuales en Stitch antes del código
- **Design Tokens Export:** Extrae colores, spacing, border-radius como JSON
- **Component Mapping:** Identifica componentes existentes vs nuevos

```
Tools: stitch_* (Stitch MCP)
Exit Signal: "UX_SPEC_ESTABLISHED: [UX_Filename]"
```

---

### @Research (Intelligence)
**Rol:** Senior Technical Researcher

- **Environment Fingerprinting:** Detecta versiones exactas en package.json, go.mod, etc.
- **Targeted Web Discovery:** Busca en documentación oficial
- **Verification:** Cruza datos encontrados con versión local detectada

```
Tools: read_file, ls, websearch
Exit Signal: "RESEARCH_COMPLETE: [Summary of findings]"
```

---

### @Tester (Test Engineer) - NUEVO!
**Rol:** TDD Specialist - Red Phase

- **Crea TODOS los tests** antes de cualquier implementación
- **Unit Tests:** Cada función/método
- **Integration Tests:** Flujos entre módulos
- **Edge Cases:** Boundary conditions, error handling
- **Tests DEBEN fallar** (Red state esperado)

```
Context: spec + plan + research
Exit Signal: "TESTS_CREATED: [N] tests - State: RED (all failing as expected)"
```

**CRITICAL:** Este agente NO escribe código de implementación, solo tests.

---

### @Build (Developer)
**Rol:** Senior Implementation Engineer - Green Phase

- **Recibe tests de @Tester** (ya creados en Red Phase)
- **Implementa código mínimo** para que los tests pasen
- **TDD Workflow:**
  - Lee los tests creados
  - Implementa código para pasar tests
  - Ejecuta tests → Deben PASAR (Green)
- **No arbitrary values:** Prohibido usar clases hardcodeadas

```
Context: spec + plan + tests from @Tester
Exit Signal: "IMPLEMENTATION_COMPLETE: Tests passing - TDD Green Phase Done"
```

---

### @CodeReview (Code Quality) - ENFOCADO EN TDD REFACTOR
**Rol:** Senior Code Quality Engineer - Refactor Phase

- **Análisis SOLID** (estricto):
  - **SRP:** Single Responsibility - una responsabilidad por función/clase
  - **OCP:** Open/Closed - abierto para extensión, cerrado para modificación
  - **LSP:** Liskov Substitution - subclases substituibles
  - **ISP:** Interface Segregation - interfaces pequeñas
  - **DIP:** Dependency Inversion - depender de abstracciones

- **Clean Code:**
  - Nombres descriptivos
  - Funciones pequeñas (20-30 líneas max)
  - DRY - No código duplicado
  - Mínimos comentarios (solo "por qué", no "qué")

- **TDD Validation:** Tests deben SEGUIR PASANDO después del refactor

```
Context: code + tests
Exit Signal: "CODE_REVIEW_COMPLETE: APPROVED/REJECTED - [N] improvements"
```

---

### @QA (Quality Assurance)
**Rol:** Senior QA & Security Engineer

- **Functional Validation:** 100% de éxito en tests
- **Visual Linting:** Verifica que no haya valores fuera del Design System
- **Semantic Linting:** Valida estructura de tags contra estrategia SEO
- **Static Analysis:** Ejecuta tsc, linting, type checking
- **Security Audit:** Invoca @Security para vulnerabilidades

```
Subagents: @Security
Exit Signal: "PHASE_APPROVED" o "PHASE_REJECTED: [Reason]"
```

---

### @Security (SecOps)
**Rol:** Senior Security Engineer

- **SAST:** Escanea OWASP Top 10 (Injection, XSS, Broken Auth)
- **Supply Chain Audit:** Ejecuta npm audit, pip-audit para CVEs
- **Secret Detection:** Busca API keys hardcodeadas

```
Exit Signal: "SECURITY_SCAN_COMPLETE: [PASS/FAIL] - [X] vulnerabilities found."
```

---

### @Devops (Infrastructure)
**Rol:** Lead DevOps & SRE Engineer

- **Environment Audit:** Lee package.json, planes para entender el stack
- **Containerization:** Escribe Dockerfile multi-stage y docker-compose
- **Pipeline Generation:** Crea workflows CI/CD en .github/workflows/

```
Exit Signal: "INFRA_READY: [Deployment Strategy Name]"
```

---

### @Perf (Performance)
**Rol:** Performance Profiler & Optimization Specialist

- **Core Web Vitals:** LCP, FID, CLS
- **Bundle Size:** Verifica tamaño del bundle
- **Memory:** Analiza uso de memoria

```
Exit Signal: "PERFORMANCE_CHECK_COMPLETE: [PASS/FAIL]"
```

---

### @Docs (Documentation)
**Rol:** Lead Technical Writer

- **AGENTS.md Maintenance:** Actualiza stack tecnológico tras cada build
- **Architecture Sync:** Documenta nuevos patrones en /docs/architecture
- **PR Generation:** Crea cuerpo del Pull Request

```
Exit Signal: "DOCS_UPDATED: [List of files]"
```

---

### @Ask (Advisor)
**Rol:** Principal Architectural Advisor

- **Consultivo puro:** Análisis sistémico y detección de anti-patrones
- **Guía estratégica:** Explica el "Por qué" antes del "Qué"
- **No ejecuta:** Guía al usuario hacia @Orch si necesita implementación

```
Exit Signal: "STRATEGY_ADVISED: [Resumen de la recomendación]"
```

---

## Ejemplo de Uso

### Feature Request
```
Usuario: "Quiero agregar autenticación social con Google"
```

### Flujo Ejecutado (TDD)
```
1. Orch → Crea rama: feature/social-login
2. Spec → Define la feature
3. Plan → Crea plan técnico + TDD Strategy
4. Research → Explora codebase

5. 🔴 Tester → Crea TODOS los tests (unit + integration + edge cases)
          → Tests FALLAN (Red state - esperado)
   
6. 🟢 Build → Implementa código para que tests pasen
          → Tests PASAN (Green state)
   
7. 🔵 CodeReview → Aplica SOLID + Clean Code
                → Tests siguen PASANDO (Refactor done)

8. QA → Valida tests + seguridad + visuales
9. Perf → Verifica performance
10. DevOps → Containeriza (si necesita)
11. Docs → Actualiza AGENTS.md + PR
```

---

## Calidad de Código (TDD Refactor)

### Principios SOLID Aplicados por @CodeReview

| Principio | Descripción | Aplicación en Refactor |
|-----------|-------------|----------------------|
| **SRP** | Una responsabilidad | Extraer funciones con múltiples propósitos |
| **OCP** | Abierto para extensión | Usar abstracciones en lugar de hardcode |
| **LSP** | Subclases substituibles | Ajustar jerarquía si es necesario |
| **ISP** | Interfaces pequeñas | Separar interfaces grandes |
| **DIP** | Depender de abstracciones | Inject dependencies |

### Clean Code Aplicado por @CodeReview

| Regla | Descripción |
|-------|-------------|
| **Nombres claros** | Variables, funciones, clases con nombres descriptivos |
| **Funciones pequeñas** | Máximo 20-30 líneas, un propósito |
| **DRY** | No código duplicado |
| **Comentarios mínimos** | Solo "por qué", no "qué" |
| **Formateo consistente** | Mismos patrones del proyecto |

---

## Estado de Transparencia

Cada agente reporta su estado en formato:

```
[PHASE: X/10] [CURRENT: Phase_X] [STATUS: in_progress|waiting_approval|complete]
[TDD: 🔴 RED|🟢 GREEN|🔵 REFACTOR|N/A]
```

---

## Licencia y Contribuciones

Este sistema es parte de la configuración personal de `@alejandrocabeza`. Para sugerencias o mejoras, abrir un issue en el repositorio correspondiente.

---

**Última actualización:** 2026-05-17
**Versión:** 2.0 (TDD First)
