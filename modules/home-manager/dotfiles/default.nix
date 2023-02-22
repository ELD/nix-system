{
  pkgs,
  lib,
  ...
}: {
  xdg.configFile =
    {}
    // (lib.optionalAttrs pkgs.stdenv.isDarwin {
      "iterm2/com.googlecode.iterm2.plist".source = ./iterm2/com.googlecode.iterm2.plist;
    });
}
