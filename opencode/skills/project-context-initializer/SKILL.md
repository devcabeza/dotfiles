---
name: project-context-initializer
description: "Use when starting a new project, when project context is missing, or when the user wants to initialize or update project context. Automatically scans project structure and asks the user for deployment, infrastructure, and conventions context to generate .agents/context/project.md. Invoked by @Orch or @Ask when context file doesn't exist."
license: MIT
compatibility: opencode
metadata:
  author: alejandrocabeza
  workflow: initialization
---

# Project Context Initializer

This skill generates a comprehensive project context file at `.agents/context/project.md` that gets auto-injected into every agent's system prompt. This eliminates the need for each agent to re-scan the project from scratch.

## When to Use

- First time working on a project
- When `.agents/context/project.md` doesn't exist
- When the user says "initialize context" or "setup project context" or "analiza el proyecto"
- Automatically invoked by @Orch at pipeline start if context file is missing
- Automatically invoked by @Ask when user asks about the project

## Workflow

### Phase 1: Auto-Detection

Scan the project and auto-detect:

1. **Project type**: Check for these files in order:
   - `flake.nix` → Nix project
   - `package.json` → Node/JS project (read name, scripts, dependencies)
   - `Cargo.toml` → Rust project
   - `composer.json` → PHP project
   - `Makefile` → C/C++/generic project
   - `Dockerfile` → Containerized app
   - `docker-compose.yml` → Multi-container app
   - `Gemfile` → Ruby project
   - `mix.exs` → Elixir project
   - `go.mod` → Go project
   - `setup.py`/`pyproject.toml` → Python project
   - `pom.xml`/`build.gradle` → Java project

2. **Project structure**: Scan top 2 levels of directories

3. **Existing docs**: Read `README.md`, `AGENTS.md`, `CONTRIBUTING.md`, `DESIGN.md` if they exist

4. **Git info**: Current branch, recent commits (last 5)

5. **Config files**: `.gitignore`, `.env.example`, any linter/formatter config

### Phase 2: User Interview

Ask the user these questions (only the ones that CANNOT be auto-detected):

1. "¿Dónde está desplegado este proyecto? (ej: Localhost, VPS, Vercel, Fly.io, Railway...)"
2. "¿Qué comando o proceso usas para desplegar?"
3. "¿Hay alguna convención importante que deban conocer los agentes? (idioma, estilo de commits, branching...)"
4. "¿Decisiones arquitectónicas clave que deba saber el sistema?"
5. "¿Stack específico o versiones que no se puedan auto-detectar?"
6. "¿Algún secreto o variable de entorno importante (sin revelar el valor)?"

### Phase 3: Context File Generation

Generate `.agents/context/project.md` with this exact structure:

```markdown
# Project Context

## Project Overview
- **Name:** [auto-detected]
- **Type:** [auto-detected]
- **Description:** [from README or user]
- **Language:** [auto-detected]

## Stack
- **Runtime:** [Node/Rust/Python/etc]
- **Frameworks:** [auto-detected from dependencies]
- **Database:** [auto-detected or user-provided]
- **Package Manager:** [npm/cargo/nix/etc]

## Structure
[tree-like structure of the project, top 2-3 levels]

## Deployment
- **Target:** [user-provided]
- **Command:** [user-provided]

## Conventions
[from AGENTS.md or user-provided]

## Key Decisions
[user-provided architectural decisions]

## Last Updated
[timestamp]
```

IMPORTANT: Save this file to `.agents/context/project.md`. The directory `.agents/context/` should be created if it doesn't exist.

### Phase 4: Confirmation

Tell the user the context file was created and that all agents will now have this context automatically.

---

## Context File Maintenance

The skill can also be invoked with the `update` action to refresh the context file. When updating, it should:
1. Re-scan the project structure
2. Keep user-provided answers from the previous file (unless the user wants to change them)
3. Ask only about new things that changed
