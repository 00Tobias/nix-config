{ config, pkgs, lib, ... }:
let
  theme = import ../theme.nix { inherit pkgs; };
in
{
  home = {
    file = {
      ".emacs.d/early-init.el" = {
        source = ./config/early-init.el;
      };
      ".emacs.d/init.el" = {
        source = ./config/init.el;
      };

      # ./config/lisp/... files
      ".emacs.d/lisp/init-theme.el" = {
        text = with theme; ''
          ;; -*- lexical-binding: t; -*-
          (load-theme '${theme.colors.emacs-theme} t)
          (add-to-list 'default-frame-alist '(font . "${theme.font.name}"))
          (provide 'init-theme)
        '';
      };
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
      ".emacs.d/lisp/init-text.el" = {
        source = ./config/lisp/init-text.el;
      };
      ".emacs.d/lisp/init-eshell.el" = {
        source = ./config/lisp/init-eshell.el;
      };
    };

    packages = with pkgs; [
      theme.font.package # Font package designated in theme.nix
      git # magit
      fd
      (ripgrep.override { withPCRE2 = true; })
      sqlite # org-roam
      nodePackages.prettier # Org mode and Apheleia
      zip # org-mode exports
      languagetool
      imagemagick # dirvish
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

      # Keys
      lispy
      hydra
      pretty-hydra
      hydra-posframe
      (epkgs.trivialBuild {
        pname = "hydra-posframe";
        version = "unstable-2022-03-01";

        packageRequires = with epkgs; [ hydra posframe ];

        src = pkgs.fetchFromGitHub {
          owner = "Ladicle";
          repo = "hydra-posframe";
          rev = "94405b5fbec1ae9447c976c3deef41043b9b7de3";
          sha256 = "1psj75xj56s5dy5v3cqymnkn0bz6rf6cjgc3j3fzs4fjjxcg1wgg";
        };
      })
      avy
      mwim
      multiple-cursors
      expand-region
      embrace

      # UI / Mode enhancements
      doom-themes
      moody
      diminish
      diff-hl
      hl-todo
      rainbow-mode
      rainbow-delimiters
      (epkgs.trivialBuild {
        pname = "flymake-posframe";
        version = "unstable-2021-03-04";

        packageRequires = with epkgs; [ posframe ];

        src = pkgs.fetchFromGitHub {
          owner = "Ladicle";
          repo = "flymake-posframe";
          rev = "6ce6e2bc62699c84b7046dd6d07191d37cad3e3e";
          sha256 = "08id06c3750adxgk8y30yai098jzrh0mmgwn34b7gmfvcn16934n";
        };
      })
      helpful
      dirvish
      ctrlf
      browse-kill-ring
      which-key
      which-key-posframe
      popper
      ace-window
      undo-tree

      # Completion
      vertico
      vertico-posframe
      orderless
      consult
      marginalia
      corfu
      kind-icon

      # Org / Text
      languagetool
      hyperbole
      ox-gemini
      org-roam
      org-roam-ui
      htmlize
      ox-reveal
      org-modern

      # Eshell
      eshell-syntax-highlighting
      esh-autosuggest
      eshell-up
      eshell-autojump

      # Programming
      tree-sitter
      (tree-sitter-langs.withPlugins (p: [
        p.tree-sitter-clojure
        p.tree-sitter-elisp
        p.tree-sitter-fennel
        p.tree-sitter-rust
        p.tree-sitter-nix
        p.tree-sitter-zig
      ]))
      eglot
      apheleia
      yasnippet
      yasnippet-snippets
      auto-yasnippet
      aggressive-indent

      # Clojure
      clojure-mode
      cider

      # Lua
      fennel-mode

      # Rust
      rustic

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
