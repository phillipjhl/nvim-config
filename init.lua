-- Require other modules
require("init")

-- ========================================================================== --
-- ==                               COMMANDS                               == --
-- ========================================================================== --

vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})

local group = vim.api.nvim_create_augroup('user_cmds', {clear = true})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = group,
  callback = function()
    vim.highlight.on_yank({higroup = 'Visual', timeout = 200})
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'help', 'man'},
  group = group,
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})


-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  -- You can "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
	{'Shatur/neovim-ayu'},
	{'folke/tokyonight.nvim'},
	{'nvim-treesitter/nvim-treesitter'},
  	{'kyazdani42/nvim-web-devicons'},
  	{'nvim-lualine/lualine.nvim'},
	{'nvim-treesitter/playground'},
	{'nvim-lua/plenary.nvim'},
	{'tpope/vim-fugitive'},
	{'neovim/nvim-lspconfig'},
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
	{'hrsh7th/vim-vsnip'},
    {'L3MON4D3/LuaSnip'},
  	{'nvim-telescope/telescope.nvim', tag = '0.1.8'},
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{'airblade/vim-gitgutter'},
	{'sindrets/diffview.nvim'},
	{'numToStr/Comment.nvim'},
	{'christoomey/vim-tmux-navigator',
		cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  }
	},
	{"github/copilot.vim"}
})


-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

---
-- Colorscheme
---

vim.cmd[[colorscheme tokyonight-night]]
-- lualine.nvim (statusline)
---
vim.opt.showmode = false
require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'tokyonight-night',
    component_separators = '|',
    section_separators = '',
  },
})

---
-- LSP
---
require('lsp-zero')
local lspconfig = require('lspconfig')
-- `on_attach` callback will be called after a language server
-- instance has been attached to an open buffer with matching filetype
-- here we're setting key mappings for hover documentation, goto definitions, goto references, etc
-- you may set those key mappings based on your own preference
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})
lspconfig.elixirls.setup({
  capabilities = capabilities,
  cmd = { "/opt/homebrew/bin/elixir-ls" },
  on_attach = on_attach
})
lspconfig.gopls.setup({
	on_attach = on_attach,
  cmd = { "~/.asdf/shims/gopls"}
    -- cmd = { "/usr/bin/gopls"}
})
lspconfig.bashls.setup{}

--
-- Cmp
--
require('cmp').setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end
	}
    
})

---
-- Telescope
--
require('telescope').setup({
  pickers = {
    find_files = {
      theme = "dropdown",
    }
  }
})
require('telescope').load_extension('fzf')

---
-- Treesitter
--- 
require('nvim-treesitter').setup({
    build = ":TSUpdate",
})

local configs = require("nvim-treesitter.configs")

configs.setup({
          ensure_installed = {
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"bash",
			"erlang",
			"elixir",
			"heex",
			"eex",
			"javascript",
			"html",
			"typescript",
			"go",
			"python",
		        "yaml",
		        "json",
		        "scss",
		        "rust",
		        "dockerfile",
		        "cpp",
		        "graphql",
		        "markdown"
	  },
	  ignore_install = { },
          highlight = {
	    enable = true,
            additional_vim_regex_highlighting = false,
	  },
          indent = { enable = true },
        })

---
-- Navigator
--

---
-- Commenter
---
require('Comment').setup()

---
-- CMP
---
