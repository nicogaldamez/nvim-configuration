return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", "tmp", ".git", "dist", "build" }
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      vim.keymap.set("n", "<C-F>", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
      vim.keymap.set("n", "<leader>o", builtin.oldfiles, {})

      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("live_grep_args")
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown { }
          }
        }
      }
      require("telescope").load_extension("ui-select")
    end
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
}
