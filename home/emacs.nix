{ config, pkgs, ... }: {

  home = {
    sessionPath = [ "${config.home.homeDirectory}/.emacs.d/bin/" ];

    file.".doom.d" = {
      source = ../doom.d;
      recursive = true;
      onChange = ''
        if [ ! -d "${config.home.homeDirectory}/.emacs.d" ]; then
            git clone --depth 1 https://github.com/hlissner/doom-emacs.git ${config.home.homeDirectory}/.emacs.d
            ${config.home.homeDirectory}/.emacs.d/bin/doom -y install
        fi

        ${config.home.homeDirectory}/.emacs.d/bin/doom sync
      '';
    };

    # Explicitly installed doom dependencies
    packages = with pkgs; [
      git
      fd
      (ripgrep.override { withPCRE2 = true; })
      gnumake
      cmake
      libvterm
      discount # Markdown

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

      # Python
      python3
      black
      pipenv
      python-language-server
      python39Packages.pyflakes
      python39Packages.pyflakes
      python39Packages.isort
      python39Packages.pytest

      # Rust
      rust-analyzer
      cargo
      rustc
      rustfmt

      # Zig
      zls

      fd
      sqlite
      editorconfig-core-c
      emacs-all-the-icons-fonts
      hack-font

    ];
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkGcc;
  };

  services = {
    emacs = {
      enable = true;
      client = {
        enable = true;
        arguments = [ "-c" "-n" ];
      };
    };
  };
}
