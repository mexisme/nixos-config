;;; -*- lexical-binding: t -*-

(setq straight-repository-branch "develop")

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;(desktop-save-mode 1)

(add-hook 'after-make-frame-functions
          (lambda (frame)
            (with-selected-frame frame
              (unless desktop-save-mode
                (desktop-save-mode 1)
                (desktop-read)))))

(straight-use-package 'org-plus-contrib)
(use-package org
  :bind (("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c b" . org-switchb ))
  :hook (org-mode . (lambda () (auto-fill-mode 1)))
  :custom
  (org-agenda-window-setup 'current-window)
  (org-catch-invisible-edits 'smart)
  (org-enforce-todo-checkbox-dependencies t)
  (org-enforce-todo-dependencies t)
  (org-mode-done t)
  (org-return-follows-link t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-window-setup 'current-window)
  (org-startup-indented t)
  (org-treat-S-cursor-todo-selection-as-state-change nil)
  (org-ascii-links-to-notes nil)
  :config
  (require 'ox-md)
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((shell . t)))


  (defun tangle-init ()
    "If the current buffer is 'init.org' the code-blocks are
  tangled, and the tangled file is compiled."
    (when (equal (file-name-nondirectory (buffer-file-name)) "init.org")
      (let ((prog-mode-hook nil))
        (org-babel-tangle)
        )))
  (add-hook 'after-save-hook 'tangle-init))

(use-package org-crypt
  :straight nil
  :after org
  :bind ("C-c d" . org-decrypt-entries)
  :custom
  (org-crypt-key "4E2C63893A3ED8940586EAA9CEE6B10D0AE8C842")
  (org-tags-exclude-from-inheritance (quote ("crypt")))
  :config
  (org-crypt-use-before-save-magic))

(use-package org-tempo
  :straight nil
  :after org)

(use-package diminish)
(use-package delight)

(savehist-mode)

(setq show-paren-delay 0)
(show-paren-mode 1)

(setq auto-save-default nil
      create-lockfiles nil
      backup-directory-alist `(("." . "~/.saves")))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'norerror)

(defun back-window ()
  (interactive)
  (other-window -1))
(global-set-key (kbd "M-o") 'other-window)
;; (global-set-key (kbd "M-O") 'back-window)

(use-package term
  :bind (("C-c t" . ansi-term)
         :map term-raw-map
         (("M-o" . other-window)
          ("M-x" . counsel-M-x)
          ("C-c C-y" . term-paste))))

(winner-mode 1)
(global-set-key (kbd "C-c o") 'winner-undo)
(global-set-key (kbd "C-c O") 'winner-redo)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(windmove-default-keybindings)

(global-display-line-numbers-mode -1)

(global-subword-mode 1)

(setq confirm-kill-processes nil)
(setq kill-buffer-query-functions nil)

(use-package god-mode
  :disabled
  :bind (( "<escape>" . god-mode-all)
         ("C-x C-1" . delete-other-windows)
         ("C-x C-2" . split-window-below)
         ("C-x C-3" . split-window-right)
         ("C-x C-0" . delete-window)
         :map god-local-mode-map
         ("i" . god-mode-all)
         ("." . repeat)))

(use-package eyebrowse
  :config (eyebrowse-mode 1))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed t)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)

(use-package key-chord
  :load-path "packages"
  :disabled
  :config
  (key-chord-mode 1)
  (key-chord-define-global "jk" 'god-mode-all))

(global-set-key (kbd "C-c v") 'ivy-push-view)
(global-set-key (kbd "C-c V") 'ivy-pop-view)

;; (setq pop-up-windows nil)

(global-set-key (kbd "M-i") 'imenu)

(custom-set-variables '(indent-tabs-mode nil)
                      '(tab-width 2)
                      '(tab-stop-list (number-sequence 2 120 2))
                      '(js-indent-level 2)
                      '(css-indent-offset 2))

(when (or (string= (system-name) "worky-mcworkface")
          (string= (system-name) "surface"))
  (set-face-attribute 'default nil :height 100))

(add-to-list 'default-frame-alist '(font . "Source Code Pro 10" ))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(customize-set-variable 'inhibit-startup-message t)

(use-package solarized-theme
  :custom
  (solarized-high-contrast-mode-line t)
  (solarized-scale-org-headlines nil)
  (x-underline-at-descent-line t)
  (solarized-use-more-italic t)
  (solarized-distinct-fringe-background t)
  (solarized-use-variable-pitch t)
  ;; using the default emacs theme currently
  ;; (load-theme 'solarized-light)
  )

(global-auto-revert-mode 1)

(delete-selection-mode 1)

(use-package whole-line-or-region
  :functions whole-line-or-region-global-mode
  :config
  (whole-line-or-region-global-mode 1))

(use-package which-key
  :diminish
  :config
  (which-key-mode t))

(customize-set-variable 'column-number-mode t)

(defalias 'yes-or-no-p 'y-or-n-p)

;; (use-package bookmark+)

(use-package company
  :diminish
  :config
  (global-company-mode))

(use-package transpose-frame)

(use-package orgalist)

(use-package dired-narrow
  :bind (:map dired-mode-map
              ("/" . dired-narrow)))

(use-package dired-ranger)

(use-package dired-open)

(use-package dired-collapse)

(use-package dired-avfs)

(use-package dired-subtree
  :bind (:map dired-mode-map
              ("i" . dired-subtree-insert)
              (";" . dired-subtree-remove))
  :custom
  (dired-subtree-use-backgrounds t)
  :config
  (custom-set-faces
   '(dired-subtree-depth-1-face ((t (:background "white smoke"))))
   '(dired-subtree-depth-2-face ((t (:background "gainsboro"))))
   '(dired-subtree-depth-3-face ((t (:background "light gray"))))
   '(dired-subtree-depth-4-face ((t (:background "gray"))))
   '(dired-subtree-depth-5-face ((t (:background "dark gray"))))
   '(dired-subtree-depth-6-face ((t (:background "dim gray"))))))

(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            ;; Set dired-x global variables here.  For example:
            ;; (setq dired-guess-shell-gnutar "gtar")
            ;; (setq dired-x-hands-off-my-keys nil)
            ))

(add-hook 'dired-mode-hook
          (lambda ()
            ;; Set dired-x buffer-local variables here.  For example:
            ;; (dired-omit-mode 1)
            ))

(customize-set-variable
 'dired-guess-shell-alist-user
 '(("\\.doc\\'" "libreoffice")
   ("\\.docx\\'" "libreoffice")
   ("\\.ppt\\'" "libreoffice")
   ("\\.pptx\\'" "libreoffice")
   ("\\.xls\\'" "libreoffice")
   ("\\.xlsx\\'" "libreoffice")
   ("\\.csv\\'" "libreoffice")
   ("\\.java\\'" "idea")))

(use-package direnv
  :config
  (direnv-mode)
  (custom-set-variables '(direnv-always-show-summary nil)))

(use-package flycheck)

(use-package ivy
  :diminish
  :custom
  (ivy-use-virtual-buffers t)
  (enable-recursive-minibuffers t)
  :config
  (ivy-mode))
(use-package ivy-hydra)
(use-package counsel
  :config
  (counsel-mode)
  :diminish
  :bind (("C-s" . swiper)))

(use-package magit
  :bind (("C-x g" . magit-status))
  :custom
  (magit-diff-refine-hunk t)
  (magit-diff-refine-ignore-whitespace t)
  (magit-save-repository-buffers 'dontask)
  (magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)
  :config
  (global-magit-file-mode 1))

;; (use-package magit-gerrit
  ;; :straight (:host github :repo "darcylee/magit-gerrit"))

(use-package git-gutter
  :bind (("C-c g p" . git-gutter:previous-hunk) ("C-c g n" . git-gutter:next-hunk))
  :custom
  (git-gutter:diff-option "-w")
  :config
  (set-face-attribute 'git-gutter:modified nil
                      :background "#ddddff"
                      :foreground "#2222aa")
  (set-face-attribute 'git-gutter:added nil
                      :background "#ddffdd"
                      :foreground "#22aa22")
  (set-face-attribute 'git-gutter:deleted nil
                      :background "#ffdddd"
                      :foreground "#aa2222"))

(defun neotree-project-dir ()
  "open NeoTree using the project root."
  (interactive)
  (let ((project-dir (projectile-project-root))
        (file-name (buffer-file-name)))
    (neotree)
    (if project-dir
        (if (neo-global--window-exists-p)
            (progn
              (neotree-dir project-dir)
              (neotree-find file-name))))))

(use-package neotree
  :bind ("C-c n" . neotree-project-dir)
  :config
  (setq neo-smart-open t))

(use-package git-auto-commit-mode)

(use-package htmlize)

(setq org-agenda-files '())
(setq org-agenda-include-inactive-timestamps t)

(setq org-default-notes-file (concat org-directory "/refile.org"))
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Inbox")
         "* TODO %? %a\n:PROPERTIES:\n:Created: %U\n:END:\n%i")
        ("j" "Personal journal entry" plain (file+datetree "~/org/journal.org.gpg")
         "%?" :unnarrowed t)
        ("x" "Tech journal entry" entry (file "~/org/tech_journal.org.gpg")
         "* %?\n\nAdded: %U" :unnarrowed t)
         ))

(setq org-refile-targets '((org-agenda-files :maxlevel . 9))
      org-outline-path-complete-in-steps nil
      org-refile-use-outline-path 'file)

(use-package projectile
  :diminish
  :custom
  (projectile-completion-system 'ivy)
  (projectile-switch-project-action #'projectile-dired)
  :config
  (projectile-mode 1)
  :bind-keymap ("C-c p" . projectile-command-map))

(use-package counsel-projectile
  :functions counsel-projectile-mode
  :config (counsel-projectile-mode 1))

(use-package expand-region
  :bind (("C-=" . er/expand-region)))

(use-package avy
  :bind (("C-c j" . avy-goto-word-or-subword-1)))

(setq tramp-default-method "ssh")

(use-package lsp-mode
  :commands lsp
  :bind (:map lsp-mode-map
              ("C-c f" . lsp-format-buffer)
              ("C-c h" . lsp-describe-thing-at-point))
  :custom
  (lsp-prefer-flymake nil))
(use-package lsp-ui
  :commands lsp-ui-mode
  :bind  (:map lsp-mode-map
               ("C-c /" . lsp-ui-sideline-apply-code-actions)
               ("C-c ?" . lsp-ui-peek-find-references)
               ("C-c d" . lsp-ui-peek-find-definitions)))
(use-package company-lsp :commands company-lsp)

(use-package haskell-mode
  :init
  (require 'haskell-process)
  (require 'haskell-interactive-mode)
  :config
  (custom-set-variables
   '(haskell-tags-on-save nil)
   '(haskell-interactive-popup-errors nil)
   '(haskell-process-suggest-remove-import-lines t)
   '(haskell-process-suggest-hoogle-imports t)
   '(haskell-process-suggest-remove-import-lines t)
   '(haskell-process-auto-import-loaded-modules t)
   '(haskell-process-log t)
   '(tab-width 2))
  (eval-after-load "interactive-haskell-mode" (lambda ()
                                                (define-key interactive-haskell-mode-map (kbd "C-c C-c") 'haskell-compile)
                                                (define-key interactive-haskell-mode-map (kbd "M-.") 'haskell-mode-goto-loc)
                                                (define-key interactive-haskell-mode-map (kbd "C-c C-t") 'haskell-mode-show-type-at)))

  (add-hook 'haskell-mode-hook (lambda ()
                                 (interactive-haskell-mode)
                                 (set (make-local-variable 'company-backends)
                                      (append '((company-capf company-dabbrev-code)) company-backends))))
  (define-key haskell-mode-map (kbd "M-.") 'haskell-mode-jump-to-def-or-tag)
  (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile)
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-file)
  (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-;") 'haskell-check)
  (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
  (define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal))

;; (use-package flycheck-haskell
;;   :hook (haskell-mode . flycheck-haskell-setup))

(use-package lsp-haskell)

(use-package hindent)

(use-package nix-mode
  :mode ("\\.nix\\'" "\\.nix.in\\'"))
(use-package nix-drv-mode
  :straight nix-mode
  :mode "\\.drv\\'")
(use-package nix-shell
  :straight nix-mode
  :commands (nix-shell-unpack nix-shell-configure nix-shell-build))
(use-package nix-repl
  :straight nix-mode
  :commands (nix-repl))

(use-package nix-update)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(use-package typescript-mode
  :custom (typescript-indent-level 2))

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . setup-tide-mode)))

(use-package web-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  :custom
  (js-indent-level 2)
  (web-mode-markup-indent-offset 2)
  (web-mode-code-indent-offset 2)

  :hook ((web-mode .
                   (lambda ()
                     (when (string-equal "tsx" (file-name-extension buffer-file-name))
                       (setup-tide-mode))))))

(use-package dhall-mode
  :mode "\\.dhall\\'")

(use-package beancount
  :straight nil
  :load-path "packages"
  :config
  (setq beancount-mode-map-prefix [(control x)(control a)]))

(use-package paredit
  :diminish
  :config
  :hook ((emacs-lisp-mode lisp-mode lisp-interaction-mode scheme-mode) . enable-paredit-mode))

(use-package slime
  :init
  (setq inferior-lisp-program "/run/current-system/sw/bin/sbcl"))

(use-package geiser
  :config
  (add-to-list 'auto-mode-alist '(".scheme\\'" . scheme-mode)))

(use-package purescript-mode
  :functions turn-on-purescript-indentation)

(use-package psc-ide
  :config
  :hook (purescript-mode . (lambda ()
                             (psc-ide-mode)
                             (company-mode)
                             (flycheck-mode)
                             (turn-on-purescript-indentation))))

(use-package yaml-mode)

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :custom (markdown-command "multimarkdown"))

(use-package flymd)

(use-package csv-mode)

(use-package dockerfile-mode
  :config
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

(use-package tex-site
  :straight auctex)

(use-package winum
  :bind (:map winum-keymap
              ("M-0" . winum-select-window-0-or-10)
              ("M-1" . winum-select-window-1)
              ("M-2" . winum-select-window-2)
              ("M-3" . winum-select-window-3)
              ("M-4" . winum-select-window-4)
              ("M-5" . winum-select-window-5)
              ("M-6" . winum-select-window-6)
              ("M-7" . winum-select-window-7)
              ("M-8" . winum-select-window-8)
              ("M-9" . winum-select-window-9))
  :config (winum-mode))
