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

    # Opinioated (probably shouldn't be forced, you can remove them)
    lxappearance
    kdePackages.gwenview
    mpv
  ];

  qt = {
    enable = true;
    style = "adwaita";
    platformTheme = "gnome";
  };

  environment.sessionVariables = rec {
    GTK_USE_PORTAL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = ["${XDG_BIN_HOME}"];

    # XDG base directory patches
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
    WAKATIME_HOME = "${XDG_CONFIG_HOME}/wakatime";
    CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
    GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java";
    WORKON_HOME = "${XDG_DATA_HOME}/virtualenvs";
    XDG_CONFIG_DIR = XDG_CONFIG_HOME; # PulseAudio
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
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

  xdg.mime.defaultApplications = {
    "image/png" = "org.kde.gwenview.desktop";
    "image/jpeg" = "org.kde.gwenview.desktop";
    "image/webp" = "org.kde.gwenview.desktop";
    "image/svg+xml" = "org.kde.gwenview.desktop";
    "image/bmp" = "org.kde.gwenview.desktop";
    "image/gif" = "org.kde.gwenview.desktop";
    "video/mp4" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/quicktime" = "mpv.desktop";
    "video/x-msvideo" = "mpv.desktop";
    "video/x-flv" = "mpv.desktop";
    "application/x-mpegurl" = "mpv.desktop";
    "x-scheme-handler/discord" = "legcord.desktop";
  };
}
