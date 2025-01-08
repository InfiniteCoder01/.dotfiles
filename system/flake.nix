{
  description = "InfiniteCoder's system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    wakatime-ls.url = "github:mrnossiom/wakatime-ls";
    wakatime-ls.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-index-database, wakatime-ls, ... }@attrs:
    let
      system = "x86_64-linux";
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
        environment.systemPackages = with pkgs; [
          # Save
          dotbot
          konsave

          # CLI Tools
          starship
          kitty

          man-pages
          man-pages-posix

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
          cloudflared
          twitch-cli

          graphicsmagick

          pkgs-unstable.fastfetch
          btop

          tmux
          yazi

          pkgs-unstable.helix

          cloc
          direnv

          # Apps
          qpwgraph
          tigervnc
          pkgs-unstable.rpi-imager
          gparted
          steam
          firefox
          chromium
          libreoffice
          gitkraken
          (pkgs-unstable.wrapOBS {
            plugins = with pkgs-unstable.obs-studio-plugins; [
              obs-multi-rtmp
              droidcam-obs
              obs-backgroundremoval
            ];
          })
          audacity

          arduino
          pkgs-unstable.arduino-ide
          pkgs-unstable.vscode
          pkgs-unstable.zed-editor

          # Quick fix for my overlay, which requires openssl
          (symlinkJoin {
            name = "godot_4+openssl";
            paths = [ pkgs-unstable.godot_4 ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/godot4 \
                --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ openssl libgcc.lib ]}:\$LD_LIBRARY_PATH
            '';
            # inherit (pkgs.emacs) meta;
          })
          pkgs-unstable.luanti

          # Art
          ldtk
          aseprite
          krita
          inkscape
          blender
          blockbench
          pkgs-unstable.kdePackages.kdenlive
          frei0r
          vlc
          pkgs-unstable.freecad

          # kicad-testing
          pkgs-unstable.prusa-slicer
          lmms

          # Social
          pkgs-unstable.discord
          telegram-desktop

          # Libraries, environments and build systems
          wakatime-ls.packages.${system}.default
          gdb
          bear
          gcc
          rustup
          go
          jdk
          gradle
          lua54Packages.lua
          lua-language-server
          bash-language-server
          nil
          nix-direnv
          python3

          appimage-run
          winetricks
          wineWow64Packages.full
          wl-clipboard

          avrdude
          android-tools
        ];

        # services.emacs = {
        #   enable = true;
        #   package = with pkgs; (
        #     (emacsPackagesFor emacs).emacsWithPackages (
        #       epkgs: [ epkgs.vterm ]
        #     )
        #   );
        # };

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

        # Some fonts
        fonts.packages = with pkgs-unstable; [
          nerd-fonts.fira-code
          nerd-fonts.commit-mono
          times-newer-roman
        ];

        # Shells
        programs.zsh.enable = true;
        programs.xonsh.enable = true;
        environment.shells = with pkgs; [ xonsh zsh ];
        users.defaultUserShell = pkgs.xonsh;

        documentation = {
          dev.enable = true;
        };

        virtualisation.docker.enable = true;
      };
      nixosConfigurations."InfiniteCoders-System" = nixpkgs-unstable.lib.nixosSystem {
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
