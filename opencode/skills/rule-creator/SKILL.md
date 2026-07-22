---
name: rule-creator
description: >
  Skill para crear, modificar y validar reglas en `.agents/rules/`.
  Úsala SIEMPRE que un agente necesite documentar una constraint
  arquitectónica, un patrón de código, una convención del proyecto,
  o una policy que los agentes deben seguir. También cuando se
  detecte que falta una regla, cuando un agente pregunte "¿debería
  crear una regla para esto?", o cuando se quiera refactorizar una
  regla existente que no sigue la plantilla estándar.
  NO usar para documentación general del proyecto (eso va en
  README.md, AGENTS.md o .agents/context/).
---

# Rule Creator

Esta skill define el **formato estándar** y el **proceso de creación**
para todas las reglas dentro de `.agents/rules/`. Una regla mal
estructurada es una regla que los agentes no seguirán.

## 📐 La Plantilla Obligatoria

Toda regla en `.agents/rules/<name>.md` DEBE seguir esta estructura,
en este orden:

```markdown
# [Título Claro y Accionable]

## Scope
_¿A quién aplica esta regla? ¿En qué contexto?_

> Aplica a: [todos los agentes | agentes Build | código cliente | etc.]
> Tags: `[keyword1, keyword2]`

## When to Use
_Descripción explícita de cuándo un agente debe aplicar esta regla._

- ✅ Usar cuando...
- ✅ Usar cuando...
- ❌ NO usar cuando...

## Core Rule
_La regla en sí. Una o dos frases máximas. Directa, imperativa, sin ambigüedad._

> **Regla**: [texto claro de la regla]

## ✅ Correcto / ❌ Incorrecto

### Ejemplo 1: [nombre descriptivo]

✅ **Bien:**
```[lenguaje]
// código correcto
```

❌ **Mal:**
```[lenguaje]
// código incorrecto
```

**Por qué**: [explicación breve de por qué el primero está bien y el segundo mal]

### Ejemplo 2: [nombre descriptivo]
...

## Rationale
_¿Por qué existe esta regla? ¿Qué problema resuelve? ¿Qué pasa si no se sigue?_

- [razón 1]
- [razón 2]

## Exceptions
_Cuándo está permitido romper esta regla (y con la aprobación de quién)._

- ✅ [excepción válida]
- ❌ [esto NO es excusa para romper la regla]
- **Aprobación requerida**: [quién debe autorizar]

## Related Rules
- [enlace a otra regla](.agents/rules/otra-regla.md) — [relación breve]
```

> ⚠️ **Regla de oro**: Si una sección no aplica, pon "N/A" explícitamente.
> No elimines la sección — la consistencia estructural es parte de la regla.

---

## 🧩 Proceso de Creación

### Paso 1: Detectar la necesidad

Una regla es necesaria cuando:

- Un agente comete el mismo error dos veces → documentar como regla
- Hay una decisión arquitectónica recurrente → codificarla como regla
- El AGENTS.md o README.md menciona una constraint que no tiene regla propia
- Un code review identifica un patrón que debe evitarse
- Pregúntate: **"¿Esto aplica en múltiples contextos?"** Si sí, es regla. Si es de una sola vez, es comentario.

### Paso 2: Redactar usando la plantilla

1. **Elige un nombre corto y descriptivo** (ej: `module-pattern.md`, no `reglas-para-crear-modulos-en-el-proyecto-v2.md`)
2. **Rellena cada sección en orden**
3. **Escribe al menos 2 ejemplos** (✅/❌) por regla
4. **Añade la regla al final del `AGENTS.md`** si aplica como recordatorio

### Paso 3: Auto-validación

Antes de dar la regla por terminada, ejecuta este checklist:

```markdown
- [ ] ¿El título es accionable? ("Module Creation Rule" ✓ vs "Modules" ✗)
- [ ] ¿Tiene sección Scope?
- [ ] ¿Tiene sección When to Use con casos ✅ y ❌?
- [ ] ¿Tiene al menos 2 ejemplos con código correcto E incorrecto?
- [ ] ¿Cada ejemplo incluye "Por qué"?
- [ ] ¿Tiene Rationale?
- [ ] ¿Tiene Exceptions?
- [ ] ¿La regla cabe en una o dos frases en Core Rule?
- [ ] ¿El archivo está en `.agents/rules/`?
- [ ] ¿El nombre del archivo usa kebab-case?
```

### Paso 4: Registrar

Si la regla es lo suficientemente importante, menciónala en el `AGENTS.md`
del proyecto en una sección de referencias a reglas.

---

## 🧠 Guía de Estilo

### Lo que hace una buena regla

| Característica | Ejemplo bueno | Ejemplo malo |
|---|---|---|
| **Accionable** | "Usar `BaseService` para toda lógica de negocio" | "Los servicios son importantes" |
| **Específica** | "Importar desde `@/framework/auth/client` en client components" | "Usar los imports correctos" |
| **Con ejemplos** | Código ✅ y ❌ lado a lado | "Sigue las mejores prácticas" |
| **Con por qué** | "Porque si se importa en server, rompe el bundle" | "Porque es mejor así" |
| **Con excepciones** | "Solo con aprobación del arquitecto" | — |

### Lo que NO es una regla

- ❌ Documentación de una API externa (eso va en comentarios o README)
- ❌ Tutoriales o guías paso a paso (eso va en `.agents/context/` o docs/)
- ❌ Decisiones de una sola vez (una regla debe ser reutilizable)
- ❌ Código de ejemplo sin contexto (no digas qué está bien y qué mal)

---

## 📋 Ejemplo de Regla Bien Hecha

> Ver `auth-rules.md` en el proyecto — es un buen ejemplo de regla
> existente que sigue aproximadamente esta estructura.

## 📋 Ejemplo de Regla Mal Hecha

```markdown
# Import Rules

## Reglas
- No importar cosas del framework
- Usar los paths correctos
```

**Problemas**: No tiene ejemplos, no dice cuándo aplicar,
no tiene rationale, no tiene excepciones, el título no es accionable.

---

## 🔄 Mantenimiento

Las reglas deben revisarse cuando:

- Cambia la arquitectura del proyecto
- Se actualiza una dependencia principal (Next.js, shadcn, etc.)
- Un agente encuentra un edge case que la regla no contempla
- Se acumulan 3+ excepciones a la regla → la regla está mal diseñada

**ADVICE_RENDERED**
