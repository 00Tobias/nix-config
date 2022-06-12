{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # Clojure
    clojure
    clojure-lsp
    zprint

    # Nix
    rnix-lsp
    nixpkgs-fmt # TODO: Alejandra?
    statix

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
}
