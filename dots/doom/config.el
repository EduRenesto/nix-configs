;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Eduardo Renesto Estanquiere"
      user-mail-address "edure95@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "Iosevka" :size 13 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 14))
;(setq doom-font "FantasqueSansMono Nerd Font-13")
;(setq doom-font "Iosevka Nerd Font Mono-13")
;(setq doom-variable-pitch-font "Barlow-13")

(if (not (string= (system-name) "dragonstone"))
  (progn
    (setq doom-font "Iosevka Term Curly Slab-13")
    (setq doom-variable-pitch-font "Manrope3-13")))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; My key bindings
(map! :n ";" #'evil-ex)

(map! :n "C-h" #'evil-window-left)
(map! :n "C-j" #'evil-window-down)
(map! :n "C-k" #'evil-window-up)
(map! :n "C-l" #'evil-window-right)

(map! :n "M-H" #'evil-window-decrease-width)
(map! :n "M-J" #'evil-window-decrease-height)
(map! :n "M-K" #'evil-window-increase-height)
(map! :n "M-L" #'evil-window-increase-width)

;; Evil niceness
(setq evil-split-window-below t)

;; Org-mode stuff
(setq org-agenda-files '("~/org/" "~/org/ufabc"))

(defun send-to-emulator (str)
  (add-to-list 'display-buffer-alist '("*Async Shell Command*" . display-buffer-no-window))
  (async-shell-command (format "adb shell input text \"%s\"" str) nil))

(defun send-region-to-android ()
  "Sends the text in the region to a currently running Android device or emulator."
  (interactive)
  (send-to-emulator
   (buffer-substring (region-beginning) (region-end))))

(map! :v "SPC e" #'send-region-to-android)

(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(setq mu4e-view-html-plaintext-ratio-heuristic most-positive-fixnum)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/inbox.org" "Tasks")
         "* TODO SRV-%?\n\n- [ ] Implemented\n- [ ] MR Opened\n- [ ] Reviewed\n\n")))

(defun edu/insert-markdown-jira-link ()
  "Insert at point a Markdown link of a Jira issue."
  (interactive)
  (let
      ((issue (read-from-minibuffer "Enter issue ID: VBU-")))
      (insert (format " ([VBU-%s](https://vizir.atlassian.net/browse/VBU-%s))" issue issue))))

(map! :n "SPC i j" #'edu/insert-markdown-jira-link)

(add-hook 'typescript-mode-hook 'editorconfig-mode)

(setq projectile-indexing-method 'hybrid)
