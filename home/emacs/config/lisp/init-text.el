;;; init-text.el --- Configuration for text modes  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Languagetool for checking writing
(setq languagetool-java-arguments '("-Dfile.encoding=UTF-8")
      languagetool-console-command "languagetool-commandline"
      languagetool-server-command "languagetool-server")

;; Automatically wrap lines at 80 columns in text modes
(add-hook 'text-mode-hook (lambda nil
                            (auto-fill-mode 1)
                            (set-fill-column 80)))

;; Use a CDN for reveal.js for org-reveal
(setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")

(provide 'init-text)
;;; init-text.el ends here
