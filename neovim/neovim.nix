{ config, pkgs, ... }: {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile = {
    # # Commented out because home-manager still generates init.vim
    # # https://github.com/nix-community/home-manager/issues/1907
    # "nvim/init.lua".text = ''
    #   vim.g["aniseed#env"] = {
    #     module = "init",
    #     compile = true
    #   }
    # '';

    "nvim/fnl" = {
      recursive = true;
      source = ./config;
      onChange = ''
        nvim --headless -u NONE \
          -c "let &runtimepath = &runtimepath . ',${pkgs.vimPlugins.aniseed},' . getcwd()" \
          -c "lua require('aniseed.compile').glob('**/*.fnl', '${./config}', '${config.xdg.configHome}/nvim/lua')" \
          +q
      '';
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    extraConfig = "let g:aniseed#env = v:true";
    # extraConfig = ''
    #   lua << EOF
    #   vim.g["aniseed#env"] = {
    #     module = "init",
    #     compile = true
    #   }
    #   EOF
    # '';

    plugins = with pkgs.vimPlugins; [
      # Libraries and essentials
      aniseed # Necessity, my config doesn't load without it lol
      plenary-nvim # Dep of *many* plugins
      cmd-parser-nvim # Dep of range-highlight-nvim

      # Languages
      fennel-vim
      conjure
      vim-nix
      zig-vim

      # Theming
      nvim-web-devicons
      nvim-base16
      feline-nvim
      bufferline-nvim

      # Nice-to-have highlighters and UI enhancements
      gitsigns-nvim
      which-key-nvim
      registers-nvim
      specs-nvim
      range-highlight-nvim
      nvim-colorizer-lua
      nvim-ts-rainbow
      indent-blankline-nvim
      todo-comments-nvim

      # Movement and operator plugins
      lightspeed-nvim
      numb-nvim
      kommentary
      nvim-autopairs
      pkgs.nur.repos.toxic-nur.vimPlugins.tabout-nvim

      # Neovim as an IDE/Emacs replacement
      nvim-dap
      nvim-dap-ui
      # nvim-tree-lua
      pkgs.nur.repos.toxic-nur.vimPlugins.nnn-nvim
      telescope-nvim
      formatter-nvim
      neorg
      # https://github.com/TimUntersberger/neogit/issues/206
      neogit

      # Lsp and tree-sitter
      { plugin = nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars); }
      nvim-lspconfig
      lspkind-nvim
      lsp_signature-nvim
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
