{ config, pkgs, lib, ... }: {
  programs.neovim =
    {
      # vimtex config
      plugins = with pkgs.vimPlugins;
        [
          # completion nvim
          (config.lib.vimUtils.pluginWithLua {
            plugin = nvim-lspconfig;
            file = "nvim-lspconfig";
          })
        ];
    };
}
