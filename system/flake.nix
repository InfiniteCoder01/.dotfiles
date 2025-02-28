{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    wakatime-ls.url = "github:mrnossiom/wakatime-ls";
    wakatime-ls.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-index-database, wakatime-ls, nix-snapd, ... }@attrs:
    let
      system = "x86_64-linux";
      pkgs-config = {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            prismlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs {
              src = pkgs.fetchFromGitHub {
                owner = "Diegiwg";
                repo = "PrismLauncher-Cracked";
                tag = "9.2";
                hash = "sha256-/5xtzKed3r84lIMMDVrQE8jqvTUzHTdsWyPIySw/NGs=";
              };
            };
          })
        ]; 
      };
      pkgs = import nixpkgs pkgs-config;
      pkgs-unstable = import nixpkgs-unstable pkgs-config;
    in
    rec {
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
      packages = {
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = with pkgs; [
          # Save
          dotbot
          nix-output-monitor

          # CLI Tools
          starship
          kitty

          caligula
          trashy
          eza
          bat
          fzf
          ripgrep
          zoxide
          file
          ffmpeg

          unzip
          unrar
          appimagekit

          picocom
          inetutils
          arp-scan
          qbittorrent
          wget
          git
          gh

          graphicsmagick

          fastfetch
          btop

          tmux
          yazi

          warp-plus

          pkgs-unstable.helix
          pkgs-unstable.arduino-ide
          pkgs-unstable.vscode
          pkgs-unstable.platformio

          cloc
          direnv

          # Apps
          qpwgraph
          tigervnc
          rpi-imager
          gparted
          brave
          libreoffice
          gitkraken
          (wrapOBS {
            plugins = with obs-studio-plugins; [
              obs-multi-rtmp
            ];
          })
          audacity

          # Quick fix for my overlay, which requires openssl
          (symlinkJoin {
            name = "godot_4+openssl";
            paths = [ pkgs-unstable.godot_4 ];
            buildInputs = [ makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/godot4 \
                --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ openssl libgcc.lib ]}:\$LD_LIBRARY_PATH
            '';
          })
          pkgs-unstable.luanti
          pkgs.prismlauncher

          # Art
          aseprite
          # krita
          # inkscape
          # blender
          # blockbench
          kdePackages.kdenlive
          frei0r
          vlc
          pkgs-unstable.freecad

          pkgs-unstable.prusa-slicer
          pkgs-unstable.orca-slicer
  #          lmms

          # Social
          discord
          telegram-desktop

          # Libraries, environments and build systems
          wakatime-ls.packages.${system}.default
          gdb
          gcc
          rustup
          zig
          go
          jdk
          gradle
          lua54Packages.lua
          lua-language-server
          bash-language-server
          nil
          nix-direnv
          python3
          python312Packages.python-magic # Xonsh onepath fix

          appimage-run
          wineWowPackages.minimal
          wl-clipboard

#          avrdude
#          android-tools
        ];

        # services.emacs = {
        #   enable = true;
        #   package = with pkgs; (
        #     (emacsPackagesFor emacs).emacsWithPackages (
        #       epkgs: [ epkgs.vterm ]
        #     )
        #   );
        # };

        services.ollama = {
          enable = true;
          acceleration = "cuda";
        };

        services.open-webui = {
          package = pkgs.open-webui;
          enable = true;
          environment = {
            ANONYMIZED_TELEMETRY = "False";
            DO_NOT_TRACK = "True";
            SCARF_NO_ANALYTICS = "True";
            OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
            OLLAMA_BASE_URL = "http://127.0.0.1:11434";
          };
        };

        environment.sessionVariables = {
          PYTHON_MAGIC_PATH = "${pkgs.python312Packages.python-magic.outPath}/lib/python3.12/site-packages";
        };

        programs.steam.enable = true;

        programs.nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
          flake = "/home/infinitecoder/.dotfiles/system";
        };

        services.kanata = {
          enable = true;
          keyboards = {
            internalKeyboard = {
              devices = [
                "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
              ];
              configFile = ./kanata.kbd;
            };
          };
        };

        services.udev.packages = [ 
          pkgs-unstable.platformio-core.udev
        ];

        # Some fonts
        fonts.packages = with pkgs; [
          (nerdfonts.override { fonts = [ "FiraCode" "CommitMono" ]; })
          fira-code
          commit-mono
        ];

        # Shells
        programs.zsh.enable = true;
        # programs.xonsh.enable = true;
        environment.shells = with pkgs; [ zsh ];
        users.defaultUserShell = "/home/infinitecoder/.dotfiles/xonsh/venv/bin/xonsh";

        virtualisation.docker.enable = true;
      };
      nixosConfigurations."InfiniteCoders-System" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs;
        modules = [
          ./configuration.nix
          packages
          nix-index-database.nixosModules.nix-index
        ];
      };
    };
}
