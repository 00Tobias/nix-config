;;; init-completion.el --- Configuration for completion and minibuffer  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Enable vertico
(vertico-mode)

;; vertico-posframe
(vertico-posframe-mode 1)

;; richer annotations with marginalia
(marginalia-mode)

;; Save history
(savehist-mode)
(setq savehist-save-minibuffer-history t
      savehist-autosave-interval nil
      savehist-additional-variables '(register-alist
                                      kill-ring
                                      mark-ring global-mark-ring
                                      search-ring regexp-search-ring))

;; Use corfu for a small in-buffer completion popup
(setq corfu-auto t)
(global-corfu-mode)

;; Kind-icon for icons in corfu
(require 'kind-icon) ;; :/
(setq kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
(add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)

;; Use orderless as my completion style
(setq completion-styles '(orderless)
      completion-category-defaults nil
      completion-category-overrides '((file (styles . (partial-completion)))))

;; Use TAB to autocomplete
(setq tab-always-indent 'complete)

(provide 'init-completion)
;;; init-completion.el ends here
