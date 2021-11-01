{ config, pkgs, ... }: {
  home.file = {
    # TODO: This should not be in home-manger since it's darwin-specific
    iterm2 = {
      source = ./iterm2/com.googlecode.iterm2.plist;
      target = "${config.home.homeDirectory}/Library/Preferences/com.googlecode.iterm2.plist";
    };
  };
}
