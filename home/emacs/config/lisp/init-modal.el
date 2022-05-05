;;; My own personal modal editing package using ryo-modal (and paredit (for now?))

;; ryo-modal configuration

;; Remove ryo prefix with which-key
(require 'which-key)
(push '((nil . "ryo:.*:") . (nil . "")) which-key-replacement-alist)

;; Automatically start ryo-modal on select modes
(add-hook 'text-mode-hook 'ryo-modal-mode 1)
(add-hook 'prog-mode-hook 'ryo-modal-mode 1)

(defun ryo-insert ()
  "Simple helper function to exit ryo-modal-mode"
  (interactive)
  (ryo-modal-mode 0))

;; Set ryo-modal cursor color and type
(setq ryo-modal-cursor-color "#ffffff")
(setq ryo-modal-cursor-type  'box)

;; Set cursor shape to bar in insert mode
(setq cursor-type 'bar)

;; The *true* modal experience
(global-set-key (kbd "<escape>") (lambda ()
                                   (interactive)
                                   (ryo-modal-mode 1)))

;; Define commands to be active when text is selectedi
(require 'selected)
(define-key selected-keymap (kbd "d") #'kill-region)

(ryo-modal-keys
 (:norepeat t)
 ("0" "M-0")
 ("1" "M-1")
 ("2" "M-2")
 ("3" "M-3")
 ("4" "M-4")
 ("5" "M-5")
 ("6" "M-6")
 ("7" "M-7")
 ("8" "M-8")
 ("9" "M-9"))

;; Main modal mode keys
(ryo-modal-keys
 (:mc-all t)
 ;; Escape and g to keyboard-quit
 ("<escape>" keyboard-escape-quit)
 ("g" keyboard-escape-quit)

 ;; Char movement
 ("h" backward-char)
 ("j" next-line)
 ("k" previous-line)
 ("l" forward-char)
 ("H" block-nav-previous-indentation-level)
 ("J" block-nav-next-block)
 ("K" block-nav-previous-block)
 ("L" block-nav-next-indentation-level)

 ("f" right-word)
 ("F" avy-goto-word-1-below)
 ("s" left-word)
 ("S" avy-goto-word-1-above)

 ("w" mwim-beginning)
 ("r" mwim-end)

 ;; Deleting
 ("d" delete-forward-char)
 ("D" kill-line)

 ;; Copy / paste region
 ("e" kill-ring-save)
 ("E" yank)

 ("SPC" set-mark-command)

 ;; Undo / redo
 ("u" undo)
 ("U" undo-redo)

 ;; Add comment above / below
 (";" comment-line)

 ;; Insert / Append text
 ("i" ryo-insert) ("I" ryo-insert)
 ("o" crux-smart-open-line :exit t)
 ("O" crux-smart-open-line-above :exit t)

 ;; Expand region
 ("n" er/expand-region)

 ;; Multiple cursors
 ("m" mc/edit-lines)
 ("M" mc/mark-all-like-this))

;; Modal structural editing in lispy modes with paredit
(require 'paredit)
(ryo-modal-keys
 (:mode 'paredit-mode :mc-all t)
 ("h" paredit-backward-up)
 ("j" paredit-forward)
 ("k" paredit-backward)
 ("l" paredit-forward-down)

 ("H" backward-char)
 ("J" next-line)
 ("K" previous-line)
 ("L" forward-char)

 ("d" paredit-kill)
 ("D" delete-forward-char))

;; Selected overwrites for paredit
(setq selected-paredit-mode-keymap (make-sparse-keymap))
(define-key selected-paredit-mode-keymap (kbd "d") #'paredit-kill)

;; Main spacemacs like prefix key
(ryo-modal-keys
 ("," (("s" save-buffer :name "Save buffer")
       ("g" magit-status :name "Magit")
       ("p" "C-x p" :name "Project")
       ("b" switch-to-buffer :name "Switch to buffer")
       ("k" kill-buffer :name "Kill a buffer"))))

;; Use which-key
(which-key-mode)

(provide 'init-modal)
