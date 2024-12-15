{ pkgs, pkgs-stable, ... }: {
  environment.systemPackages = with pkgs; [
    # Save
    pkgs-stable.dotbot
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
    
    fastfetch
    btop

    tmux
    yazi

    helix

    cloc
    direnv

    # Apps
    qpwgraph
    tigervnc
    rpi-imager
    gparted
    steam
    firefox
    chromium
    libreoffice
    gitkraken
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-multi-rtmp
        droidcam-obs
        obs-backgroundremoval
      ];
    })
    audacity

    arduino
    arduino-ide
    vscode
    zed-editor

    # Quick fix for my overlay, which requires openssl
    (symlinkJoin {
      name = "godot_4+openssl";
      paths = with pkgs; [
        # (godot_4.overrideAttrs (old: rec {
        #   src = fetchFromGitHub {
        #     owner = "pkowal1982";
        #     repo = "godot";
        #     hash = "";
        #   };
        # }))
        godot_4
      ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/godot4 \
          --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ openssl ]}:\$LD_LIBRARY_PATH
      '';
      inherit (pkgs.emacs) meta;
    })
    minetest

    # Art
    ldtk
    aseprite
    krita
    inkscape
    blender
    kdePackages.kdenlive frei0r
    vlc
    freecad

    # kicad-testing
    prusa-slicer
    lmms

    # Social
    discord
    telegram-desktop

    # Libraries, environments and build systems
    bear
    gcc
    rustup
    go
    jdk
    lua54Packages.lua
    lua-language-server
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
  fonts.packages = with pkgs; [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.commit-mono
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
}
