{ pkgs, system, fh, nix-snapd, ... }: {
  environment.systemPackages = with pkgs; [
    # Save
    dotbot
    konsave
    appimagekit

    # CLI Tools
    arp-scan
    bat
    btop
    direnv
    eza
    fastfetch
    fh.packages.${system}.default
    fzf
    gh
    git
    gnumake
    graphicsmagick
    hugo
    lazygit
    neovim
    podman
    ripgrep
    strace
    tmux
    unzip
    zoxide

    # Apps
    arduino
    arduino-ide
    chromium
    cutecom
    floorp
    gitkraken
    gnome.gnome-disk-utility
    godot_4
    libreoffice
    neovide
    qpwgraph
    rpi-imager
    scrcpy
    tigervnc
    vscode
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-multi-rtmp
      ];
    })

    # Art
    aseprite
    blender
    gimp
    inkscape
    krita
    prusa-slicer
    reaper
    # (freecad.overrideAttrs (finalAttrs: previousAttrs: {
    #   version = "master";
    #   src = fetchFromGitHub {
    #     owner = "FreeCAD";
    #     repo = "FreeCAD";
    #     rev = "3b4598ce04d7aaec69feeb560c29ae18f0236e0c";
    #     hash = "sha256-NW3Ngpy3r+HBsXneMxZVtaHtA3+G2yfmFJDVdomlKrQ=";
    #     fetchSubmodules = true;
    #   };
    #   buildInputs = previousAttrs.buildInputs ++ [ yaml-cpp ];
    #   patches = [];
    # }))
    freecad
    kicad-testing

    # Social
    discord
    telegram-desktop

    # Libraries, environments and build systems
    cmake
    gcc
    go
    jdk
    lua-language-server
    nil
    nix-direnv
    nodejs
    openssl
    pipx
    qemu_kvm
    rustup
    nix-snapd.packages.${system}.default
    winetricks
    wineWowPackages.stable
    wl-clipboard
  ];
}
