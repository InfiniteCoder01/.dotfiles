vim.g.mapleader = ' ' -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = '\\' -- Same for `maplocalleader`
vim.cmd("set autoindent expandtab tabstop=2 shiftwidth=2")

-- lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require('lazy').setup({
  -- LSP
  { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  { 'L3MON4D3/LuaSnip' },
  { 'LhKipp/nvim-nu' },
  { 'nvim-treesitter/nvim-treesitter' },
  { 'numToStr/Comment.nvim', lazy = false, config = true },
  {
    "folke/trouble.nvim",
    branch = "dev",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    lazy = false, -- This plugin is already lazy
  },

  -- Themes & Tools (Panes)
  { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() return require('alpha').setup(require('alpha.themes.startify').config) end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = { theme = 'gruvbox' },
      sections = {
        lualine_c = { 'buffers' },
        lualine_x = { 'filetype' }
      }
    },

  },
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
    }
  },
  { 'akinsho/toggleterm.nvim', version = '*', config = true },
  { 'numToStr/BufOnly.nvim' },

  -- Tools
  { 'ahmedkhalf/project.nvim', config = function() require('project_nvim').setup {} end },
  { 'wakatime/vim-wakatime', lazy = false },
  { 'Exafunction/codeium.vim', event = 'BufEnter' },
})

require('telescope').load_extension('projects')
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})

vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gr", function() require("trouble").toggle("lsp_references") end)

vim.keymap.set({ 'n', 'v', 'i', 't' }, '<C-\\>', '<cmd>ToggleTerm direction=float<cr>', {})
vim.keymap.set({ 'n', 'v' }, '<leader>e', '<cmd>Neotree toggle<cr>', {})
vim.keymap.set({ 'n', 'v' }, '<leader>/', 'gcc', { remap = true })

-- LSP
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(_, bufnr) lsp_zero.default_keymaps({ buffer = bufnr }) end)

local cmp = require('cmp')
cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
}

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

require('lspconfig').nil_ls.setup{}
require('lspconfig').nushell.setup{}
require('lspconfig').lua_ls.setup {
  settings = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          align_function_params = "false",
          align_continuous_assign_statement = "false",
          align_continuous_rect_table_field = "false",
          align_array_table = "false",
          align_continuous_inline_comment = "false",
        },
      },
    },
  }
}

-- configs
vim.cmd.colorscheme('gruvbox')
vim.opt.clipboard = 'unnamedplus'
