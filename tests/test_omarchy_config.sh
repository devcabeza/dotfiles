#!/usr/bin/env bash
# ==============================================================================
# test_omarchy_config.sh — RED phase test for dotfiles/Hyprland config
#
# Validates that all expected config files exist, parse correctly, and that
# symlinks are properly set up. Designed to FAIL on current (pre-config) state.
# ==============================================================================

set -euo pipefail

# -------------------------------------------------------------------
# Counters
# -------------------------------------------------------------------
PASSED=0
FAILED=0
TOTAL=0

# -------------------------------------------------------------------
# Helpers
# -------------------------------------------------------------------
pass() {
    local label="$1"
    echo "  ✅ ${label}"
    PASSED=$((PASSED + 1))
}

fail() {
    local label="$1"
    local detail="${2:-}"
    if [[ -n "$detail" ]]; then
        echo "  ❌ ${label} — ${detail}"
    else
        echo "  ❌ ${label}"
    fi
    FAILED=$((FAILED + 1))
}

check_exe() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        echo "  ⚠️  Required tool '${cmd}' not found — skipping relevant checks"
        return 1
    fi
    return 0
}

# -------------------------------------------------------------------
# Section header
# -------------------------------------------------------------------
section() {
    local title="$1"
    echo ""
    echo "--- ${title} ---"
}

# -------------------------------------------------------------------
# 1. Hyprland Lua files exist and parse correctly
# -------------------------------------------------------------------
check_lua_file() {
    local file="$1"
    local label="$2"
    TOTAL=$((TOTAL + 1))
    if [[ ! -f "$file" ]]; then
        fail "$label" "file not found: $file"
        return
    fi
    if ! check_exe "luac"; then
        pass "$label (file exists, skipped syntax check)"
        return
    fi
    if luac -p "$file" 2>/dev/null; then
        pass "$label"
    else
        fail "$label" "Lua syntax error in $file"
    fi
}

section "1. Hyprland Lua files"

check_lua_file "$HOME/.config/hypr/hyprland.lua"       "hyprland.lua"
check_lua_file "$HOME/.config/hypr/lua/monitors.lua"     "lua/monitors.lua"
check_lua_file "$HOME/.config/hypr/lua/programs.lua"     "lua/programs.lua"
check_lua_file "$HOME/.config/hypr/lua/env.lua"          "lua/env.lua"
check_lua_file "$HOME/.config/hypr/lua/look.lua"         "lua/look.lua"
check_lua_file "$HOME/.config/hypr/lua/misc.lua"         "lua/misc.lua"
check_lua_file "$HOME/.config/hypr/lua/input.lua"        "lua/input.lua"
check_lua_file "$HOME/.config/hypr/lua/keybinds.lua"     "lua/keybinds.lua"
check_lua_file "$HOME/.config/hypr/lua/windowRules.lua"  "lua/windowRules.lua"
check_lua_file "$HOME/.config/hypr/lua/autostart.lua"    "lua/autostart.lua"
check_lua_file "$HOME/.config/hypr/lua/theme.lua"        "lua/theme.lua"

# -------------------------------------------------------------------
# 2. Waybar files exist and are valid
# -------------------------------------------------------------------
section "2. Waybar"

check_waybar_config() {
    local file="$1"
    local label="$2"
    TOTAL=$((TOTAL + 1))
    if [[ ! -f "$file" ]]; then
        fail "$label" "file not found: $file"
        return
    fi
    if check_exe "jq"; then
        if jq empty "$file" 2>/dev/null; then
            pass "$label"
        else
            fail "$label" "invalid JSON in $file"
        fi
    else
        pass "$label (file exists, skipped JSON validation)"
    fi
}

check_waybar_config "$HOME/.config/waybar/config.jsonc" "waybar/config.jsonc (valid JSON)"

check_css_file() {
    local file="$1"
    local label="$2"
    TOTAL=$((TOTAL + 1))
    if [[ -f "$file" ]]; then
        pass "$label"
    else
        fail "$label" "file not found: $file"
    fi
}

check_css_file "$HOME/.config/waybar/style.css" "waybar/style.css"

# -------------------------------------------------------------------
# 3. Walker config exists and is valid TOML
# -------------------------------------------------------------------
section "3. Walker"

check_toml_file() {
    local file="$1"
    local label="$2"
    TOTAL=$((TOTAL + 1))
    if [[ ! -f "$file" ]]; then
        fail "$label" "file not found: $file"
        return
    fi
    if check_exe "python3"; then
        if python3 -c "
import sys, tomllib
try:
    with open('$file', 'rb') as f:
        tomllib.load(f)
    sys.exit(0)
except Exception as e:
    print(e)
    sys.exit(1)
" 2>/dev/null; then
            pass "$label"
        else
            fail "$label" "invalid TOML in $file"
        fi
    else
        pass "$label (file exists, skipped TOML validation)"
    fi
}

