{
  lib,
  pkgs,
  ...
}: {
  programs.gpg = {
    enable = true;
    scdaemonSettings =
      {}
      // lib.optionalAttrs pkgs.stdenvNoCC.isDarwin {
        disable-ccid = true;
      };
  };

  services = {
    gpg-agent = {
      enable =
        if pkgs.stdenvNoCC.isDarwin
        then false
        else true;
      enableScDaemon =
        if pkgs.stdenvNoCC.isDarwin
        then false
        else true;
      enableSshSupport = true;
    };
  };
}
