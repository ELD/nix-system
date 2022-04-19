{ config, pkgs, lib, ... }: {
  programs.neovim =
    let inherit (lib.vimUtils ./.) pluginWithLua;
    in
    {
      # vimtex config
      plugins = with pkgs.vimPlugins;
        [
          (config.lib.vimUtils.pluginWithCfg {
            plugin = lspsaga-nvim;
            file = "lspsaga-nvim";
          })
        ];
    };
}
