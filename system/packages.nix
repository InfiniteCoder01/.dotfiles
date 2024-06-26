{ pkgs, system, fh, nix-snapd, ... }: {
  environment.systemPackages = with pkgs; [
    # Save
    dotbot
    konsave
    appimagekit

    # CLI Tools
    eza
    bat
    fzf
    ripgrep
    zoxide
    fastfetch
    btop
    unzip
    gh
    git
    lazygit
    neovim
    direnv
    tmux
    arp-scan
    fh.packages.${system}.default

    gnumake
    graphicsmagick
    podman
    strace

    # Apps
    gnome.gnome-disk-utility
    qpwgraph
    cutecom
    tigervnc
    rpi-imager
    chromium
    floorp
    libreoffice
    gitkraken
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-multi-rtmp
      ];
    })

    arduino
    arduino-ide
    vscode
    neovide
    godot_4

    # Art
    # aseprite
    gimp
    krita
    inkscape
    blender
    # (appimageTools.wrapType2 {
    #   pname = "freecad";
    #   version = "weekly";
    #
    #   src = fetchurl {
    #     url = "https://github.com/FreeCAD/FreeCAD-Bundle/releases/download/weekly-builds/FreeCAD_weekly-builds-37819-conda-Linux-x86_64-py311.AppImage";
    #     hash = "sha256-7FLtYdLmKLOF6L7ilg12RrLlIlkG83Vz/Atd3PbrJIk=";
    #   };
    #
    #   # extraInstallCommands = ''
    #   #   install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
    #   #   install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
    #   #   substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
    #   # '';
    #
    #   meta = with lib; {
    #     homepage = "https://www.freecad.org";
    #     description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
    #     longDescription = ''
    #       FreeCAD is an open-source parametric 3D modeler made primarily to design
    #       real-life objects of any size. Parametric modeling allows you to easily
    #       modify your design by going back into your model history and changing its
    #       parameters.
    #
    #       FreeCAD allows you to sketch geometry constrained 2D shapes and use them
    #       as a base to build other objects. It contains many components to adjust
    #       dimensions or extract design details from 3D models to create high quality
    #       production ready drawings.
    #
    #       FreeCAD is designed to fit a wide range of uses including product design,
    #       mechanical engineering and architecture. Whether you are a hobbyist, a
    #       programmer, an experienced CAD user, a student or a teacher, you will feel
    #       right at home with FreeCAD.
    #     '';
    #     license = lib.licenses.lgpl2Plus;
    #     maintainers = with lib.maintainers; [ viric gebner AndersonTorres ];
    #     platforms = lib.platforms.linux;
    #   };
    # })
    (appimageTools.wrapType2 rec {
      pname = "ondsel-es";
      version = "weekly";

      src = fetchurl {
        url = "https://github.com/Ondsel-Development/FreeCAD/releases/download/weekly-builds/Ondsel_ES_weekly-builds-37829-Linux-x86_64.AppImage";
        hash = "sha256-AJ99gy4wZ5zzW9kNN79i3YUiVMFqXhqxd8XoPvDhjd8=";
      };

      extraInstallCommands = let
        appimageContents = appimageTools.extractType2 { inherit pname version src; };
      in ''
        install -Dm444 ${appimageContents}/com.ondsel.ES.desktop -t $out/share/applications/
        install -Dm444 ${appimageContents}/Ondsel.svg -t $out/share/pixmaps/
      '';

      extraPkgs = pkgs: [ pkgs.python313 ];

      meta = with lib; {
        homepage = "https://www.ondsel.com";
        license = lib.licenses.lgpl2Plus;
        maintainers = with lib.maintainers; [ viric gebner AndersonTorres ];
        platforms = lib.platforms.linux;
      };
    })

    kicad-testing
    prusa-slicer
    orca-slicer
    reaper

    # Social
    discord
    telegram-desktop

    # Libraries, environments and build systems
    gcc
    cmake
    rustup
    go
    jdk
    lua-language-server
    nil
    nix-direnv
    nodejs
    pipx
    carapace

    openssl
    qemu_kvm
    nix-snapd.packages.${system}.default
    winetricks
    wineWowPackages.stable
    wl-clipboard
  ];
}
