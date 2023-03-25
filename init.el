;; package settings
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(require 'use-package)
(package-initialize)

; Default font
(add-to-list 'default-frame-alist
             '(font . "Iosevka 12"))
; Debugging
;(setq debug-on-error t)

;; kill vterm buffer without confirmation
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))
;; kill buffer without confirmation
(global-set-key [(control x) (k)] 'kill-this-buffer)
;; don't ask about processes when closing emacs
(setq confirm-kill-processes nil)

;; remove gui objects
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(set-fringe-mode 0)

(setq load-prefer-newer t)

(show-paren-mode 1)

; everything utf-8
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

; reload emacs config
(defun config-reload ()
  "Reloads ~/.emacs.d/init.el at runtime"
  (interactive)
  (load-file (expand-file-name "~/.emacs.d/init.el")))
(global-set-key (kbd "C-c r") 'config-reload)

; change all prompts to y or n
(fset 'yes-or-no-p 'y-or-n-p)
(setq ad-redefinition-action 'accept)
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq completion-cycle-threshold t)

; smooth scrolling
(pixel-scroll-precision-mode)
(setq pixel-scroll-precision-large-scroll-height 40.0)

; stop creating backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; TAB cycle if there are only few candidates
(setq completion-cycle-threshold 3)
;; Enable indentation+completion using the TAB key.
(setq tab-always-indent 'complete)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil) ;; spaces instead of tabs
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq backward-delete-char-untabify-method 'nil)

; Enable switching between frames with shift+arrow keys
(windmove-default-keybindings)
(setq windmove-wrap-around t)

; disable bell sound
(setq ring-bell-function 'ignore)

(setq frame-title-format "%b")

; Set the first day of the week to Monday
(setq calendar-week-start-day 1)

;; show tabs at top and display date & time
(tab-bar-mode 1)
(use-package time
  :commands world-clock
  :config
  (setq display-time-format "%a %d %b, %H:%M")
  (setq display-time-interval 60)
  (setq display-time-mail-directory nil)
  (setq display-time-default-load-average nil)
  :hook (after-init . display-time-mode))
(eval-after-load "tab-bar"
(defun tab-bar-format-align-right ()
  "Align the rest of tab bar items to the right."
  (let* ((rest (cdr (memq 'tab-bar-format-align-right tab-bar-format)))
         (rest (tab-bar-format-list rest))
         (rest (mapconcat (lambda (item) (nth 2 item)) rest ""))
         (hpos (length rest))
         (str (propertize " " 'display `(space :align-to (- right ,hpos 0)))))
    `((align-right menu-item ,str ignore)))))

; tree-sitter
(require 'tree-sitter)
(require 'tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

; pulsar settings
(setq pulsar-pulse t)
(setq pulsar-delay 0.055)
(setq pulsar-iterations 10)
(setq pulsar-face 'pulsar-blue)
(setq pulsar-highlight-face 'pulsar-yellow)
(pulsar-global-mode 1)

; xml indentation fix
(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))

; set indentation width to 4 spaces in c files
(setq-default c-basic-offset 4)

; set global keybdings
(global-set-key (kbd "C-/") 'undo)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "<f8>") 'global-hl-line-mode)
(global-set-key (kbd "<f9>") 'display-line-numbers-mode) ;
(global-set-key (kbd "C-x C-k") 'kill-buffer-and-window)
(global-set-key (kbd "<f5>") 'modus-themes-toggle)
(global-set-key (kbd "<f3>") 'treemacs-select-directory)
(global-set-key (kbd "M-o") 'dired-omit-mode)
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z") #'undo)
; Create a new line below cursor
(global-set-key (kbd "<C-return>") (lambda ()
                   (interactive)
                   (end-of-line)
                   (newline-and-indent)))

(setq help-window-select t)  ; Switch to help buffers automatically
(when window-system (set-frame-size (selected-frame) 165 42)) ; Set default window size

; create closing paranthesis automatically
(electric-pair-mode 1)
(setq electric-pair-preserve-balance nil)

;; add line numbers on code files
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Distraction-free screen
  (use-package olivetti
    :init
    (setq olivetti-body-width 0.56))

; markdown mode
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

; Focus on the new frame
(defadvice split-window (after split-window-after activate)
  (other-window 1))

;; automatically focus on man page
(setq Man-notify-method 'aggressive)

; dired settings
(use-package dired
  :hook (dired-mode . dired-hide-details-mode)
  :config
  (setq dired-listing-switches "--group-directories-first -lha"
        dired-kill-when-opening-new-dired-buffer t ; only one dired buffer
        global-auto-revert-non-file-buffers t
        auto-revert-verbose nil
        dired-recursive-deletes 'always ; Also auto refresh dired, but be quiet about it
        global-auto-revert-mode 1))
  ; Colourful columns.
  (use-package diredfl
    :ensure t
    :config
    (diredfl-global-mode 1))
(use-package dired-subtree
  :ensure t
  :after dired
  :bind (:map dired-mode-map
              ("TAB" . dired-subtree-toggle)
              ("b" . dired-up-directory)))
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(require 'dired-x)
(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

(use-package page-break-lines
  :requires dashboard
  :init
    (global-page-break-lines-mode))

(use-package yasnippet
  :config
    ;;(use-package yasnippet-snippets)
    ;;(use-package auto-yasnippet)
  (yas-reload-all)
  (yas-global-mode))
(global-set-key (kbd "C-c y") 'yas-insert-snippet)

(use-package company
  :after lsp-mode
  :diminish
  :bind
  (:map company-active-map
        ("C-n". company-select-next)
        ("C-p". company-select-previous)
        ("M-<". company-select-first)
        ("M->". company-select-last)
        ("C-;" . company-complete-selection))
(:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :config
  (setq company-dabbrev-other-buffers t
        company-dabbrev-code-other-buffers t
        company-idle-delay 0
        company-minimum-prefix-length 4)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.3)
  :hook ((text-mode . company-mode)
         (prog-mode . company-mode)
         (org-mode . company-mode)
         (company-mode . yas-minor-mode)
         (lsp-mode . company-mode)))

(use-package org
  :config
  (setq org-hide-emphasis-markers t))

;; org-bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

; automatically show css colors
(use-package rainbow-mode
  :diminish
  :init
    (add-hook 'prog-mode-hook 'rainbow-mode))

; Dashboard
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)))
  (setq dashboard-show-shortcuts nil)
  (setq dashboard-center-content t)
  (setq dashboard-set-navigator t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-startup-banner 'official)
  (dashboard-setup-startup-hook))
  (setq dashboard-set-footer t)
(when (display-graphic-p)
  (require 'all-the-icons))

(load-theme 'modus-operandi t)

;; Vertico autocomplete
(use-package vertico
  :init
  (vertico-mode))

;; Enable richer annotations using the Marginalia package
(use-package marginalia
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; Orderless completion
(use-package orderless
  :ensure t
  :custom (completion-styles '(orderless)))

;; RSS reader
  (use-package elfeed
    :ensure t
    :config
    (setq elfeed-db-directory (expand-file-name "elfeed" user-emacs-directory))
    (setq-default elfeed-search-filter "@2-week-ago")
    :bind
    ("C-x w" . elfeed ))
(setq elfeed-feeds
    '(("https://archlinux.org/feeds/news/" linux)
	("https://www.reddit.com/r/linux.rss" linux reddit)
    ("https://www.sachachua.com/blog/feed" emacs)
    ("https://www.reddit.com/r/emacs.rss" emacs reddit)
	("https://www.reddit.com/r/CommunismMemes.rss" memes reddit)
	("https://xkcd.com/rss.xml" comics)
	("https://lwn.net/headlines/rss" linux)
    ( "https://www.phoronix.com/phoronix-rss.php" tech linux)
	("https://www.omgubuntu.co.uk/feed" linux)
	("https://thisweek.gnome.org/index.xml" linux)))
(use-package general
 :ensure t)

(use-package avy
   :bind
   ("M-s" . avy-goto-char))

; C-s: ctrlf-forward-default (originally isearch-forward)
; C-r: ctrlf-backward-default (originally isearch-backward)
; C-M-s: ctrlf-forward-alternate (originally isearch-forward-regexp)
; C-M-r: ctrlf-backward-alternate (originally isearch-backward-regexp)
; M-s _: ctrlf-forward-symbol (originally isearch-forward-symbol)
; M-s .: ctrlf-forward-symbol-at-point (originally isearch-forward-symbol-at-point)
(use-package ctrlf
  :init (ctrlf-mode +1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3cd28471e80be3bd2657ca3f03fbb2884ab669662271794360866ab60b6cb6e6" "e0d42a58c84161a0744ceab595370cbe290949968ab62273aed6212df0ea94b4" "72a81c54c97b9e5efcc3ea214382615649ebb539cb4f2fe3a46cd12af72c7607" "9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" "857a606b0b1886318fe4567cc073fcb1c3556d94d101356da105a4e993112dc8" "ff1607d931035f2496e58566ee567b44a0f10be2f3f55d8e2956af16a2431d94" "22eef4c1484c8caf5dad32054830080e76f2076ec8e6b950b3f0b70ba5c988fe" "68a665225842bc1dec619da72f6d2e05d5c46fc64a70199272ebc21cab74477f" "289474b5a9be8e9aad6b217b348f69af6d9c6e86a17c271ab4f5b67d13cf2322" "f1a116f53d9e685023ebf435c80a2fecf11a1ecc54bb0d540bda1f5e2ae0ae58" "5b89b65f5e9e30d98af9d851297ee753e28528676e8ee18a032934a12762a5f2" "c0d992b42529cc61d03cbb8668df5c928d179ab5babbd21c9673b9aa47707f90" "6d741c51b4fd0dd4211fe4134c55b95018e94765e0dfd27771a2f54642ba11f8" "89feed18f1d627659e68e457852ffff5bd63c5103f5d23fbc949db121d4ce742" "8e8152ac5b1c2a4f55928ca03a6e6d93647b9a9900f7613e433092b202191963" "b9e222c23b493f3f0a452e06135fb108f062c31e4adc00842ce2f9e3c3c9368e" "5a6854c6ad74c99ced6e42ed19f0856d2feba54fdaafe05e15fec509a1d1bd7a" "0bfc1a9df8943554fa36c6ac38e6149c58a484273caddf5f78404c7b2edde196" "4a288765be220b99defaaeb4c915ed783a9916e3e08f33278bf5ff56e49cbc73" "5a611788d47c1deec31494eb2bb864fde402b32b139fe461312589a9f28835db" "dad40020beea412623b04507a4c185079bff4dcea20a93d8f8451acb6afc8358" "a0415d8fc6aeec455376f0cbcc1bee5f8c408295d1c2b9a1336db6947b89dd98" "e0628ee6c594bc7a29bedc5c57f0f56f28c5b5deaa1bc60fc8bd4bb4106ebfda" "c414f69a02b719fb9867b41915cb49c853489930be280ce81385ff7b327b4bf6" "02fff7eedb18d38b8fd09a419c579570673840672da45b77fde401d8708dc6b5" "e27c391095dcee30face81de5c8354afb2fbe69143e1129109a16d17871fc055" "795d2a48b56beaa6a811bcf6aad9551878324f81f66cac964f699871491710fa" "0d01e1e300fcafa34ba35d5cf0a21b3b23bc4053d388e352ae6a901994597ab1" default))
 '(echo-keystrokes 0.2)
 '(elfeed-db-directory "/home/matias/.emacs.d/elfeed")
 '(elfeed-search-filter "@2-week-ago")
 '(keyboard-coding-system 'utf-8-unix)
 '(line-spacing 2)
 '(org-hide-macro-markers nil)
 '(org-table-shrunk-column-indicator nil)
 '(package-selected-packages
   '(page-break-lines ctrlf avy tree-sitter-indent json-mode modus-themes mpdmacs general mpdel simple-mpc mingus tree-sitter-langs tree-sitter @ yasnippet-snippets auto-yasnippet yasnippet company lsp-haskell org-modern pulsar markdown-mode ef-themes transpose-frame nov olivetti dired-single haskell-mode emms dired-subtree dired+ diredfl all-the-icons-dired vterm sudo-edit elfeed-goodies elfeed vertico orderless centered-window org-tree-slide marginalia org-bullets magit use-package rainbow-mode org doom-modeline dashboard))
 '(tab-bar-close-button-show nil)
 '(tab-bar-format
   '(tab-bar-format-history tab-bar-format-tabs tab-bar-separator tab-bar-format-align-right tab-bar-format-global))
 '(tab-bar-mode t)
 '(tab-bar-new-tab-choice t)
 '(tab-bar-show t)
 '(warning-minimum-level :error)
 '(warning-suppress-types '((comp))))
;; '(pulsar-pulse-functions
;;   '(isearch-repeat-forward isearch-repeat-backward recenter-top-bottom move-to-window-line-top-bottom reposition-window other-window delete-window delete-other-windows forward-page backward-page scroll-up-command scroll-down-command windmove-right windmove-left windmove-up windmove-down windmove-swap-states-right windmove-swap-states-left windmove-swap-states-up windmove-swap-states-down tab-new tab-close tab-next org-next-visible-heading org-previous-visible-heading org-forward-heading-same-level org-backward-heading-same-level outline-backward-same-level outline-forward-same-level outline-next-visible-heading outline-previous-visible-heading outline-up-heading)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil))))
 '(markdown-header-face ((t (:height 1.0))))
 '(markdown-header-face-1 ((t (:inherit modus-themes-heading-1 :height 1.8))))
 '(markdown-header-face-2 ((t (:inherit modus-themes-heading-2 :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit bold :foreground "#437000" :height 1.4))))
 '(modus-themes-search-success-modeline ((t (:foreground "#004c2e"))) t)
 '(org-document-title ((t (:inherit modus-themes-heading-0 :height 2.0))))
 '(org-level-1 ((t (:inherit outline-1 :height 1.7))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.4))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
 '(tab-bar-tab-group-current ((t (:background "#f6f6f6" :box (:line-width (1 . -2) :color "gray50"))))))
