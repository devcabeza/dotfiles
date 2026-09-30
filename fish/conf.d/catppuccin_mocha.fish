# Catppuccin Mocha Syntax & Pager Theme for Fish
set -l foreground cdd6f4
set -l selection 313244
set -l comment 6c7086
set -l red f38ba8
set -l orange fab387
set -l yellow f9e2af
set -l green a6e3a1
set -l purple cba6f7
set -l cyan 89dceb
set -l pink f5c2e7

# Resaltado de Sintaxis
set -g fish_color_normal $foreground
set -g fish_color_command $green
set -g fish_color_keyword $purple
set -g fish_color_quote $yellow
set -g fish_color_redirection $pink
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $foreground
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment
set -g fish_color_cancel $red

# Prompt Base
set -g fish_color_cwd $cyan
set -g fish_color_user $purple
set -g fish_color_host $green
set -g fish_color_host_remote $green
set -g fish_color_status $red

# Pager de Autocompletado
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $pink
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection
