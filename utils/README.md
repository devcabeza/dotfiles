# Utils — Utilidades de Desarrollo

```
utils/
└── lamp/
    ├── docker-compose.yml    # Stack LAMP completo
    ├── Makefile              # Comandos rápidos
    ├── phpmyadmin.ini        # Config PHPMyAdmin
    ├── pgmodeler/            # Modelos de base de datos
    └── dump_pgsql_20260110_190705.sql  # Backup PostgreSQL
```

## 🐳 Stack LAMP (Docker Compose)

Entorno de desarrollo web con Linux + Apache + MariaDB/MySQL + PHP.

### Servicios

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| **MariaDB** | `3306` | Base de datos MySQL-compatible |
| **PHPMyAdmin** | `8080` | Gestión visual de bases de datos |
| **Apache + PHP** | `80` | Servidor web con PHP |
| **Redis** | `6379` | Caché en memoria |
| **PostgreSQL** | `5432` | Base de datos alternativa |

### Comandos (Makefile)

```bash
make start       # Inicia todos los servicios
make down        # Detiene todos los servicios
make restart     # Reinicia el stack
make clear-redis # Limpia caché de Redis
make backup-pgsql               # Backup completo de PostgreSQL
make backup-pgsql-db DB=nombre  # Backup de BD específica
```

### Archivos adicionales

- **phpmyadmin.ini** — Configuración personalizada de PHPMyAdmin
- **pgmodeler/** — Modelos entidad-relación exportados desde pgModeler
- **dump_pgsql_*.sql** — Backup automatizado vía `pg_dumpall`

## 🚀 Despliegue

```bash
cd utils/lamp && docker compose up -d
```

Requiere Docker y Docker Compose instalados.
