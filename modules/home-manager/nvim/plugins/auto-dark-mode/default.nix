{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithCfg {
        plugin = auto-dark-mode;
        file = ./auto-dark-mode.lua;
      })
    ];
  };
}
