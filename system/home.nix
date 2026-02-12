{ wakatime-ls, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI Tools
    starship
    kitty
    any-nix-shell

    eza
    yazi
    zoxide
    bat
    ripgrep
    fzf
    fd
    dysk
    dust
    xxd
    file
    exiftool
    fastfetch
    btop
    ffmpeg
    kew
    graphicsmagick

    zip
    unzip
    unrar

    inetutils
    nmap
    dig
    qbittorrent
    wget
    lazygit
    git
    gh

    # IDE
    helix
    arduino-ide

    cloc

    # Apps
    firefox
    qpwgraph
    tigervnc
    libreoffice
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

    prusa-slicer
    lmms

    # Social
    discord
    telegram-desktop

    # Libraries, environments and build systems
    wakatime-ls.packages.${stdenv.hostPlatform.system}.default
    gnumake gdb

    clang clang-tools pkgconf
    rustup
    zig zls
    bun typescript-language-server
    javaPackages.compiler.openjdk25 maven jdt-language-server
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

  # programs.obs-studio = {
  #   enable = true;
  #   enableVirtualCamera = true;
  #   plugins = with pkgs.obs-studio-plugins; [
  #     obs-multi-rtmp
  #     advanced-scene-switcher
  #     obs-move-transition
  #   ];
  # };

  # services.printing.enable = true;
  # services.udisks2.enable = true;
  # programs.steam.enable = true;
  # services.flatpak.enable = true;
  # virtualisation.docker.enable = true;

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
}
