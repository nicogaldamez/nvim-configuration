return {
  "nvim-neotest/neotest",
  dependencies = {
    "olimorris/neotest-rspec",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter"
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-rspec")
      }
    })
    vim.api.nvim_set_keymap("n", "<Leader>R", ":lua require('neotest').run.run()<CR>", {})
    vim.api.nvim_set_keymap("n", "<Leader>t", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", {})
    vim.api.nvim_set_keymap("n", "<Leader>ts", ":lua require('neotest').summary.toggle()<CR>", {})
    vim.api.nvim_set_keymap("n", "<Leader>l", ":lua require('neotest').run.run_last()<CR>", {})
    vim.api.nvim_set_keymap("n", "<Leader>rS", ":lua require('neotest').run.stop()<CR>", {})
    vim.api.nvim_set_keymap("n", "<Leader>ro", ":lua require('neotest').output.open()<CR>", {})
    vim.api.nvim_set_keymap("n", "<Leader>rO", ":lua require('neotest').output.open({ enter = true })<CR>", {})
    vim.api.nvim_set_keymap("n", "<Leader>rp", ":lua require('neotest ).output_panel.toggle()<CR>", {})
  end
}
