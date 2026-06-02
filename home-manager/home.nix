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
    pkgs.luaPackages.luacheck
    pkgs.stylua
    pkgs.biome
    pkgs.prettierd
    pkgs.blade-formatter
    pkgs.oh-my-fish
    pkgs.libgcc
    pkgs.bun
    pkgs.python313
    pkgs.gnumake42
    pkgs.libcdada
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.symbols-only
    pkgs.bluetui

    # WiFi, Bluetooth, Notifications
    pkgs.dunst
    pkgs.blueman
    pkgs.impala
    pkgs.iwd
    pkgs.jq
    pkgs.networkmanagerapplet
    pkgs.walker

    # Tools
    pkgs.brightnessctl
    pkgs.grim
    pkgs.slurp

    # Wallpaper daemon (Wayland)
    pkgs.swaybg
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

    # Alacritty Config
    ".config/alacritty".source = /home/alejandrocabeza/.dotfiles/alacritty;

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

    # Tmux Config (link only tmux.conf, not the whole directory — plugins/ needs to be writable for tpm)
    ".config/tmux/tmux.conf".source = /home/alejandrocabeza/.dotfiles/tmux/tmux.conf;

    # Zellij
    ".config/zellij".source = /home/alejandrocabeza/.dotfiles/zellij;

    #lazygit
    ".config/lazygit".source = /home/alejandrocabeza/.dotfiles/lazygit;
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

    installTpm = lib.hm.dag.entryAfter ["linkGeneration"] ''
      mkdir -p "$HOME/.config/tmux/plugins"
      if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
        $DRY_RUN_CMD /usr/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
      fi
    '';
  };

  # --- Programas ---
  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  programs.ripgrep = { enable = true; arguments = [ "--smart-case" ]; };

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
