;; Emacs Configuration of kshrs

;; disable startup splash screen
(setq inhibit-startup-screen t)

;; minimal ui setup
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode 0)

;; give the fringes some width
(set-fringe-mode 10)

;; font-setup
(set-face-attribute 'default nil :font "BlexMono Nerd Font Mono"
		    :height 150
		    :weight 'medium)
;; (setq-default line-spacing 0.15)

;; use history for minibuffer | use M-p and M-n to scroll the minibuffer
(setq history-length 25)
(savehist-mode t)

;; refresh buffers when opened files or (dir/file changes) outside of emacs
(global-auto-revert-mode 1) ; for files
(setq global-auto-revert-non-file-buffers 1) ; for dired and read only buffers

;; melpa setup
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
				 ("org" . "https://orgmode.org/elpa/")
				 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; theme
(load-theme 'base16-default-dark t nil)
(column-number-mode t)
(global-display-line-numbers-mode t)

;; enable auto pair
(electric-pair-mode t)

;; restore to the last edit position of opened files
(save-place-mode t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(base16-theme rainbow-delimiters)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
