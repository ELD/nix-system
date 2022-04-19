{ config, pkgs, lib, ... }: {
  programs.neovim =
    {
      plugins = with pkgs.vimPlugins;
        [
          (config.lib.vimUtils.pluginWithCfg {
            plugin = nvim-autopairs;
            file = "nvim-autopairs";
          })
        ];
    };
}
