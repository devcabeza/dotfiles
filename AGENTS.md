# AGENTS.md — dotfiles

Idioma de trabajo: **español**. Todas las respuestas y comentarios deben ser en español.

## Despliegue

La fuente de verdad es `home-manager/home.nix`. El flujo es:

1. Editar `home.nix` (paquetes en `home.packages`, links en `home.file`)
2. Ejecutar `uhm`

```bash
uhm
```

`uhm` equivale a:
```bash
home-manager switch -b backup --impure --flake ~/.dotfiles/home-manager#alejandrocabeza
```

> ⚠️ El alias real en `.bashrc` es `home-manager switch -b backup --impure` (sin `--flake`). Si falla desde otra ruta, usa la versión completa con `--flake`.

**Sin `uhm` los cambios no toman efecto.** Los dotfiles se copian/symlinkean a `~/.config/` durante el switch.

### Comandos útiles

| Comando | Propósito |
|---------|-----------|
| `uhm` | Desplegar cambios |
| `home-manager generations` | Listar snapshots anteriores |
| `home-manager switch --rollback` | Revertir a generación anterior |
| `nix flake update` | Actualizar `flake.lock` |

Los hooks de activación (`createEngramDir`, `installTpm`, `downloadPiperModel`) corren en cada `uhm`.

## Arquitectura

| Dir | Propósito | Linkeado en `home.nix` |
|-----|-----------|------------------------|
| `home-manager/` | Corazón: `home.nix` + `flake.nix` | — |
| `alacritty/` | Terminal (toml, GPU, Gruvbox) | ✅ |
| `nvim/` | Neovim (NixCats + Lua) | ✅ |
| `tmux/` | Tmux (prefix `Ctrl+t`, Gruvbox) | ✅ |
| `fish/` | Shell (Vi mode, Starship) | ✅ |
| `ranger/` | File manager (previews) | ✅ |
| `lazygit/` | Git TUI | ✅ |
| `opencode/` | Config de agentes OpenCode | ✅ en `~/.config/opencode` |

- **Gestión**: Nix + Home Manager (flake en `home-manager/`)
- **Shell**: Fish (Vi mode) → Starship (bloques sólidos Gruvbox)
- **Terminal**: Alacritty → lanza `tmux` automáticamente
- **DE**: GNOME (Wayland)
- **Tema**: Gruvbox Material oscuro (#282828 bg, #ddc7a1 fg, #7daea3 accent)

## Cómo modificar dotfiles

1. **Crear/editar** el archivo de configuración en su directorio (ej. `alacritty/alacritty.toml`)
2. **Linkearlo** en `home-manager/home.nix` bajo `home.file` (si es nuevo)
3. **Ejecutar `uhm`** para desplegar

Para **añadir un paquete**: editar `home.nix` bajo `home.packages` + `uhm`.

## Sistema de Agentes (OpenCode)

Este repo define su propio pipeline SDD de 7 fases en `opencode/`:

```
Spec → Plan → Tester (RED) → Build (GREEN) → CodeReview (REFACTOR) → QA → Docs
```

Archivos clave:
- `opencode/opencode.jsonc` — MCP servers: Engram (memoria persistente), Context7 (docs), Playwright
- `opencode/agents/` — 10 agentes (Orch, Spec, Plan, Build, CodeReview, QA, Docs, Tester, Debugger, Ask)
- `opencode/skills/` — 3 skills: `spec-driven-development`, `planning-protocol`, `context7`
- `opencode/commands/` — `commit-push`, `pull-request`

Engram DB: `~/.local/share/engram/engram.db`. Context7 requiere `CONTEXT7_API_KEY` en `opencode/.env`.

## Convenciones

1. **Idioma**: español — respuestas, comentarios, commits
2. **Rama por defecto**: `Master` (no `main`)
3. **Commits**: Conventional Commits (`feat(scripts):`, `fix(tmux):`, `docs:`, `refactor:`)
4. **Para paquete nuevo**: editar `home.nix` → `home.packages` → `uhm`
5. **Para config nuevo**: crear archivo + entry en `home.file` + `uhm`

## Notas importantes

- **nvim/AGENTS.md** está referenciado en varias partes del repo pero **no existe** — está pendiente de crear
- **Engram** se compila desde source con patch Go 1.25.10 → 1.25.0
- **PHP** tiene `memory_limit = 512M` y 10 extensiones extra para Laravel
- **Tmux** usa `Ctrl+t` como prefix (no `Ctrl+b`)
- **No hay tests automatizados** — `tests/test_qtile_omarchy.py` es un residuo de una config anterior
- **No hay CI/CD** — repo de configuración personal
