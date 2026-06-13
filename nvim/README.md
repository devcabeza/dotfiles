# 🐱 nixCats-nvim — Configuración de Neovim

Esta configuración de **Neovim** está construida sobre el framework [**nixCats-nvim**](https://github.com/BirdeeHub/nixCats-nvim), que combina **Nix** para la gestión reproducible de dependencias (plugins, LSPs, linters, formateadores) con **Lua** para la configuración en tiempo de ejecución.

## 🧠 ¿Por qué nixCats?

- **Reproducibilidad total**: cada plugin, LSP y herramienta externa está versionada en `flake.lock`. No hay sorpresas al clonar en otra máquina.
- **Sin Mason**: los LSPs, linters y formateadores se instalan desde Nix, no desde Mason. Esto garantiza que estén disponibles en el `PATH` del wrapper.
- **Dependencias híbridas**: Nix maneja la descarga y las rutas; Lua (vía lazy.nvim) maneja la carga y configuración.

## 🏗️ Arquitectura

```
nvim/
├── flake.nix             # 🧊 Capa Nix — paquetes, inputs, categoryDefinitions
├── flake.lock            #   Pinning de versiones
├── init.lua              # 🟢 Entry point → require("config")
├── lazy-lock.json        #   Lock de lazy.nvim (los plugins los maneja Nix)
├── lua/
│   ├── config/           #   options.lua, keymaps.lua, autocmds.lua, filetype.lua
│   ├── plugins/          #   +15 specs de plugins (lsp.lua, snacks.lua, treesitter.lua…)
│   ├── setup/            #   lsp/servers.lua, snacks/dashboard.lua
│   └── nixCatsUtils/     #   Bridge entre categorías Nix y Lua
├── ftplugin/             #   Configuraciones por tipo de archivo
└── tests/                #   Tests de configuración
```

### 🧊 Capa Nix (`flake.nix`)
- `categoryDefinitions`: agrupa paquetes por lenguaje (laravel, rust, general) o función (lspsAndRuntimeDeps, startupPlugins, optionalPlugins).
- Inputs: `nixpkgs` + repos GitHub específicos (`laravel.nvim`, `neotest-pest`, `phpactor`, etc.).

### 🟢 Capa Lua (`lua/`)
- `init.lua` → `require("nixCatsUtils").setup()` → `require("config")` → lazy.nvim carga `lua/plugins/`.
- Cada plugin usa `nixCats('category_name')` para decidir si cargarse.

## 🛠️ Stacks de desarrollo soportados

| Lenguaje / Stack | Herramientas |
|---|---|
| **PHP / Laravel** | phpactor (custom), laravel.nvim, blade-treesitter, blade-formatter, neotest-pest |
| **Lua** | lua-language-server, stylua, lazydev.nvim |
| **Nix** | nixd, nixfmt-rfc-style |
| **Rust** | rust-analyzer, cargo, rustfmt |
| **Go** | gopls, golangci-lint |
| **JavaScript / TypeScript** | typescript-language-server, tailwindcss-language-server |
| **Python** | python-lsp-server |
| **C++** | clang |

## 📦 Plugins principales

### 🧭 Navegación y búsqueda
| Plugin | Propósito |
|---|---|
| **snacks.nvim** | Picker (archivos, grep, buffers, LSP), dashboard, terminal, git, notificaciones |
| **oil.nvim** | Explorador de archivos como editor de texto |
| **which-key.nvim** | Ayuda contextual de atajos |

### ✍️ Edición
| Plugin | Propósito |
|---|---|
| **nvim-treesitter** | Resaltado sintáctico avanzado, motions por objeto sintáctico |
| **mini.pairs** | Auto-cierre de paréntesis, corchetes, comillas |
| **mini.comment** | Comentarios con `gc` |
| **conform.nvim** | Autoformateo al guardar |
| **blink.cmp** | Autocompletado |

### 🧪 LSP
| Plugin | Propósito |
|---|---|
| **nvim-lspconfig** | Configuración de servidores LSP |
| **fidget.nvim** | Notificaciones de progreso LSP |
| **neodev.nvim** | Configuración LSP para Lua |

### 🐛 Testing y Debug
| Plugin | Propósito |
|---|---|
| **nvim-dap** | Debugger (php-debug-adapter) |
| **neotest** | Test runner (PHPUnit/Pest) |

### 🎨 UI y Tema
| Plugin | Propósito |
|---|---|
| **catppuccin/nvim** | Tema mocha |
| **lualine.nvim** | Barra de estado |
| **noice.nvim** | Mejora de mensajes y cmdline |
| **dashboard** (snacks) | Pantalla de inicio |

### 🔧 Git
| Plugin | Propósito |
|---|---|
| **gitsigns** | Signos en la gutter |
| **diffview.nvim** | Vista de diffs |
| **lazygit** (snacks) | Integración con lazygit |
| **git-worktree** | Gestión de worktrees |

### ☁️ Otros
| Plugin | Propósito |
|---|---|
| **copilot.lua** | Asistente AI |
| **obsidian.nvim** | Integración con Obsidian |
| **opencode.nvim** | Agente de codificación |
| **compiler.nvim** | Ejecución de código |

## ⌨️ Referencia rápida de atajos

### Navegación general
| Atajo | Acción |
|---|---|
| `<C-s>` | Guardar |
| `<C-w>` | Cerrar ventana |
| `ss` / `sv` | Split horizontal / vertical |
| `s{h,j,k,l}` | Moverse entre ventanas |
| `<S-h>` / `<S-l>` | Buffer anterior / siguiente |
| `<leader>bd` | Eliminar buffer |
| `<F6>` | Explorador de archivos |
| `<C-/>` | Terminal toggle |
| `<leader>.` | Scratch buffer |

### Búsqueda (snacks picker)
| Atajo | Acción |
|---|---|
| `<leader>ff` | Buscar archivos + buffers (smart) |
| `<leader>fb` | Buscar buffers |
| `<leader>fg` | Grep en el proyecto |
| `<leader>fw` | Grep de la palabra bajo el cursor |
| `<leader>fh` | Buscar en help |
| `<leader>fs` | Archivos modificados (git status) |
| `<leader>fk` | Buscar keymaps |
| `<leader>fc` | Buscar comandos |
| `<leader>:` | Historial de comandos |
| `<leader>fi` | Buscar iconos (modo insert: `<C-i>`) |

### LSP
| Atajo | Acción |
|---|---|
| `gd` | Ir a definición |
| `gi` | Ir a implementaciones |
| `grr` | Ir a referencias |
| `grt` | Ir a definición de tipo |
| `gn` | Renombrar |
| `ga` / `<leader>ca` | Code action / Quick fix |
| `<leader>th` | Toggle inlay hints |

### Git
| Atajo | Acción |
|---|---|
| `<leader>gg` | Lazygit |
| `<leader>gl` | Lazygit log (cwd) |
| `<leader>gf` | Lazygit log (archivo actual) |
| `<leader>gb` | Git blame línea |
| `<leader>gB` | Git browse (abrir en GitHub) |
| `<leader>gws` | Switch worktree |
| `<leader>gwc` | Crear worktree |
| `<leader>gwd` | Eliminar worktree |

### Testing
| Atajo | Acción |
|---|---|
| `<leader>cf` | Formatear archivo (conform) |

## 📖 Fuente de verdad

Para información detallada sobre convenciones, flujo de trabajo de agentes y guías de mantenimiento, consulta [`nvim/AGENTS.md`](./AGENTS.md).

## ➕ Cómo añadir o modificar plugins

Cada plugin requiere tocar **dos capas**:

### 1. 🧊 Nix (`flake.nix`)
- Si el plugin está en **nixpkgs**: agrégalo a la lista correspondiente en `categoryDefinitions` (ej. `startupPlugins.general`).
- Si es de **GitHub**: añade el input URL y expónlo vía overlay o en `packageDefinitions`.
- Las herramientas externas (LSPs, linters) van en `lspsAndRuntimeDeps`.

### 2. 🟢 Lua (`lua/plugins/`)
- Crea o edita un archivo en `lua/plugins/` con la spec del plugin.
- Opcionalmente usa `nixCats('nombre_categoria')` para carga condicional.

> ⚠️ **No instales herramientas con Mason.** Todo debe venir de Nix.

### Despliegue

```bash
uhm   # home-manager switch, linkea ~/.config/nvim → nvim/
```

> El directorio `nvim/` se linkea desde `home.nix` con `uhm`. Los cambios no toman efecto hasta ejecutarlo.
