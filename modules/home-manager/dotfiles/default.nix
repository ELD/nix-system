{ config, pkgs, lib, ... }: {
  home.file = { } // (lib.optionalAttrs pkgs.stdenvNoCC.isDarwin {
    iterm2 = {
      source = ./iterm2/com.googlecode.iterm2.plist;
      target = "${config.home.homeDirectory}/Library/Preferences/com.googlecode.iterm2.plist";
    };
  });
}
