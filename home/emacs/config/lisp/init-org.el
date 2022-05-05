;; TODO: Rename this file to init-text or something?

;; Enable spell-fu in org-mode
(add-hook 'org-mode-hook
          (lambda ()
            (setq spell-fu-faces-exclude
                  '(org-block-begin-line
                    org-block-end-line
                    org-code
                    org-date
                    org-drawer org-document-info-keyword
                    org-ellipsis
                    org-link
                    org-meta-line
                    org-properties
                    org-properties-value
                    org-special-keyword
                    org-src
                    org-tag
                    org-verbatim))
            (spell-fu-mode)))

;; Automatically wrap lines at 80 columns in text modes
(add-hook 'org-mode-hook (lambda nil
                           (auto-fill-mode 1)
                           (set-fill-column 80)))
(add-hook 'markdown-mode-hook (lambda nil
                                (auto-fill-mode 1)
                                (set-fill-column 80)))


;; Use a CDN for reveal.js for org-reveal
(setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")

(provide 'init-org)
