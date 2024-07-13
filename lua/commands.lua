---
-- Commands
--

-- Save the current buffer mapping
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<ESC>:w<CR>i', { noremap = true })
