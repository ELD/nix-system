{ config, pkgs, lib, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in {
  xdg.configFile = { } // (lib.optionalAttrs pkgs.stdenv.isDarwin {
    "iterm2/com.googlecode.iterm2.plist".source = link ./. + "/iterm2/com.googlecode.iterm2.plist";
  });
}
