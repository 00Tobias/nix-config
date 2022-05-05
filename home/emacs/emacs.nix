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
      ".emacs.d/lisp/init-modal.el" = {
        source = ./config/lisp/init-modal.el;
      };
      ".emacs.d/lisp/init-completion.el" = {
        source = ./config/lisp/init-completion.el;
      };
      ".emacs.d/lisp/init-prog.el" = {
        source = ./config/lisp/init-prog.el;
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
      nodePackages.prettier # Org mode and Apheleia

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
    package = pkgs.emacsPgtkNativeComp;
    extraPackages = epkgs: with epkgs; [
      # Tools / Media
      vterm
      magit
      elpher
      emms

      # Keys / Modal
      ryo-modal
      selected
      paredit
      block-nav
      avy
      mwim
      multiple-cursors
      expand-region
      crux
      embrace
      which-key

      # UI
      kaolin-themes
      moody
      git-gutter-fringe
      hl-todo
      rainbow-mode
      rainbow-delimiters
      frames-only-mode
      ace-window
      popper

      # Completion
      vertico
      orderless
      consult
      marginalia
      corfu
      kind-icon

      # Org / Text
      spell-fu
      hyperbole
      ox-gemini
      org-roam
      org-roam-ui
      htmlize
      ox-reveal

      # Eshell
      eshell-syntax-highlighting
      eshell-fixed-prompt
      esh-autosuggest
      eshell-up
      eshell-autojump

      # Programming
      eglot
      apheleia
      yasnippet
      yasnippet-snippets
      auto-yasnippet
      dumb-jump
      aggressive-indent

      # Clojure
      clojure-mode
      cider

      # Common-lisp
      sly

      # Elixir
      elixir-mode
      mix

      # Lua
      fennel-mode

      # Rust
      rustic

      # Scheme
      geiser
      geiser-guile
      geiser-racket
      racket-mode

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
