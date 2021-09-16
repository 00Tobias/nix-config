{ config, pkgs, ... }: {

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.configFile = {
    # Commented out because home-manager still generates init.vim
    # https://github.com/nix-community/home-manager/issues/1907
    # "nvim/init.lua".text = ''
    #   vim.g["aniseed#env"] = {
    #     module = "init",
    #     compile = true
    #   }
    # '';

    # TODO: Change this so that it doesn't put ./fnl into the nvim conf folder
    "nvim/fnl" = {
      recursive = true;
      source = ./fnl;
      onChange = ''
        nvim --headless -u NONE \
          -c "let &runtimepath = &runtimepath . ',${pkgs.vimPlugins.aniseed},' . getcwd()" \
          -c "lua require('aniseed.compile').glob('**/*.fnl', '${./fnl}', '${config.xdg.configHome}/nvim/lua')" \
          +q
      '';
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      lua << EOF
      vim.g["aniseed#env"] = {
        module = "init",
        compile = true
      }
      EOF
    '';

    plugins = with pkgs.vimPlugins; [
      # Needed to load my config
      aniseed
      plenary-nvim

      # Languages
      fennel-vim
      vim-nix
      # { plugin = zig-vim; config = "lua vim.g.zig_fmt_autosave = 0"; }

      # Theming
      nvim-web-devicons
      # { plugin = nvim-base16; config = wrapLuaConfig (import ./config/nvim-base16-config.nix { }); }
      # { plugin = feline-nvim; config = wrapLuaConfig (readFile ./config/feline-nvim-config.lua); }
      # { plugin = bufferline-nvim; config = wrapLuaConfig (readFile ./config/bufferline-nvim-config.lua); }

      # { plugin = gitsigns-nvim; config = "lua require('gitsigns').setup()"; }
      which-key-nvim
      # { plugin = specs-nvim; config = wrapLuaConfig (readFile ./config/specs-nvim-config.lua); }
      # cmd-parser-nvim
      # { plugin = range-highlight-nvim; config = "lua require'range-highlight'.setup{}"; }
      # { plugin = nvim-tree-lua; config = wrapLuaConfig (readFile ./config/nvim-tree-lua-config.lua); }
      # { plugin = nvim-colorizer-lua; config = "lua require'colorizer'.setup()"; }
      # { plugin = nvim-ts-rainbow; config = "lua require'nvim-treesitter.configs'.setup { rainbow = { enable = true, extended_mode = true } }"; }
      # { plugin = indent-blankline-nvim; config = "lua require('indent_blankline').setup { space_char_blankline = ' ', show_current_context = true }"; }
      todo-comments-nvim

      # { plugin = lightspeed-nvim; config = wrapLuaConfig (readFile ./config/lightspeed-nvim-config.lua); }
      # { plugin = numb-nvim; config = wrapLuaConfig (readFile ./config/numb-nvim-config.lua); }
      # { plugin = registers-nvim; config = wrapLuaConfig (readFile ./config/registers-nvim-config.lua); }
      # { plugin = kommentary; config = wrapLuaConfig (readFile ./config/kommentary-config.lua); }
      # { plugin = nvim-autopairs; config = "lua require('nvim-autopairs').setup{}"; }
      # { plugin = pkgs.nur.repos.toxic-nur.vimPlugins.tabout-nvim; config = wrapLuaConfig (readFile ./config/tabout-nvim-config.lua); }

      # { plugin = neorg; config = wrapLuaConfig (readFile ./config/neorg-config.lua); }
      # https://github.com/TimUntersberger/neogit/issues/206
      # { plugin = neogit; config = wrapLuaConfig (readFile ./config/neogit-config.lua); }

      # {
      #   plugin = nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars);
      #   config = wrapLuaConfig (readFile ./config/nvim-treesitter-config.lua);
      # }

      # { plugin = nvim-lspconfig; config = wrapLuaConfig (readFile ./config/nvim-lspconfig-config.lua); }
      # { plugin = lspkind-nvim; config = wrapLuaConfig (readFile ./config/lspkind-nvim-config.lua); }
      # { plugin = lsp_signature-nvim; config = "lua require('lsp_signature').setup()"; }
      # { plugin = formatter-nvim; config = wrapLuaConfig (readFile ./config/formatter-nvim-config.lua); }

      telescope-nvim
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
      luaformatter

      # Fennel
      fennel

      # Nix
      rnix-lsp
      nixpkgs-fmt

      # C
      clang
      ccls

      # Rust
      rust-analyzer
      cargo
      clippy
      rustc
      rustfmt

      # Zig
      zig
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
