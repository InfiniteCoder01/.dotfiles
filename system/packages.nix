({ pkgs, ... }: {
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
    (freecad.overrideAttrs (finalAttrs: previousAttrs: {
      version = "link-daily";
      src = fetchFromGitHub {
        owner = "realthunder";
        repo = "FreeCAD";
        rev = finalAttrs.version;
        hash = "sha256-OX4s9rbGsAhH7tLJkUJYyq2A2vCdkq/73iqYo9adogs=";
      };
    }))

    # Social
    discord
    telegram-desktop

    # Libraries, environments and build systems
    cmake
    gcc
    jdk
    qemu_kvm
    lua-language-server
    nil
    nix-direnv
    nodejs
    openssl
    pipx
    rustup
    wineWowPackages.stable
    wl-clipboard
  ];
})
