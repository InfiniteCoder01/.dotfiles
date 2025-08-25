{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    wakatime-ls.url = "github:mrnossiom/wakatime-ls";
    wakatime-ls.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-index-database, wakatime-ls, ... }@attrs:
    let
      system = "x86_64-linux";
      hostname = "InfiniteCoder";
      pkgs-config = {
        inherit system;
        config.allowUnfree = true;
        config.pulseaudio = true;
      };
      pkgs = import nixpkgs pkgs-config;
      pkgs-cuda = import nixpkgs pkgs-config // {
        config.cudaSupport = true;
      };
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
          arp-scan
          qbittorrent
          wget
          lazygit
          git
          gh
          jq

          graphicsmagick

          fastfetch
          btop

          tmux
          zellij
          yazi

          # IDE
          helix
          arduino
          arduino-ide
          vscode
          platformio

          cloc

          # Apps
          qpwgraph
          tigervnc
          rpi-imager
          gparted
          firefox
          libreoffice
          gitkraken
          (pkgs-cuda.wrapOBS {
            plugins = with obs-studio-plugins; [
              obs-multi-rtmp
              advanced-scene-switcher
              obs-move-transition
              obs-vkcapture
            ];
          })
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

          super-slicer-beta
          lmms

          # Social
          discord
          telegram-desktop

          # Libraries, environments and build systems
          wakatime-ls.packages.${system}.default
          gdb

          clang-tools pkg-config
          rustup gcc # gcc for cc
          zig zls
          bun typescript-language-server
          jdk24 gradle
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
          xdg-terminal-exec
          ulauncher
          shotman
          waybar
          swaybg
        ];

        programs.sway.enable = true;

        environment.sessionVariables = {
          PYTHON_MAGIC_PATH = "${pkgs.python312Packages.python-magic.outPath}/lib/python3.12/site-packages";
        };

        services.ollama = {
          enable = true;
          acceleration = "cuda";
          environmentVariables = {
            OLLAMA_MODELS="/mnt/D/ollama";
          };
          package = pkgs-cuda.ollama-cuda;
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
