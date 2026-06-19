local map = vim.keymap.set

-- =============================================================================
-- Basic Mappings
-- =============================================================================

-- Better Navigation (Wrap aware)
-- Makes movement smoother on long wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Clear search highlight with <Esc>
map({ "i", "n" }, "<Esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Save file with <C-s>
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map({ "i", "x", "n", "s" }, "<C-w>", "<cmd>q<cr>", { desc = "Close Window" })

-- Exit terminal mode easily
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Delete a word backwards
map("n", "dw", 'vb"_d', { desc = "Delete Word Backwards" })

-- =============================================================================
-- Window Management (Replaces old 's' mappings to fix Flash conflict)
-- =============================================================================

-- Split windows
map("n", "ss", "<cmd>split<cr>", { desc = "Split Window Below" })
map("n", "sv", "<cmd>vsplit<cr>", { desc = "Split Window Right" })

-- Move between windows (sh, sj, sk, sl)
map("n", "sh", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("n", "sj", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("n", "sk", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("n", "sl", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- Move between windows (Ctrl + hjkl)
map("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- Resize windows (Ctrl + Arrow Keys)
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- =============================================================================
-- Buffer Navigation
-- =============================================================================

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })

-- =============================================================================
-- Editor Enhancements
-- =============================================================================

-- Move Lines (Alt + j/k) - VS Code Style
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Better Indenting (Stays in visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select All" })

-- =============================================================================
-- Tabs (Optional if you prefer tabs over buffers)
-- =============================================================================
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
