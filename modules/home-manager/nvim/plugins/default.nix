{ lib, ... }: {
  imports = [
    ./auto-dark-mode
    ./fugitive
    ./lsp-zero
    ./lualine-nvim
    ./telescope
    ./theme
    ./treesitter
    ./undotree
    ./vim-closetag
  ];
}
