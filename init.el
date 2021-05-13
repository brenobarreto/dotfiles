;; Make all commands of the “package” module present.
(require 'package)

;; Internet repositories for new packages.
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.org/packages/")))

;; Actually get “package” to work.
(package-initialize)
(package-refresh-contents)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

(setq use-package-always-ensure t)

(use-package auto-package-update
  :defer 10
  :config
  ;; Delete residual old versions
  (setq auto-package-update-delete-old-versions t)
  ;; Do not bother me when updates have taken place.
  (setq auto-package-update-hide-results t)
  ;; Update installed packages at startup if there is an update pending.
  (auto-package-update-maybe))

;; https://github.com/purcell/exec-path-from-shell
;(when (memq window-system '(mac ns x))
;  (exec-path-from-shell-initialize))

;; -------------------------------------

;; LOOKS

(load-theme 'zenburn t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

;(global-set-key (kbd "C-/") 'comment-region)


;; -------------------------------------

;; GLOBAL KEYBINDINGS

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-<down-mouse-1>") 'lsp-find-definition-mouse)
(global-set-key (kbd "C-h") 'lsp-find-definition)

;; -------------------------------------

;; INITIALIZATION SETUP

(desktop-save-mode 1)

;; -------------------------------------


;; CLOJURE LSP

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;(package-initialize)

(setq package-selected-packages '(clojure-mode lsp-mode cider lsp-treemacs flycheck company))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)
(add-hook 'cider-repl-mode-hook #'paredit-mode)
(add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)

(setq cider-save-file-on-load t)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-minimum-prefix-length 1
      lsp-lens-enable t
      lsp-signature-auto-activate nil
      ; lsp-enable-indentation nil ; uncomment to use cider indentation instead of lsp
      ; lsp-enable-completion-at-point nil ; uncomment to use cider completion instead of lsp
      )

(use-package lsp-mode
  :ensure t
  :hook ((clojure-mode . lsp))
  :commands lsp
  :config
  (dolist (m '(clojure-mode
               clojurescript-mode))
    (add-to-list 'lsp-language-id-configuration `(,m . "clojure"))))

(show-paren-mode 1)
  
;; -------------------------------------

;; TELL EMACS TO USE DEFAULT ZSH SHELL

(setenv "ESHELL" (expand-file-name "~/bin/eshell"))

;; -------------------------------------

;; PROJECTILE

(unless (package-installed-p 'projectile)
  (package-install 'projectile))

(require 'projectile)
(define-key projectile-mode-map (kbd "C-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)

;; -------------------------------------

(use-package diminish
  :defer 5
  :config ;; let's hide some markers.
  (diminish  'org-indent-mode))

(use-package counsel
  :after ivy
  :config (counsel-mode))

(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

(use-package ivy-rich
  :after ivy
  :custom
  (ivy-virtual-abbreviate 'full
                          ivy-rich-switch-buffer-align-virtual-buffer t
                          ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package clojure-mode
  :config
  (setq clojure-indent-style 'align-arguments
        clojure-thread-all-but-last t
        yas-minor-mode 1)
  (cljr-add-keybindings-with-prefix "C-c C-c"))

(use-package paredit
  :hook ((clojure-mode . paredit-mode)
         (emacs-lisp-mode . paredit-mode)))

; Remove old paredit bindings
;(defun take-from-list (condp list)
;  "Returns elements in list satisfying condp"
;  (delq nil
;    (mapcar (lambda (x) (and (funcall condp x) x)) list)))
;(setq minor-mode-map-alist 
;      (take-from-list 
;        (lambda (x) (not (eq (car x) 'paredit-mode))) 
;        minor-mode-map-alist))

; Create new paredit-mode-map
;(setq paredit-mode-map (make-sparse-keymap))
;(define-key paredit-mode-map (kbd "<s-right>") 'paredit-forward-slurp-sexp)
;(define-key paredit-mode-map (kbd "<s-left>") 'paredit-forward-barf-sexp)

; Add the new paredit-mode-map to minor-mode-map-alist
;(setq minor-mode-map-alist (append
;                (list (append (list 'paredit-mode) paredit-mode-map))
;                minor-mode-map-alist))

;; -------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-lein-command "/usr/local/bin/lein")
 '(cider-repl-display-help-banner nil)
 '(custom-safe-themes
   '("e208e45345b91e391fa66ce028e2b30a6aa82a37da8aa988c3f3c011a15baa22" "bc4c89a7b91cfbd3e28b2a8e9e6750079a985237b960384f158515d32c7f0490" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "191bc4e53173f13e9b827272fa39be59b7295a0593b9f070deb6cb7c3745fd1d" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" default))
 '(debug-on-error t)
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(treemacs-projectile rebecca-theme zenburn-theme zone-nyan sublime-themes base16-theme rainbow-delimiters rg projectile-ripgrep ripgrep flycheck-clj-kondo ag clj-refactor cider zerodark-theme magit ivy-rich diminish auto-package-update use-package dracula-theme doom-modeline-now-playing counsel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))

(setq inhibit-startup-message t)

;; Ignore ring bell
(setq ring-bell-function 'ignore)

;; Doom modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package magit
  :config (global-set-key (kbd "C-x g") 'magit-status))


;; --------------------

;; Use right shell
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "$SHELL --login -c 'echo $PATH'"
						    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

;; --------------------

;; Flycheck
(require 'flycheck-clj-kondo)

;; --------------------

;; Rebalanece sizes when splitting windows
(defadvice split-window-horizontally (after rebalance-windows activate)
  (balance-windows))
(ad-activate 'split-window-horizontally)


;; --------------------

;; RAINBOW DELIMITERS AS DEFAULT FOR PROGRAMMING LANGUAGE MODES
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

