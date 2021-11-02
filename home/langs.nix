{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # C
    gnumake
    cmake
    clang
    clang-tools

    # Clojure
    clojure
    clojure-lsp

    # Common-lisp
    sbcl

    # Lua
    luajit
    sumneko-lua-language-server
    luaformatter
    fennel

    # Nix
    rnix-lsp
    nixpkgs-fmt

    # Python
    python3
    python-language-server

    # Racket
    racket-minimal

    # Rust
    rust-analyzer
    cargo
    clippy
    rustc
    rustfmt

    # Shell
    shellcheck

    # Zig
    zig
    zls
  ];
}
