{ config, pkgs, lib, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # -- Core LSP setup
      (config.lib.vimUtils.pluginWithCfg {
        plugin = lsp-zero;
        file = ./lsp-zero.lua;
      })
      nvim-lspconfig
      mason
      mason-lspconfig

      # -- Autocompletion
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp_luasnip
      cmp-nvim-lsp
      cmp-nvim-lua

      # -- Snippets
      luasnip
      friendly-snippets
    ];
  };
}
