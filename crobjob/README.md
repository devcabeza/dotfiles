# Crobjob — Backup con rclone

```
crobjob/
└── backup.sh
```

## 💾 backup.sh

```bash
#!/bin/bash
rclone bisync $HOME/Documentos/Alejandro\ Cabeza/ gdrive:Alejandro\ Cabeza/ \
  --progress --resilient --recover --verbose
```

### 🔍 Detalle

| Opción | Explicación |
|--------|-------------|
| `bisync` | Sincronización **bidireccional** — cambios en local o en Google Drive se fusionan |
| `--progress` | Muestra progreso durante la sincronización |
| `--resilient` | Maneja errores transitorios sin abortar |
| `--recover` | Recupera de estados de fallo previos automáticamente |
| `--verbose` | Salida detallada para depuración |

Sincroniza `~/Documentos/Alejandro Cabeza/` con la carpeta homónima en Google Drive (`gdrive:`).

### 📅 Programación

Añadir al crontab del usuario:

```bash
crontab -e
# Ejemplo: ejecutar cada día a las 2 AM
0 2 * * * ~/.dotfiles/crobjob/backup.sh
```

## 🚀 Despliegue

Manual — el script ya existe en el repo. Programar con `crontab -e`.
