{ config, pkgs, lib, ... }: {
  programs.neovim =
    {
      # vimtex config
      plugins = with pkgs.vimPlugins;
        [
          (config.lib.vimUtils.pluginWithCfg {
            plugin = vimtex;
            file = "vimtex";
          })
        ];

      # LSP config
      extraPackages = with pkgs; with nodePackages; [ texlab ];
      extraConfig = ''
        ${readLuaSection "lsp"}
      '';
    };
}
