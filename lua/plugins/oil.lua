return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { "<leader>o", "<cmd>Oil<cr>", desc = "Oil" },
      {
        "<leader>O",
        function()
          require("oil").open_float()
        end,
        desc = "Oil float",
      },
    },
  },
}
