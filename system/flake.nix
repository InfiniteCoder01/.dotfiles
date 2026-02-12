{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    wakatime-ls.url = "github:mrnossiom/wakatime-ls";
    wakatime-ls.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, determinate, nix-index-database, wakatime-ls, ... }@attrs:
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
          kew
          exiftool
          xxd

          zip
          unzip
          unrar

          inetutils
          nmap
          qbittorrent
          wget
          lazygit
          git
          gh
          fastfetch
          btop
          yazi

          graphicsmagick

          # IDE
          helix
          arduino-ide
          vscode
          # jetbrains.idea-community-bin

          cloc

          # Apps
          qpwgraph
          tigervnc
          firefox
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
            mgba
          ]))

          # Art
          aseprite
          krita
          inkscape
          blender
          blockbench
          freecad

          pkgs-unstable.prusa-slicer
          lmms

          # Social
          discord
          telegram-desktop

          # Libraries, environments and build systems
          wakatime-ls.packages.${system}.default
          gnumake gdb

          clang clang-tools pkgconf
          rustup
          zig zls
          bun typescript-language-server
          pkgs-unstable.javaPackages.compiler.openjdk25 maven jdt-language-server
          lua54Packages.lua lua-language-server
          bash-language-server
          nil
          python3 pyright

          steam-run
          appimage-run
          wineWowPackages.full

          avrdude
          android-tools
        ];

        programs.obs-studio = {
          enable = true;
          enableVirtualCamera = true;
          plugins = with pkgs.obs-studio-plugins; [
            obs-multi-rtmp
            advanced-scene-switcher
            obs-move-transition
          ];
        };

        services.printing.enable = true;
        services.udisks2.enable = true;
        programs.steam.enable = true;
        services.flatpak.enable = true;
        virtualisation.docker.enable = true;

        programs.nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 1";
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
        ];

        # Some fonts
        fonts.packages = with pkgs.nerd-fonts; [
          commit-mono
          profont
        ];

        # Shells
        users.users.infinitecoder.shell = "/home/infinitecoder/.dotfiles/xonsh/venv/bin/xonsh";
      };
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs // { inherit hostname; };
        modules = [
          determinate.nixosModules.default
          nix-index-database.nixosModules.nix-index
          packages
          ./configuration.nix
          ./desktop.nix
        ];
      };
    };
}
