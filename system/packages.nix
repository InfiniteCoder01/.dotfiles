({ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    dotbot
    konsave
    appimagekit
    arp-scan
    aseprite
    bat
    btop
    cmake
    direnv
    discord
    dotbot
    eza
    f3d
    fastfetch
    fzf
    gh
    gimp
    git
    gitkraken
    gnome.gnome-disk-utility
    gnumake
    graphicsmagick
    jdk
    konsave
    lazygit
    libreoffice
    lunarvim
    neovim
    neovide
    nix
    nix-direnv
    nodejs
    obs-studio
    openssl
    pipx
    podman
    prusa-slicer
    qpwgraph
    reaper
    ripgrep
    rustup
    strace
    telegram-desktop
    tigervnc
    unzip
    vscode
    zoxide
  ];
})
