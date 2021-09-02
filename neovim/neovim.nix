{ config, pkgs, ... }: {
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./init.lua;

    plugins = with pkgs.vimPlugins; [

    ];

    extraPackages = with pkgs; [
      git
      fd
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

      # Doesn't support Python 39 yet
      python-language-server
    ];

    extraPython3Packages = (ps: with ps; [
      black
      pyflakes
      isort
      pytest
    ]);
  };
}
