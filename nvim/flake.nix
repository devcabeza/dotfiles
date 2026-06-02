{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    blade-treesitter = {
      url = "github:EmranMR/tree-sitter-blade";
      flake = false;
    };

    "plugins-universal-clipboard.nvim" = {
      url = "github:swaits/universal-clipboard.nvim";
      flake = false;
    };

    "plugins-obsidian-nvim" = {
      url = "github:obsidian-nvim/obsidian.nvim";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, nixCats, ... }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = { };
      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];
categoryDefinitions = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
    lspsAndRuntimeDeps = {
      general = with pkgs; [
      # Herramientas base
      fd
      gh
      git
      ripgrep
      stylua
      wl-clipboard
      xclip
      xsel
      jq

      # LSPs y herramientas por lenguaje
      lua-language-server
      nixd
      nixfmt-rfc-style

      # PHP / Laravel (Esenciales)
      phpactor
      php83Packages.php-cs-fixer
      phpstan

      # JS / TS / Web
      nodejs
      deno
      typescript-language-server
      tailwindcss-language-server
      emmet-language-server
      vscode-langservers-extracted # html, css, json, eslint
      eslint_d
      prettierd
      biome
      astro-language-server
      vue-language-server
      svelte-language-server

      # Otros
      gopls
      rust-analyzer
      python312Packages.python-lsp-server
      dockerfile-language-server-nodejs
      hadolint
      sqlfluff
      sqls
      clang
      nodePackages.prisma
    ];
  };
            # Habilitar categoria para Copilot
            copilot = true;
            };

            startupPlugins = {
             gitPlugins = with pkgs.neovimPlugins; [
             ];
             general = with pkgs.vimPlugins; [
              # UI/UX
              inc-rename-nvim

              # Core Plugins
              todo-comments-nvim
              friendly-snippets
              SchemaStore-nvim
              plugins-universal-clipboard-nvim

              # Notes & Obsidian
              plugins-obsidian-nvim

              nvim-ts-autotag
              lualine-nvim
              nui-nvim
              nvim-web-devicons
              undotree
              nvim-dap
              nvim-ufo
              promise-async
              mini-nvim
              (nvim-treesitter.withPlugins (p: with p; [
              bash
              c
              diff
              html
              javascript
              jsdoc
              json
              lua
              luadoc
              luap
              markdown
              markdown_inline
              python
              query
              toml
              regex
              tsx
              typescript
              vim
              vimdoc
              xml
              yaml
              php
              css
              dockerfile
              sql
              jsonc
            ]))
          ];
        };

        optionalPlugins = {
          gitPlugins = with pkgs.neovimPlugins; [ ];
          general = with pkgs.vimPlugins; [ ];
        };
        sharedLibraries = {
          general = with pkgs; [
            # libgit2
          ];
        };
        environmentVariables = {
          test = {
            CATTESTVAR = "It worked!";
          };
        };
        extraWrapperArgs = {
          test = [
            '' --set CATTESTVAR2 "It worked again!"''
          ];
        };
        python3.libraries = {
          test = (_: [ ]);
        };
        extraLuaPackages = {
          general = with pkgs.lua51Packages; [
          ];
          test = [ (_: [ ]) ];
        };
      };

      packageDefinitions = {
        nvim = { pkgs, name, ... }: {
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = true;
            aliases = [ "vim" ];
          };
          categories = {
            general = true;
            test = true;
            copilot = true;
            example = {
              youCan = "add more than just booleans";
              toThisSet = [
                "and the contents of this categories set"
                "will be accessible to your lua with"
                "nixCats('path.to.value')"
                "see :help nixCats"
              ];
            };
          };
        };
      };
      defaultPackageName = "nvim";
    in


    forEachSystem
      (system:
        let
          nixCatsBuilder = utils.baseBuilder luaPath
            {
              inherit nixpkgs system dependencyOverlays extra_pkg_config;
            }
            categoryDefinitions
            packageDefinitions;
          defaultPackage = nixCatsBuilder defaultPackageName;
          pkgs = import nixpkgs { inherit system; };
        in
        {
          packages = utils.mkAllWithDefault defaultPackage;
          devShells = {
            default = pkgs.mkShell {
              name = defaultPackageName;
              packages = [ defaultPackage ];
              inputsFrom = [ ];
              shellHook = ''
        '';
            };
          };

        }) // (
      let
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
      in
      {

        overlays = utils.makeOverlays luaPath
          {
            inherit nixpkgs dependencyOverlays extra_pkg_config;
          }
          categoryDefinitions
          packageDefinitions
          defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );

}
