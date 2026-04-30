-- Setup leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Alias for vim.opt
local opt = vim.opt

-- Line Number
opt.number = true
opt.relativenumber = true
opt.guicursor = ""

-- Tab Space
opt.tabstop = 4 -- 1 Tab = 4 Spaces
opt.shiftwidth = 4
opt.expandtab = true -- tab to spaces
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true -- Use of capital letters in search makes it case sensitive
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes" -- Always show a column on left for error highlighting
opt.scrolloff = 8
opt.wrap = false

-- Clipboard
opt.clipboard = "unnamedplus"
opt.updatetime = 50

-- Swap and Undo
opt.swapfile = false
opt.backup = false
opt.undofile = true -- Persistent undo for a session

-- Alias for vim.keymap
local keymap = vim.keymap

-- nohl setup
keymap.set("n", "<leader>nh", ":nohl<CR>", {desc = "Clear Search Highlights"})

-- Split window keymap
keymap.set("n", "<leader>se", "<C-w>=", {desc = "Make Split Equal"})
keymap.set("n", "<leader>sx", ":close<CR>", {desc = "Close Split"})

-- Move to window keymap
keymap.set("n", "<leader>wh", "<C-w>h", {desc = "Move Left"})
keymap.set("n", "<leader>wj", "<C-w>j", {desc = "Move Down"})
keymap.set("n", "<leader>wk", "<C-w>k", {desc = "Move Up"})
keymap.set("n", "<leader>wl", "<C-w>l", {desc = "Move Right"})

-- Visual Mode Keymap
keymap.set("v", ">", ">gv", {desc = "Set Visual Mode on after Indenting"})
keymap.set("v", "<", "<gv", {desc = "Set Visual Mode on after Indenting"})

keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- Jump to the previous error in the file
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Jump to previous error" })

-- Jump to the next error in the file
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Jump to next error" })


-- status line config
opt.laststatus = 3 -- Global status line
local statusline = {
    "%#CursorLineNr#", -- color
    "%r", -- read only flag
    " %t",  -- fine name
    "%m ", -- modified flag
    "%*", -- reset color
    "%=", -- separator
    "%#StatusLineNC#", -- color
    "%y ", -- file type
    "%p%% ", -- percentage of file
    "%#StatusLineNC#", -- color
    "%l:%c ", -- line and col number
    "%*", -- reset color
}
opt.statusline = table.concat(statusline)
-- Lazy setup
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    {
        "RRethy/base16-nvim",
        lazy = false, -- load at startup
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme base16-default-dark]])
        end, 
    },

    {
        'nvim-telescope/telescope.nvim', version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- optional but recommended
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            local builtin = require('telescope.builtin')
            keymap.set("n", "<leader>ff", builtin.find_files, {desc = "Find files in cwd"})
            keymap.set('n', '<leader>fs', builtin.live_grep, { desc = 'Find string in cwd' })
            keymap.set("n", "<leader>sh", "<C-w>h:Telescope find_files<CR>", {desc = "Split Horizontally (Top/Bottom)"})
            keymap.set("n", "<leader>sv", "<C-w>v:Telescope find_files<CR>", {desc = "Split Vertically (Left/Right)"})
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- The languages we care about for your generic dev and CP
                ensure_installed = { "c", "cpp", "python", "java", "go", "javascript", "lua", "bash" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "pyright",
                    "gopls",
                    "ts_ls",
                    "rust_analyzer",
                }
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- The list of servers we want to wire up
            local servers = { "clangd", "pyright", "jdtls", "gopls", "ts_ls", "rust_analyzer" }

            -- NEW ARCHITECTURE: Using native vim.lsp instead of the deprecated framework
            for _, server in ipairs(servers) do
                -- We still fetch the default configurations (like cmd paths) from the plugin
                local default_config = require('lspconfig.configs.' .. server).default_config
                
                -- Inject our autocompletion capabilities into the config
                default_config.capabilities = vim.tbl_deep_extend(
                    "force",
                    default_config.capabilities or {},
                    capabilities
                )

                default_config.root_dir = nil
                
                -- Register the server directly with Neovim's core C-engine
                vim.lsp.config(server, default_config)
                
                -- Enable the server globally
                vim.lsp.enable(server)
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(e)
                    local opts = { buffer = e.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Read doc
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename variable across file
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Auto fix errors
                end,
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(), -- Up
                    ["<C-j>"] = cmp.mapping.select_next_item(), -- Down
                    ["<C-Space>"] = cmp.mapping.complete(), -- Force menu to open
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter to accept snippet
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = { "hrsh7th/nvim-cmp" }, 
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true, -- Use Treesitter to check if we are in a string or comment
                disable_filetype = { "TelescopePrompt", "vim" },
            })

            -- 2. Wire it into the Autocompletion Engine (The Secret Sauce)
            -- This makes it so when you hit Enter to autocomplete a function,
            -- it automatically adds the parenthesis: function_name()
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end,
    },
})
