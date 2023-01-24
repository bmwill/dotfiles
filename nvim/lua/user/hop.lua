local status_ok, hop = pcall(require, "hop")
if not status_ok then
  return
end

hop.setup({ keys = "asdghklqwertyuiopzxcvbnmfj;" })

vim.keymap.set("n", "<leader><leader>w", ":HopWordAC<CR>")
vim.keymap.set("n", "<leader><leader>b", ":HopWordBC<CR>")
vim.keymap.set("n", "<leader><leader>j", ":HopLineStartAC<CR>")
vim.keymap.set("n", "<leader><leader>k", ":HopLineStartBC<CR>")
vim.keymap.set("n", "s", ":HopChar1<CR>")
vim.keymap.set("n", "S", ":HopChar2<CR>")
vim.keymap.set("n", "gs", ":HopChar1MW<CR>")
vim.keymap.set("n", "gS", ":HopChar2MW<CR>")
