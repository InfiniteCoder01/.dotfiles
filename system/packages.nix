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
    lazygit
    neovim
    podman
    ripgrep
    strace
    unzip
    zoxide

    # Apps
    gitkraken
    gnome.gnome-disk-utility
    libreoffice
    neovide
    obs-studio
    qpwgraph
    tigervnc
    vscode

    # Art
    aseprite
    gimp
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
    nix-direnv
    nodejs
    openssl
    pipx
    rustup
    wl-clipboard
  ];
})
