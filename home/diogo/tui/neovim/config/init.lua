local cmp = require("cmp")

cmp.setup({
  formatting = {
    format = function(entry, vim_item)
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
      })[entry.source.name]
      return vim_item
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = {
      border = "rounded",
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      max_width = 80,
      max_height = 20,
    },
  },
  mapping = {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  sources = cmp.config.sources({
    {
      name = "nvim_lsp",
      ---@param entry cmp.Entry
      ---@param ctx cmp.Context
      entry_filter = function(entry, ctx)
        if ctx.filetype ~= "vue" then
          return true
        end

        local cursor_before_line = ctx.cursor_before_line
        if cursor_before_line:sub(-1) == "@" then
          return entry.completion_item.label:match("^@")
        elseif cursor_before_line:sub(-1) == ":" then
          return entry.completion_item.label:match("^:") and not entry.completion_item.label:match("^:on%-")
        else
          return true
        end
      end,
    },
    { name = "buffer" },
    { name = "path" },
    { name = "luasnip" },
    { name = "nvim_lua" },
  }),
  experimental = {
    ghost_text = false,
  },
})

cmp.event:on("menu_closed", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
end)

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    vue = { "prettierd", "prettier", stop_after_first = true },
    astro = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    nix = { "nixfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ timeout_ms = 500, lsp_format = "fallback" })
end, { desc = "Format buffer or selection" })

require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 100,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%d-%m-%Y> - <summary>",
})

local navic = require("nvim-navic")

navic.setup({
  separator = " › ",
  highlight = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, event.buf)
    end
    vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
  end,
})

local lsp_present, lspconfig = pcall(require, "lspconfig")

if not lsp_present then
  vim.notify("lspconfig not present", vim.log.levels.ERROR)
  return
end

vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
})

local servers = {
  -- keep-sorted start block=yes newline_separated=yes
  astro = {
    settings = {
      typescript = {
        tsdk = vim.fn.expand("~") .. "/.npm-global/lib/node_modules/typescript/lib",
      },
    },
  },

  emmet_language_server = {
    filetypes = {
      "vue",
      "astro",
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "typescriptreact",
    },
  },

  gopls = {},

  jsonls = {
    settings = {
      json = {
        validate = { enable = true },
        schemas = {
          {
            fileMatch = { "package.json" },
            url = "https://www.schemastore.org/package.json",
          },
          {
            fileMatch = { "tsconfig*.json" },
            url = "https://www.schemastore.org/tsconfig.json",
          },
        },
      },
    },
  },

  just = {},

  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        hint = { enable = true },
      },
    },
  },

  nil_ls = {
    cmd = { "nil" },
    settings = {
      ["nil"] = {
        diagnostics = {
          bindingEndHintMinLines = 2,
        },
        nix = { maxMemoryMB = nil },
      },
    },
  },

  rust_analyzer = {},

  sourcekit = {},

  tailwindcss = {
    filetypes = {
      "vue",
      "astro",
      "javascriptreact",
      "typescriptreact",
      "html",
      "css",
    },
  },

  vtsls = {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_dir = function(fname)
      local root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json")(fname)
      if root_dir then
        local node_modules_index = root_dir:find("node_modules", 1, true)
        if node_modules_index and node_modules_index > 0 then
          root_dir = root_dir:sub(1, node_modules_index - 2)
        end
      end
      return root_dir
    end,
    settings = {
      typescript = {
        tsdk = vim.fn.expand("~") .. "/.npm-global/lib/node_modules/typescript/lib",
      },
    },
  },

  vue_ls = {},

  yamlls = {
    settings = {
      yaml = {
        completion = true,
        validate = true,
        suggest = {
          parentSkeletonSelectedFirst = true,
        },
        schemas = {
          ["https://www.schemastore.org/github-workflow.json"] = ".github/workflows/*",
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
          "docker-compose*.{yml,yaml}",
        },
      },
      redhat = {
        telemetry = {
          enable = false,
        },
      },
    },
  },
  -- keep-sorted end
}

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
})

