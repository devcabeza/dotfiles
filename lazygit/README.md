# Lazygit — TUI para Git

```
lazygit/
└── config.yml
```

## 🧑‍💻 ¿Qué es Lazygit?

[Lazygit](https://github.com/jesseduffield/lazygit) es una interfaz de terminal para Git que permite gestionar repositorios con atajos de teclado intuitivos. Simplifica staging, commits, branches, rebase y más.

## ⚙️ config.yml

```yaml
gui:
  mouseEvents: false
  showCommandLog: true
  showFileIcons: true
  theme:
    activeBorderColor: ['#50fa7b']
    inactiveBorderColor: ['#6272a4']
git:
  autoFetch: true
  skipHookPrefix: WIP
os:
  editPreset: 'nvim'
  edit: "nvim --server $NVIM --remote-tab {{filename}}"
```

### 🔍 Detalle

| Opción | Explicación |
|--------|-------------|
| `mouseEvents: false` | Deshabilita clicks del mouse — 100% teclado |
| `showCommandLog` | Muestra comandos git ejecutados |
| `showFileIcons` | Iconos de archivo (requiere Nerd Font) |
| `activeBorderColor: #50fa7b` | Borde verde tipo Dracula para panel activo |
| `inactiveBorderColor: #6272a4` | Borde gris-azul para paneles inactivos |
| `autoFetch: true` | Fetch automático periódico |
| `skipHookPrefix: WIP` | Salta git hooks en commits que empiezan con "WIP" |
| `editPreset: 'nvim'` / `edit` | Abre archivos en Neovim vía `--remote-tab` (integración con sesión existente) |

### 🔗 Integración

- **Tmux**: acceso rápido con `prefix + g`
- **Hyprland**: no tiene atajo directo — se accede desde un tmux popup
- **Neovim**: editar archivos abre en la sesión activa de Neovim

## 🚀 Despliegue

Linkeado vía `home-manager/home.nix` → `home.file`. Ejecutar `uhm` para aplicar.
