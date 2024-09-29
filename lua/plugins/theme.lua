return {
    { "ellisonleao/gruvbox.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "catppuccin/nvim", name = "catppuccin", lazy = false },
    { "rose-pine/neovim", name = "rose-pine" },
    { "sainnhe/everforest" },
    { "bluz71/vim-nightfly-colors" },
    { "NLKNguyen/papercolor-theme" },
    { "romainl/Apprentice" },
    { "shaunsingh/nord.nvim" },
    { "tomasr/molokai" },
    { "joshdick/onedark.vim" },

    -- Configure LazyVim to load colorscheme
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "nightfly",
        },
    },
}
