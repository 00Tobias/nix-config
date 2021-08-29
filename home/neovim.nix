{ config, pkgs, ... }: {

  home = {
    file = {
      ".config/lvim" = {
        source = ../lvim;
        recursive = true;
        # onChange = ''
        #   nvim -u "${config.xdg.dataHome}/lunarvim/lvim/init.lua" --headless \
        #     -c 'autocmd User PackerComplete quitall' \
        #     -c 'PackerSync'
        # '';
      };

      "scripts/lvim" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          export LUNARVIM_CONFIG_DIR="${config.xdg.configHome}/lvim"
          export LUNARVIM_RUNTIME_DIR="${config.xdg.dataHome}/lunarvim"

          exec nvim -u "${config.xdg.dataHome}/lunarvim/lvim/init.lua" "$@"
        '';
      };

      "${config.xdg.dataHome}/lunarvim/lvim" = {
        recursive = true;
        source = (
          pkgs.fetchFromGitHub {
            owner = "LunarVim";
            repo = "LunarVim";
            rev = "5ede0c906ab174678e39237fe55f24bc5ae99348";
            sha256 = "UYVIXW3k0LGmUwZ/mH3ryVTB61zfxZThAOV7H4FIzCw=";
          }
        );
      };

      "${config.xdg.dataHome}/lunarvim/site/pack/packer/start/packer.nvim" = {
        recursive = true;
        source = (
          pkgs.fetchFromGitHub {
            owner = "wbthomason";
            repo = "packer.nvim";
            rev = "09cc2d615bbc14bca957f941052e49e489d76537";
            sha256 = "eAJVd4HGzlgzYMrRakddFCFOAgexiCnvvm0b4raC+9g=";
          }
        );
      };
    };

    # Explicitly installed lunarvim dependencies
    packages = with pkgs; [
      git
      fd
      (ripgrep.override { withPCRE2 = true; })
      gnumake
      cmake

      # Nix
      nixpkgs-fmt

      # C
      gcc

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
    ];
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
