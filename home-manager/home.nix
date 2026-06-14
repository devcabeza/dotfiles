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
    pkgs.lazydocker
    pkgs.lazysql
    pkgs.lazyjournal
    pkgs.lazyssh
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
    pkgs.luaPackages.luacheck
    pkgs.stylua
    pkgs.biome
    pkgs.prettierd
    pkgs.blade-formatter
    pkgs.libgcc
    pkgs.bun
    pkgs.python313
    pkgs.gnumake42
    pkgs.libcdada
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.symbols-only
    pkgs.bluetui

    # WiFi & Bluetooth
    pkgs.blueman
    pkgs.iwd
    pkgs.jq
    pkgs.networkmanagerapplet

    # Tools
    pkgs.brightnessctl
    pkgs.grim
    pkgs.slurp

    # SVG rendering
    pkgs.librsvg

    # Ranger & Previews
    pkgs.ranger
    pkgs.ueberzugpp
    pkgs.poppler-utils
    pkgs.xlsx2csv
    pkgs.glow
    pkgs.ffmpegthumbnailer
    pkgs.exiftool
    pkgs.odt2txt

    # Utilities
    pkgs.tesseract
    pkgs.ffmpeg

    # Voice Chat
    pkgs.piper-tts
    pkgs.curl
  ];

  fonts.fontconfig.enable = true;

  # --- Gestión de archivos (Dotfiles) ---
  home.file = {
    # Core Config
    ".gitconfig".source = ../.gitconfig;
    "utils".source = ../utils;
    ".bashrc".source = ../.bashrc;

    # Neovim Config
    ".config/nvim".source = ../nvim;

    # Alacritty Config
    ".config/alacritty".source = ../alacritty;

    # Fish Config
    ".config/fish/conf.d".source = ../fish/conf.d;
    ".config/fish/config.fish".source = ../fish/config.fish;
    ".config/fish/functions".source = ../fish/functions;
    
    # Opencode Config
    ".config/opencode/opencode.jsonc".source = ../opencode/opencode.jsonc;
    ".config/opencode/agents".source = ../opencode/agents;
    ".config/opencode/skills".source = ../opencode/skills;
    ".config/opencode/commands".source = ../opencode/commands;

    # Tmux Config
    ".config/tmux/tmux.conf".source = ../tmux/tmux.conf;

    #lazygit
    ".config/lazygit".source = ../lazygit;

    # Ranger Config
    ".config/ranger/rc.conf".source = ../ranger/rc.conf;
    ".config/ranger/scope.sh".source = ../ranger/scope.sh;
  };


  # --- Variables de entorno ---
  home.sessionVariables = {
    EDITOR = "nvim";
    COMPOSER_HOME = "${config.home.homeDirectory}/.composer";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    ENGRAM_DB_PATH = "/home/alejandrocabeza/.local/share/engram/engram.db";
    DOCKER_API_VERSION = "1.40";

    # Wayland environment
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
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

    downloadPiperModel = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -f "$HOME/.local/share/piper-tts/es_MX-claude-x_low.onnx" ]; then
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$HOME/.local/share/piper-tts"
        $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fL --progress-bar \
          -o "$HOME/.local/share/piper-tts/es_MX-claude-x_low.onnx" \
          "https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_MX/claude/low/es_MX-claude-x_low.onnx" \
          || true
        $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fL --progress-bar \
          -o "$HOME/.local/share/piper-tts/es_MX-claude-x_low.onnx.json" \
          "https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_MX/claude/low/es_MX-claude-x_low.onnx.json" \
          || true
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
