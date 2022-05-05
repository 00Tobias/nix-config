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

    # Nix
    rnix-lsp
    nixpkgs-fmt
    nix-prefetch

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
