local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

nvim_tree.setup({
  disable_netrw = false,
  hijack_netrw = true,
  diagnostics = {
    enable = true,
  },
  git = {
    enable = false,
  },
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")
