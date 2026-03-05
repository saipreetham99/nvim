return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "float",
      float_opts = {
        border = "rounded",
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.85)
        end,
        winblend = 0,
      },
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      close_on_exit = false,
      shade_terminals = false,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      -- One reusable floating terminal instance
      local float_term = Terminal:new({
        direction = "float",
        hidden = true,
        float_opts = opts.float_opts,
      })

      -- Optional split terminals
      local hsplit_term = Terminal:new({
        direction = "horizontal",
        hidden = true,
        size = 15,
      })

      local vsplit_term = Terminal:new({
        direction = "vertical",
        hidden = true,
        size = function()
          return math.floor(vim.o.columns * 0.4)
        end,
      })

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc })
      end

      -- LazyVim-style leader maps
      map("n", "<leader>tt", function()
        float_term:toggle()
      end, "Terminal (Float)")

      map("n", "<leader>th", function()
        hsplit_term:toggle()
      end, "Terminal (Horizontal)")

      map("n", "<leader>tv", function()
        vsplit_term:toggle()
      end, "Terminal (Vertical)")

      -- Terminal buffer behavior + keymaps
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        callback = function(args)
          local buf = args.buf
          local win = vim.api.nvim_get_current_win()

          -- window-local options (must use vim.wo)
          vim.wo[win].number = false
          vim.wo[win].relativenumber = false
          vim.wo[win].signcolumn = "no"

          -- buffer-local options (fine with vim.bo)
          vim.bo[buf].buflisted = false

          -- Terminal mode helpers
          vim.keymap.set("t", "<esc>", [[<c-\><c-n>]], { buffer = buf, silent = true })
          vim.keymap.set("t", "<c-h>", [[<c-\><c-n><c-w>h]], { buffer = buf, silent = true })
          vim.keymap.set("t", "<c-j>", [[<c-\><c-n><c-w>j]], { buffer = buf, silent = true })
          vim.keymap.set("t", "<c-k>", [[<c-\><c-n><c-w>k]], { buffer = buf, silent = true })
          vim.keymap.set("t", "<c-l>", [[<c-\><c-n><c-w>l]], { buffer = buf, silent = true })

          -- Press q to close the terminal window (does not kill the job)
          -- Works from terminal mode too.
          vim.keymap.set("t", "<c-q>", [[<c-\><c-n>:close<cr>]], { buffer = buf, silent = true })
          vim.keymap.set("n", "q", ":close<cr>", { buffer = buf, silent = true })
        end,
      })
    end,
  },
}
