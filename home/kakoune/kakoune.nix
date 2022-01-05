{ lib, config, pkgs, ... }:
let
  # More recently updated plugins, plus some not in nixpkgs
  fzf-kak = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "fzf-kak";
    version = "2021-09-11";
    src = pkgs.fetchFromGitHub {
      owner = "andreyorst";
      repo = "fzf.kak";
      rev = "68f21eb78638e5a55027f11aa6cbbaebef90c6fb";
      sha256 = "12zfvyxqgy18l96sg2xng20vfm6b9py6bxmx1rbpbpxr8szknyh6";
    };
  };
  kakboard = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "kakboard";
    version = "2020-05-08";
    src = pkgs.fetchFromGitHub {
      owner = "lePerdu";
      repo = "kakboard";
      rev = "2f13f5cd99591b76ad5cba230815b80138825120";
      sha256 = "1kvnbsv20y09rlnyar87qr0h26i16qsq801krswvxcwhid7ijlvd";
    };
  };
  kakoune-snippets = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "kakoune-snippets";
    version = "2021-07-18";
    src = pkgs.fetchFromGitHub {
      owner = "occivink";
      repo = "kakoune-snippets";
      rev = "c0c39eda2e8f9608cbc0372583bf76441a24afd9";
      sha256 = "12q32ahxvmi82f8jlx24xpd61vlnqf14y78ahj1381rv61a386mv";
    };
  };
  kakoune-snippet-collection = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "kakoune-snippet-collection";
    version = "2021-10-15";
    src = pkgs.fetchFromGitHub {
      owner = "andreyorst";
      repo = "kakoune-snippet-collection";
      rev = "8cd0329f3f93d30d0507564eaf311b433a404213";
      sha256 = "0h3cc0aq5yv8c26jxmnfcg0pib01qbwxv1sb0dlq3zgwafpvbmjy";
    };
  };
  kakoune-repl-buffer = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "kakoune-repl-buffer";
    version = "2021-01-22";
    src = pkgs.fetchFromGitLab {
      owner = "Screwtapello";
      repo = "kakoune-repl-buffer";
      rev = "473192d3e7875142a25b607cdb20af2a5c2d4b47";
      sha256 = "007pzhmgr8wbrmn8a8hsbxhafndxqhscw2xx5jqfg0xdakp72dpf";
    };
  };
  kak-rainbow = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
    pname = "kak-rainbow";
    version = "2020-08-31";
    src = pkgs.fetchFromGitHub {
      owner = "Bodhizafa";
      repo = "kak-rainbow";
      rev = "9c3d0aa62514134ee5cb86e80855d9712c4e8c4b";
      sha256 = "0mqghysiwi1h0hx96c7bq0a16yrxh65f3v8bqqn5bh9x1zh2l9mg";
    };
  };
in
{
  home.sessionVariables = {
    EDITOR = "kak";
    VISUAL = "kak";
  };

  # Colorscheme based on my system colors
  xdg.configFile = {
    "kak/colors/colors.kak" = {
      text = import ./colors.nix { inherit lib; };
    };
  };

  programs = {
    zsh.shellAliases = { k = "eval $EDITOR"; };
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    kakoune = {
      enable = true;
      extraConfig = builtins.readFile ./config.kak;
      plugins = with pkgs.kakounePlugins; [
        parinfer-rust # Builds a Rust package

        # Personally defined plugins
        fzf-kak
        kakboard
        kakoune-snippets
        kakoune-snippet-collection
        kakoune-repl-buffer
        kak-rainbow
      ];
    };
  };
  # Kakoune dependencies
  home.packages = with pkgs; [
    kak-lsp
    perl # kakoune-snippets
    git
    lazygit
    ranger
  ];

  # kak-lsp config
  xdg.configFile."kak-lsp/kak-lsp.toml" = {
    # TODO: 'toToml' an option here?
    text = ''
      snippet_support = false
      verbosity = 2

      [server]
      timeout = 1800 # seconds = 30 minutes

      [language.c_cpp]
      filetypes = ["c", "cpp"]
      roots = ["compile_commands.json", ".clangd", ".git", ".hg"]
      command = "clangd"
      offset_encoding = "utf-8"

      [language.clojure]
      filetypes = ["clojure"]
      roots = ["project.clj", "deps.edn", ".git", ".hg"]
      command = "clojure-lsp"

      [language.lua]
      filetypes = ["lua"]
      roots = [".git", ".hg"]
      command = "lua-language-server"
      [language.lua.settings.Lua]
      # See https://github.com/sumneko/vscode-lua/blob/master/setting/schema.json
      # diagnostics.enable = true

      [language.nix]
      filetypes = ["nix"]
      roots = ["flake.nix", "shell.nix", ".git", ".hg"]
      command = "rnix-lsp"

      [language.python]
      filetypes = ["python"]
      roots = ["requirements.txt", "setup.py", ".git", ".hg"]
      command = "python-language-server"

      # Install using 'raco pkg install racket-langserver'
      [language.racket]
      filetypes = ["racket", "scheme"]
      roots = [".git", ".hg"]
      command = "racket"
      args = ["--lib", "racket-langserver"]

      [language.rust]
      filetypes = ["rust"]
      roots = ["Cargo.toml"]
      command = "rust-analyzer"
      # command = "sh"
      # args = [
      #     "-c",
      #     """
      #         if path=$(rustup which rust-analyzer 2>/dev/null); then
      #             "$path"
      #         else
      #             rust-analyzer
      #         fi
      #     """,
      # ]

      settings_section = "rust-analyzer"
      [language.rust.settings.rust-analyzer]
      hoverActions.enable = false # kak-lsp doesn't support this at the moment
      # cargo.features = []
      # See https://rust-analyzer.github.io/manual.html#configuration
      # If you get 'unresolved proc macro' warnings, you have two options
      # 1. The safe choice is two disable the warning:
      # diagnostics.disabled = ["unresolved-proc-macro"]
      # 2. Or you can opt-in for proc macro support
      procMacro.enable = true
      cargo.loadOutDirsFromCheck = true
      # See https://github.com/rust-analyzer/rust-analyzer/issues/6448

      [language.zig]
      filetypes = ["zig"]
      roots = ["build.zig"]
      command = "zls"

      # Semantic tokens
      [[semantic_tokens]]
      token = "comment"
      face = "documentation"
      modifiers = ["documentation"]

      [[semantic_tokens]]
      token = "comment"
      face = "comment"

      [[semantic_tokens]]
      token = "function"
      face = "function"

      [[semantic_tokens]]
      token = "keyword"
      face = "keyword"

      [[semantic_tokens]]
      token = "namespace"
      face = "module"

      [[semantic_tokens]]
      token = "operator"
      face = "operator"

      [[semantic_tokens]]
      token = "string"
      face = "string"

      [[semantic_tokens]]
      token = "type"
      face = "type"

      [[semantic_tokens]]
      token = "variable"
      face = "default+d"
      modifiers = ["readonly"]

      [[semantic_tokens]]
      token = "variable"
      face = "default+d"
      modifiers = ["constant"]

      [[semantic_tokens]]
      token = "variable"
      face = "variable"
    '';
  };
}
