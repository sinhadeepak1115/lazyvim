-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
    -- add gruvbox
    { "ellisonleao/gruvbox.nvim" },

    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox",
        },
    },

    -- change trouble config
    {
        "folke/trouble.nvim",
        -- opts will be merged with the parent spec
        opts = { use_diagnostic_signs = true },
    },

    -- disable trouble
    { "folke/trouble.nvim", enabled = false },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = true, -- show icons in the signs column
            sign_priority = 8, -- sign priority
            -- keywords recognized as todo comments
            keywords = {
                FIX = {
                    icon = " ", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            gui_style = {
                fg = "NONE", -- The gui style to use for the fg highlight group.
                bg = "BOLD", -- The gui style to use for the bg highlight group.
            },
            merge_keywords = true, -- when true, custom keywords will be merged with the defaults
            -- highlighting of the line containing the todo comment
            -- * before: highlights before the keyword (typically comment characters)
            -- * keyword: highlights of the keyword
            -- * after: highlights after the keyword (todo text)
            highlight = {
                multiline = true, -- enable multine todo comments
                multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
                multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
                before = "", -- "fg" or "bg" or empty
                keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
                after = "fg", -- "fg" or "bg" or empty
                pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
                comments_only = true, -- uses treesitter to match keywords in comments only
                max_line_len = 400, -- ignore lines longer than this
                exclude = {}, -- list of file types to exclude highlighting
            },
            -- list of named colors where we try to extract the guifg from the
            -- list of highlight groups or use the hex color if hl not found as a fallback
            colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info = { "DiagnosticInfo", "#2563EB" },
                hint = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
                test = { "Identifier", "#FF00FF" },
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                -- regex that will be used to match keywords.
                -- don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):]], -- ripgrep regex
                -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
            },
        },
    },

    -- add symbols-outline
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
        config = true,
    },

    -- override nvim-cmp and add cmp-emoji
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-emoji" },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            table.insert(opts.sources, { name = "emoji" })
        end,
    },

    -- change some telescope options and a keymap to browse plugin files
    {
        "nvim-telescope/telescope.nvim",
        keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
        },
        -- change some options
        opts = {
            defaults = {
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
            },
        },
    },

    -- add telescope-fzf-native
    {
        "telescope.nvim",
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            config = function()
                require("telescope").load_extension("fzf")
            end,
        },
    },

    -- add pyright to lspconfig
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                -- pyright will be automatically installed with mason and loaded with lspconfig
                pyright = {},
            },
        },
    },

    -- add tsserver and setup with typescript.nvim instead of lspconfig
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "jose-elias-alvarez/typescript.nvim",
            init = function()
                require("lazyvim.util").on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
                    vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
                end)
            end,
        },
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                -- tsserver will be automatically installed with mason and loaded with lspconfig
                tsserver = {},
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                tsserver = function(_, opts)
                    require("typescript").setup({ server = opts })
                    return true
                end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
    },

    -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
    -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
    { import = "lazyvim.plugins.extras.lang.typescript" },

    -- add more treesitter parsers
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "bash",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "tsx",
                "typescript",
                "vim",
                "yaml",
            },
        },
    },

    -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
    -- would overwrite `ensure_installed` with the new value.
    -- If you'd rather extend the default config, use the code below instead:
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            -- add tsx and treesitter
            vim.list_extend(opts.ensure_installed, {
                "tsx",
                "typescript",
            })
        end,
    },

    -- the opts function can also be used to change the default opts:
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            table.insert(opts.sections.lualine_x, "😄")
        end,
    },

    -- or you can return new options to override all the defaults
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            return {
                --[[add your custom lualine config here]]
            }
        end,
    },

    -- use mini.starter instead of alpha
    { import = "lazyvim.plugins.extras.mini.starter" },

    -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
    { import = "lazyvim.plugins.extras.lang.json" },
    -- add any tools you want to have installed below
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "stylua",
                "shellcheck",
                "shfmt",
                "flake8",
            },
        },
    },

    -- Use <tab> for completion and snippets (supertab)
    -- first: disable default <tab> and <s-tab> behavior in LuaSnip
    {
        "L3MON4D3/LuaSnip",
        keys = function()
            return {}
        end,
    },
    -- then: setup supertab in cmp
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-emoji",
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            local cmp = require("cmp")

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                    -- this way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            })
        end,
    },
}
