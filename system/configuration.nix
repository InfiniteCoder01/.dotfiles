{ inputs, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than +5"; 
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "InfiniteCoders-System";
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # GPU
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };

  boot.blacklistedKernelModules = ["nouveau"];

  environment.variables.__EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  # i18n & l10n
  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.defaultSession = "plasmax11";
  services.desktopManager.plasma6.enable = true;

  # Emacs WM
  # services.xserver.windowManager.session = lib.singleton {
  #   name = "exwm";
  #   start = ''
  #     xhost +SI:localuser:$USER
  #     exec emacs -l ${pkgs.writeText "emacs-exwm-load" ''
  #       (require 'exwm)
  #       (require 'exwm-config)
  #       (exwm-config-example)
  #   ''}
  #   '';
  # };
  # services.xserver.displayManager.lightdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.infinitecoder = {
    isNormalUser = true;
    description = "InfiniteCoder";
    extraGroups = [ "networkmanager" "wheel" "dialout" "plugdev" "docker" "uinput" ];
    packages = with pkgs; [
      kate
      yakuake
      partition-manager
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "infinitecoder";

  # List packages installed in system profile. To search, run:
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
