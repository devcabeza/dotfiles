{
  config,
  pkgs,
  lib,
  ...
}:

let
  # --- Configuración de PHP ---
  phpBase = pkgs.php;

  phpWithMyExtensions = phpBase.withExtensions (
    { all, enabled }:
    enabled
    ++ [
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
      sha256 = "sha256-zsly4YyziaOdVqeV+wdRbIXUeQN9iz1Z9D4OMfGWBa4=";
    };

    # Hack para saltar la restricción de Go 1.25.10
    postPatch = ''
      substituteInPlace go.mod --replace "go 1.25.10" "go 1.25.0"
    '';

    # Hash obtenido de tu error anterior (Verificado)
    vendorHash = "sha256-O+pC4x4DKNUWr7Sx9iZOjK6a64wrQA4/lnjvkNLBX64=";

    subPackages = [ "cmd/engram" ];

    # Los tests requieren git y red; se deshabilitan en el sandbox de Nix
    doCheck = false;
  };

  # --- PHP Debug Adapter (inlineado porque Nix no copia archivos sueltos al store) ---
  phpDebugAdapter = pkgs.stdenv.mkDerivation {
    name = "php-debug-adapter";
    version = "1.33.1";
    src = pkgs.fetchurl {
      url = "https://github.com/xdebug/vscode-php-debug/releases/download/v1.33.1/php-debug-1.33.1.vsix";
      sha256 = "sha256-oN9xhG8BkK/jLS9aRV4Ff+EHsLcWe60Z2GDlvgkh5HM=";
    };
    buildInputs = [ pkgs.unzip ];
    phases = [
      "unpackPhase"
      "installPhase"
    ];
    unpackPhase = ''
      mkdir -p $out/extracted
      unzip $src -d $out/extracted
    '';
    installPhase = ''
            mkdir -p $out/bin
            cat > $out/bin/php-debug-adapter << 'SCRIPT'
      #!/bin/sh
      exec ${pkgs.nodejs}/bin/node ${placeholder "out"}/extracted/extension/out/phpDebug.js "$@"
      SCRIPT
            chmod +x "$out/bin/php-debug-adapter"
    '';
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
    pkgs.gcc # compilador C para tree-sitter parsers
    pkgs.gnumake # make para build steps de plugins
    pkgs.tree-sitter # CLI de tree-sitter
    pkgs.fd
    pkgs.tmux
    pkgs.lazygit
    pkgs.lazydocker
    pkgs.lazysql
    pkgs.lazyjournal
    pkgs.lazyssh
    pkgs.neovim
    pkgs.xclip
    pkgs.xsel
    pkgs.wl-clipboard
    pkgs.lsof
    pkgs.btop
    pkgs.fnm
    pkgs.rustup
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
    pkgs.libcdada
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.symbols-only
    pkgs.bluetui
    pkgs.gh
    pkgs.symfony-cli # Symfony CLI
    pkgs.starship # Starship prompt

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

    # ══════════════════════════════════════════════════════
    # LSPs (Language Servers) — provistos por Nix, no Mason
    # ══════════════════════════════════════════════════════
    pkgs.phpactor # PHP
    pkgs.intelephense # PHP Framework LSP (Laravel/Symfony)
    pkgs.lua-language-server # Lua
    pkgs.nixd # Nix
    pkgs.gopls # Go
    pkgs.gotools # Go tools
    pkgs.typescript-language-server # JS/TS
    pkgs.tailwindcss-language-server # Tailwind CSS
    pkgs.emmet-language-server # Emmet
    pkgs.vscode-langservers-extracted # HTML/CSS/JSON/ESLint
    pkgs.astro-language-server # Astro
    pkgs.vue-language-server # Vue
    pkgs.svelte-language-server # Svelte
    pkgs.dockerfile-language-server # Docker
    pkgs.sqls # SQL
    pkgs.clang-tools # C/C++
    pkgs.python312Packages.python-lsp-server # Python
    pkgs.golangci-lint-langserver # Go lint LSP

    # ══════════════════════════════════════════════════════
    # Formatters adicionales
    # ══════════════════════════════════════════════════════
    pkgs.nixfmt # Nix
    pkgs.php83Packages.php-cs-fixer # PHP
    pkgs.shfmt # Shell

    # ══════════════════════════════════════════════════════
    # Linters adicionales
    # ══════════════════════════════════════════════════════
    pkgs.markdownlint-cli # Markdown
    pkgs.eslint_d # JS/TS
    pkgs.golangci-lint # Go
    pkgs.phpstan # PHP
    pkgs.sqlfluff # SQL
    pkgs.hadolint # Docker
    # ══════════════════════════════════════════════════════
    # Debug
    # ══════════════════════════════════════════════════════
    phpDebugAdapter
  ];

  fonts.fontconfig.enable = true;

  # --- Gestión de archivos (Dotfiles) ---
  home.file = {
    # Core Config
    ".gitconfig".source = ../.gitconfig;
    "utils".source = ../utils;
    ".bashrc".source = ../.bashrc;

    # neovim
    ".config/nvim".source = ../nvim;

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

    # Kitty
    ".config/kitty/kitty.conf".source = ../kitty/kitty.conf;

    #lazygit
    ".config/lazygit".source = ../lazygit;

    # Ranger Config
    ".config/ranger/rc.conf".source = ../ranger/rc.conf;
    ".config/ranger/scope.sh".source = ../ranger/scope.sh;

    # Starship
    ".config/starship.toml".source = ../starship.toml;
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
    createEngramDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG /home/alejandrocabeza/.local/share/engram
    '';

    installTpm = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      mkdir -p "$HOME/.config/tmux/plugins"
      if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
        $DRY_RUN_CMD /usr/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
      fi
    '';

    downloadPiperModel = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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

    ensureStarshipWritable = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      TARGET="$HOME/.config/starship.toml"
      if [ -L "$TARGET" ]; then
        $DRY_RUN_CMD cp -L "$TARGET" "''${TARGET}.tmp"
        $DRY_RUN_CMD rm "$TARGET"
        $DRY_RUN_CMD mv "''${TARGET}.tmp" "$TARGET"
      fi
    '';
  };

  # --- Programas ---
  programs.home-manager.enable = true;
  programs.neovim.enable = false;
  programs.ripgrep = {
    enable = true;
    arguments = [ "--smart-case" ];
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height 40% --layout reverse --border"
    ];
  };

}
