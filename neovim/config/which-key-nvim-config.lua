local wk = require("which-key")

require("which-key").setup {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = false,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  window = {
    border = "single",
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "left",
  },
  show_help = true,
  triggers = "auto",
}

wk.register({
  b = {
    name = "Buffers",
    j = { "<cmd>BufferPick<cr>", "Jump" },
    f = { "<cmd>Telescope buffers<cr>", "Find" },
    b = { "<cmd>b#<cr>", "Previous" },
    w = { "<cmd>BufferWipeout<cr>", "Wipeout" },
    e = { "<cmd>BufferCloseAllButCurrent<cr>", "Close all but current", },
    h = { "<cmd>BufferCloseBuffersLeft<cr>", "Close all to the left" },
    l = { "<cmd>BufferCloseBuffersRight<cr>", "Close all to the right", },
    D = { "<cmd>BufferOrderByDirectory<cr>", "Sort by directory", },
    L = { "<cmd>BufferOrderByLanguage<cr>", "Sort by language", },
  },
  g = {
    name = "Git",
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk", },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    C = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit(for current file)", },
    d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Git Diff", },
  },
  f = {
    name = "Find",
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    f = { "<cmd>Telescope find_files<cr>", "Files" },
    h = { "<cmd>Telescope help_tags<cr>", "Help Pages" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    t = { "<cmd>Telescope live_grep<cr>", "Text" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
  },
}, { prefix = "<leader>" })
