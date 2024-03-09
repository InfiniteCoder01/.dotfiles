-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
    { 'wakatime/vim-wakatime',   lazy = false },
    { 'Exafunction/codeium.vim', event = 'BufEnter' },
    { 'qnighy/lalrpop.vim' },
    -- {
    --   'mrcjkb/rustaceanvim',
    --   version = '^4', -- Recommended
    --   ft = { 'rust' },
    -- },
    {
        'saecki/crates.nvim',
        config = function()
            require('crates').setup()
        end,
    },
}

-- lvim.format_on_save.enabled = true
vim.wo.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
-- lvim.builtin.project.active = false

-- vim.cmd("cd %")

local crates = require("crates")
local opts = { silent = true }

vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
vim.keymap.set("n", "<leader>cu", crates.update_crate, opts)
vim.keymap.set("v", "<leader>cu", crates.update_crates, opts)
vim.keymap.set("n", "<leader>ca", crates.update_all_crates, opts)
vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, opts)
vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, opts)
vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, opts)

vim.keymap.set("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, opts)
vim.keymap.set("n", "<leader>cX", crates.extract_crate_into_table, opts)

vim.keymap.set("n", "<leader>cH", crates.open_homepage, opts)
vim.keymap.set("n", "<leader>cR", crates.open_repository, opts)
vim.keymap.set("n", "<leader>cD", crates.open_documentation, opts)
vim.keymap.set("n", "<leader>cC", crates.open_crates_io, opts)

require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                neededFileStatus = {
                    ["lowercase-global"] = "None",
                    ["missing-parameter"] = "None",
                },
            }
        }
    }
}
