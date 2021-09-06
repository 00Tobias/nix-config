require('formatter').setup({
  filetype = {
    nix = {
        function()
          return {
            exe = "nixpkgs-fmt",
            stdin = true
          }
        end
    },
    lua = {
        function()
          return {
            exe = "stylua",
            args = { "--indent-type", "'Spaces'", "--indent-width", 4, "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
            stdin = true
          }
        end
    },
    rust = {
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    },
    sh = {
       function()
         return {
           exe = "shfmt",
           args = { "-i", 2 },
           stdin = true,
         }
       end,
     },
    zig = {
       function()
         return {
           exe = "zig fmt",
           args = { "--stid" },
           stdin = true,
         }
       end,
     },
  }
})
