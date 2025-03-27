(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ignored-local-variable-values
   '((eval progn
      (require 'projectile)
      (puthash
       (projectile-project-root)
       "cask exec buttercup -L . -L tests" projectile-test-cmd-map))))
 '(org-agenda-files nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-document-title ((t (:inherit default :weight bold :foreground "#f380ac" :height 1.5 :underline nil))))
 '(org-level-1 ((t (:inherit default :weight bold :foreground "#f380ac" :height 1.3))))
 '(org-level-2 ((t (:inherit default :weight bold :foreground "#f9e2af" :height 1.3))))
 '(org-level-3 ((t (:inherit default :weight bold :foreground "#89b4fa" :height 1.3))))
 '(org-level-4 ((t (:inherit default :weight bold :foreground "#a6e3a1" :height 1.3))))
 '(org-level-5 ((t (:inherit default :weight bold :foreground "white"))))
 '(org-level-6 ((t (:inherit default :weight bold :foreground "white"))))
 '(org-level-7 ((t (:inherit default :weight bold :foreground "white"))))
 '(org-level-8 ((t (:inherit default :weight bold :foreground "white")))))
