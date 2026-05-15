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

    # Kitty Config
    ".config/kitty".source = /home/alejandrocabeza/.dotfiles/kitty;

    # Ghostty Config
    ".config/ghostty".source = /home/alejandrocabeza/.dotfiles/ghostty;

    # Fish Config
    ".config/fish/conf.d".source = /home/alejandrocabeza/.dotfiles/fish/conf.d;
    ".config/fish/config.fish".source = /home/alejandrocabeza/.dotfiles/fish/config.fish;
    ".config/fish/functions".source = /home/alejandrocabeza/.dotfiles/fish/functions;
    
    # Opencode Config
    ".config/opencode/opencode.jsonc".source = /home/alejandrocabeza/.dotfiles/opencode/opencode.jsonc;
    ".config/opencode/agents".source = /home/alejandrocabeza/.dotfiles/opencode/agents;

    # Zed Config
    ".config/zed/settings.json".source = /home/alejandrocabeza/.dotfiles/zed/settings.json;
    ".config/zed/keymap.json".source = /home/alejandrocabeza/.dotfiles/zed/keymap.json;
    ".config/zed/tasks.json".source = /home/alejandrocabeza/.dotfiles/zed/tasks.json;

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
    terminal = "tmux-256color";
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.tmux-fzf
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''
      unbind C-b
      set-option -g prefix C-t
      set-option -g repeat-time 0
      set-option -g focus-events on
      set-window-option -g mode-keys vi
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
      bind o run-shell "xdg-open #{pane_current_path}"
      bind -r e kill-pane -a
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
      set-option -g mouse on
      set-option -g history-limit 64096
      set -sg escape-time 0
      set -g status-interval 1
      set -g status-position top
      bind / split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Estilo Gruvbox Material
      set -g status-justify "left"
      set -g status-style "bg=#282828,fg=#dfbf8e"
      set -g pane-border-style "fg=#504945"
      set -g pane-active-border-style "fg=#a9b665"
      set -g status-left "#[fg=#282828,bg=#a9b665,bold] #S #[fg=#a9b665,bg=#282828,nobold]"
      set -g status-right "#[fg=#504945,bg=#282828]#[fg=#dfbf8e,bg=#504945] %Y-%m-%d  %H:%M #[fg=#a9b665,bg=#504945]#[fg=#282828,bg=#a9b665,bold] #h "
    '';
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [ "--height 40% --layout reverse --border" ];
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "[](#a89984)$username[](bg:#d8a657 fg:#a89984)$directory[](fg:#d8a657 bg:#a9b665)$git_branch$git_status[](fg:#a9b665 bg:#7daea3)$nix_shell[](fg:#7daea3 bg:#32302f)$cmd_duration[ ](fg:#32302f)$character";
      username = { show_always = true; style_user = "bg:#a89984 fg:#282828"; format = "[$user]($style)"; };
      directory = { style = "bg:#d8a657 fg:#282828"; format = "[ $path ]($style)"; truncation_length = 3; };
      git_branch = { symbol = " "; style = "bg:#a9b665 fg:#282828"; format = "[ $symbol$branch ]($style)"; };
    };
  };
}
