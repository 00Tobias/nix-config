{ config, pkgs, lib, ... }: {
  home = {
    file = {
      ".emacs.d/early-init.el" = {
        source = ./config/early-init.el;
      };
      ".emacs.d/init.el" = {
        source = ./config/init.el;
      };

      # ./config/lisp/... files
      ".emacs.d/lisp/init-ui.el" = {
        source = ./config/lisp/init-ui.el;
      };
      ".emacs.d/lisp/init-keybindings.el" = {
        source = ./config/lisp/init-keybindings.el;
      };
      ".emacs.d/lisp/init-completion.el" = {
        source = ./config/lisp/init-completion.el;
      };
      ".emacs.d/lisp/init-langs.el" = {
        source = ./config/lisp/init-langs.el;
      };
      ".emacs.d/lisp/init-org.el" = {
        source = ./config/lisp/init-org.el;
      };
    };

    packages = with pkgs; [
      hack-font # font
      git # magit
      tree-sitter
      fd # Faster "find"
      (ripgrep.override { withPCRE2 = true; }) # Faster "grep"
      sqlite # org-roam
      languagetool # flymake-languagetool

      # spell-fu
      (aspellWithDicts (ds: with ds; [
        en
        en-computers
        en-science
        sv
      ]))

      mu # mu4e
      isync
    ];
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkGcc;
    extraPackages = epkgs: with epkgs; [
      # Tools
      auto-compile
      vterm
      magit
      elpher

      # Keybindings
      meow
      paredit
      paredit-everywhere
      avy
      ace-window
      which-key

      # UI
      kaolin-themes
      moody
      diff-hl
      hl-todo
      rainbow-mode
      rainbow-delimiters
      zoom

      # Completion
      vertico
      vertico-posframe
      orderless
      consult
      marginalia
      corfu
      kind-icon

      # Org
      spell-fu
      ox-gemini
      org-roam
      org-roam-ui
      htmlize
      ox-reveal

      # Programming
      # tree-sitter
      # tree-sitter-indent
      flymake-languagetool
      flymake-racket
      flymake-kondor
      eglot
      apheleia
      yasnippet
      yasnippet-snippets
      auto-yasnippet
      dumb-jump

      # Clojure
      clojure-mode
      clj-refactor
      cider

      # Common-lisp
      sly

      # Lua
      fennel-mode

      # Racket
      racket-mode
      geiser

      # Rust
      rustic
      racer

      # Nix
      nix-mode
      nix-update

      # Zig
      zig-mode
    ];
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
