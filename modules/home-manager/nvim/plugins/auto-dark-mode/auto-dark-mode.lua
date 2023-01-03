local auto_dark_mode = require('auto-dark-mode')

auto_dark_mode.setup({
    update_interval = 1000,
    set_dark_mode = function()
        vim.api.nvim_set_option('background', 'dark')
        vim.cmd('colorscheme two-firewatch')
    end,
    set_light_mode = function()
        vim.api.nvim_set_option('background', 'light')
    end,
})

-- auto_dark_mode.init()
