-- return {
--   {
--     "hrsh7th/cmp-nvim-lsp"
--   },
--   {
--     "L3MON4D3/LuaSnip",
--     dependencies = {
--       "saadparwaiz1/cmp_luasnip",
--       "rafamadriz/friendly-snippets",
--     },
--   },
--   {
--     "hrsh7th/nvim-cmp",
--     config = function()
--       local cmp = require("cmp")
--       require("luasnip.loaders.from_vscode").lazy_load()
--
--       cmp.setup({
--         snippet = {
--           expand = function(args)
--             require("luasnip").lsp_expand(args.body)
--           end,
--         },
--         window = {
--           completion = cmp.config.window.bordered(),
--           documentation = cmp.config.window.bordered(),
--         },
--         mapping = cmp.mapping.preset.insert({
--           ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--           ["<C-f>"] = cmp.mapping.scroll_docs(4),
--           ["<C-Space>"] = cmp.mapping.complete(),
--           ["<C-e>"] = cmp.mapping.abort(),
--           ["<CR>"] = cmp.mapping.confirm({ select = true }),
--         }),
--         sources = cmp.config.sources({
--           { name = "nvim_lsp" },
--           { name = "luasnip" }, -- For luasnip users.
--         }, {
--           { name = "buffer" },
--         }),
--       })
--     end,
--   },
-- }
return {
  "hrsh7th/nvim-cmp",
  lazy = true,
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- Buffer completions
    "hrsh7th/cmp-path", -- Path completions
    "hrsh7th/cmp-cmdline", -- Cmdline completions
    "hrsh7th/cmp-nvim-lsp", -- LSP completions
    "hrsh7th/cmp-nvim-lsp-document-symbol", -- For textDocument/documentSymbol

    -- Snippets
    "saadparwaiz1/cmp_luasnip", -- snippet completions
    "L3MON4D3/LuaSnip", --snippet engine
    "rafamadriz/friendly-snippets", -- a bunch of snippets to

    -- Misc
    "lukas-reineke/cmp-under-comparator", -- Tweak completion order
    "f3fora/cmp-spell",
  },
  config = function()
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if not cmp_status_ok then
      return
    end

    local snip_status_ok, luasnip = pcall(require, "luasnip")
    if not snip_status_ok then
      return
    end

    local cmp_buffer_ok, cmp_buffer = pcall(require, "cmp_buffer")
    if not cmp_buffer_ok then
      return
    end

    local cmp_under_comparator_ok, cmp_under_comparator = pcall(require, "cmp-under-comparator")
    if not cmp_under_comparator_ok then
      return
    end

    -- Required or snippets will not be added to the completion options
    require("luasnip/loaders/from_vscode").lazy_load()

    local check_backspace = function()
      local col = vim.fn.col(".") - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
    end

    local kind_icons = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Event = "",
      Operator = "",
      TypeParameter = "",
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)

          vim_item.menu = ({
            buffer = "[Buffer]",
            luasnip = "[Snippet]",
            nvim_lsp = "[LSP]",
            spell = "[Spelling]",
          })[entry.source.name]

          return vim_item
        end,
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer", keyword_length = 3 },
        {
          name = "spell",
          option = {
            keep_all_entries = false,
            enable_in_context = function()
              return require("cmp.config.context").in_treesitter_capture("spell")
            end,
          },
        },
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          function(...)
            return cmp_buffer:compare_locality(...)
          end,
          -- require("copilot_cmp.comparators").prioritize,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      window = {
        documentation = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
      },
      experimental = {
        ghost_text = false,
        native_menu = false,
      },
      enabled = function()
        local in_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
        if in_prompt then -- this will disable cmp in the Telescope window (taken from the default config)
          return false
        end
        local context = require("cmp.config.context")
        return not (context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
      end,
    })

    cmp.setup.cmdline(":", {
      completion = { autocomplete = false },
      sources = {
        { name = "cmdline" },
      },
      mapping = cmp.mapping.preset.cmdline({}),
    })

    cmp.setup.cmdline("/", {
      completion = { autocomplete = false },
      sources = cmp.config.sources({
        { name = "buffer" },
      }, {
        { name = "nvim_lsp_document_symbol" },
      }),
      mapping = cmp.mapping.preset.cmdline({}),
    })
  end,
}
