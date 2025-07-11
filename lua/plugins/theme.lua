return {
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
        end,
    },
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({ transparent = true })
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000, -- Ensure Catppuccin loads first
        config = function()
            require("catppuccin").setup({
                transparent_background = true,
            })
            vim.cmd("colorscheme catppuccin") -- Set Catppuccin as the default
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({ disable_background = true })
        end,
    },
    {
        "sainnhe/everforest",
        config = function()
            vim.g.everforest_transparent_background = 1
        end,
    },
    {
        "bluz71/vim-nightfly-colors",
        config = function()
            vim.g.nightflyTransparent = true
        end,
    },
    {
        "NLKNguyen/papercolor-theme",
        config = function()
            vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
        end,
    },
    {
        "romainl/Apprentice",
        config = function()
            vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
        end,
    },
    {
        "shaunsingh/nord.nvim",
        config = function()
            vim.g.nord_disable_background = true
        end,
    },
    {
        "tomasr/molokai",
        config = function()
            vim.g.molokai_transparent = true
            vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
        end,
    },
    {
        "joshdick/onedark.vim",
        config = function()
            vim.g.onedark_transparent_background = true
        end,
    },

    -- LazyVim Default Theme Configuration
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox",
        },
    },
}
