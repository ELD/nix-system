{ config, pkgs, inputs, lib, ... }: {
  imports = [
    ../common.nix
  ];

  hm = { pkgs, ... }: {
    imports = [ ../home-manager/gnome ];

    programs.alacritty = {
      enable = true;
      settings =
        {
          key_bindings = [
            {
              key = "K";
              mods = "Control";
              chars = "\\x0c";
            }
            {
              key = "K";
              mods = "Control";
              action = "ClearHistory";
            }
          ];
        };
    };
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Configure keymap in X11
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    layout = "us";
    xkbVariant = "";

    libinput.enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    desktopManager.gnome.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      edattore = {
        isNormalUser = true;
        description = "Eric Dattore";
        extraGroups = [ "networkmanager" "wheel" ];
        hashedPassword = "$6$66tB9.ICPVgLalwX$zKQCNv0mZRAv8kiXYQfavELSeLHKMUwir7wCrLp9f4ar9Letv8Xr2mHWzolWItlr/VbQoRindubqtJon2iMzy0";
      };
    };
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    discord
    firefox
    git
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.pop-shell
    pop-gtk-theme
    pop-icon-theme
    pop-launcher
    thunderbird
    vscode
    wget
  ];

  # Session Variables
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
