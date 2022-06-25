;;; init-prog.el --- Configuration for programming modes  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Tree-sitter
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook 'tree-sitter-hl-mode)
(add-to-list 'tree-sitter-major-mode-language-alist '(clojure-mode . clojure))
(add-to-list 'tree-sitter-major-mode-language-alist '(emacs-lisp-mode . elisp))
(add-to-list 'tree-sitter-major-mode-language-alist '(fennel-mode . fennel))

;; Automatically start flymake
(add-hook 'emacs-lisp-mode-hook 'flymake-mode)

;; Automatically start Eglot on supported modes
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'nix-mode-hook 'eglot-ensure)
(add-hook 'racket-mode-hook 'eglot-ensure)
(add-hook 'rust-mode-hook 'eglot-ensure)
(add-hook 'rustic-mode-hook 'eglot-ensure)
(add-hook 'zig-mode-hook 'eglot-ensure)

;; Rustic should use Eglot
(setq rustic-lsp-client 'eglot)

;; yasnippet
(yas-global-mode 1)
(with-eval-after-load 'yasnippet
  (diminish 'yas-minor-mode))

;; Enable electric-pair-mode
(electric-pair-mode 1)

;; lispy
(add-hook 'clojure-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'fennel-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'hy-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'lisp-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'racket-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'scheme-mode-hook (lambda () (lispy-mode 1)))
(with-eval-after-load 'lispy
  (diminish 'lispy-mode " Lispy"))

;; Colemak bindings for lispy
(require 'lispy)
(lispy-define-key lispy-mode-map (kbd "n") 'lispy-left)
(lispy-define-key lispy-mode-map (kbd "e") 'lispy-down)
(lispy-define-key lispy-mode-map (kbd "i") 'lispy-up)
(lispy-define-key lispy-mode-map (kbd "o") 'lispy-right)
(lispy-define-key lispy-mode-map (kbd "N") 'lispy-ace-symbol-replace)
(lispy-define-key lispy-mode-map (kbd "E") 'lispy-outline-next)
(lispy-define-key lispy-mode-map (kbd "I") 'lispy-outline-prev)
(lispy-define-key lispy-mode-map (kbd "O") 'lispy-outline-goto-child)

(lispy-define-key lispy-mode-map (kbd "h") 'lispy-new-copy)
(lispy-define-key lispy-mode-map (kbd "j") 'lispy-eval)
(lispy-define-key lispy-mode-map (kbd "k") 'lispy-tab)
(lispy-define-key lispy-mode-map (kbd "l") 'lispy-other-mode)
(lispy-define-key lispy-mode-map (kbd "H") 'lispy-narrow)
(lispy-define-key lispy-mode-map (kbd "J") 'lispy-eval-and-insert)
(lispy-define-key lispy-mode-map (kbd "K") 'lispy-shifttab)
(lispy-define-key lispy-mode-map (kbd "L") 'lispy-oneline)
(lispy-defverb
 "other"
 (("n" lispy-move-left)
  ("e" lispy-down-slurp)
  ("i" lispy-up-slurp)
  ("o" lispy-move-right)
  ("SPC" lispy-other-space)
  ("g" lispy-goto-mode)))

;; apheleia
(require 'apheleia)
(with-eval-after-load 'apheleia
  (diminish 'apheleia-mode))
(add-hook 'prog-mode-hook 'apheleia-mode)

;; Add zprint for formatting Clojure code to Apheleia
(push '(zprint . ("zprint"))
      apheleia-formatters)
(push '(clojure-mode . (zprint))
      apheleia-mode-alist)

;; Add nixpkgs-fmt for formatting Nix code to Apheleia
(push '(nixpkgs-fmt . ("nixpkgs-fmt"))
      apheleia-formatters)
(push '(nix-mode . (nixpkgs-fmt))
      apheleia-mode-alist)

;; Add zig fmt for formatting Zig code to Apheleia
(push '(zigfmt . ("zig" "fmt"))
      apheleia-formatters)
(push '(zig-mode . (zigfmt))
      apheleia-mode-alist)

;; ;; Display flymake diagnostics at point
;; (with-eval-after-load 'flymake
;;   (require 'flymake-diagnostic-at-point)
;;   (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode))

;; Enable rainbow-delimiters
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Enable Aggressive indentation
(global-aggressive-indent-mode 1)
(with-eval-after-load 'aggressive-indent
  (diminish 'aggressive-indent-mode))

;; Highlight trailing whitespace
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

;; Use spaces for indentation.
(setq-default indent-tabs-mode nil)

;; Set width of indent
(setq-default tab-width 4)
(setq standard-indent 4)

;; Smarter line movement using mwim
(global-set-key (kbd "C-a") 'mwim-beginning)
(global-set-key (kbd "C-e") 'mwim-end)

;; Expand region
(global-set-key (kbd "C-:") 'er/expand-region)

;; Jump in buffer with avy
(global-set-key (kbd "C-.") 'avy-goto-char-2)

(provide 'init-prog)
;;; init-prog.el ends here
