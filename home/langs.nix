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
    zprint

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
    hy
    black
    python-language-server # FIXME: Remove this?
    python310Packages.python-lsp-server

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
