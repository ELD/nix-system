{ inputs, config, pkgs, ... }:
let
  prefix = "/run/current-system/sw/bin";
  inherit (pkgs.stdenvNoCC) isAarch64 isAarch32;
in
{
  # environment setup
  environment = {
    loginShell = pkgs.zsh;
    pathsToLink = [ "/Applications" ];
    backupFileExtension = "backup";
    etc = { darwin.source = "${inputs.darwin}"; };
    # Use a custom configuration.nix location.
    # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix

    # packages installed in system profile
    systemPackages = with pkgs; [ pinentry_mac ];
  };

  fonts.fontDir.enable = true;

  homebrew.brewPrefix = if isAarch64 || isAarch32 then "/opt/homebrew/bin" else "/usr/local/bin";

  nix.nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # enable gnupg
  programs.gnupg = {
    agent.enable = true;
    agent.enableSSHSupport = true;
  };

  # auto manage nixbld users with nix darwin
  users.nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
