-- Shorten function name
local keymap = vim.keymap.set

-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Standed operations
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "No highlight" })
keymap("n", "<C-s>", "<cmd>w!<cr>", { desc = "Force write" })
keymap("n", "<C-q>", "<cmd>q!<cr>", { desc = "Force quit" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Resize with arrows
keymap("n", "<M-k>", "<cmd>resize -2<cr>", { desc = "Resize split up" })
keymap("n", "<M-j>", "<cmd>resize +2<cr>", { desc = "Resize split down" })
keymap("n", "<M-l>", "<cmd>vertical resize -2<cr>", { desc = "Resize split left" })
keymap("n", "<M-h>", "<cmd>vertical resize +2<cr>", { desc = "Resize split right" })

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<esc>", { desc = "Exit insert mode" })

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", { desc = "unindent line" })
keymap("v", ">", ">gv", { desc = "indent line" })

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<cr>==", { desc = "Move text down" })
keymap("v", "<A-k>", ":m .-2<cr>==", { desc = "Move text up" })

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<cr>gv-gv", { desc = "Move text down" })
keymap("x", "K", ":move '<-2<cr>gv-gv", { desc = "Move text up" })
keymap("x", "<A-k>", ":move '<-2<cr>gv-gv", { desc = "Move text up" })
keymap("x", "<A-j>", ":move '>+1<cr>gv-gv", { desc = "Move text down" })

-- Terminal --
-- Better terminal navigation
keymap("t", "<esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
keymap("t", "jk", "<C-\\><C-n>", { desc = "Terminal normal mode" })
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Terminal left window navigation" })
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Terminal down window navigation" })
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Terminal up window navigation" })
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Terminal right window naviation" })
