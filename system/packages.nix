{ pkgs, pkgs-stable, ... }: {
  environment.systemPackages = with pkgs; [
    # Save
    pkgs-stable.dotbot
    konsave

    # CLI Tools
    starship

    trashy
    eza
    bat
    fzf
    ripgrep
    zoxide
    file
    unzip
    unrar
    ffmpeg

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

    zellij

    vim
    neovim
    helix

    direnv

    # Apps
    qpwgraph
    cutecom
    tigervnc
    rpi-imager
    gparted
    steam
    chromium
    floorp
    libreoffice
    gitkraken
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-multi-rtmp
      ];
    })
    audacity

    arduino
    arduino-ide
    vscode
    zed-editor
    godot_4


    # Art
    ldtk
    aseprite
    krita
    inkscape
    blender
    vlc
    # ondsel
    # (appimageTools.wrapType2 rec {
    #   pname = "ondsel-es";
    #   version = "weekly";
    #
    #   src = fetchurl {
    #     url = "https://github.com/Ondsel-Development/FreeCAD/releases/download/2024.2.0/Ondsel_ES_2024.2.0.37191-Linux-x86_64.AppImage";
    #     sha256 = "";
    #   };
    #
    #   extraInstallCommands = let
    #     appimageContents = appimageTools.extractType2 { inherit pname version src; };
    #   in ''
    #     install -Dm444 ${appimageContents}/com.ondsel.ES.desktop -t $out/share/applications/
    #     install -Dm444 ${appimageContents}/Ondsel.svg -t $out/share/pixmaps/
    #   '';
    #
    #   extraPkgs = pkgs: [ pkgs.python313 ];
    #
    #   meta = with lib; {
    #     homepage = "https://www.ondsel.com";
    #     license = lib.licenses.lgpl2Plus;
    #     maintainers = with lib.maintainers; [ viric gebner AndersonTorres ];
    #     platforms = lib.platforms.linux;
    #   };
    # })

    # kicad-testing
    prusa-slicer
    lmms

    # Social
    discord
    telegram-desktop

    # Libraries, environments and build systems
    gcc
    rustup
    go
    jdk
    lua-language-server
    nil
    nix-direnv
    python3
    carapace

    appimagekit
    winetricks
    wineWowPackages.stable
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
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    (nerdfonts.override { fonts = [ "CommitMono" ]; })
  ];

  # Shells
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh nushell ];
  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;
}
