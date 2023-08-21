{
  pkgs,
  lib,
  config,
  ...
}: let
  mkFullPathRelativeToNixpkgs = relative: "${config.home.homeDirectory}/.nixpkgs/${relative}";
in {
  home.file."${config.xdg.configHome}/zsh/.p10k.zsh" = {
    source =
      config.lib.file.mkOutOfStoreSymlink (mkFullPathRelativeToNixpkgs
        "modules/home-manager/dotfiles/p10k/.p10k.zsh");
  };
  xdg.configFile =
    {
      nvim = {
        source =
          config.lib.file.mkOutOfStoreSymlink (mkFullPathRelativeToNixpkgs
            "modules/home-manager/dotfiles/spartanvim");
        recursive = true;
      };
    }
    // (lib.optionalAttrs pkgs.stdenv.isDarwin {
      "iterm2/com.googlecode.iterm2.plist".source =
        config.lib.file.mkOutOfStoreSymlink (mkFullPathRelativeToNixpkgs
          "modules/home-manager/dotfiles/iterm2/com.googlecode.iterm2.plist");
    });
}
