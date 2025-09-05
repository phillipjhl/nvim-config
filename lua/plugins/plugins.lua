-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
	{
		-- {'Shatur/neovim-ayu'},
		-- disabled below
		{ "folke/noice.nvim", enabled = false },
		-- end disbaled
		-- start overrides
		{ "folke/which-key.nvim", enabled = false },
		{ "folke/todo-comments.nvim", enabled = false },
		{
			"folke/snack",
			enabled = false,
			opts = {
				scroll = { enabled = false },
				notifier = { enabled = false },
				dashboard = { enabled = false },
			},
		},
		-- end
		{ "folke/tokyonight.nvim" },
		{
			"nvim-treesitter/nvim-treesitter",
			opts = function(_, opts)
				opts.ensure_installed = {
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
					"markdown",
				}
				opts.build = ":TSUpdate"

				opts.ignore_install = {}
				opts.highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				}
				opts.indent = { enable = true }
			end,
		},
		{ "kyazdani42/nvim-web-devicons" },
		{
			"nvim-lualine/lualine.nvim",
			opts = {
				icons_enabled = true,
				theme = "tokyonight-night",
				component_separators = "|",
				section_separators = "",
			},
		},
		{ "nvim-treesitter/playground" },
		{ "nvim-lua/plenary.nvim" },
		{ "tpope/vim-fugitive" },
		{ "neovim/nvim-lspconfig" },
		{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{
			"hrsh7th/nvim-cmp",
			opts = {
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
			},
		},
		{ "hrsh7th/vim-vsnip" },
		{ "L3MON4D3/LuaSnip" },
		{
			"nvim-telescope/telescope.nvim",
			opts = {
				pickers = {
					find_files = {
						theme = "dropdown",
					},
				},
			},
		},
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "airblade/vim-gitgutter" },
		{ "sindrets/diffview.nvim" },
		{ "numToStr/Comment.nvim" },
		{
			"christoomey/vim-tmux-navigator",
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
			},
		},
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
		{ "github/copilot.vim" },
	},
}
