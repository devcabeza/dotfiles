{ config, pkgs, lib, ... }:

let
  # --- Configuración de PHP ---
  phpBase = pkgs.php;

  phpWithMyExtensions = phpBase.withExtensions (
    { all, enabled }: enabled ++ [
      all.imagick
      all.gd
      all.pdo_sqlite
      all.pdo_mysql
      all.pdo_pgsql
      all.intl
      all.zip
      all.bcmath
      all.sodium
      all.opcache
      all.redis
    ]
  );

  phpWithMemoryLimit = phpWithMyExtensions.passthru.buildEnv {
    extraConfig = ''
      memory_limit = 512M
    '';
  };

  composerForMyPhp = pkgs.php84Packages.composer.override {
    php = phpWithMemoryLimit;
  };

  # --- Definición de Engram con Parche de Versión ---
  engramPackage = pkgs.buildGoModule rec {
    pname = "engram";
    version = "main";

    src = pkgs.fetchFromGitHub {
      owner = "Gentleman-Programming";
      repo = "engram";
      rev = "main";
      sha256 = "sha256-HwYq6wmE3O47ZC8gWE8ZamCVim5F2KHGVJs9wVTLdXw=";
    };

    # Hack para saltar la restricción de Go 1.25.10
    postPatch = ''
      substituteInPlace go.mod --replace "go 1.25.10" "go 1.25.0"
    '';

    # Hash obtenido de tu error anterior (Verificado)
    vendorHash = "sha256-O+pC4x4DKNUWr7Sx9iZOjK6a64wrQA4/lnjvkNLBX64="; 

    subPackages = [ "." ];
  };

