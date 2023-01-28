{ lib, ... }: {
  imports = [
    ./map-leader

    # ./auto-dark-mode
    ./bgwinch
    ./fugitive
    ./leap
    ./lsp-zero
    ./lualine-nvim
    ./telescope
    ./theme
    ./treesitter
    ./undotree
    ./vim-closetag
  ];
}
