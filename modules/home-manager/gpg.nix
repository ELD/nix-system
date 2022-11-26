{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.gpg = {
    enable = true;
    # scdaemonSettings = { } // lib.optionalAttrs.stdenvNoCC.isDarwin rec {
    #   disable-ccid = true;
    # };
  };

  services = {
    gpg-agent.enableScDaemon =
      if pkgs.stdenvNoCC.isDarwin
      then false
      else true;
    gpg-agent.enableSshSupport = true;
  };
}