for server, config in pairs(servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  max_width = 80,
})

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "LSP Hover Documentation" })

require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = "auto",
    globalstatus = true,
    component_separators = "|",
    section_separators = "",
    disabled_filetypes = {
      statusline = { "NvimTree" },
      winbar = { "NvimTree" },
    },
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return str:sub(1, 1)
        end,
      },
    },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {
    lualine_c = {
      {
        "navic",
        cond = function()
          return require("nvim-navic").is_available()
        end,
      },
    },
  },
  inactive_winbar = {},
  extensions = {},
})
vim.opt.showmode = false
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.opt.completeopt = { "menu", "menuone", "noselect" }

require("mini.pairs").setup()

require("mini.notify").setup({
  window = {
    config = { border = "rounded" },
    winblend = 0,
    lsp_progress = {
      enable = true,
    },
  },
})

vim.notify = require("mini.notify").make_notify()
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft == "" or vim.bo[args.buf].buftype ~= "" then
      return
    end

    local fn = vim.fn.fnamemodify(args.file, ":t")
    vim.notify("Saved " .. fn, vim.log.levels.INFO, { title = "File Written" })
  end,
})

require("mini.move").setup({
  mappings = {
    left = "<M-h>",
    right = "<M-l>",
    down = "<M-j>",
    up = "<M-k>",
    line_left = "<M-h>",
    line_right = "<M-l>",
    line_down = "<M-j>",
    line_up = "<M-k>",
  },
  options = {
    reindent_linewise = true,
  },
})

require("mini.comment").setup({
  options = {
    custom_commentstring = nil,
    ignore_blank_line = false,
    start_of_line = false,
    pad_comment_parts = true,
  },
  mappings = {
    comment = "gc",
    comment_line = "gcc",
  },
})

require("mini.surround").setup({
  mappings = {
    add = "S",      -- Add surrounding in Normal and Visual modes
    delete = "ds",  -- Delete surrounding
    find = "sf",    -- Find surrounding (to the right)
    find_left = "sF", -- Find surrounding (to the left)
    highlight = "sh", -- Highlight surrounding
    replace = "cs", -- Replace surrounding
  },
})

require("telescope").setup({
  defaults = {
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_ignore_patterns = { "bun.lock" },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>", opts)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fl",
  "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>",
  opts
)
vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>fd", "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ft", "<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>fi", "<cmd>Telescope lsp_implementations<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>Telescope lsp_document_symbols<CR>", opts)

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  renderer = {
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = true,
        git = false,
        modified = true,
      },
    },
  },
  view = {
    width = 30,
    side = "right",
  },
  disable_netrw = true,
  hijack_netrw = true,
  update_focused_file = { enable = true },
  filters = { dotfiles = false },
  git = { enable = true },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})

vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { desc = "Focus file explorer" })

require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" then
      vim.treesitter.start()
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

require("cord").setup({})

require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  custom_highlights = function(colors)
    return {
      TelescopeBorder = { fg = colors.blue },
      TelescopePromptBorder = { fg = colors.blue },
      TelescopeResultsBorder = { fg = colors.blue },
      TelescopePreviewBorder = { fg = colors.blue },
      TelescopeNormal = { bg = "NONE" },
      TelescopePromptNormal = { bg = "NONE" },
      TelescopeResultsNormal = { bg = "NONE" },
      TelescopePreviewNormal = { bg = "NONE" },
      TelescopeTitle = { fg = colors.blue },
      MiniNotifyNormal = { bg = "NONE" },
      MiniNotifyBorder = { bg = "NONE", fg = colors.blue },
      MiniNotifyTitle = { bg = "NONE", fg = colors.blue },
    }
  end,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    telescope = {
      enabled = true,
    },
    mini = {
      enabled = true,
      indentscope_color = "",
    },
  },
})
vim.cmd("colorscheme catppuccin")
