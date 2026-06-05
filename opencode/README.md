# 🤖 Sistema de Agentes OpenCode

> **Flujo de desarrollo autónomo impulsado por IA** con Spec-Driven Development (SDD) y TDD First — pipeline estricto que transforma una idea en código de producción con calidad garantizada.

[![Pipeline Status](https://img.shields.io/badge/pipeline-TDD%20First-green)](#ciclo-tdd)
[![Phases](https://img.shields.io/badge/phases-7-blue)](#flujo-de-trabajo)
[![Agents](https://img.shields.io/badge/agents-10-purple)](#agentes-del-sistema)

---

## 📑 Tabla de Contenidos

- [Visión General](#visión-general)
- [Principios Fundamentales](#principios-fundamentales)
- [Ciclo TDD](#-ciclo-tdd-implementado)
- [Flujo de Trabajo (7 Fases)](#flujo-de-trabajo-7-fases)
- [Agentes del Sistema](#agentes-del-sistema)
  - [Agentes Principales (Pipeline)](#agentes-principales-pipeline)
  - [Agentes de Soporte](#agentes-de-soporte)
- [Gestión de Contexto (Engram)](#gestión-de-contexto-engram)
- [Quality Gates](#quality-gates)
- [Calidad de Código (SOLID + Clean Code)](#calidad-de-código-solid--clean-code)
- [Ejemplo Completo de Uso](#ejemplo-completo-de-uso)
- [Comandos y Señales de Salida](#comandos-y-señales-de-salida)
- [Troubleshooting](#troubleshooting)
- [Contribuir](#contribuir)

---

## Visión General

**OpenCode** es un sistema de agentes de IA que implementa un flujo de trabajo de desarrollo de software completamente automatizado y autónomo. Transforma una simple solicitud del usuario en código funcional, documentado y desplegado, siguiendo las mejores prácticas de la industria.

### ¿Qué hace?

```
Tu idea → Spec → Plan → Tests → Código → Refactor → QA → Docs
```

El sistema garantiza que cada feature se desarrolle siguiendo el ciclo **TDD (Test-Driven Development)** de forma estricta, con **Quality Gates** que impiden avanzar sin cumplir los criterios de calidad.

### Características Clave

| Característica | Descripción |
|----------------|-------------|
| **Spec-Driven Development** | Todo comienza con una especificación clara aprobada por el usuario |
| **TDD First (Estricto)** | 🔴 Tests primero → 🟢 Código que pasa → 🔵 Refactor limpio |
| **10 Agentes Especializados** | Cada agente tiene un rol específico y responsabilidades claras |
| **Human-in-the-loop** | Tú apruebas specs, planes y decisiones críticas |
| **Engram Memory** | Memoria persistente entre sesiones para preservar contexto |
| **Quality Gates** | Validación en cada fase antes de avanzar |
| **Branch-per-Change** | Nunca se opera en `main`; cada feature tiene su rama |
| **Documentación Automática** | @Docs genera documentación al finalizar |

---

## Principios Fundamentales

| # | Principio | Descripción |
|---|-----------|-------------|
| 1 | **Spec como Fuente de Verdad** | La especificación es el contrato que todos los agentes respetan |
| 2 | **TDD First (Estricto)** | Nunca se escribe código sin tests previos que fallen (Red Phase) |
| 3 | **Human-in-the-loop** | El usuario define la visión y aprueba decisiones clave |
| 4 | **Branch-per-Change** | Cada feature se desarrolla en una rama dedicada |
| 5 | **Quality Gate** | Ninguna fase avanza sin la aprobación de la fase anterior |
| 6 | **Memoria Persistente** | Engram guarda contexto entre sesiones para continuidad |
| 7 | **Separación de Responsabilidades** | Cada agente tiene un rol y no se entromete en otros |
| 8 | **Mínimo Viable** | @Build implementa solo lo necesario para pasar los tests |

---

## 🎯 Ciclo TDD Implementado

El **Test-Driven Development** es el corazón del sistema. Cada feature sigue este ciclo de forma estricta:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        🎯 TDD CYCLE                                        │
│                                                                             │
│   🔴 RED PHASE              🟢 GREEN PHASE           🔵 REFACTOR PHASE    │
│   ┌─────────────┐          ┌─────────────┐         ┌─────────────┐         │
│   │ @Tester     │ ───────► │ @Build      │ ───────► │ @CodeReview │         │
│   │             │          │             │          │             │         │
│   │ • Crea todos│          │ • Implementa│          │ • Aplica    │         │
│   │   los tests │          │   código    │          │   SOLID     │         │
│   │ • Tests     │          │ • Tests     │          │ • Clean     │         │
│   │   FALLAN    │          │   PASAN     │          │   Code      │         │
│   │ (expected)  │          │             │          │ • Tests     │         │
│   └─────────────┘          └─────────────┘         │   siguen    │         │
│                                                      │   pasando   │         │
│                                                      └─────────────┘         │
│                                                                              │
│   Si @CodeReview REJECTED → @Build ajusta código → @CodeReview re-evalúa   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Flujo TDD Detallado

| Fase | Agente | Acción | Estado de Tests |
|------|--------|--------|-----------------|
| 🔴 **RED** | @Tester | Crea todos los tests (unit, integration, edge cases) | ❌ Todos fallan (esperado) |
| 🟢 **GREEN** | @Build | Implementa código mínimo para pasar tests | ✅ Todos pasan |
| 🔵 **REFACTOR** | @CodeReview | Mejora código (SOLID + Clean Code) | ✅ Sigue pasando |

### Reglas Críticas del TDD

1. **@Tester NO escribe código de implementación** — Solo tests
2. **@Build NO escribe tests** — Solo implementa para pasar los existentes
3. **@CodeReview NO modifica tests** — Solo mejora el código de implementación
4. **Si los tests fallan después de refactor** → Se devuelve a @Build para corrección

---

## Flujo de Trabajo (7 Fases)

Cada feature sigue estas 7 fases en orden estricto. **Ninguna fase se salta** sin aprobación.

```
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 1: SPECIFICATION (🔒 USER APPROVAL GATE)                         │
│ @Spec define la feature según visión del usuario                        │
│ Output: .opencode/plans/[feature].spec.md                               │
│ ⚠️  REQUIERE APROBACIÓN DEL USUARIO                                    │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 2: PLANNING (🔒 USER APPROVAL GATE)                              │
│ @Plan crea plan técnico + ERD + TDD Strategy                           │
│ Output: /tmp/opencode/plan-[feature].md (temporal)                      │
│ ⚠️  REQUIERE APROBACIÓN DEL USUARIO                                    │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ 🔴 PHASE 3: TEST CREATION (TDD - RED PHASE)                            │
│ @Tester crea TODOS los tests:                                           │
│   • Unit Tests (cada función/método)                                    │
│   • Integration Tests (flujos entre módulos)                            │
│   • Edge Cases (boundary conditions, error handling)                    │
│ Output: Tests en /tests/ — Estado: RED (todos fallan como esperado)    │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ 🟢 PHASE 4: IMPLEMENTATION (TDD - GREEN PHASE)                         │
│ @Build lee los tests y implementa código mínimo para que pasen          │
│ Output: Código funcional + Tests pasando (Green)                        │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ 🔵 PHASE 5: CODE QUALITY (TDD - REFACTOR PHASE)                        │
│ @CodeReview analiza y mejora código contra SOLID + Clean Code           │
│   • Si REJECTED → @Build corrige → se repite Phase 5                   │
│   • Si APPROVED → tests siguen pasando tras refactor                   │
│ Output: Código refactorizado + tests pasando                            │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 6: QA & VALIDATION                                                │
│ @QA ejecuta validación completa:                                        │
│   • Tests funcionales (unit, integration, e2e)                          │
│   • Security scan (OWASP Top 10, dependency audit)                     │
│   • Performance check (LCP, FID, CLS, bundle size)                     │
│   • Spec compliance (todos los requisitos cubiertos)                    │
│ Output: QA_PASSED o QA_FAILED (si FAILED → @Build corrige)            │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 7: DOCUMENTATION                                                  │
│ @Docs actualiza documentación del proyecto                              │
│   • Architecture Overview (Mermaid diagrams)                            │
│   • API Reference (si aplica)                                           │
│   • Feature Logs                                                        │
│   • ADRs (Architecture Decision Records)                                │
│ Output: Documentación actualizada                                       │
│ 🏁 PIPELINE_COMPLETE: [Feature_Name]                                    │
└──────────────────────────────────────────────────────────────────────────┘
```

### Detalle por Fase

| Fase | Agente(s) | Output | Gate | Retry |
|------|-----------|--------|------|-------|
| 1 | @Spec | `[feature].spec.md` | **Usuario aprueba** | — |
| 2 | @Plan | `/tmp/opencode/plan-[feature].md` | **Usuario aprueba** | — |
| 3 | @Tester | Tests (RED) | Automático | — |
| 4 | @Build | Código + Tests (GREEN) | Automático | Max 2 |
| 5 | @CodeReview | Código refactorizado | APPROVED/REJECTED | Max 2 |
| 6 | @QA | Tests + Seguridad + Performance | PASSED/FAILED | Max 2 |
| 7 | @Docs | Docs actualizadas | Automático | — |

---

## Agentes del Sistema

### Agentes Principales (Pipeline)

#### 🎯 @Orch (Orchestrator)
**Rol:** Pipeline Coordinator — Controla el flujo completo

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Coordinar las 7 fases, routing de agentes, tracking de estado |
| **Entrada** | Solicitud del usuario |
| **Salida** | Pipeline completo + contexto guardado en Engram |
| **Regla clave** | **Traffic director** — no micromanage, solo coordina |
| **Señal de salida** | `PIPELINE_COMPLETE: [Feature_Name]` |
| **Formato de estado** | `[Phase X/7] [Agent: @X] [Status: running\|waiting\|done] [Retry: N/2]` |
| **Permisos** | bash: allow, read: allow, edit: deny |

```
Ejemplo de uso:
  Usuario: "Agregar autenticación con Google"
  @Orch: Coordina pipeline completo, pausa para aprobaciones
```

---

#### 📝 @Spec (Specification Strategist)
**Rol:** Define qué se va a construir

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Traducir visión del usuario en especificación formal |
| **Entrada** | Solicitud en lenguaje natural |
| **Salida** | `.opencode/plans/[feature].spec.md` |
| **Contenido de spec** | Visión, requisitos funcionales, criterios de aceptación, restricciones |
| **Señal de salida** | `SPECIFICATION_LOCKED: [Filename] - Waiting for User Approval` |
| **Permisos** | edit: deny, read: allow |

```
Estructura de una Spec:
├── Visión general
├── Requisitos funcionales
├── Criterios de aceptación (Given/When/Then)
├── Restricciones técnicas
├── Dependencias identificadas
└── Criterios de éxito
```

---

#### 🏗️ @Plan (Technical Architect)
**Rol:** Diseña CÓMO se va a construir

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Stack discovery, arquitectura, ERD, estrategia TDD |
| **Entrada** | Spec aprobada |
| **Salida** | `/tmp/opencode/plan-[feature].md` (temporal) |
| **Componentes** | ERD (Mermaid), Security Strategy, TDD Strategy, Tech Stack |
| **Señal de salida** | `PLAN_LOCKED: [Filename] - Waiting for User Approval` |
| **Permisos** | edit: deny, read: allow |

```
Contenido del Plan:
├── Architecture Overview
├── Entity Relationship Diagram (Mermaid)
├── Security Strategy (JWT, CORS, Input Validation)
├── Testing Strategy (Unit + Security tests)
├── Step-by-Step Roadmap
└── Integration Points
```

> ⚠️ **NOTA:** El plan es un documento temporal. La spec (`.opencode/plans/[feature].spec.md`) es la fuente de verdad permanente.

---

#### 🧪 @Tester (Test Engineer)
**Rol:** TDD Specialist — Crea la especificación de tests (Red Phase)

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Crear TODOS los tests antes de cualquier implementación |
| **Entrada** | Spec + Plan |
| **Salida** | Archivos de test en `/tests/` |
| **Tipos de tests** | Unit, Integration, Edge Cases, Error Handling |
| **Estado de tests** | ❌ Todos deben FALLAR (Red state) |
| **Señal de salida** | `TESTS_CREATED: [N] tests - State: RED (all failing as expected)` |
| **Permisos** | edit: deny, read: allow, bash: allow |

```
Tipos de tests que crea @Tester:
├── Unit Tests ──────── Cada función/método aislado
├── Integration Tests ─ Flujos entre módulos
├── Edge Cases ──────── Boundary conditions
├── Error Handling ──── Exception paths
└── Happy Path ──────── Escenarios exitosos esperados
```

> ⚠️ **REGLA CRÍTICA:** @Tester NO escribe código de implementación. SOLO tests.

---

#### 💻 @Build (Developer)
**Rol:** Implementador — Hace que los tests pasen (Green Phase)

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Implementar código mínimo para pasar los tests de @Tester |
| **Entrada** | Spec + Plan + Tests de @Tester |
| **Salida** | Código funcional + Tests pasando |
| **Regla** | **Mínimo viable** — No implementar features extras |
| **Prohibido** | Valores hardcodeados, clases sin sentido |
| **Señal de salida** | `IMPLEMENTATION_COMPLETE: [N] tests passing` |
| **Permisos** | edit: allow, read: allow, bash: allow |

```
Workflow de @Build:
1. Lee todos los tests creados por @Tester
2. Lee spec y plan para contexto
3. Identifica qué código falta para que pasen
4. Implementa código mínimo necesario
5. Ejecuta tests → Verifica que TODOS pasan (Green)
6. Si algún test falla → Ajusta hasta que pasen
```

**Retry Context:** Si @Build es invocado con un reporte de rechazo de @CodeReview o @QA:
1. Lee los issues específicos del reporte
2. Fix SOLO los issues reportados — no refactorice código no relacionado
3. Ejecuta tests después de cada fix

---

#### 🔵 @CodeReview (Code Quality)
**Rol:** Calidad de código — Refactor limpio (Refactor Phase)

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Mejorar código contra SOLID + Clean Code |
| **Entrada** | Código implementado + Tests |
| **Salida** | Código refactorizado + Tests siguen pasando |
| **Validación** | Análisis SOLID estricto + Clean Code |
| **Señal de salida** | `REVIEW_APPROVED` o `REVIEW_REJECTED: [Issues]` |
| **Permisos** | edit: deny, read: allow, bash: allow |

```
Checklist de @CodeReview:
├── SRP ── ¿Una responsabilidad por función/clase?
├── OCP ── ¿Abierto para extensión, cerrado para modificación?
├── LSP ── ¿Subclases son substituibles?
├── ISP ── ¿Interfaces pequeñas y específicas?
├── DIP ── ¿Depende de abstracciones, no concreciones?
├── Nombres claros
├── Funciones pequeñas (20-30 líneas max)
├── DRY (No repetición)
├── Comentarios solo "por qué", no "qué"
└── Tests siguen pasando tras refactor
```

**Formato de Rechazo:**
```
## Code Review Failed

### Issues Found
1. [file:line] — [issue type] — [how to fix]
2. [file:line] — [issue type] — [how to fix]

### Required Changes
- [specific instruction for @Build]
```

---

#### 🛡️ @QA (Quality Assurance)
**Rol:** Validación integral de calidad (Tests + Security + Performance)

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Tests funcionales + Security scan + Performance check + Spec compliance |
| **Entrada** | Código refactorizado |
| **Salida** | `QA_PASSED` o `QA_FAILED: [Report]` |
| **Sub-funciones** | Functional Testing, Security Scan, Performance Check, Spec Compliance |
| **Señal de salida** | `QA_PASSED` o `QA_FAILED: [Report]` |
| **Permisos** | edit: deny, read: allow, bash: allow |

```
Validation Checklist de @QA:
├── Functional Testing
│   ├── Unit tests → must pass
│   ├── Integration tests → must pass
│   └── E2E tests → must pass
├── Security Scan
│   ├── OWASP Top 10 vulnerabilities
│   ├── Hardcoded secrets check
│   ├── Dependency audit (npm audit, pip-audit)
│   └── Input validation & auth patterns
├── Performance Check
│   ├── LCP < 2.5s
│   ├── FID < 100ms
│   ├── CLS < 0.1
│   └── Bundle size < 200KB
└── Spec Compliance
    ├── Every requirement implemented
    ├── Every edge case handled
    └── Every success criterion met
```

**Formato de Fallo:**
```
## QA Failed

### Test Failures
- [test name]: [error]

### Security Issues
- [issue]: [severity] [fix]

### Performance Issues
- [metric]: [actual] vs [target]

### Required Fixes for @Build
1. [specific fix]
2. [specific fix]
```

---

#### 📚 @Docs (Documentation)
**Rol:** Documentación técnica

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Mantener documentación clara del proyecto |
| **Entrada** | Código aprobado por @QA + spec original |
| **Salida** | Documentación actualizada en `/docs` |
| **Archivos** | Architecture_Overview.md, API_Reference.md, Feature_Logs/, ADRs |
| **Señal de salida** | `DOCUMENTATION_UPDATED` |
| **Permisos** | edit: deny, read: allow, bash: allow |

```
Documentación que mantiene @Docs:
├── /docs/Architecture_Overview.md ── Diagramas Mermaid + data flow
├── /docs/API_Reference.md ── Endpoints, payloads, response codes (si aplica)
├── /docs/Feature_Logs/[Feature_Name].md ── Resumen de implementación
└── /docs/ADRs/ ── Architecture Decision Records
```

---

### Agentes de Soporte

#### 🐛 @Debugger (Debug Specialist)
**Rol:** Diagnóstico de errores (Auxiliar — bajo demanda)

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Root cause analysis, propuestas de fix |
| **Entrada** | Error logs + stack traces + código |
| **Salida** | Diagnóstico + propuesta de fix |
| **Regla** | **Solo diagnostica** — No implementa fixes |
| **Señal de salida** | `DIAGNOSIS_COMPLETE: [Bug Summary]` |
| **Permisos** | edit: deny, read: allow, bash: allow |

```
Cuándo invocar a @Debugger:
├── @Build no puede entender por qué los tests fallan
├── @QA encuentra un bug que necesita root cause analysis
└── Comportamiento inesperado durante cualquier fase
```

**Formato de Reporte:**
```
## Bug Report
- **Error:** [type] at [file:line]
- **Root Cause:** [why it happens]
- **Fix:** [specific code change]
- **Prevention:** [how to avoid in future]
```

---

#### 💡 @Ask (Senior Technical Consultant)
**Rol:** Asesor arquitectónico estratégico (Read-Only)

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Guidance técnica de alto nivel, explicar conceptos complejos |
| **Entrada** | Preguntas del usuario |
| **Salida** | Recomendaciones estratégicas (solo advice, sin modificar archivos) |
| **Regla** | **Solo aconseja** — No modifica archivos, no ejecuta bash |
| **Señal de salida** | `ADVICE_RENDERED` |
| **Permisos** | edit: deny, read: allow, bash: deny |
| **Temperatura** | 0.7 (más creativo que los agentes operacionales) |

```
Estándares de @Ask:
├── Seniority & Logic — Explica el "Why" detrás de cada recomendación
├── Best Practices — Usa analogías y estándares de la industria
├── Debt Prevention — Advierte sobre deuda técnica
├── Strategic Deep Dives — Desde low-level hasta cloud orchestration
└── The Bird's-Eye View — Analiza desde perspectiva alta cuando otros fallan
```

---

## Gestión de Contexto (Engram)

El sistema usa **Engram** para preservar contexto entre sesiones:

### Ciclo de Vida de la Memoria

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ INICIO SESIÓN   │────►│ DURANTE SESIÓN  │────►│ FIN SESIÓN      │
│                 │     │                 │     │                 │
│ • Search previo │     │ • Save decision │     │ • Session       │
│ • Load context  │     │ • Save patterns │     │   summary       │
│ • Analyze state │     │ • Save bugs     │     │ • Final context │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

### Qué se Guarda

| Tipo | Ejemplo |
|------|---------|
| **Decisión** | "Usamos JWT en lugar de sesiones" |
| **Patrón** | "Patrón de autenticación en middleware" |
| **Bug Fix** | "FTS5 match syntax requiere sanitización" |
| **Arquitectura** | "API design decisions" |
| **Discovery** | "Framework X requiere config Y" |

### Qué NO se Guarda

- Operaciones rutinarias de archivos
- Información ya presente en specs/plans
- Notas temporales de debugging

---

## Quality Gates

### GATES OBLIGATORIOS (No se pueden saltar)

| Gate | Fase | Acción |
|------|------|--------|
| **User Approval** | Phase 1 (Spec) | Usuario debe aprobar "Approved" o "Yes" |
| **User Approval** | Phase 2 (Plan) | Usuario debe aprobar "Approved" o "Yes" |
| **TDD Red** | Phase 3 | @Tester confirma tests creados y FALLANDO |
| **TDD Green** | Phase 4 | @Build confirma tests PASANDO |
| **SOLID Review** | Phase 5 | @CodeReview aprueba calidad de código |
| **QA Gate** | Phase 6 | @QA aprueba funcionalidad + seguridad + performance |

### Retry Policy

Si un gate falla:

```
Gate REJECTED/FAILED → @Build corrige → re-intenta gate
                       ↓
                    Max 2 intentos
                       ↓
                    Si persiste → ESCALAR al usuario
```

**Protocolo de Retry (Orch.md):**
1. Track retry count: `[Retry: 1/2]` o `[Retry: 2/2]`
2. Incluir rejection report al invocar @Build
3. En retry #2: Si @QA falla again, PARAR y reportar al usuario
4. **Nunca exceder 2 retries** — escalar al usuario

---

## Calidad de Código (SOLID + Clean Code)

### Principios SOLID (Aplicados por @CodeReview)

| Principio | Descripción | Ejemplo de Refactor |
|-----------|-------------|---------------------|
| **SRP** | Single Responsibility | Extraer función que hace 3 cosas en 3 funciones |
| **OCP** | Open/Closed | Usar interfaz en lugar de switch/if gigante |
| **LSP** | Liskov Substitution | Asegurar subclases respetan contrato del padre |
| **ISP** | Interface Segregation | Separar `IUserService` en `IUserReader` + `IUserWriter` |
| **DIP** | Dependency Inversion | Inyectar `ILogger` en lugar de usar `Console.WriteLine` |

### Clean Code (Aplicado por @CodeReview)

| Regla | Mal Ejemplo | Buen Ejemplo |
|-------|-------------|--------------|
| **Nombres claros** | `d`, `tmp`, `fn` | `daysUntilExpiry`, `temporaryBuffer`, `fetchUserData` |
| **Funciones pequeñas** | 200 líneas | Máximo 20-30 líneas por función |
| **DRY** | Código duplicado 3 veces | Extraer a función compartida |
| **Comentarios** | `// incrementa i` | `// retry para manejar race condition` |
| **Formateo** | Mezcla de estilos | Consistencia del proyecto |

---

## Ejemplo Completo de Uso

### Solicitud del Usuario

```
Usuario: "Quiero agregar autenticación social con Google y GitHub"
```

### Pipeline Ejecutado (TDD)

```
PHASE 1 ───────────────────────────────────────────────────────────────
  @Spec define feature:
    - Login con Google OAuth2
    - Login con GitHub OAuth  
    - Botón en UI para cada provider
    - Manejo de errores (token inválido, usuario cancela)
  → Archivo: .opencode/plans/social-auth.spec.md
  → 🔒 ESPERANDO APROBACIÓN DEL USUARIO
  → Usuario: "Approved"
  → Señal: SPECIFICATION_LOCKED: social-auth.spec.md

PHASE 2 ───────────────────────────────────────────────────────────────
  @Plan crea plan técnico:
    - Stack: Next.js + NextAuth.js
    - ERD: User, Account, Session tables (Mermaid diagram)
    - Security: CSRF, PKCE flow
    - TDD Strategy: Unit (services), Integration (OAuth flow)
  → Archivo: /tmp/opencode/plan-social-auth.md (temporal)
  → 🔒 ESPERANDO APROBACIÓN DEL USUARIO
  → Usuario: "Approved"
  → Señal: PLAN_LOCKED: plan-social-auth.md

PHASE 3 ───────────────────────────────────────────────────────────────
  🔴 @Tester crea tests (RED):
    - Unit: GoogleProvider.getAuthorizationUrl()
    - Unit: GitHubProvider.exchangeCode()
    - Integration: OAuth callback flow
    - Edge: Token refresh after expiry
    - Edge: Invalid state parameter (CSRF)
  → Estado: TODOS FALLAN (esperado)
  → Señal: TESTS_CREATED: 12 tests - State: RED

PHASE 4 ───────────────────────────────────────────────────────────────
  🟢 @Build implementa código (GREEN):
    - Implementa GoogleProvider class
    - Implementa GitHubProvider class  
    - Implementa OAuth callback handler
    - Implementa token refresh logic
  → Ejecuta tests → TODOS PASAN ✅
  → Señal: IMPLEMENTATION_COMPLETE: 12 tests passing

PHASE 5 ───────────────────────────────────────────────────────────────
  🔵 @CodeReview refactor:
    - Extrae lógica común a BaseOAuthProvider (SRP)
    - Inyecta ITokenService en lugar de crear tokens inline (DIP)
    - Funciones >30 líneas → divididas
  → Tests siguen pasando ✅
  → Señal: REVIEW_APPROVED

PHASE 6 ───────────────────────────────────────────────────────────────
  @QA valida todo:
    - Tests funcionales: 12/12 pass ✅
    - Security scan: OWASP check PASS ✅
    - npm audit: 0 vulnerabilities ✅
    - Performance: LCP 1.2s, bundle +12KB ✅
    - Spec compliance: 100% ✅
  → Señal: QA_PASSED

PHASE 7 ───────────────────────────────────────────────────────────────
  @Docs documenta:
    - Actualiza Architecture_Overview.md con flujo OAuth
    - Crea Feature_Logs/social-auth.md
    - Genera ADR para decisión de NextAuth.js
  → Señal: DOCUMENTATION_UPDATED
  → 🏁 PIPELINE_COMPLETE: social-auth
```

---

## Comandos y Señales de Salida

### Señales de Salida por Agente

| Agente | Señal | Ejemplo |
|--------|-------|---------|
| @Orch | `PIPELINE_COMPLETE` | `PIPELINE_COMPLETE: social-auth` |
| @Spec | `SPECIFICATION_LOCKED` | `SPECIFICATION_LOCKED: social-auth.spec.md - Waiting for User Approval` |
| @Plan | `PLAN_LOCKED` | `PLAN_LOCKED: plan-social-auth.md - Waiting for User Approval` |
| @Tester | `TESTS_CREATED` | `TESTS_CREATED: 12 tests - State: RED (all failing as expected)` |
| @Build | `IMPLEMENTATION_COMPLETE` | `IMPLEMENTATION_COMPLETE: 12 tests passing` |
| @CodeReview | `REVIEW_APPROVED` / `REVIEW_REJECTED` | `REVIEW_APPROVED` o `REVIEW_REJECTED: 3 issues found` |
| @QA | `QA_PASSED` / `QA_FAILED` | `QA_PASSED` o `QA_FAILED: 2 test failures` |
| @Docs | `DOCUMENTATION_UPDATED` | `DOCUMENTATION_UPDATED: Architecture_Overview.md, Feature_Logs/` |
| @Debugger | `DIAGNOSIS_COMPLETE` | `DIAGNOSIS_COMPLETE: Auth race condition` |
| @Ask | `ADVICE_RENDERED` | `ADVICE_RENDERED: Use event-driven architecture` |

### Formato de Estado

```bash
[Phase 3/7] [Agent: @Tester] [Status: running] [Retry: 0/2]
[TDD: 🔴 RED PHASE]

[Phase 5/7] [Agent: @CodeReview] [Status: waiting] [Retry: 0/2]
[TDD: 🔵 REFACTOR PHASE]

[Phase 6/7] [Agent: @QA] [Status: running] [Retry: 1/2]
[TDD: N/A]
```

---

## Troubleshooting

### Problemas Comunes

| Problema | Causa | Solución |
|----------|-------|----------|
| Tests no fallan en Red Phase | @Tester no creó tests correctamente | Re-ejecutar @Tester con spec más clara |
| Tests no pasan en Green Phase | @Build no implementó correctamente | Revisar spec y re-ejecutar @Build |
| @CodeReview REJECTED múltiples veces | Código tiene deuda técnica significativa | Considerar arquitectura diferente |
| @QA FAILED | Tests o seguridad fallan | @Build corrige issues específicos |
| Pipeline stuck en Phase 1/2 | Usuario no ha aprobado | Esperar aprobación o ajustar spec/plan |

### Límites de Retry

```
Build → CodeReview: Máximo 2 intentos
Build → QA:         Máximo 2 intentos
```

Si después de 2 intentos persiste el fallo → **Escalar al usuario** con reporte detallado:

```
⚠️ ESCALATION: @Build has failed 2 QA cycles.
Issues: [summary from last QA report]
Recommendation: Review architecture or break feature into smaller parts.
```

---

## Contribuir

Este sistema es parte de la configuración personal de `@alejandrocabeza`.

### Para Sugerir Mejoras

1. Abrir un issue describiendo la mejora
2. Incluir el agente/fase afectada
3. Proponer solución o alternativa

### Para Agregar un Nuevo Agente

1. Definir responsabilidad clara y exclusiva
2. Definir señal de salida (exit signal)
3. Definir contexto de entrada requerido
4. Crear archivo en `/agents/[Nombre].md`
5. Agregar a la sección de agentes en este README
6. Actualizar el flujo de fases si aplica

---

**Última actualización:** 2026-06-04  
**Versión:** 4.0 (7-Phase Pipeline + Integrated QA)  
**Autor:** @alejandrocabeza
