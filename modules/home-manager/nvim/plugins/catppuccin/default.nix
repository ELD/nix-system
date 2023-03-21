{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithCfg {
        plugin = catppuccin-nvim;
        file = ./catppuccin.lua;
      })
    ];
  };
}
