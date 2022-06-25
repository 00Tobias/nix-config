;;; init-ui.el --- Configurations for mode enhancements and UI  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Change cursor settings
(blink-cursor-mode 0)

;; Delete selection when typing
(delete-selection-mode 1)

;; Enable line-numbers
(global-display-line-numbers-mode)

;; Diminish ElDoc
(with-eval-after-load 'eldoc
  (diminish 'eldoc-mode))

;; Vim-like scrolling
(setq scroll-step 1)
(setq scroll-margin 5)

;; If Emacs is version 29 or above, enable smooth scrolling
(if (>= emacs-major-version 29)
    (pixel-scroll-precision-mode))

;; ace-window
(global-set-key (kbd "C-x o") 'ace-window)
(global-set-key (kbd "M-o") 'ace-window)
;; Set ace-window keys to be the home row, according to Colemak-dh
;; (setq aw-keys '(?a ?r ?s ?t ?g ?m ?n ?e ?i ?o))
(setq aw-dispatch-always t)

;; Customize modeline faces for moody
(let ((line (face-attribute 'mode-line :underline)))
  (set-face-attribute 'mode-line          nil :overline   line)
  (set-face-attribute 'mode-line-inactive nil :overline   line)
  (set-face-attribute 'mode-line-inactive nil :underline  line)
  (set-face-attribute 'mode-line          nil :box        nil)
  (set-face-attribute 'mode-line-inactive nil :box        nil)
  (set-face-attribute 'mode-line-inactive nil :background "#191D26"))

;; moody
(setq x-underline-at-descent-line t)
(setq moody-mode-line-height 25)
(moody-replace-mode-line-buffer-identification)
;; (moody-replace-vc-mode)
(moody-replace-eldoc-minibuffer-message-function)

;; Add elements to modeline
(column-number-mode)

;; hl-todo
(add-hook 'prog-mode-hook 'hl-todo-mode)
(setq hl-todo-highlight-punctuation ":"
      hl-todo-keyword-faces
      `(("TODO" warning bold)
        ("FIXME" error bold)
        ("HACK" font-lock-constant-face bold)
        ("REVIEW" font-lock-keyword-face bold)
        ("NOTE" success bold)
        ("DEPRECATED" font-lock-doc-face bold)
        ("BUG" error bold)
        ("XXX" font-lock-constant-face bold)))

;; helpful
(global-set-key (kbd "C-h f") 'helpful-callable)
(global-set-key (kbd "C-h v") 'helpful-variable)
(global-set-key (kbd "C-h k") 'helpful-key)
(global-set-key (kbd "C-c C-d") 'helpful-at-point)

;; diff-hl
(setq-default left-fringe-width 5)
(global-diff-hl-mode)
(add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

;; which-key
(which-key-mode)
(which-key-posframe-mode)
(setq which-key-posframe-poshandler 'posframe-poshandler-frame-bottom-center)
(with-eval-after-load 'which-key
  (diminish 'which-key-mode))

;; undo-tree
(global-undo-tree-mode)
(with-eval-after-load 'undo-tree
  (diminish 'undo-tree-mode))
(setq undo-tree-history-directory-alist '(("." . "~/.cache/emacs/undo-tree/")))
(setq undo-tree-auto-save-history t)
(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "C-S-z") 'undo-tree-redo)
(global-set-key (kbd "C-c z") 'undo-tree-visualize)

;; dirvish
(dirvish-override-dired-mode)

;; browse-kill-ring
(global-set-key (kbd "C-c y") 'browse-kill-ring)

;; ctrlf
(ctrlf-mode +1)

;; Group popper buffers by project
(setq popper-group-function #'popper-group-by-project)

;; Add buffers to popper-mode
(setq popper-reference-buffers
      '("\\*Messages\\*"
        "\\*Warnings\\*"
        "\\*scratch\\*"
        "\\*xref\\*"
        "Output\\*$"
        "\\*Async Shell Command\\*"
        "\\*Kill Ring\\*"
        help-mode
        compilation-mode

        ;; Shell modes
        "^\\*eshell.*\\*$" eshell-mode
        "^\\*shell.*\\*$"  shell-mode
        "^\\*term.*\\*$"   term-mode
        "^\\*vterm.*\\*$"  vterm-mode))

;; Set keybindings for popper-mode
(global-set-key (kbd "C->") 'popper-toggle-latest)
(global-set-key (kbd "C-<") 'popper-cycle)
(global-set-key (kbd "C-M-<") 'popper-toggle-type)

;; popper
(popper-mode +1)

;; Enable echo-area hints for popper
(popper-echo-mode +1)

(provide 'init-ui)
;;; init-ui.el ends here
