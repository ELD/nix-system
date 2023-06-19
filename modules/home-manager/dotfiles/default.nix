{
  pkgs,
  lib,
  config,
  ...
}: let
  mkFullPathRelativeToNixpkgs = relative: "${config.home.homeDirectory}/.nixpkgs/${relative}";
in {
  xdg.configFile =
    {}
    // (lib.optionalAttrs pkgs.stdenv.isDarwin {
      "iterm2/com.googlecode.iterm2.plist".source =
        config.lib.file.mkOutOfStoreSymlink (mkFullPathRelativeToNixpkgs
          "modules/home-manager/dotfiles/iterm2/com.googlecode.iterm2.plist");
    })
    // {
      nvim = {
        source =
          config.lib.file.mkOutOfStoreSymlink (mkFullPathRelativeToNixpkgs
            "modules/home-manager/dotfiles/spartanvim");
        recursive = true;
      };
    };
}
