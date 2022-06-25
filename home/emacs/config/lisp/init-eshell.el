;;; init-eshell --- Configuration for Eshell  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Disable welcome message
(setq eshell-banner-message "")

;; Disable line numbers in eshell-mode
(add-hook 'eshell-mode-hook 'display-line-numbers-mode -1)

(eshell-syntax-highlighting-global-mode +1)

(add-hook 'eshell-mode-hook #'esh-autosuggest-mode)

(require 'eshell-up)

(provide 'init-eshell)
;;; init-eshell.el ends here