check_toml_file "$HOME/.config/walker/config.toml" "walker/config.toml"

# -------------------------------------------------------------------
# 4. Mako config exists
# -------------------------------------------------------------------
section "4. Mako"

check_config_file() {
    local file="$1"
    local label="$2"
    TOTAL=$((TOTAL + 1))
    if [[ -f "$file" ]]; then
        pass "$label"
    else
        fail "$label" "file not found: $file"
    fi
}

check_config_file "$HOME/.config/mako/config" "mako/config"

# -------------------------------------------------------------------
# 5. Hyprlock / Hypridle exist
# -------------------------------------------------------------------
section "5. Hyprlock / Hypridle"

check_config_file "$HOME/.config/hypr/hypridle.conf" "hypr/hypridle.conf"
check_config_file "$HOME/.config/hypr/hyprlock.conf"  "hypr/hyprlock.conf"

# -------------------------------------------------------------------
# 6. Scripts exist and are executable
# -------------------------------------------------------------------
section "6. Scripts"

check_script() {
    local file="$1"
    local label="$2"
    TOTAL=$((TOTAL + 1))
    if [[ ! -f "$file" ]]; then
        fail "$label" "file not found: $file"
        return
    fi
    if [[ ! -x "$file" ]]; then
        fail "$label" "not executable: $file"
        return
    fi
    pass "$label"
}

SCRIPT_DIR="/home/alejandrocabeza/.dotfiles/scripts"
check_script "$SCRIPT_DIR/screenshot.sh"       "scripts/screenshot.sh"
check_script "$SCRIPT_DIR/wallpaper-rotate.sh" "scripts/wallpaper-rotate.sh"

# -------------------------------------------------------------------
# 7. Theme directories exist
# -------------------------------------------------------------------
section "7. Theme directories"

check_theme_dir() {
    local dir="$1"
    local label="$2"
    TOTAL=$((TOTAL + 1))
    if [[ -d "$dir" ]]; then
        pass "$label"
    else
        fail "$label" "directory not found: $dir"
    fi
}

HYPR_THEMES="$HOME/.config/hypr/themes"
check_theme_dir "$HYPR_THEMES/gruvbox/"     "themes/gruvbox/"
check_theme_dir "$HYPR_THEMES/catppuccin/"  "themes/catppuccin/"
check_theme_dir "$HYPR_THEMES/tokyo-night/" "themes/tokyo-night/"
check_theme_dir "$HYPR_THEMES/kanagawa/"    "themes/kanagawa/"
check_theme_dir "$HYPR_THEMES/nord/"        "themes/nord/"
check_theme_dir "$HYPR_THEMES/rose-pine/"   "themes/rose-pine/"

# -------------------------------------------------------------------
# 8. Theme files exist for Gruvbox
# -------------------------------------------------------------------
section "8. Gruvbox theme files"

check_config_file "$HYPR_THEMES/gruvbox/colors.conf" "themes/gruvbox/colors.conf"
check_config_file "$HYPR_THEMES/gruvbox/waybar.css"   "themes/gruvbox/waybar.css"

# -------------------------------------------------------------------
# 9. Symlink checks
# -------------------------------------------------------------------
section "9. Symlinks"

check_symlink() {
    local path="$1"
    local expected_target="$2"
    local label="$3"
    TOTAL=$((TOTAL + 1))
    if [[ ! -L "$path" ]]; then
        fail "$label" "not a symlink: $path"
        return
    fi
    local actual
    actual="$(readlink -f "$path")"
    local expected_resolved
    expected_resolved="$(readlink -f "$expected_target")"
    if [[ "$actual" == "$expected_resolved" ]]; then
        pass "$label"
    else
        fail "$label" "symlink target mismatch: expected ${expected_resolved}, got ${actual}"
    fi
}

DOTFILES="/home/alejandrocabeza/.dotfiles"
check_symlink "$HOME/.config/hypr"   "$DOTFILES/hypr"   "~/.config/hypr → dotfiles/hypr"
check_symlink "$HOME/.config/waybar" "$DOTFILES/waybar"  "~/.config/waybar → dotfiles/waybar"
check_symlink "$HOME/.config/walker" "$DOTFILES/walker"  "~/.config/walker → dotfiles/walker"
check_symlink "$HOME/.config/mako"   "$DOTFILES/mako"    "~/.config/mako → dotfiles/mako"

# -------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------
echo ""
echo "========================================"
echo "  Results: ${PASSED} passed, ${FAILED} failed out of ${TOTAL}"
echo "========================================"

if [[ "$FAILED" -gt 0 ]]; then
    exit 1
fi
exit 0
