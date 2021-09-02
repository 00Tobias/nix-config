{ config, pkgs, ... }:

with builtins;

# Workaround for home-manager not supporting init.lua yet
# Courtesy of Neovitality
let
  wrapLuaConfig = luaConfig: ''
    lua << EOF
    ${luaConfig}
    EOF
  '';
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    extraConfig = wrapLuaConfig (readFile ./init.lua);

    plugins = with pkgs.vimPlugins; [
      vim-nix
      plenary-nvim
      nvim-web-devicons
      { plugin = one-nvim; config = "lua vim.g.colors_name = 'one-nvim'"; }
      { plugin = feline-nvim; config = wrapLuaConfig (readFile ./config/feline-nvim-config.lua); }
      { plugin = barbar-nvim; config = wrapLuaConfig (readFile ./config/barbar-nvim-config.lua); }
      { plugin = gitsigns-nvim; config = "lua require('gitsigns').setup()"; }
      { plugin = specs-nvim; config = wrapLuaConfig (readFile ./config/specs-nvim-config.lua); }
      cmd-parser-nvim
      { plugin = range-highlight-nvim; config = "lua require'range-highlight'.setup{}"; }
      { plugin = nvim-tree-lua; config = wrapLuaConfig (readFile ./config/nvim-tree-lua-config.lua); }
      { plugin = nvim-colorizer-lua; config = "lua require'colorizer'.setup()"; }
      { plugin = nvim-ts-rainbow; config = "lua require'nvim-treesitter.configs'.setup { rainbow = { enable = true, extended_mode = true } }"; }
      { plugin = indent-blankline-nvim; config = "lua require('indent_blankline').setup { show_current_context = true }"; }
      todo-comments-nvim

      { plugin = lightspeed-nvim; config = wrapLuaConfig (readFile ./config/lightspeed-nvim-config.lua); }
      { plugin = numb-nvim; config = wrapLuaConfig (readFile ./config/numb-nvim-config.lua); }
      { plugin = registers-nvim; config = wrapLuaConfig (readFile ./config/registers-nvim-config.lua); }
      { plugin = kommentary; config = wrapLuaConfig (readFile ./config/kommentary-config.lua); }

      { plugin = neorg; config = wrapLuaConfig (readFile ./config/neorg-config.lua); }
      { plugin = neogit; config = wrapLuaConfig (readFile ./config/neogit-config.lua); }

      {
        plugin = nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars);
        config = wrapLuaConfig (readFile ./config/nvim-treesitter-config.lua);
      }

      { plugin = nvim-lspconfig; config = wrapLuaConfig (readFile ./config/nvim-lspconfig-config.lua); }
      { plugin = lspkind-nvim; config = wrapLuaConfig (readFile ./config/lspkind-nvim-config.lua); }
      { plugin = lsp_signature-nvim; config = "lua 'lsp_signature'.setup()"; }

      { plugin = telescope-nvim; config = wrapLuaConfig (readFile ./config/telescope-nvim-config.lua); }
      { plugin = telescope-fzy-native-nvim; config = "lua require('telescope').load_extension('fzy_native')"; }
    ];

    extraPackages = with pkgs; [
      git
      fd
      bat
      (ripgrep.override { withPCRE2 = true; })
      gnumake
      cmake

      # Lua
      luajit
      sumneko-lua-language-server
      stylua

      # Nix
      rnix-lsp
      nixpkgs-fmt

      # C
      clang
      ccls

      # Rust
      rust-analyzer
      cargo
      rustc
      rustfmt

      # Zig
      zls
    ];

    extraPython3Packages = (ps: with ps; [
      python-lsp-server
      python-lsp-black
      black
      pyflakes
      isort
      pytest
    ]);
  };
}