in
{
  # --- Configuración básica de Home Manager ---
  home.username = "alejandrocabeza";
  home.homeDirectory = "/home/alejandrocabeza";
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;

  # --- Paquetes a instalar ---
  home.packages = [
    engramPackage
    phpWithMemoryLimit
    composerForMyPhp
    pkgs.imagemagick
    pkgs.bat
    pkgs.fastfetch
    pkgs.eza
    pkgs.fzf
    pkgs.fd
    pkgs.tmux
    pkgs.lazygit
    pkgs.xclip
    pkgs.xsel
    pkgs.wl-clipboard
    pkgs.lsof
    pkgs.btop
    pkgs.fnm
    pkgs.rustup
    pkgs.sqlite
    pkgs.postgresql
    pkgs.delta
    pkgs.luarocks-nix
    pkgs.oh-my-fish
    pkgs.libgcc
    pkgs.bun
    pkgs.python313
    pkgs.gnumake42
    pkgs.libcdada
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.symbols-only

    # WiFi, Bluetooth, Notifications
    pkgs.dunst
    pkgs.blueman
    pkgs.networkmanagerapplet

    # Wallpaper daemon (Wayland)
    pkgs.swww
    pkgs.librsvg
  ];

  fonts.fontconfig.enable = true;

  # --- Gestión de archivos (Dotfiles) ---
  home.file = {
    # Core Config
    ".gitconfig".source = /home/alejandrocabeza/.dotfiles/.gitconfig;
    "utils".source = /home/alejandrocabeza/.dotfiles/utils;
    ".bashrc".source = /home/alejandrocabeza/.dotfiles/.bashrc;

    # Neovim Config
    ".config/nvim".source = /home/alejandrocabeza/.dotfiles/nvim;

    # Ghostty Config
    ".config/ghostty".source = /home/alejandrocabeza/.dotfiles/ghostty;

    # Fish Config
    ".config/fish/conf.d".source = /home/alejandrocabeza/.dotfiles/fish/conf.d;
    ".config/fish/config.fish".source = /home/alejandrocabeza/.dotfiles/fish/config.fish;
    ".config/fish/functions".source = /home/alejandrocabeza/.dotfiles/fish/functions;
    
    # Opencode Config
    ".config/opencode/opencode.jsonc".source = /home/alejandrocabeza/.dotfiles/opencode/opencode.jsonc;
    ".config/opencode/agents".source = /home/alejandrocabeza/.dotfiles/opencode/agents;

    # ".config/qtile".source = /home/alejandrocabeza/.dotfiles/qtile;
    ".config/wofi".source = /home/alejandrocabeza/.dotfiles/wofi;

    # Hyprland
    ".config/hypr".source = /home/alejandrocabeza/.dotfiles/hypr;
    ".config/waybar".source = /home/alejandrocabeza/.dotfiles/waybar;
  };

  # --- Variables de entorno ---
  home.sessionVariables = {
    EDITOR = "nvim";
    COMPOSER_HOME = "${config.home.homeDirectory}/.composer";
    GEMINI_API_KEY = "AIzaSyBHPwwVIzVjMTPsafksZrY1AIZKQpTeJwc";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    ENGRAM_DB_PATH = "/home/alejandrocabeza/.local/share/engram/engram.db";
  };

  # --- Crear directorio de base de datos ---
  home.activation = {
    createEngramDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG /home/alejandrocabeza/.local/share/engram
    '';
  };

  # --- Programas ---
  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  programs.ripgrep = { enable = true; arguments = [ "--smart-case" ]; };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color"; # Cambiado a tmux-256color para mejor soporte de colores
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.tmux-fzf
      tmuxPlugins.vim-tmux-navigator
      # Eliminamos tokyo-night-tmux porque vamos a usar Gruvbox Material
    ];
    extraConfig = ''
      # --- GRUVBOX MATERIAL COLOR SCHEME ---
      set -g status-justify "left"
      set -g status-style "bg=#282828,fg=#dfbf8e" # Fondo oscuro, texto crema

      # Pane borders
      set -g pane-border-style "fg=#504945"
      set -g pane-active-border-style "fg=#a9b665" # Verde para el panel activo

      # Status bar design
      set -g status-left-length "100"
      set -g status-right-length "100"
      set -g status-left "#[fg=#282828,bg=#a9b665,bold] #S #[fg=#a9b665,bg=#282828,nobold,nounderscore,noitalics]"
      set -g status-right "#[fg=#504945,bg=#282828,nobold,nounderscore,noitalics]#[fg=#dfbf8e,bg=#504945] %Y-%m-%d  %H:%M #[fg=#a9b665,bg=#504945,nobold,nounderscore,noitalics]#[fg=#282828,bg=#a9b665,bold] #h "

      # Window tabs
      setw -g window-status-activity-style "underscore,fg=#a89984,bg=#282828"
      setw -g window-status-separator ""
      setw -g window-status-style "fg=#dfbf8e,bg=#282828"
      setw -g window-status-format "#[fg=#282828,bg=#282828,nobold,nounderscore,noitalics]#[default] #I  #W #[fg=#282828,bg=#282828,nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#282828,bg=#45403d,nobold,nounderscore,noitalics]#[fg=#dfbf8e,bg=#45403d,bold] #I  #W #[fg=#45403d,bg=#282828,nobold,nounderscore,noitalics]"

      # --- Resto de tu configuración original ---
      unbind C-b
      set-option -g prefix C-t
      set-option -g repeat-time 0
      set-option -g focus-events on

      set-window-option -g mode-keys vi
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      
      # Usar wl-copy para Wayland (COSMIC/Pop!_OS)
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
      
      bind o run-shell "xdg-open #{pane_current_path}"
      bind -r e kill-pane -a

      # Navegación y Resizing (tus binds anteriores)
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
      bind -r C-k resize-pane -U 5
      bind -r C-j resize-pane -D 5
      bind -r C-h resize-pane -L 5
      bind -r C-l resize-pane -R 5

      set-option -g mouse on
      set-option -g history-limit 64096
      set -sg escape-time 0
      set -g status-interval 1
      set -g status-position top

      bind / split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind %
      unbind '"'
    '';
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--color=fg:#d4be98,bg:-1,hl:#e67e80"
      "--color=fg+:#d4be98,bg+:#3c3836,hl+:#e67e80"
      "--color=info:#a9b665,prompt:#7daea3,pointer:#d3869b"
      "--color=marker:#d3869b,spinner:#a9b665,header:#7daea3"
      "--height 40% --layout reverse --border"
    ];
  };

  programs.starship = {
    enable = true;
    settings = {
      # Formato de bloques sólidos sin módulos que dependan de estados complejos
      format = "[](#a89984)$username[](bg:#d8a657 fg:#a89984)$directory[](fg:#d8a657 bg:#a9b665)$git_branch$git_status[](fg:#a9b665 bg:#7daea3)$nix_shell[](fg:#7daea3 bg:#32302f)$cmd_duration[ ](fg:#32302f)$character";

      add_newline = true;
      line_break = { disabled = true; };

      # El carácter de entrada simple y elegante
      character = {
        success_symbol = "[➜](bold #a9b665)";
        error_symbol = "[➜](bold #e67e80)";
      };

      username = {
        show_always = true;
        style_user = "bg:#a89984 fg:#282828";
        format = "[$user]($style)";
      };

      directory = {
        style = "bg:#d8a657 fg:#282828";
        format = "[ $path ]($style)";
        truncation_length = 3;
        fish_style_pwd_dir_length = 1;
      };

      git_branch = {
        symbol = " ";
        style = "bg:#a9b665 fg:#282828";
        format = "[ $symbol$branch ]($style)";
      };

      git_status = {
        style = "bg:#a9b665 fg:#282828";
        format = "([$all_status$ahead_behind]($style))";
        ahead = "⇡\${count}"; 
        behind = "⇣\${count}";
      };

      nix_shell = {
        symbol = " ";
        style = "bg:#7daea3 fg:#282828";
        format = "[ $symbol]($style)";
      };

      cmd_duration = {
        style = "bg:#32302f fg:#d8a657";
        format = "[  $duration ]($style)";
      };
    };
  };
}
