# Nix — Configuración Global

```
nix/
└── nix.conf
```

## ⚙️ nix.conf

```ini
experimental-features = nix-command flakes
max-jobs = auto
```

### 🔍 Detalle

| Opción | Explicación |
|--------|-------------|
| `experimental-features = nix-command flakes` | Habilita el comando `nix` moderno y el sistema de flakes — **requerido** para que funcione `home-manager switch --flake` |
| `max-jobs = auto` | Usa todos los cores disponibles para builds paralelas |

### 📍 Ubicación

Este archivo va en **`/etc/nix/nix.conf`** — es configuración del sistema, no del usuario.

## 🚀 Despliegue

**No se despliega vía home-manager.** Copiar manualmente:

```bash
sudo cp nix/nix.conf /etc/nix/nix.conf
```

O al editar, se puede poner en `~/.config/nix/nix.conf` para configuración por usuario (aplica solo a `nix` commands del usuario).
