(require 'color-theme)
(color-theme-initialize)
;;(color-theme-arjen)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-set-key [S-left] 'windmove-left)          ; move to left windnow
(global-set-key [S-right] 'windmove-right)        ; move to right window
(global-set-key [S-up] 'windmove-up)              ; move to upper window
(global-set-key [S-down] 'windmove-down)          ; move to downer window

;; Auto completion
(add-to-list 'load-path "~/Documents/Progs/Emacs")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/Documents/Progs/Emacs/ac-dict")
(ac-config-default)

(require 'gccsense)
