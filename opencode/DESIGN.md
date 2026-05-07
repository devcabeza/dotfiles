# DESIGN.md
## Sistema de Diseño del Proyecto

Este archivo es la **fuente de verdad visual** para todo el proyecto. @UX debe consultarlo antes de generar cualquier especificación.

---

## 1. Design System Base

### Paleta de Colores
| Token | Valor | Uso |
|-------|-------|-----|
| `primary` | `#3B82F6` | Botones principales, links |
| `secondary` | `#6B7280` | Texto secundario |
| `surface` | `#FFFFFF` | Fondos de tarjetas |
| `background` | `#F9FAFB` | Fondo de página |
| `error` | `#EF4444` | Estados de error |
| `success` | `#10B981` | Estados de éxito |

### Tipografía
| Token | Font | Size | Weight |
|-------|------|------|--------|
| `heading-1` | Inter | 32px | 700 |
| `heading-2` | Inter | 24px | 600 |
| `heading-3` | Inter | 20px | 600 |
| `body` | Inter | 16px | 400 |
| `caption` | Inter | 14px | 400 |

### Espaciado (Tailwind)
| Token | Valor |
|-------|-------|
| `space-1` | 4px |
| `space-2` | 8px |
| `space-3` | 12px |
| `space-4` | 16px |
| `space-6` | 24px |
| `space-8` | 32px |

### Border Radius
| Token | Valor |
|-------|-------|
| `rounded-sm` | 4px |
| `rounded-md` | 8px |
| `rounded-lg` | 12px |
| `rounded-full` | 9999px |

---

## 2. Componentes Base

### Button
- Primary: `bg-primary text-white rounded-md px-4 py-2 hover:bg-primary/90`
- Secondary: `bg-gray-100 text-gray-700 rounded-md px-4 py-2 hover:bg-gray-200`
- Ghost: `text-gray-600 hover:text-gray-900`

### Card
- Container: `bg-surface rounded-lg shadow-sm border border-gray-100 p-6`
- Hover: `hover:shadow-md transition-shadow`

### Input
- Default: `border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-primary focus:border-transparent`
- Error: `border-error focus:ring-error`

### Table (PowerGrid)
- Header: `bg-gray-50 text-left text-sm font-semibold text-gray-700`
- Row: `border-b border-gray-100 hover:bg-gray-50`
- Cell: `px-6 py-4 text-sm`

---

## 3. Layout Patterns

### Dashboard Layout
- Sidebar: `w-64 fixed left-0 top-0 h-screen bg-surface border-r`
- Main Content: `ml-64 p-8`

### Form Layout
- Label: `block text-sm font-medium text-gray-700 mb-1`
- Input Group: `space-y-4 max-w-md`

### Grid System
- Container: `max-w-7xl mx-auto px-4`
- Grid: `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6`

---

## 4. Reglas de Uso

1. **PROHIBIDO** usar valores fuera de esta especificación
2. **PROHIBIDO** crear nuevos colores sin actualizar este archivo
3. **OBLIGATORIO** referenciar tokens de este archivo en los UX Specs
4. **OBLIGATORIO** verificar adherencia antes de generar spec

---

## 5. Actualización

Para actualizar el Design System:
1. Modificar los valores en este archivo
2. Ejecutar `npm run sync-design-tokens` (si existe)
3. Notificar a @Build del cambio