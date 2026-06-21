# Noctalia FZF colors - generated automatically
# Do not edit manually

# Fondo y texto
set -gx FZF_DEFAULT_OPTS "--color=fg:{{colors.on_surface.default.hex}},bg:{{colors.surface.default.hex}},hl:{{colors.error.default.hex}}"
set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --color=fg+:{{colors.on_surface.default.hex}},bg+:{{colors.surface_container_high.default.hex}},hl+:{{colors.error.default.hex}}"
set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --color=info:{{colors.secondary.default.hex}},prompt:{{colors.primary.default.hex}},pointer:{{colors.primary_fixed_dim.default.hex}}"
set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --color=marker:{{colors.primary_fixed_dim.default.hex}},spinner:{{colors.secondary.default.hex}},header:{{colors.primary.default.hex}}"
set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --height 40% --layout reverse --border"
