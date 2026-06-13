# 🐟 Fish Shell — Configuración

[Fish](https://fishshell.com/) es un *shell* moderno con **autosugerencias**, **syntax highlighting** nativo y un sistema de **completado** inteligente, todo *out of the box* sin necesidad de frameworks externos.

## ¿Por qué Fish?

| Aspecto | Fish | bash/zsh |
|---------|------|----------|
| Autosugerencias | ✅ nativas | ❌ requieren plugin (zsh-autosuggestions) |
| Syntax highlighting | ✅ nativo | ❌ plugin externo |
| Configuración web | ✅ `fish_config` | ❌ no existe |
| Scripting | ✅ legible, sin `$()` loco | ❌ POSIX legacy |

## 🎯 Modo Vi

`fish_vi_key_bindings` activa navegación modal consistente con Neovim y tmux:

- **Normal** → cursor block
- **Insert** → cursor line
- **Replace** → cursor underscore

Esto permite `j`/`k`/`/`/`v`/`y`/`d`/`p` en el propio shell. El retraso entre modos se minimizó con `fish_sequence_key_delay_ms 10`.

## 🪐 Integración con Warp Terminal

El `config.fish` detecta Warp mediante `$TERM_PROGRAM` y **desactiva** `fastfetch` y `starship init` para evitar conflictos visuales con los componentes nativos de Warp.

## 🔧 Alias principales

| Alias | Comando | Descripción |
|-------|---------|-------------|
| `ll` | `exa -l -g --icons` | Listado largo con iconos |
| `lla` | `ll -a` | Incluye ocultos |
| `tree` | `exa --tree --level=2 --icons` | Árbol de directorios |
| `vim` | `nvim` | Neovim como editor por defecto |
| `g` | `git` | Atajo rápido para git |
| `cat` | `bat` | `cat` con syntax highlighting |

## 📦 Gestión de Node con fnm

`fnm env --use-on-cd | source` carga la versión de Node correcta automáticamente al entrar a un proyecto (detecta `.node-version` o `.nvmrc`).

## ✨ Starship prompt

Prompt minimalista con **bloques sólidos segmentados** (user, dir, git, Node, Rust, Python, elapsed time). Solo se activa fuera de Warp.

## 🔍 Funciones FZF

`functions/` contiene utilidades navegables con **FZF**:

| Atajo | Función | Acción |
|-------|---------|--------|
| `Ctrl+R` | `fzf_history` | Buscar y pegar comando del historial |
| `Ctrl+F` | `fzf_change_directory` | Navegar y cambiar directorio |
| `Ctrl+O` | `fzf_edit_file` | Buscar archivo y abrirlo en Neovim |
| `Ctrl+K` | `fzf_kill_process` | Buscar y matar procesos |
| `Ctrl+B` | `fzf_git_branch` | Cambiar rama git |
| `Ctrl+L` | `fzf_git_log` | Navegar el log de git |

Los bindings funcionan en **todos los modos Vi** (normal, insert, visual, replace).

## 🚀 Despliegue

Enlazado vía `home-manager/home.nix` con 3 entradas `home.file`:

```nix
".config/fish/config.fish".source = ../fish/config.fish;
".config/fish/functions".source = ../fish/functions;
".config/fish/conf.d".source = ../fish/conf.d;
```

## 📁 Estructura

```
fish/
├── config.fish       # Config principal (55 líneas)
├── conf.d/tide.fish  # Tide prompt config (legacy)
└── functions/        # FZF functions + key bindings
    ├── fish_user_key_bindings.fish
    ├── fzf_change_directory.fish
    ├── fzf_edit_file.fish
    ├── fzf_git_branch.fish
    ├── fzf_git_log.fish
    ├── fzf_history.fish
    └── fzf_kill_process.fish
```

Después de modificar, ejecutar `uhm` (`home-manager switch`) para aplicar los cambios.
