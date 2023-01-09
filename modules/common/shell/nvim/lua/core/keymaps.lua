local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local function extend(desc) return vim.tbl_deep_extend("force", { desc = desc }, opts) end

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
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
keymap("n", "<C-s>", "<cmd>w!<cr>", extend "Force write")
keymap("n", "<C-q>", "<cmd>q!<cr>", extend "Force quit")

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", extend "Move to left split")
keymap("n", "<C-j>", "<C-w>j", extend "Move to below split")
keymap("n", "<C-k>", "<C-w>k", extend "Move to above split")
keymap("n", "<C-l>", "<C-w>l", extend "Move to right split")

-- Resize with arrows
keymap("n", "<C-Up>", "<cmd>resize -2<cr>", extend "Resize split up")
keymap("n", "<C-Down>", "<cmd>resize +2<cr>", extend "Resize split down")
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", extend "Resize split left")
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", extend "Resize split right")

-- Navigate buffers
keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", extend "Next buffer tab")
keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", extend "Previous buffer tab")

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<esc>", extend "Exit insert mode")

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", extend "unindent line")
keymap("v", ">", ">gv", extend "indent line")

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<cr>==", extend "Move text down")
keymap("v", "<A-k>", ":m .-2<cr>==", extend "Move text up")

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<cr>gv-gv", extend "Move text down")
keymap("x", "K", ":move '<-2<cr>gv-gv", extend "Move text up")
keymap("x", "<A-k>", ":move '<-2<cr>gv-gv", extend "Move text up")
keymap("x", "<A-j>", ":move '>+1<cr>gv-gv", extend "Move text down")

-- Terminal --
-- Better terminal navigation
keymap("t", "<esc>", "<C-\\><C-n>", extend "Terminal normal mode")
keymap("t", "jk", "<C-\\><C-n>", extend "Terminal normal mode")
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", extend "Terminal left window navigation")
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", extend "Terminal down window navigation")
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", extend "Terminal up window navigation")
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", extend "Terminal right window naviation")
