{ config, pkgs, lib, ... }: {
  programs.neovim =
    {
      plugins = with pkgs.vimPlugins; [
        (config.lib.vimUtils.pluginWithCfg {
          plugin = nvim-cmp;
          file = "nvim-cmp";
        })
        vim-vsnip
        vim-vsnip-integ
      ];
    };
}
