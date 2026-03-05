{ pkgs, ... }:
rec {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wl-clip-persist
    ulauncher
    shotman
    waybar
    swaybg
    swaynotificationcenter
  ];

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config.common.default = "*";
  };

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${programs.sway.package}/bin/sway --unsupported-gpu";
        user = "infinitecoder";
      };
    };
  };

  environment.sessionVariables = {
    # XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
    QT_QPA_PLATFORM = "wayland-egl";
    QT_QPA_PLATFORMTHEME = "gtk2";
    QT_WAYLAND_FORCE_DPI = "physical";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    GTK_USE_PORTAL = 1;
  };
}
