{ config, pkgs, lib, ... }:

let
  langs = [
    "bash"
    "c"
    "clojure"
    "comment"
    "cpp"
    "css"
    "elisp"
    "fennel"
    "go"
    "haskell"
    "html"
    "java"
    "javascript"
    "json"
    "latex"
    "lua"
    "markdown"
    "nix"
    "python"
    "ruby"
    "rust"
    "toml"
    "typescript"
    "vim"
    "yaml"
    "zig"
  ];
  grammars = lib.getAttrs (map (lang: "tree-sitter-${lang}") langs) pkgs.tree-sitter.builtGrammars;
in
{
  home = {
    sessionPath = [ "${config.home.homeDirectory}/.emacs.d/bin/" ];

    file = {
      ".doom.d" = {
        source = ./config;
        recursive = true;
        onChange = ''
          if [ ! -d "${config.home.homeDirectory}/.emacs.d" ]; then
              git clone --depth 1 https://github.com/hlissner/doom-emacs.git ${config.home.homeDirectory}/.emacs.d
              ${config.home.homeDirectory}/.emacs.d/bin/doom -y install
          fi

          # Sync the config and run 'doom doctor' to make sure there are no errors
          ${config.home.homeDirectory}/.emacs.d/bin/doom sync && ${config.home.homeDirectory}/.emacs.d/bin/doom doctor
        '';
      };

      ".tree-sitter".source = (pkgs.runCommand "grammars" { } ''
        mkdir -p $out/bin
        ${lib.concatStringsSep "\n"
          (lib.mapAttrsToList (name: src: "name=${name}; ln -s ${src}/parser $out/bin/\${name#tree-sitter-}.so") grammars)};
      '');
    };

    packages = with pkgs; [
      # Magit
      git

      # Deps for Doom and modules
      fd
      sqlite
      (ripgrep.override { withPCRE2 = true; })

      # :checkers spell
      (aspellWithDicts (ds: with ds; [
        en
        en-computers
        en-science
        sv
      ]))

      wordnet # :lookup
      languagetool # :grammar
      libvterm # :vterm
      editorconfig-core-c # :editorconfig

      # discount # Markdown

      # Fonts
      emacs-all-the-icons-fonts
      hack-font

      # :langs python
      black
      pipenv
      python39Packages.pyflakes
      python39Packages.isort
      python39Packages.pytest
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
