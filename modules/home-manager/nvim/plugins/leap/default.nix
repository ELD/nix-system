{ config, pkgs, lib, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithCfg {
        plugin = leap-nvim;
        file = ./leap.lua;
      })
    ];
  };
}
