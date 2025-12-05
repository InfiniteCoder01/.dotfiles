{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    wakatime-ls.url = "github:mrnossiom/wakatime-ls";
    wakatime-ls.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-index-database, wakatime-ls, ... }@attrs:
    let
      system = "x86_64-linux";
      hostname = "InfiniteCoder";
      pkgs-config = {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = import nixpkgs pkgs-config;
      pkgs-unstable = import nixpkgs-unstable pkgs-config;
    in
    rec {
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
      packages = {
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = with pkgs; [
          # CLI Tools
          starship
          kitty

          any-nix-shell
          caligula
          eza
          bat
          fzf
          fd
          ripgrep
          zoxide
          file
          ffmpeg
          dysk
          dust
          httpie
          kew
          exiftool
          xxd

          zip
          unzip
          unrar

          picocom
          inetutils
          nmap
          qbittorrent
          wget
          lazygit
          git
          gh
          jq
          fastfetch
          btop
          yazi

          graphicsmagick

          # IDE
          helix
          arduino
          arduino-ide
          vscode
          platformio
          jetbrains.idea-community-bin

          cloc

          # Apps
          qpwgraph
          tigervnc
          rpi-imager
          gparted
          (wrapFirefox (firefox-unwrapped.override { pipewireSupport = true;}) {})
          libreoffice
          gitkraken
          v4l-utils
          audacity

          mpv
          kdePackages.gwenview

          godot
          luanti
          prismlauncher
          (retroarch.withCores (cores: with cores; [
            quicknes
            snes9x
            mgba
            genesis-plus-gx
          ]))

          # Art
          aseprite
          krita
          inkscape
          blender
          blockbench
          kdePackages.kdenlive
          frei0r
          vlc
          freecad

          pkgs-unstable.prusa-slicer
          orca-slicer
          lmms

          # Social
          discord
          telegram-desktop

          # Libraries, environments and build systems
          wakatime-ls.packages.${system}.default
          gdb

          clang-tools pkgconf
          rustup gcc # gcc for cc
          zig zls
          bun typescript-language-server
          pkgs-unstable.javaPackages.compiler.openjdk25 maven jdt-language-server kotlin-language-server
          lua54Packages.lua lua-language-server
          bash-language-server
          nil
          python3 pyright
          python312Packages.python-magic # Xonsh onepath fix

          steam-run
          appimage-run
          wineWowPackages.full
          wl-clipboard

          avrdude
          android-tools

          wl-clip-persist
          ulauncher
          shotman
          waybar
          swaybg
        ];

        programs.obs-studio = {
          enable = true;
          enableVirtualCamera = true;
          plugins = with pkgs.obs-studio-plugins; [
            obs-vaapi
            obs-vkcapture
            obs-multi-rtmp
            advanced-scene-switcher
            obs-move-transition
          ];
        };

        programs.sway.enable = true;

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
          pkgs.platformio-core.udev
          pkgs.android-udev-rules
        ];

        # Some fonts
        fonts.packages = with pkgs.nerd-fonts; [
          commit-mono
          profont
        ];

        # Shells
        programs.zsh.enable = true;
        # programs.xonsh.enable = true;
        environment.shells = with pkgs; [ zsh ];
        users.defaultUserShell = "/home/infinitecoder/.dotfiles/xonsh/venv/bin/xonsh";

        virtualisation.docker.enable = true;
      };
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs // { inherit hostname; };
        modules = [
          nix-index-database.nixosModules.nix-index
          packages
          ./configuration.nix
        ];
      };
    };
}
