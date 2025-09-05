require("config/lazy")

vim.opt.showmode = false

---
-- LSP
---
-- require("lsp-zero")
local lspconfig = require("lspconfig")
-- `on_attach` callback will be called after a language server
-- instance has been attached to an open buffer with matching filetype
-- here we're setting key mappings for hover documentation, goto definitions, goto references, etc
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true }

	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cd", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
lspconfig.elixirls.setup({
	capabilities = capabilities,
	-- MacOS
	cmd = { "/opt/homebrew/bin/elixir-ls" },
	-- Linux
	-- cmd = { "/home/phillipjhl/.elixir-ls/language_server.sh" },
	on_attach = on_attach,
	settings = {
		elixirLS = {
			dialyzerEnabled = true,
			incrementalDialyzer = true,
			suggestSpecs = true,
		},
	},
})
lspconfig.gopls.setup({
	on_attach = on_attach,
	cmd = { "~/.asdf/shims/gopls" },
	-- cmd = { "/usr/bin/gopls"}
})
lspconfig.bashls.setup({})
lspconfig.clangd.setup({})
lspconfig.bashls.setup({ {
	on_attach = on_attach,
	cmd = { "bash-language-server", "start" },
} })

---
-- Telescope
--
require("telescope").load_extension("fzf")
