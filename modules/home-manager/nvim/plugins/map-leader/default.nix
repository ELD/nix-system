{ config, pkgs, lib, ... }:
let
  leader-mappings = (config.lib.vimUtils.pluginWithCfg {
    plugin = pkgs.writeText "dummy" "";
    file = ./map-leader.lua;
  });
in{
  programs.neovim.plugins = lib.mkBefore [ leader-mappings ];
}
