# 🤖 Sistema de Agentes OpenCode

> **Flujo de desarrollo autónomo impulsado por IA** con Spec-Driven Development (SDD) y TDD First —严strict pipeline que transforma una idea en código de producción con calidad garantizada.

[![Pipeline Status](https://img.shields.io/badge/pipeline-TDD%20First-green)](#ciclo-tdd)
[![Phases](https://img.shields.io/badge/phases-10-blue)](#flujo-de-trabajo)
[![Agents](https://img.shields.io/badge/agents-14-purple)](#agentes-del-sistema)

---

## 📑 Tabla de Contenidos

- [Visión General](#visión-general)
- [Principios Fundamentales](#principios-fundamentales)
- [Ciclo TDD](#-ciclo-tdd-implementado)
- [Flujo de Trabajo (10 Fases)](#flujo-de-trabajo-10-fases)
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
Tu idea → Spec → Plan → Research → Tests → Código → Refactor → QA → Deploy → Docs
```

El sistema garantiza que cada feature se desarrolle siguiendo el ciclo **TDD (Test-Driven Development)** de forma estricta, con **Quality Gates** que impiden avanzar sin cumplir los criterios de calidad.

### Características Clave

| Característica | Descripción |
|----------------|-------------|
| **Spec-Driven Development** | Todo comienza con una especificación clara aprobada por el usuario |
| **TDD First (Estricto)** | 🔴 Tests primero → 🟢 Código que pasa → 🔵 Refactor limpio |
| **14 Agentes Especializados** | Cada agente tiene un rol específico y responsabilidades claras |
| **Human-in-the-loop** | Tú apruebas specs, planes y decisiones críticas |
| **Engram Memory** | Memoria persistente entre sesiones para preservar contexto |
| **Quality Gates** | Validación en cada fase antes de avanzar |
| **Branch-per-Change** | Nunca se opera en `main`; cada feature tiene su rama |
| **Documentación Automática** | @Docs genera documentación y PR body al finalizar |

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

## Flujo de Trabajo (10 Fases)

Cada feature sigue estas 10 fases en orden estricto. **Ninguna fase se salta** sin aprobación.

```
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 0: CONTEXT INITIALIZATION                                         │
│ @Orch busca contexto anterior en Engram + analiza proyecto              │
│ Output: Contexto cargado                                                │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
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
│ Output: .opencode/plans/[feature]-plan.md                               │
│ ⚠️  REQUIERE APROBACIÓN DEL USUARIO                                    │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 3: RESEARCH                                                       │
│ @Research explora codebase + patrones + documentación externa          │
│ Output: Hallazgos documentados para @Tester y @Build                    │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ 🔴 PHASE 4: TEST CREATION (TDD - RED PHASE)                            │
│ @Tester crea TODOS los tests:                                           │
│   • Unit Tests (cada función/método)                                    │
│   • Integration Tests (flujos entre módulos)                            │
│   • Edge Cases (boundary conditions, error handling)                    │
│ Output: Tests en /tests/ — Estado: RED (todos fallan como esperado)    │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ 🟢 PHASE 5: IMPLEMENTATION (TDD - GREEN PHASE)                         │
│ @Build lee los tests y implementa código mínimo para que pasen          │
│ Output: Código funcional + Tests pasando (Green)                        │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ 🔵 PHASE 6: CODE QUALITY (TDD - REFACTOR PHASE)                        │
│ @CodeReview analiza y mejora código contra SOLID + Clean Code           │
│   • Si REJECTED → @Build corrige → se repite Phase 6                   │
│   • Si APPROVED → tests siguen pasando tras refactor                   │
│ Output: Código refactorizado + tests pasando                            │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 7: TESTING & SECURITY                                             │
│ @QA ejecuta tests completos + @Security escanea vulnerabilidades        │
│ Output: APPROVED o REJECTED (si REJECTED → @Build corrige)             │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 8: PERFORMANCE                                                    │
│ @Perf verifica Core Web Vitals, bundle size, memoria                    │
│ Output: APPROVED o REJECTED (si REJECTED → @Build corrige)             │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 9: INFRASTRUCTURE (Conditional)                                   │
│ @DevOps prepara Docker + CI/CD solo si es necesario                     │
│ Output: Dockerfile + docker-compose + workflows (o SKIP)               │
└────────────────────────────────┬─────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ PHASE 10: DOCUMENTATION                                                 │
│ @Docs actualiza documentación + genera PR body                          │
│ Output: Documentación actualizada + Pull Request listo                  │
│ 🏁 PIPELINE_COMPLETE: [Feature_Name]                                    │
└──────────────────────────────────────────────────────────────────────────┘
```

### Detalle por Fase

| Fase | Agente(s) | Output | Gate | Retry |
|------|-----------|--------|------|-------|
| 0 | @Orch | Contexto cargado | Automático | — |
| 1 | @Spec | `[feature].spec.md` | **Usuario aprueba** | — |
| 2 | @Plan | `[feature]-plan.md` | **Usuario aprueba** | — |
| 3 | @Research | Hallazgos documentados | Automático | — |
| 4 | @Tester | Tests (RED) | Automático | — |
| 5 | @Build | Código + Tests (GREEN) | Automático | Max 3 |
| 6 | @CodeReview | Código refactorizado | APPROVED/REJECTED | Max 3 |
| 7 | @QA + @Security | Tests + Seguridad | APPROVED/REJECTED | Max 3 |
| 8 | @Perf | Performance check | APPROVED/REJECTED | Max 3 |
| 9 | @DevOps | Infra (opcional) | Automático | — |
| 10 | @Docs | Docs + PR | Automático | — |

---

## Agentes del Sistema

### Agentes Principales (Pipeline)

#### 🎯 @Orch (Orchestrator)
**Rol:** Master Pipeline Orchestrator — Controla el flujo completo

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Detectar tipo de request, crear rama, orquestar las 10 fases |
| **Entrada** | Solicitud del usuario |
| **Salida** | Rama creada + pipeline completo |
| **Regla clave** | **Nunca opera en `main`** — siempre crea feature branch |
| **Señal de salida** | `PIPELINE_COMPLETE: [Feature_Name]` |
| **Formato de estado** | `[PHASE: X/10] [CURRENT: Phase_X] [STATUS: in_progress]` |

```
Ejemplo de uso:
  Usuario: "Agregar autenticación con Google"
  @Orch: Crea rama "feature/google-auth", inicia Phase 0
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
| **Señal de salida** | `SPEC_DEFINED: [feature]` |

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
| **Salida** | `.opencode/plans/[feature]-plan.md` |
| **Subagentes** | @Research, @UX (si necesita UI) |
| **Componentes** | ERD, Security Strategy, TDD Strategy, Tech Stack |
| **Señal de salida** | `PLAN_ESTABLISHED: [Plan_Filename]` |

```
Contenido del Plan:
├── Stack Discovery (frameworks, dependencias detectadas)
├── Architectural Decisions (monolito vs microservicios, etc.)
├── Entity Relationship Diagram (ERD)
├── Security Strategy (auth, OWASP considerations)
├── TDD Strategy (tipos de tests por feature)
├── File Structure proposal
└── Integration Points
```

---

#### 🔍 @Research (Intelligence)
**Rol:** Investigador técnico — busca información verificada

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Documentación oficial, patterns, versiones exactas |
| **Entrada** | Contexto del plan |
| **Salida** | Hallazgos documentados con fuentes |
| **Herramientas** | `read_file`, `ls`, `websearch`, `context7` |
| **Método** | Environment fingerprinting → Web discovery → Verification |
| **Señal de salida** | `RESEARCH_COMPLETE: [Summary of findings]` |

---

#### 🧪 @Tester (Test Engineer)
**Rol:** TDD Specialist — Crea la especificación de tests (Red Phase)

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Crear TODOS los tests antes de cualquier implementación |
| **Entrada** | Spec + Plan + Research |
| **Salida** | Archivos de test en `/tests/` |
| **Tipos de tests** | Unit, Integration, Edge Cases, Error Handling |
| **Estado de tests** | ❌ Todos deben FALLAR (Red state) |
| **Señal de salida** | `TESTS_CREATED: [N] tests - State: RED` |

```
Tipos de tests que crea @Tester:
├── Unit Tests ──────── Cada función/método aislado
├── Integration Tests ─ Flujos entre módulos
├── Edge Cases ──────── Boundary conditions
├── Error Handling ──── Exception paths
└── Contract Tests ──── API contracts (si aplica)
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
| **Señal de salida** | `IMPLEMENTATION_COMPLETE: Tests passing` |

```
Workflow de @Build:
1. Lee todos los tests creados por @Tester
2. Identifica qué código falta para que pasen
3. Implementa código mínimo necesario
4. Ejecuta tests → Verifica que TODOS pasen (Green)
5. Si algún test falla → Ajusta hasta que pasen
```

---

#### 🔵 @CodeReview (Code Quality)
**Rol:** Calidad de código — Refactor limpio (Refactor Phase)

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Mejorar código contra SOLID + Clean Code |
| **Entrada** | Código implementado + Tests |
| **Salida** | Código refactorizado + Tests siguen pasando |
| **Validación** | Análisis SOLID estricto + Clean Code |
| **Señal de salida** | `CODE_REVIEW_COMPLETE: APPROVED/REJECTED` |

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

---

#### 🛡️ @QA (Quality Assurance)
**Rol:** Validación integral de calidad

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Tests funcionales + visual + semantic linting + static analysis |
| **Entrada** | Código refactorizado |
| **Salida** | APPROVED o REJECTED |
| **Subagentes** | @Security |
| **Validaciones** | Functional (100%), Visual, Semantic, Type checking, Linting |
| **Señal de salida** | `PHASE_APPROVED` o `PHASE_REJECTED: [Reason]` |

---

#### 🔒 @Security (SecOps)
**Rol:** Seguridad de la aplicación

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | SAST, Supply Chain Audit, Secret Detection |
| **Entrada** | Código fuente |
| **Salida** | PASS/FAIL + vulnerabilidades encontradas |
| **Escaneos** | OWASP Top 10, npm audit, pip-audit, API keys hardcodeadas |
| **Señal de salida** | `SECURITY_SCAN_COMPLETE: [PASS/FAIL] - [N] vulnerabilities` |

---

#### ⚡ @Perf (Performance)
**Rol:** Performance Profiler

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Core Web Vitals, bundle size, memoria |
| **Entrada** | Código listo para producción |
| **Salida** | APPROVED o REJECTED |
| **Métricas** | LCP, FID, CLS, bundle size, memory usage |
| **Señal de salida** | `PERFORMANCE_CHECK_COMPLETE: [PASS/FAIL]` |

---

#### 📦 @DevOps (Infrastructure)
**Rol:** Infraestructura y despliegue

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Containerization + CI/CD pipelines |
| **Entrada** | Stack tecnológico detectado |
| **Salida** | Dockerfile, docker-compose, GitHub Actions workflows |
| **Condición** | Solo se ejecuta si es necesario (conditional) |
| **Señal de salida** | `INFRA_READY: [Deployment Strategy Name]` |

---

#### 📚 @Docs (Documentation)
**Rol:** Documentación técnica

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Actualizar AGENTS.md, docs, PR body |
| **Entrada** | Resumen de todas las fases |
| **Salida** | Documentación actualizada + PR body |
| **Archivos** | AGENTS.md, /docs/architecture/*, PR description |
| **Señal de salida** | `DOCS_UPDATED: [List of files]` |

---

### Agentes de Soporte

#### 🎨 @UX (Designer)
**Rol:** UI/UX Design con Stitch

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Diseños visuales, design tokens, component mapping |
| **Herramienta** | Stitch MCP (`stitch_*`) |
| **Señal de salida** | `UX_SPEC_ESTABLISHED: [UX_Filename]` |

---

#### 🐛 @Debugger (Debug Specialist)
**Rol:** Diagnóstico de errores

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Root cause analysis, fix proposals, pattern recognition |
| **Entrada** | Error logs + stack traces + código |
| **Salida** | Diagnóstico + propuesta de fix |
| **Regla** | **Solo diagnostica** — No implementa fixes |
| **Señal de salida** | `DIAGNOSIS_COMPLETE: [Bug Summary] - Fix Proposed` |

---

#### 💡 @Ask (Advisor)
**Rol:** Asesor arquitectónico estratégico

| Aspecto | Detalle |
|---------|---------|
| **Responsabilidad** | Análisis sistémico, detección de anti-patrones |
| **Entrada** | Preguntas del usuario |
| **Salida** | Recomendaciones estratégicas |
| **Regla** | **Solo aconseja** — Guía hacia @Orch si necesita implementación |
| **Señal de salida** | `STRATEGY_ADVISED: [Resumen de la recomendación]` |

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
| **TDD Red** | Phase 4 | @Tester confirma tests creados y FALLANDO |
| **TDD Green** | Phase 5 | @Build confirma tests PASANDO |
| **SOLID Review** | Phase 6 | @CodeReview aprueba calidad de código |
| **QA Gate** | Phase 7 | @QA aprueba funcionalidad + seguridad |
| **Perf Gate** | Phase 8 | @Perf aprueba rendimiento |

### Retry Policy

Si un gate falla:

```
Gate REJECTED → @Build corrige → re-intenta gate
                 ↓
              Max 3 intentos
                 ↓
              Si persiste → ESCALAR al usuario
```

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
PHASE 0 ───────────────────────────────────────────────────────────────
  @Orch detecta: feature request → crea rama "feature/social-auth"
  @Orch busca contexto en Engram: auth patterns previos

PHASE 1 ───────────────────────────────────────────────────────────────
  @Spec define feature:
    - Login con Google OAuth2
    - Login con GitHub OAuth  
    - Botón en UI para cada provider
    - Manejo de errores (token inválido, usuario cancela)
  → Archivo: .opencode/plans/social-auth.spec.md
  → 🔒 ESPERANDO APROBACIÓN DEL USUARIO
  → Usuario: "Approved"

PHASE 2 ───────────────────────────────────────────────────────────────
  @Plan crea plan técnico:
    - Stack: Next.js + NextAuth.js
    - ERD: User, Account, Session tables
    - Security: CSRF, PKCE flow
    - TDD Strategy: Unit (services), Integration (OAuth flow), E2E (UI)
  → Archivo: .opencode/plans/social-auth-plan.md
  → 🔒 ESPERANDO APROBACIÓN DEL USUARIO
  → Usuario: "Approved"

PHASE 3 ───────────────────────────────────────────────────────────────
  @Research investiga:
    - NextAuth.js v5 API changes
    - Google OAuth2 setup requirements
    - GitHub OAuth scopes
    - PKCE implementation patterns

PHASE 4 ───────────────────────────────────────────────────────────────
  🔴 @Tester crea tests (RED):
    - Unit: GoogleProvider.getAuthorizationUrl()
    - Unit: GitHubProvider.exchangeCode()
    - Integration: OAuth callback flow
    - Edge: Token refresh after expiry
    - Edge: Invalid state parameter (CSRF)
  → Estado: TODOS FALLAN (esperado)

PHASE 5 ───────────────────────────────────────────────────────────────
  🟢 @Build implementa código (GREEN):
    - Implementa GoogleProvider class
    - Implementa GitHubProvider class  
    - Implementa OAuth callback handler
    - Implementa token refresh logic
  → Ejecuta tests → TODOS PASAN ✅

PHASE 6 ───────────────────────────────────────────────────────────────
  🔵 @CodeReview refactor:
    - Extrae lógica común a BaseOAuthProvider (SRP)
    - Inyecta ITokenService en lugar de crear tokens inline (DIP)
    - Funciones >30 líneas → divididas
  → Tests siguen pasando ✅
  → APPROVED

PHASE 7 ───────────────────────────────────────────────────────────────
  @QA + @Security:
    - Tests funcionales: 100% pass
    - OWASP check: PASS
    - npm audit: 0 vulnerabilities
  → APPROVED

PHASE 8 ───────────────────────────────────────────────────────────────
  @Perf:
    - Bundle size: +12KB (aceptable)
    - LCP: 1.2s (dentro de target)
  → APPROVED

PHASE 9 ───────────────────────────────────────────────────────────────
  @DevOps (no necesario para este feature)
  → SKIP

PHASE 10 ──────────────────────────────────────────────────────────────
  @Docs:
    - Actualiza AGENTS.md con nuevo patrón OAuth
    - Genera PR body con resumen de cambios
  → PIPELINE_COMPLETE: social-auth
```

---

## Comandos y Señales de Salida

### Señales de Salida por Agente

| Agente | Señal | Ejemplo |
|--------|-------|---------|
| @Orch | `PIPELINE_COMPLETE` | `PIPELINE_COMPLETE: social-auth` |
| @Spec | `SPEC_DEFINED` | `SPEC_DEFINED: social-auth` |
| @Plan | `PLAN_ESTABLISHED` | `PLAN_ESTABLISHED: social-auth-plan.md` |
| @Research | `RESEARCH_COMPLETE` | `RESEARCH_COMPLETE: OAuth patterns found` |
| @Tester | `TESTS_CREATED` | `TESTS_CREATED: 12 tests - State: RED` |
| @Build | `IMPLEMENTATION_COMPLETE` | `IMPLEMENTATION_COMPLETE: Tests passing` |
| @CodeReview | `CODE_REVIEW_COMPLETE` | `CODE_REVIEW_COMPLETE: APPROVED - 5 improvements` |
| @QA | `PHASE_APPROVED` / `PHASE_REJECTED` | `PHASE_APPROVED` |
| @Security | `SECURITY_SCAN_COMPLETE` | `SECURITY_SCAN_COMPLETE: PASS - 0 vulns` |
| @Perf | `PERFORMANCE_CHECK_COMPLETE` | `PERFORMANCE_CHECK_COMPLETE: PASS` |
| @DevOps | `INFRA_READY` | `INFRA_READY: docker-deploy` |
| @Docs | `DOCS_UPDATED` | `DOCS_UPDATED: AGENTS.md, PR body` |
| @Debugger | `DIAGNOSIS_COMPLETE` | `DIAGNOSIS_COMPLETE: Auth race condition` |
| @Ask | `STRATEGY_ADVISED` | `STRATEGY_ADVISED: Use event-driven` |

### Formato de Estado

```bash
[PHASE: 6/10] [CURRENT: Phase_6] [STATUS: in_progress]
[TDD: 🔵 REFACTOR]

[PHASE: 6/10] [CURRENT: Phase_6] [STATUS: waiting_approval]
[TDD: 🔵 REFACTOR]

[PHASE: 7/10] [CURRENT: Phase_7] [STATUS: complete]
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
| @QA REJECTED | Tests o seguridad fallan | @Build corrige issues específicos |
| @Perf REJECTED | Performance por debajo del target | Optimizar hot paths, lazy loading |
| Pipeline stuck en Phase 1/2 | Usuario no ha aprobado | Esperar aprobación o ajustar spec/plan |

### Límites de Retry

```
Build → CodeReview: Máximo 3 intentos
Build → QA:         Máximo 3 intentos
Build → Perf:       Máximo 3 intentos
```

Si después de 3 intentos persiste el fallo → **Escalar al usuario** con reporte detallado.

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
4. Agregar a la sección de agentes en este README
5. Actualizar el flujo de fases si aplica

---

**Última actualización:** 2026-06-04  
**Versión:** 3.0 (TDD First + Engram Memory)  
**Autor:** @alejandrocabeza
