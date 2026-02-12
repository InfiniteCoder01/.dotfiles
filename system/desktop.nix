{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wl-clip-persist
    ulauncher
    shotman
    waybar
    swaybg
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
    wrapperFeatures.gtk = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --unsupported-gpu";
        user = "infinitecoder";
      };
    };
  };

  environment.sessionVariables = {
    # XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk2";
    GTK_USE_PORTAL = 1;
    # WLR_DRM_DEVICES = "/dev/dri/card0";
  };
}
