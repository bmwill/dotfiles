local status_ok, hop = pcall(require, "hop")
if not status_ok then
  return
end

hop.setup({ keys = "asdghklqwertyuiopzxcvbnmfj;" })

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<leader><leader>w", ":HopWordAC<CR>", opts)
keymap("n", "<leader><leader>b", ":HopWordBC<CR>", opts)
keymap("n", "<leader><leader>j", ":HopLineStartAC<CR>", opts)
keymap("n", "<leader><leader>k", ":HopLineStartBC<CR>", opts)
keymap("n", "s", ":HopChar1<CR>", opts)
keymap("n", "S", ":HopChar2<CR>", opts)
keymap("n", "gs", ":HopChar1MW<CR>", opts)
keymap("n", "gS", ":HopChar2MW<CR>", opts)
