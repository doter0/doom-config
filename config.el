(map! :leader "r" (cmd! (save-buffer) (doom/reload)))

(defun remove-key-bindings (mode key-list)
  "Remove multiple key bindings from the given MODE's keymap."
  (let ((keymap (symbol-value mode)))
    (if (keymapp keymap)
        (dolist (key key-list)
          (define-key keymap (kbd key) nil)))))

(setq evil-echo-state nil)             ; signal the current state in the echo area.
(setq evil-toggle-key nil)             ; don't use emacs state, let's disable it. TODO not work

;; TODO s, S 키도 후보에 넣기
(remove-key-bindings 'evil-normal-state-map
                     '("s" "S" "<insert>" "<insertchar>" "gu" "gf" "g~"
                       "zo" "zO" "zc" "zr" "zm" "za" "zr" "zm" "J"
                       "z=" "C-n" "C-p" "C-t" "C-." "M-." "=" "~"))

(defun dt/invert-case-at-word ()
  "Invert the case of the word at point."
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'word)))
    (if bounds
        (evil-invert-char (car bounds) (cdr bounds))
      (message "No word at point"))))

(defun dt/invert-case-first-char-at-word ()
  "Invert the case of the first character of the word at point."
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'word)))
    (if bounds
        (let ((start (car bounds))) ;; 단어의 시작 위치
          (evil-invert-case start (1+ start))) ;; 첫 글자만 처리
      (message "No word at point"))))

;; TODO 현재 커서의 element를 fold하는 기능.
(map! :map evil-normal-state-map
      "zz" #'evil-toggle-fold
      "za" #'evil-open-folds
      "zc" #'evil-close-folds
      "g]" #'evil-goto-last-change
      "g[" #'evil-goto-last-change-reverse
      "=c" #'evil-invert-char
      "=w" #'dt/invert-case-at-word
      "=f" #'dt/invert-case-first-char-at-word)

;; evil-window-map
;; (define-key evil-window-map "b" 'evil-window-bottom-right)
;; (define-key evil-window-map "c" 'evil-window-delete)
;; (define-key evil-window-map "f" ffap-other-window)
;; (define-key evil-window-map "h" 'evil-window-left)
;; (define-key evil-window-map "H" 'evil-window-move-far-left)
;; (define-key evil-window-map "j" 'evil-window-down)
;; (define-key evil-window-map "J" 'evil-window-move-very-bottom)
;; (define-key evil-window-map "k" 'evil-window-up)
;; (define-key evil-window-map "K" 'evil-window-move-very-top)
;; (define-key evil-window-map "l" 'evil-window-right)
;; (define-key evil-window-map "L" 'evil-window-move-far-right)
;; (define-key evil-window-map "n" 'evil-window-new)
;; (define-key evil-window-map "o" 'delete-other-windows)
;; (define-key evil-window-map "p" 'evil-window-mru)
;; (define-key evil-window-map "q" 'evil-quit)
;; (define-key evil-window-map "r" 'evil-window-rotate-downwards)
;; (define-key evil-window-map "R" 'evil-window-rotate-upwards)
;; (define-key evil-window-map "s" 'evil-window-split)
;; (define-key evil-window-map "S" 'evil-window-split)
;; (define-key evil-window-map "t" 'evil-window-top-left)

(remove-key-bindings 'evil-insert-state-map
                     '("C-q" "C-v" "C-k" "C-o" "C-y" "C-e" "C-p"
                       "C-x C-n" "C-x C-p" "C-t" "C-d" "C-a" "C-@"
                       "<insert>" "C-j" "C-r" "C-u" "C-w" "C-z"
                       "C-x C-o" "C-x C-s" "C-x s"))

;; TODO 제대로 작동하지 않음
(map! :map evil-insert-state-map
      "C-h" #'evil-forward-char
      "C-j" #'evil-next-line
      "C-k" #'evil-previous-line
      "C-l" #'evil-backward-char)

(remove-key-bindings 'evil-replace-state-map
                     '("C-q" "C-v" "C-k" "C-o" "C-y" "C-e" "C-p"
                       "C-x C-n" "C-x C-p" "C-t" "C-d" "C-a" "C-@"
                       "C-r" "C-u" "C-w" "S-<left>" "S-<right>"))

;; TODO 제대로 작동하지 않음
(map! :map evil-replace-state-map
      "C-h" #'evil-forward-char
      "C-j" #'evil-next-line
      "C-k" #'evil-previous-line
      "C-l" #'evil-backward-char)

(after! evil
  (evil-ex-define-cmd "W" 'save-buffer)
  (evil-ex-define-cmd "Q" 'evil-save-modified-and-close))

(after! which-key
  (setq which-key-idle-delay 0.3
        which-key-idle-secondary-delay 0.1))

;; evil-motion-state-map
;; evil-normal-state-map
;; evil-insert-state-map

(require 'server)
(unless (server-running-p) (server-start))

(defun dt/done ()
  (interactive)
  (server-edit)
  (make-frame-invisible nil t))

(map! :leader :n "k" #'dt/done)

;; personal information
(setq user-full-name "doter"
      user-mail-address "hollywooddreaming21@google.com")

;; autosave and backup
(setq auto-save-default t
      make-backup-files t)

;; kill emacs without confirm
(setq confirm-kill-emacs nil)

;; input method
(setq default-input-method "korean-hangul")
(global-set-key (kbd "<Hangul>") 'toggle-input-method)
(global-set-key (kbd "C-<Hangul>") 'toggle-input-method)
(global-set-key (kbd "M-<Hangul>") 'toggle-input-method)

;; Emacs 종료 시 세션 저장 및 복원
(setq desktop-save-mode t)

;; remap <localleader> from 'SPC m' to ','
(setq doom-localleader-key ","
      doom-localleader-alt-key "M-,")

;; for macOS
;; (if (featurep :system 'macos)
;;   (setq mac-command-modifier 'meta
;;         mac-option-modifier 'none
;;         mac-right-option-modifier 'super))

(defconst my/home-dir "/home/doter/")

;; Basic directory
(defconst my/download-dir (concat my/home-dir "Download/"))

;; Config directory
(defconst my/config-dir (concat my/home-dir ".config/"))
(defconst my/dotfiles-dir (concat my/home-dir ".dotfiles/"))
(defconst my/wiki-dir (concat my/home-dir "wiki/"))
(defconst my/doom-dir (concat my/config-dir "doom/"))
(defconst my/emacs-dir (concat my/config-dir "emacs/"))
(defconst my/emacs-modules-dir (concat my/emacs-dir "modules/"))

;; (setq doom-theme 'catppuccin)
(setq doom-theme 'doom-one)

(setq doom-font (font-spec :family "D2CodingLigature Nerd Font" :size 14)
      doom-unicode-font (font-spec :family "Symbols Nerd Font Mono" :size 14)
      doom-emoji-font (font-spec :family "Noto Color Emoji" :size 14))

;; (after! doom-themes
;;   (setq doom-themes-enable-bold t
;;         doom-themes-enable-italic t))

(setq +lookup-provider-url-alist
      '(("Doom Emacs issues" "https://github.com/hlissner/doom-emacs/issues?q=is%%3Aissue+%s")
        ("StackOverflow"     "https://stackoverflow.com/search?q=%s")
        ("Google" +lookup--online-backend-google "https://google.com/search?q=%s")
        ("Github"            "https://github.com/search?ref=simplesearch&q=%s")
        ("Youtube"           "https://youtube.com/results?aq=f&oq=&search_query=%s")
        ("Arch Wiki"         "https://wiki.archlinux.org/index.php?search=%s&title=Special%3ASearch&wprov=acrw1")
        ("AUR"               "https://aur.archlinux.org/packages?O=0&K=%s")))

(setq fancy-splash-image (concat doom-private-dir "splash.svg"))

(setq bookmark-default-file "~/.config/doom/bookmarks")

(map! :leader
      (:prefix ("b", "buffer")
       :desc "List bookmarks"         "l" #'list-bookmarks
       :desc "Jump to the bookmark"   "g" #'bookmark-jump
       :desc "Delete bookmark"        "M" #'bookmark-set
       :desc "Save bookmarks to file" "w" #'bookmark-save))

(run-with-idle-timer 10 t #'garbage-collect)

(pixel-scroll-precision-mode)

(setq evil-want-C-i-jump t
      evil-want-C-u-delete nil                ; C-u to scroll up, so disable it
      evil-want-C-u-scroll t
      evil-want-C-d-scroll t
      evil-want-C-w-delete nil                ; C-w to delete word in insert mode
      evil-want-C-w-in-emacs-state nil
      evil-want-Y-yank-to-eol t               ; yank to the end of line.
      evil-disable-insert-state-bindings nil) ; 잘 모르겠음.

(setq evil-repeat-move-cursor nil             ; whether repeating don't move cursor REVIEW 시범삼아 사용
      evil-move-cursor-back t)

;; beginning & end of line
(map! :nv "H" #'move-beginning-of-line
      :nv "L" #'move-end-of-line)

(advice-add 'evil-previous-line :after #'evil-scroll-line-to-center)
(advice-add 'evil-next-line :after #'evil-scroll-line-to-center)
(advice-add 'evil-previous-visual-line :after #'evil-scroll-line-to-center)
(advice-add 'evil-next-visual-line :after #'evil-scroll-line-to-center)
(advice-add 'evil-scroll-up :after #'evil-scroll-line-to-center)
(advice-add 'evil-scroll-down :after #'evil-scroll-line-to-center)

;; ;; TODO 스크롤 수가 이상함.
;; (advice-add 'evil-scroll-line-up :after #'evil-scroll-line-to-center)
;; (advice-add 'evil-scroll-line-down :after #'evil-scroll-line-to-center)
;; (map! :nvi "C-e" (cmd! (evil-scroll-line-down 3) (evil-scroll-line-to-center 0)))
;; (map! :nvi "C-y" (cmd! (evil-scroll-line-up 3) (evil-scroll-line-to-center 0)))

(setq avy-all-windows t)  ;; avy command for all window

(after! evil
 (map! :map evil-normal-state-map
       :prefix ("g a" . "avy")
       :desc "Jump to key"    "a" #'evil-avy-goto-char-timer
       :desc "Jump to 2 char" "c" #'evil-avy-goto-char-2
       :desc "Jump to word"   "w" #'evil-avy-goto-word-0
       :desc "Jump to line"   "l" #'evil-avy-goto-line))

(add-hook 'before-save-hook #'whitespace-cleanup)

(setq-default sentence-end-double-space nil)

;; (key-chord-define-global ";s" (lambda () (interactive) (insert "*")))

(setq frame-title-format
      '(""
        "%b"
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p) " ◉ %s" "  ●  %s - Emacs") project-name))))))

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(setq message-log-max 100)

;; (set-face-background 'vertical-border "black")
;; (set-face-background 'vertical-border (face-background 'vertical-border))

;; Disable s-s keys
(after! evil
  (map! :n "ss" #'+evil/window-split-and-follow
        :n "sv" #'+evil/window-vsplit-and-follow
        :n "sh" #'evil-window-left
        :n "sj" #'evil-window-down
        :n "sk" #'evil-window-up
        :n "sl" #'evil-window-right
        ;; Move window
        :n "Sh" #'+evil/window-move-left
        :n "Sj" #'+evil/window-move-down
        :n "Sk" #'+evil/window-move-up
        :n "Sl" #'+evil/window-move-right))

(defun dt/save-and-close-other-buffers ()
  "Save all buffers except the current one, then close them."
  (interactive)
  (let ((current-buffer (current-buffer)))
    (save-some-buffers t)
    (mapc (lambda (buffer)
            (unless (eq buffer current-buffer)
              (with-current-buffer buffer
                (when (buffer-file-name)
                  (save-buffer)))
              (kill-buffer buffer)))
          (buffer-list))
    (message "All other buffers saved and closed!")))

(defun my-save-and-close-window ()
  "Save the current buffer and close the window.
If the buffer cannot be saved, just close the window."
  (interactive)
  (if (and (buffer-file-name) (buffer-modified-p))
      (progn
        (save-buffer)
        (delete-window))
    (delete-window)))

(map! :leader
      :desc "Save & close other buffers"
      "qo" #'save-and-close-other-buffers)

(map! :n "qq" #'my-save-and-close-window
      :n "qo" #'dt/save-and-close-other-buffers)

;; t로 하면 커서가 새로 생긴 창으로 움직이지 않음. 왜인지 모르겠음.
(setq evil-split-window-below nil
      evil-vsplit-window-right nil)

(setq windmove-create-window t)

;; TODO 버퍼를 선택하게하는 수정이 필요함.
(defun dt/create-window-at-far-right (file)
  "Move the current window to the far-right and open FILE.
If no FILE is provided, prompt the user to select one."
  (interactive "fSelect file: ")
  (evil-window-vsplit)
  (evil-window-move-far-right)
  (find-file file))

(defun dt/create-window-at-far-left (file)
  "Move the current window to the far-left and open FILE.
If no FILE is provided, prompt the user to select one."
  (interactive "fSelect file: ")
  (evil-window-vsplit)
  (evil-window-move-far-left)
  (find-file file))

(map! :n "<DEL>" #'previous-buffer
      :n "S-<DEL>" #'next-buffer)

(setq display-line-numbers-type nil)

(setq truncate-string-ellipsis "…") ; Unicode ellispis are nicer than "..."

(blink-cursor-mode t)
(setq x-stretch-cursor t) ;; 커서가 텍스트의 크기에 맞춰서 늘어난다.

;; Evil mode cursor customization
(setq evil-normal-state-cursor '("#89b4fa" box)
      evil-insert-state-cursor '("#a6e3a1" (bar . 3))
      evil-visual-state-cursor '("#f9e2af" box)
      ;; evil-replace-state-cursor
      ;; evil-operator-state-cursor
      ;; evil-motion-state-cursor
      ;; evil-emacs-state-cursor
)

;; (defun set-cursor-color-based-on-input-method ()
;;   "Set cursor color based on the current input method.
;; Red for Korean, Blue for English."
;;   (if (string= current-input-method "korean-hangul")
;;       (set-cursor-color "red")
;;     (set-cursor-color "blue")))


;; (add-hook 'input-method-deactivate-hook 'update-cursor-color)
;; (add-hook input-method-activate-hook 'update-cursor-color)

;; Initialize cursor color when Emacs starts
;; (add-hook 'after-init-hook 'update-cursor-color)

;; (defun update-cursor-color-based-on-input-method ()
;;   "Update cursor color based on the current input method."
;;   (if (string= current-input-mehtod "korean-hangul")
;;       (set-cursor-color "red")
;;     (set-cursor-color "green")))

;; ;; `toggle-input-method` 실행 시 커서 색상 업데이트
;; (advice-add 'toggle-input-method :after
;;             (lambda () (update-cursor-color-based-on-input-method)))

;; ;; Emacs 시작 시 초기 커서 색상 설정
;; (add-hook 'after-init-hook 'update-cursor-color-based-on-input-method)

;; (set-popup-rule! "^\\*Messages\\*" :ttl t :side 'bottom :height 12 :quit t)
;; (set-popup-rule! "^\\*doom:vterm*" :ttl t :side 'bottom :height 20 :quit t)
;; (set-popup-rule! "^\\*npm*" :ttl t :side 'bottom :height 20 :quit t)
;; (set-popup-rule! "^\\*Flycheck*" :ttl t :side 'bottom :height 20 :quit t)

(defun modeline-contitional-buffer-encoding ()
  "Hide \"LF UTF-8\" in modeline.

It is expected of files to be encoded with LF UTF-8, so only show
the encoding in the modeline if the encoding is worth notifying
the user."
  (setq-local doom-modeline-buffer-encoding
              (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
                                 '(coding-category-undecided coding-category-utf-8))
                           (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
                t)))

(add-hook 'after-change-major-mode-hook #'modeline-contitional-buffer-encoding)

;; (doom-modeline-def-segment buffer-name
;;   "Display the current buffer's name, without any other information."
;;   (concat
;;    (doom-modeline-spc)
;;    (doom-modeline--buffer-name)))

;; (doom-modeline-def-segment pdf-icon
;;   "PDF icon from nerd-icons."
;;   (concat
;;    (doom-modeline-icon sucicon "nf-seti-pdf" nil nil
;;    (doom-modeline-spc)
;;                        :face (if (doom-modeline--active)
;;                                  'nerd-icons-red
;;                                'mode-line-inactive)
;;                        :v-adjust 0.02)))

;; (defun doom-modeline-update-pdf-pages ()
;;   "Update PDF pages."
;;   (setq doom-modeline--pdf-pages
;;         (let ((current-page-str (number-to-string (eval `(pdf-view-current-page))))
;;               (total-page-str (number-to-string (pdf-cache-number-of-pages))))
;;           (concat
;;            (propertize
;;             (concat (make-string (- (length total-page-str) (length current-page-str)) ? )
;;                     " P" current-page-str)
;;             'face 'mode-line)
;;            (propertize (concat "/" total-page-str) 'face 'doom-modeline-buffer-minor-mode)))))

;; (doom-modeline-def-segment pdf-pages
;;   "Display PDF pages."
;;   (if (doom-modeline--active) doom-modeline--pdf-pages
;;     (propertize doom-modeline--pdf-pages 'face 'mode-line-inactive)))

(display-time-mode t) ;; display time in modeline
(setq! display-time-24hr-format t
       display-time-default-load-average nil)

;; TODO UTF를 추가해야 함.
(after! doom-modeline
  (doom-modeline-def-segment copilot
    "Show Copilot status in modeline."
    (if (bound-and-true-p copilot-mode)
        ""
      ""))
  (doom-modeline-def-modeline 'main
    '(bar modals matches buffer-info vcs)
    '(input-method misc-info buffer-position copilot major-mode check time))
  (setq! doom-modeline-buffer-file-name-style 'relative-to-project
         doom-modeline-icon t
         doom-modeline-major-mode-icon t
         doom-modeline-buffer-modification-icon nil
         doom-modeline-position-column-format '("C%c")
         doom-modeline-position-column-line-format '("L%l")
         doom-modeline-modal-modern-icon nil))

(define-globalized-minor-mode global-rainbow-mode rainbow-mode
 (lambda ()
   (when (not (memq major-mode
               (list 'org-agenda-mode)))
     (rainbow-mode 1))))
(global-rainbow-mode 1)

(setq truncate-lines nil)

(global-auto-revert-mode 1)
(setq auto-revert-interval 2)

(use-package! visual-fill-column
  :custom
  (visual-fill-column-width 300)
  (visual-fill-column-center-text t)
  :hook (org-mode . visual-fill-column-mode))

;; (after! persp-mode
;;   ;; 탭 출력 함수: 왼쪽 정렬 + "none" 제거 + 스타일 지정
;;   (defun workspaces-formatted ()
;;     (let* ((names (remove "none" (or persp-names-cache nil)))
;;            (current-name (safe-persp-name (get-current-persp))))
;;       (concat
;;        " "
;;        (mapconcat
;;         (lambda (name)
;;           (let ((face (if (equal name current-name)
;;                           'my/workspace-tab-selected-face
;;                         'my/workspace-tab-face)))
;;             (propertize (format "   %s   " name) 'face face)))
;;         names
;;         ""))))  ;; 왼쪽 정렬: 구분자 없이 이어 붙임

;;   ;; 강제 redraw를 위한 invisible 트릭
;;   (defun hy/invisible-current-workspace ()
;;     (propertize (safe-persp-name (get-current-persp)) 'invisible t))

;;   ;; tab-bar에 탭 출력 형식 설정
;;   (customize-set-variable
;;    'tab-bar-format
;;    '(workspaces-formatted tab-bar-format-align-right hy/invisible-current-workspace))

;;   ;; 메시지 출력 억제
;;   (advice-add #'+workspace/display :override #'ignore)
;;   (advice-add #'+workspace-message :override #'ignore)

;;   ;; 탭 스타일 설정
;;   (defface my/workspace-tab-face
;;     '((t (:background "#1e1e2e" :foreground "#cdd6f4" :weight normal :box (:line-width -1 :color "#1e1e2e"))))
;;     "Face for inactive workspace tab.")

;;   (defface my/workspace-tab-selected-face
;;     '((t (:background "#f38ba8" :foreground "#1e1e2e" :weight bold :box (:line-width -1 :color "#f38ba8"))))
;;     "Face for active workspace tab."))

;; (run-at-time nil nil (lambda () (tab-bar-mode 1)))

;; ':i'를 명시하지 않으면 제대로 작동하지 않음. corfu완 연관있음. courfu README에 설명이 있음.
(map! :desc "Accept completion"         :i "M-TAB" #'copilot-accept-completion)

(map! :prefix ("M-c" . "copilot")
      :desc "Enable Copilot Mode"       :nig "c" #'copilot-mode
      :desc "Accept completion by word" :i   "w" #'coplilot-accept-completion-by-word
      :desc "Next completion"           :i   "n" #'copilot-next-completion
      :desc "Previous completion"       :i   "p" #'copilot-previous-completion
      ;; Copilot Chat
      :desc "Display Chat Window"    "d" (cmd! (+evil/window-vsplit-and-follow) (copilot-chat-display)) ;; TODO add toggle
      :desc "Explain Selected Code"  "e" (cmd! (+evil/window-vsplit-and-follow) (copilot-chat-explain))
      :desc "Review Selected Code"   "r" (cmd! (+evil/window-vsplit-and-follow) (copilot-chat-review))
      :desc "Review whole buffer"    "R" (cmd! (+evil/window-vsplit-and-follow) (copilot-chat-review-whole-buffer))
      :desc "Fix Selected Code"      "f" (cmd! (+evil/window-vsplit-and-follow) (copilot-chat-fix))
      :desc "Optimize Selected Code" "o" (cmd! (+evil/window-vsplit-and-follow) (copilot-chat-optimize))
      :desc "Write Test for Code"    "t" (cmd! (+evil/window-vsplit-and-follow) (copilot-chat-test))
      :desc "Add Current Buffer"     "a" #'copilot-chat-add-current-buffer
      :desc "Remove Current Buffer"  "A" #'copilot-chat-del-current-buffer
      :desc "Open buffer list"       "l" #'copilot-chat-list
      :desc "Document Selected Code" "D" #'copilot-chat-doc
      :desc "Clear Chat History"     "C" #'copilot-chat-reset
      :desc "Insert commit message"  "m" #'copilot-chat-insert-commit-message)

;; (add-hook 'git-commit-setup-hook 'copilot-chat-insert-commit-message) # NOTE: not use now

(remove-key-bindings 'doom-leader-map '("o /" "f p" "."))
;; (remove-key-bindings 'doom-leader-open-map '("/"))
(remove-key-bindings 'doom-leader-file-map '("E" "F" "P" "U" "Y" "c" "d" "e" "f" "h" "l" "p" "u" "m"))

(map! :leader
      :desc "Project sidebar"   :ng "<SPC>" #'dirvish-side
      :prefix ("f" . "file")
      :desc "File browser"      :ng "f" #'dirvish
      :desc "Config directory"  :ng "c" (cmd! (dirvish my/config-dir))
      :desc "Doom directory"    :ng "d" (cmd! (dirvish doom-user-dir))
      :desc "Emacs directory"   :ng "e" (cmd! (dirvish my/emacs-dir))
      :desc "Modules directory" :ng "m" (cmd! (dirvish my/emacs-modules-dir))
      :desc "Modules directory" :ng "w" (cmd! (dirvish my/wiki-dir)))

;; (dirvish-override-dired-mode)

(defun dt/close-dirvish-side ()
  "Close Dirvish side bar if it exist."
  (let ((visible (dirvish-side--session-visible-p)))
    (when (window-live-p visible)
      (delete-window visible))))

(after! dired
  ;; (setq dired-mode-map (make-sparse-keymap))
  (remove-key-bindings 'dired-mode-map
                       '("C-x" ",h" "*(" "*." "*O" "M-b" "M-e" "M-f" "M-m" "M-n" "M-s" ))
  (map! :map dired-mode-map
        :ng "k" #'dired-previous-line
        :ng "j" #'dired-next-line
        :ng "RET" #'dired-find-file

        :ng "," #'dired-create-directory
        :ng "." #'dired-create-empty-file
        :ng "d" #'dired-do-delete
        :ng "r" #'dired-do-rename

        :ng "[[" #'dired-prev-dirline
        :ng "]]" #'dired-next-dirline)

  (advice-add 'dired-find-file :after #'dt/close-dirvish-side)
  )

(map! :leader
      :prefix ("f")
      :desc "Write this file" :ng "s" #'write-file
      :desc "Move this file"  :ng "M" #'doom-move-this-file)

(setq-default delete-by-moving-to-trash t) ; Delete files to trash

(map! :leader
      (:prefix ("=" . "open file")
       :desc "Open doom config.org"    "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.org"))
       :desc "Open doom init.org"      "i" #'(lambda () (interactive) (find-file "~/.config/doom/init.el"))
       :desc "Open doom package.org"   "p" #'(lambda () (interactive) (find-file "~/.config/doom/packages.el"))
       :desc "Open doom agenda.org"    "a" #'(lambda () (interactive) (find-file "~/Org/agenda.org"))
       :desc "Open dashboard file"     "=" #'(lambda () (interactive) (find-file "~/.config/doom/dashboard.org"))
       :desc "Open doom module README" "m" #'(lambda () (interactive) (find-file
       "~/.config/emacs/modules/README.org"))
       :desc "Open evil file"          "E" #'(lambda () (interactive) (find-file
       "~/.config/emacs/modules/editor/evil/config.el"))
       :desc "Open default file"       "d" #'(lambda () (interactive) (find-file
       "~/.config/emacs/modules/config/default/+evil-bindings.el"))))

(map! :leader
      (:prefix ("= e" . "open shell files")
       :desc "Open emacs modules folder" "e" #'(lambda () (interactive) (find-file "~/.config/emacs/moudules"))
       :desc "Open eshell aliases"       "a" #'(lambda () (interactive) (find-file "~/.config/doom/eshell/aliases"))
       :desc "Open eshell profile"       "p" #'(lambda () (interactive) (find-file "~/.config/doom/eshell/profile"))))

(setq corfu-auto-delay 0.1
      corfu-count 8
      +corfu-want-minibuffer-completion nil)

(map! :leader
      (:prefix ("s" . "snippets")
       ; TODO 생성된 스니펫 종료시 버퍼가 남음
       :desc "New snippet"         :n "s" (cmd! (+evil/window-split-and-follow)
                                                (yas-new-snippet))
       :desc "Open snippet file"   :n "o" (cmd! (+evil/window-split-and-follow)
                                                (yas-visit-snippet-file))
       :desc "Reload snippet"      :n "r" #'yas-reload-all
       :desc "Show active snippet" :n "a" #'yas-describe-tables
       :desc "Open YASnippet doc"  :n "?" (cmd! (evil-window-split)
                                                (evil-window-move-far-right)
                                                (find-file "~/.config/emacs/.local/straight/repos/yasnippet/doc/index.org"))))

(after! yasnippet
  (map! :map snippet-mode-map
        :localleader
        :desc "Load snippet buffer" :n "l" #'yas-load-snippet-buffer
        :desc "Tryout snippet"      :n "t" #'yas-tryout-snippet)
  ;; Delete default key mapping
  (define-key snippet-mode-map (kbd "C-c C-k") nil)
  (define-key snippet-mode-map (kbd "C-c C-l") nil)
  (define-key snippet-mode-map (kbd "C-c C-t") nil))

(defun dt/yas-expanding-auto-snippets ()
  (when (and (boundp 'yas-minor-mode) yas-minor-mode)
    (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
      (yas-expand))))
(add-hook 'post-command-hook #'dt/yas-expanding-auto-snippets)

;; in $DOOMDIR/config.el
(after! hl-todo
  (setq hl-todo-keyword-faces
        '(
          ("TODO" warning bold)
          ("REVIEW" font-lock-keyword-face bold)
          ("SOMEDAY" font-lock-keyword-face bold)
          ("HACK" font-lock-constant-face bold)
          ("DEPRECATED" font-lock-constant-face bold)
          ("ENHANCE" font-lock-constat-face bold)
          ("NOTE" success bold)
          ("FIXME" error bold)
          ("BUG" error bold)
          ("DONE" font-lock-operator-face bold)
          ("UNKNOWN" font-lock-operator-face bold)
          ("UNUSED" success bold)
        )))

(map! :map org-mode-map
      "C-c" nil)

(setq org-directory my/wiki-dir)

(evil-define-command my/+evil-buffer-org-new (_count file)
  "Creates a new ORG buffer replacing the current window, optionally
   editing a certain FILE"
  :repeat nil
  (interactive "P<f>")
  (if file
      (evil-edit file)
    (let ((buffer (generate-new-buffer "*new org*")))
      (set-window-buffer nil buffer)
      (with-current-buffer buffer
        (org-mode)
        (setq-local doom-real-buffer-p t)))))

(map! :leader
      (:prefix "b"
       :desc "New empty Org buffer" "o" #'my/+evil-buffer-org-new))

(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)
(add-hook 'org-mode-hook #'org-appear-mode)

(setq org-table-plain-columns t)

(after! org
  (setq org-insert-heading-respect-content nil ;; Non-nil means insert new headings after the current subtree.
        org-startup-indented nil
        org-indent-indentation-per-level 2)

  (custom-set-faces
  '(org-document-title ((t (:inherit default :weight bold :foreground "#f380ac" :height 1.5 :underline nil))))
  '(org-level-1 ((t (:inherit default :weight bold :foreground "#f380ac" :height 1.3))))
  '(org-level-2 ((t (:inherit default :weight bold :foreground "#f9e2af" :height 1.3))))
  '(org-level-3 ((t (:inherit default :weight bold :foreground "#89b4fa" :height 1.3))))
  '(org-level-4 ((t (:inherit default :weight bold :foreground "#a6e3a1" :height 1.3))))
  '(org-level-5 ((t (:inherit default :weight bold :foreground "white"))))
  '(org-level-6 ((t (:inherit default :weight bold :foreground "white"))))
  '(org-level-7 ((t (:inherit default :weight bold :foreground "white"))))
  '(org-level-8 ((t (:inherit default :weight bold :foreground "white"))))))

(setq org-modern-fold-stars '(("*" . "*") ("**" . "**") ("***" . "***") ("****" . "****")))
;; (setq org-ellipsis "⋯") ; FIXME

(setq org-hide-emphasis-markers t)
(setq org-appear-autoemphasis t)
;; org-appear-autosubmarkers t) ;; toggle Subscript, superscript markers
;; org-appear-autolinks

;; 변경 사항을 Org-mode에 적용
;; (with-eval-after-load 'org
;;   (org-element-update-syntax))

;; Emphasis 색상은 사용하는 테마와 충돌할 수 있다. 따라서 테마 로드 이후 강조 색상을 재정의한다. (gpt)
;; :foreground "blue" 다음의 설정으로 색상 변경 가능.
(setq org-emphasis-alist
      '(("*" (org-emphasis-bold (:weight ultra-bold)))
        ("/" (org-emphasis-italic (:slant italic)))
        ("_" (org-emphasis-underline (:underline t)))
        ("-" (org-emphasis-strikethrough (:strike-through t)))
        ("=" (org-verbatim (:foreground "#a6e3a1" :background "#181825")))
        ("~" (org-code (:foreground "#a6e3a1" :background "#181825")))))

(map! :map org-mode-map
      :nie "M-\\" (cmd! (insert "\u200B")))

;; 숨기기 설정
(defun my-hide-zero-width-chars ()
  "Make ZERO WIDTH SPACE (U+200B) invisible in this buffer."
  (setq-local glyphless-char-display
              (let ((table (copy-sequence glyphless-char-display)))
                (set-char-table-range table (char-from-name "ZERO WIDTH SPACE") 'zero-width)
                table)))

;; 강조 설정
(defun my-highlight-zero-width-chars ()
  "Highlight ZERO WIDTH SPACE (U+200B) globally with a red background."
  (setq-local glyphless-char-display
              (let ((table (copy-sequence glyphless-char-display)))
                (set-char-table-range table (char-from-name "ZERO WIDTH SPACE") 'thin-space)
                table))
  (set-face-attribute 'glyphless-char nil
                      :background "red"
                      :foreground nil))

;; 강조 토글
(defun my-toggle-zero-width-chars-visibility ()
  "Toggle visibility of ZERO WIDTH SPACE (U+200B)."
  (interactive)
  (let ((current-display (char-table-range glyphless-char-display (char-from-name "ZERO WIDTH SPACE"))))
    (if (eq current-display 'zero-width)
        (my-highlight-zero-width-chars)
      (my-hide-zero-width-chars))))

;; 키 바인딩
(map! :map org-mode-map
      :nie "C-c z" #'my-toggle-zero-width-chars-visibility)

;; Org-mode에서 숨기기 기본 적용
(add-hook 'org-mode-hook #'my-hide-zero-width-chars)

;; (defun +org-export-remove-zero-width-space (text _backend _info)
;;   "Remove zero width spaces from TEXT."
;;   (unless (org-export-derived-backend-p 'org)
;;     (replace-regexp-in-string "\u200B" "" text)))

;; (add-to-list 'org-export-filter-final-output-functions #'+org-export-remove-zero-width-space t)

(setq org-modern-list '((43 . "+")   ; For "+"
                        (45 . "•")   ; For "-"
                        (42 . "➤"))) ; For "*"

(after! org
  (setq org-list-allow-alphabetical t ))

(setq org-startup-with-inline-images t) ; Enable inlnie image preview at startup

(setq org-modern-table-vertical 1
      org-modern-table-horizontal 0.2)

(setq org-modern-priority (quote ((?A . "󰬈") (?B . "󰬉") (?C . "󰬊"))))
      ;; org-modern-priority-faces)

(setq org-modern-progress 10 ;; Width in characters to draw progress bars
      org-modern-progress-complete '(t :background "#1e1e2e" :foreground "#a6e3a1")
      org-modern-progress-incomplete '(t :background "#313244" :foreground "#585b70"))

;; (after! org
;;   (setq org-todo-keywords
;;         '((sequence "TODO(t)" "INPROG(i)" "PROJ(p)" "STORY(s)" "WAIT(w@/!)" "|" "DONE(d@/!)" "KILL(k@/!)")
;;           (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)"))
;;         ;; The triggers break down to the following rules:

;;         ;; - Moving a task to =KILLED= adds a =killed= tag
;;         ;; - Moving a task to =WAIT= adds a =waiting= tag
;;         ;; - Moving a task to a done state removes =WAIT= and =HOLD= tags
;;         ;; - Moving a task to =TODO= removes all tags
;;         ;; - Moving a task to =NEXT= removes all tags
;;         ;; - Moving a task to =DONE= removes all tags
;;         org-todo-state-tags-triggers
;;         '(("KILL" ("killed" . t))
;;           ("HOLD" ("hold" . t))
;;           ("WAIT" ("waiting" . t))
;;           (done ("waiting") ("hold"))
;;           ("TODO" ("waiting") ("cancelled") ("hold"))
;;           ("NEXT" ("waiting") ("cancelled") ("hold"))
;;           ("DONE" ("waiting") ("cancelled") ("hold")))

;;         ;; This settings allows to fixup the state of a todo item without
;;         ;; triggering notes or log.
;;         org-treat-S-cursor-todo-selection-as-state-change nil))

(map! :desc "Org Capture" "C-c c" #'org-capture)

(setq org-default-notes-file (expand-file-name "capture.org" org-directory))

;; TODO 템플릿 추가하기.
(setq org-capture-templates
      '(("t" "Todo" entry
         (file+headline +org-capture-todo-file "Inbox")
         "* [ ] %?\n%i\n%a" :prepend t)))
 ;; ("n" "Personal notes" entry
;;   (file+headline +org-capture-notes-file "Inbox")
;;   "* %u %?\n%i\n%a" :prepend t)
;;  ("j" "Journal" entry
;;   (file+olp+datetree +org-capture-journal-file)
;;   "* %U %?\n%i\n%a" :prepend t)
;;  ("p" "Templates for projects")
;;  ("pt" "Project-local todo" entry
;;   (file+headline +org-capture-project-todo-file "Inbox")
;;   "* TODO %?\n%i\n%a" :prepend t)
;;  ("pn" "Project-local notes" entry
;;   (file+headline +org-capture-project-notes-file "Inbox")
;;   "* %U %?\n%i\n%a" :prepend t)
;;  ("pc" "Project-local changelog" entry
;;   (file+headline +org-capture-project-changelog-file "Unreleased")
;;   "* %U %?\n%i\n%a" :prepend t)
;;  ("o" "Centralized templates for projects")
;;  ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
;;  ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
;;  ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t))

(setq org-time-stamp-custom-formats '("<%Y-%m-%d>" . "<%Y-%m-%d %H:%M")
      org-display-custom-times t)

(setq org-deadline-warning-days 3)

;; (org-clock-auto-clockout-insinuate) ;; When idle automatically clock-out

(setq org-clock-out-when-done t
      org-clock-continuously t
      org-clock-auto-clockout-timer 300 ;; 5분 Idle 시 Clock-out
      org-clock-idle-time 10)

;; (setq org-archive-location "~/org.archive.org::") ;; "%s_archive::"로 해당 파일의 특정 섹션에 추가할 수 있다.
;; (setq org-agenda-skip-archived-trees t) ;; Archive된 항목을 Agenda에서 제외/

;; (use-package! org-ol-tree
;;   :commands org-ol-tree
;;   :config
  ;; (setq org-ol-tree-ui-icon-set
  ;;       (if (and (display-graphic-p)
  ;;                (fboundp 'all-the-icons-material))
  ;;           'all-the-icons
  ;;         'unicode))
  ;; (org-ol-tree-ui--update-icon-set))
;; (setq org-side-tree-persistent t        ; Use a single buffer for all trees
;;       org-side-tree-display-side 'right ; Side of window
;;       org-side-tree-width 30            ; Sets width of side-tree window
;;       org-side-tree-timer-delay .1      ; Timer to update
;;       )

;; (map! :map org-side-tree-mode-map
;;       :desc "Next heading"     :n "j"  #'org-side-tree-next-heading
;;       :desc "Previous heading" :n "k"  #'org-side-tree-previous-heading
;;       :desc ""                 :n "l" #'org-side-tree-next-todo
;;       :desc ""                 :n "h" #'org-side-tree-previous-todo
;;       :desc ""                 :n "K" #'org-side-tree-move-subtree-up
;;       :desc ""                 :n "J" #'org-side-tree-move-subtree-down
;;       :desc ""                 :n "<TAB>" #'org-side-tree-toggle)

(setq org-agenda-skip-comment-trees t
      org-agenda-skip-archived-trees t)

(setq org-agenda-window-setup 'other-window    ;; another options: 'current-window'
      org-agenda-restore-windows-after-quit t) ;; Restore windows when the agenda exits

(setq org-agenda-files (list "~/wiki/inbox.org"
                             "~/wiki/test.org"
                             "~/wiki/agenda.org"))

(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-custom-commands
      '(("i" "Inbox"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                           :todo "NEXT"
                           :order 1)
                          (:name "Important"
                           :tag "Important"
                           :priority "A"
                           :order 6)
                          (:name "Due Today"
                           :deadline today
                           :order 2)
                          (:name "Due Soon"
                           :deadline future
                           :order 8)
                          (:name "Overdue"
                           :deadline past
                           :face error
                           :order 7)
                          (:name "Assignments"
                           :tag "Assignment"
                           :order 10)
                          (:name "Issues"
                           :tag "Issue"
                           :order 12)
                          (:name "Emacs"
                           :tag "Emacs"
                           :order 13)
                          (:name "Projects"
                           :tag "Project"
                           :order 14)
                          (:name "Research"
                           :tag "Research"
                           :order 15)
                          (:name "To read"
                           :tag "Read"
                           :order 30)
                          (:name "Waiting"
                           :todo "WAITING"
                           :order 20)
                          (:name "University"
                           :tag "uni"
                           :order 32)
                          (:name "Trivial"
                           :priority<= "E"
                           :tag ("Trivial" "Unimportant")
                           :todo ("SOMEDAY" )
                           :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

;; (after! org-agenda
;;   (setq org-agenda-files (list "~/org/agenda.org"
;;                                "~/org/todo.org"))
;;   (setq org-agenda-window-setup 'current-window
;;         org-agenda-restore-windows-after-quit t
;;         org-agenda-show-all-dates nil
;;         org-agenda-time-in-grid t
;;         org-agenda-show-current-time-in-grid t
;;         org-agenda-start-on-weekday 1
;;         org-agenda-span 7
;;         org-agenda-tags-column  0
;;         org-agenda-block-separator nil
;;         org-agenda-category-icon-alist nil
;;         org-agenda-sticky t)
;;   (setq org-agenda-prefix-format
;;         '((agenda . "%i %?-12t%s")
;;           (todo .   "%i")
;;           (tags .   "%i")
;;           (search . "%i")))
;;   (setq org-agenda-sorting-strategy
;;         '((agenda deadline-down scheduled-down todo-state-up time-up
;;                   habit-down priority-down category-keep)
;;           (todo   priority-down category-keep)
;;           (tags   timestamp-up priority-down category-keep)
;;           (search category-keep))))


;; (after! org
;;   (remove-hook 'org-agenda-finalize-hook '+org-exclude-agenda-buffers-from-workspace-h)
;;   (remove-hook 'org-agenda-finalize-hook
;;                '+org-defer-mode-in-agenda-buffers-h))

;; (after! org
;;   (setq org-agenda-deadline-faces
;;         '((1.0 . error)
;;           (1.0 . org-warning)
;;           (0.5 . org-upcoming-deadline)
;;           (0.0 . org-upcoming-distant-deadline))))

;; (setq org-gtd-clarify-project-templates
;;    '(("Basic Project" . "* TODO %?\n** TODO First Task\n** TODO Second Task")
;;      ("Detailed Project" . "* TODO %?\n** TODO Define Scope\n** TODO Develop Timeline\n** TODO Execute")))

(setq org-gtd-update-ack "3.0.0") ;; 이것 없이 reload하면 warning이 뜸.

(use-package! org-gtd
  :after org
  :config
  (org-gtd-mode 1) ;; org-gtd-mode enable
  (setq org-gtd-directory (expand-file-name "GTD" org-directory))
        ;; org-gtd-default-files (expand-file-name "inbox.org" org-gtd-directory))
  (map! :leader
        (:prefix ("d" . "org-gtd")
        :desc "Capture thing"      "t" #'org-gtd-capture
        :desc "Process inbox"      "p" #'org-gtd-process-inbox
        :desc "Clarify item"       "l" #'org-gtd-clarify-item
        :desc "Engage"             "e" #'org-gtd-engage
        :desc "Show all Next"      "n" #'org-gtd-show-all-next
        :desc "Show Missed item"   "m" #'org-gtd-oops
        "ff" #'org-gtd-area-of-focus-set-on-item-at-point
        "fa" #'org-gtd-area-of-focus-set-on-agenda-item
        "s" #'org-gtd-review-stuck-projects
        ))
  (map! :map org-gtd-clarify-map
        :leader
        (:prefix ("d" . "org-gtd")
        :desc "Organize item"  "o" #'org-gtd-organize)))

;; (setq org-gtd-horizons-file (expand-file-name "horizons.org" org-gtd-directory)
      ;; org-gtd-clarify-show-horizons 'right)

(setq org-roam-directory my/wiki-dir) ;; wiki file
(setq org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory)) ;; DB file

(org-roam-db-autosync-enable)
(setq org-roam-db-gc-threshold most-positive-fixnum)

(setq org-roam-mode-sections
      (list #'org-roam-backlinks-section
            #'org-roam-reflinks-section
            #'org-roam-unlinked-references-section))

(add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               (display-buffer-in-side-window)
               (side . right)
               (slot . 0)
               (window-width . 0.23) ;; 너무 좁으면 0.33으로 설정
               (window-parameters . ((no-other-window . t)
                                     (no-delete-other-windows . t)))))

;; TODO 뭔지 모르겠음
;; (defun org-roam-buffer-setup ()
;;   "Function to make org-roam-buffer more pretty."
;;   (progn
;;     (setq-local olivetti-body-width 44)
;;     (variable-pitch-mode 1)
;;     (olivetti-mode 1)
;;     (centaur-tabs-local-mode -1)

;;   (set-face-background 'magit-section-highlight (face-background 'default))))

;; (after! org-roam
;; (add-hook! 'org-roam-mode-hook #'org-roam-buffer-setup))

(after! org-roam
  (map! :map org-mode-map
      :localleader
      :prefix ("m" . "org-roam")
      "o" nil  ;; Remove doom keybind for node properties
      (:prefix ("p" . "node properties")
       "a" #'org-roam-alias-add
       "A" #'org-roam-alias-remove
       "t" #'org-roam-tag-add
       "T" #'org-roam-tag-remove
       "r" #'org-roam-ref-add
       "R" #'org-roam-ref-remove)))

;; (require 'org-roam-protocol)

;; (require 'org-roam-export)

;; (use-package! org-roam
;;   :after org
;;   :config
;;   (setq org-roam-v2-ack t)
;;   (setq org-roam-mode-sections
;;         (list #'org-roam-backlinks-insert-section
;;               #'org-roam-reflinks-insert-section
;;               #'org-roam-unlinked-references-insert-section))
;;   (org-roam-db-autosync-enable))

;; (use-package! org-roam-ui
;;   :after org-roam
;;   :config
;;   (setq org-roam-ui-open-on-start nil)
;;   (setq org-roam-ui-browser-function #'xwidget-webkit-browse-url))

;; (use-package! websocket
;;   :after org-roam)

;;  (use-package! org-roam-ui
;;    :after org-roam
;;    :commands org-roam-ui-open
;;    :config
;;    (setq org-roam-ui-sync-theme t
;;          org-roam-ui-follow t
;;          org-roam-ui-update-on-save t
;;          org-roam-ui-open-on-start t))
;;  (after! org-roam
;;  (setq +org-roam-open-buffer-on-find-file nil))

;; (map! :map org-roam-mode-map
;;       :nv "]"       #'magit-section-forward-sibling
;;       :nv "["       #'magit-section-backward-sibling
;;       :nv "gj"      #'magit-section-forward-sibling
;;       :nv "gk"      #'magit-section-backward-sibling
;;       :nv "gr"      #'revert-buffer
;;       :nv "gR"      #'revert-buffer
;;       :nv "z1"      #'magit-section-show-level-1
;;       :nv "z2"      #'magit-section-show-level-2
;;       :nv "z3"      #'magit-section-show-level-3
;;       :nv "z4"      #'magit-section-show-level-4
;;       :nv "za"      #'magit-section-toggle
;;       :nv "zc"      #'magit-section-hide
;;       :nv "zC"      #'magit-section-hide-children
;;       :nv "zo"      #'magit-section-show
;;       :nv "zO"      #'magit-section-show-children
;;       :nv "zm"      #'magit-section-show-level-2-all
;;       :nv "zr"      #'magit-section-show-level-4-all
;;       :nv "C-j"     #'magit-section-forward
;;       :nv "C-k"     #'magit-section-backward
;;       :g  "M-p"     #'magit-section-backward-sibling
;;       :g  "M-n"     #'magit-section-forward-sibling
;;       :g  [tab]     #'magit-section-toggle
;;       :g  [C-tab]   #'magit-section-cycle
;;       :g  [backtab] #'magit-section-cycle-global)))

;; (setq org-roam-capture-templates
;;       '(("p" "Private Note" plain "%?"
;;          :target (file+head "private/${slug}.org.gpg"
;;                             "#+title: ${title}\n")
;;          :unnarrowed t)))

(setq org-capture-templates
       `(("j" "Journal" plain
          (function my/journal-entry)
          "%?"
          :jump-to-captured t
          :empty-lines 1)

         ("i" "Inbox" entry
          (file "inbox.org")
          "* TODO %?\n /Entered on/ %U")))

(defun my/journal-entry ()
  "Find or create a heading in the appropriate monthly journal file."
  (let* ((today (format-time-string "%Y-%m-%d"))
         (day (format-time-string "%a"))
         (heading (format "%s (%s)" today day))
         (file (expand-file-name
                (format "100-Notes/Journal/%s.org" (substring today 0 7))
                org-directory)))
    (unless (file-exists-p file)
      (with-temp-buffer (write-file file)))
    (find-file file)
    (goto-char (point-min))
    (if (re-search-forward (format "^\\* %s$" (regexp-quote heading)) nil t)
        (goto-char (match-beginning 0))
      (goto-char (point-max))
      (unless (bolp) (insert "\n"))
      (insert (format "* %s\n" heading)))
    (list file (point))))

(defun org-capture-inbox ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "i"))

(map! :desc "Add todo to inbox" :n "C-c i" #'org-capture-inbox)

(map! :leader
      :desc "Org agenda" :n "a" #'org-agenda)

(setq org-agenda-hide-tags-regexp "inbox")

;; (setq org-agenda-prefix-format
;;       '((agenda . " %i %-12:c%?-12t% s")
;;         (todo   . " ")
;;         (tags   . " %i %-12:c")
;;         (search . " %i %-12:c")))

(setq vterm-shell "/bin/zsh")

;; (setq vterm-always-compile-module t) ;; UNKNOWN

(setq vterm-kill-buffer-on-exit t)

;; (after! vterm
;;   (setf (alist-get "woman" vterm-eval-cmds nil nil #'equal)
;;         '((lambda (topic)
;;             (woman topic))))
;;   (setf (alist-get "magit-status" vterm-eval-cmds nil nil #'equal)
;;         '((lambda (path)
;;             (magit-status path))))
;;   (setf (alist-get "dired" vterm-eval-cmds nil nil #'equal)
;;         '((lambda (dir)
;;             (dired dir)))))

(map! :map elfeed-search-mode-map
      :after elfeed-search
      [remap kill-this-buffer] "q"
      [remap kill-buffer] "q"
      :n doom-leader-key nil
      :n "q" #'+rss/quit
      :n "e" #'elfeed-update
      :n "r" #'elfeed-search-untag-all-unread
      :n "u" #'elfeed-search-tag-all-unread
      :n "s" #'elfeed-search-live-filter
      :n "RET" #'elfeed-search-show-entry
      :n "p" #'elfeed-show-pdf
      :n "+" #'elfeed-search-tag-all
      :n "-" #'elfeed-search-untag-all
      :n "S" #'elfeed-search-set-filter
      :n "b" #'elfeed-search-browse-url
      :n "y" #'elfeed-search-yank)

(map! :map elfeed-show-mode-map
      :after elfeed-show
      [remap kill-this-buffer] "q"
      [remap kill-buffer] "q"
      :n doom-leader-key nil
      :nm "q" #'+rss/delete-pane
      :nm "o" #'ace-link-elfeed
      :nm "RET" #'org-ref-elfeed-add
      :nm "n" #'elfeed-show-next
      :nm "N" #'elfeed-show-prev
      :nm "p" #'elfeed-show-pdf
      :nm "+" #'elfeed-show-tag
      :nm "-" #'elfeed-show-untag
      :nm "s" #'elfeed-show-new-live-search
      :nm "y" #'elfeed-show-yank)

(after! elfeed-search
  (set-evil-initial-state! 'elfeed-search-mode 'normal))
(after! elfeed-show-mode
  (set-evil-initial-state! 'elfeed-show-mode   'normal))
;; (setq elfeed-goodies/entry-pane-size 0.5)

(setq elfeed-feeds (quote
                    (("https://www.reddit.com/r/emacs.rss" reddit emacs)
                     ;; ("https://hackaday.com/blog/feed/" hackaday linux)
                     ;; ("https://opensource.com/feed" opensource linux)
                     ;; ("https://itsfoss.com/feed/" itsfoss linux)
                     ;; ("https://www.zdnet.com/topic/linux/rss.xml" zdnet linux)
                     ;; ("https://www.computerworld.com/index.rss" computerworld linux)
                     ;; ("https://www.networkworld.com/category/linux/index.rss" networkworld linux)
                     ;; ("https://www.techrepublic.com/rssfeeds/topic/open-source/" techrepublic linux)
                     ;; ("https://betanews.com/feed" betanews linux)
                     ;; ("http://lxer.com/module/newswire/headlines.rss" lxer linux)
                     )))

(after! elfeed

  (elfeed-org)
  (use-package! elfeed-link)

  (setq elfeed-search-filter "@1-week-ago +unread"
        elfeed-search-print-entry-function '+rss/elfeed-search-print-entry
        elfeed-search-title-min-width 80
        elfeed-show-entry-switch #'pop-to-buffer
        elfeed-show-entry-delete #'+rss/delete-pane
        elfeed-show-refresh-function #'+rss/elfeed-show-refresh--better-style
        shr-max-image-proportion 0.6)

  (add-hook! 'elfeed-show-mode-hook (hide-mode-line-mode 1))
  (add-hook! 'elfeed-search-update-hook #'hide-mode-line-mode)

  (defface elfeed-show-title-face '((t (:weight ultrabold :slant italic :height 1.5)))
    "title face in elfeed show buffer"
    :group 'elfeed)
  (defface elfeed-show-author-face `((t (:weight light)))
    "title face in elfeed show buffer"
    :group 'elfeed)
  (set-face-attribute 'elfeed-search-title-face nil
                      :foreground 'nil
                      :weight 'light)

  (defadvice! +rss-elfeed-wrap-h-nicer ()
    "Enhances an elfeed entry's readability by wrapping it to a width of
`fill-column' and centering it with `visual-fill-column-mode'."
    :override #'+rss-elfeed-wrap-h
    (setq-local truncate-lines nil
                shr-width 120
                visual-fill-column-center-text t
                default-text-properties '(line-height 1.1))
    (let ((inhibit-read-only t)
          (inhibit-modification-hooks t))
      (visual-fill-column-mode)
      ;; (setq-local shr-current-font '(:family "Merriweather" :height 1.2))
      (set-buffer-modified-p nil)))

  (defun +rss/elfeed-search-print-entry (entry)
    "Print ENTRY to the buffer."
    (let* ((elfeed-goodies/tag-column-width 40)
           (elfeed-goodies/feed-source-column-width 30)
           (title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
           (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
           (feed (elfeed-entry-feed entry))
           (feed-title
            (when feed
              (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
           (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
           (tags-str (concat (mapconcat 'identity tags ",")))
           (title-width (- (window-width) elfeed-goodies/feed-source-column-width
                           elfeed-goodies/tag-column-width 4))

           (tag-column (elfeed-format-column
                        tags-str (elfeed-clamp (length tags-str)
                                               elfeed-goodies/tag-column-width
                                               elfeed-goodies/tag-column-width)
                        :left))
           (feed-column (elfeed-format-column
                         feed-title (elfeed-clamp elfeed-goodies/feed-source-column-width
                                                  elfeed-goodies/feed-source-column-width
                                                  elfeed-goodies/feed-source-column-width)
                         :left)))

      (insert (propertize feed-column 'face 'elfeed-search-feed-face) " ")
      (insert (propertize tag-column 'face 'elfeed-search-tag-face) " ")
      (insert (propertize title 'face title-faces 'kbd-help title))
      (setq-local line-spacing 0.2)))

  (defun +rss/elfeed-show-refresh--better-style ()
    "Update the buffer to match the selected entry, using a mail-style."
    (interactive)
    (let* ((inhibit-read-only t)
           (title (elfeed-entry-title elfeed-show-entry))
           (date (seconds-to-time (elfeed-entry-date elfeed-show-entry)))
           (author (elfeed-meta elfeed-show-entry :author))
           (link (elfeed-entry-link elfeed-show-entry))
           (tags (elfeed-entry-tags elfeed-show-entry))
           (tagsstr (mapconcat #'symbol-name tags ", "))
           (nicedate (format-time-string "%a, %e %b %Y %T %Z" date))
           (content (elfeed-deref (elfeed-entry-content elfeed-show-entry)))
           (type (elfeed-entry-content-type elfeed-show-entry))
           (feed (elfeed-entry-feed elfeed-show-entry))
           (feed-title (elfeed-feed-title feed))
           (base (and feed (elfeed-compute-base (elfeed-feed-url feed)))))
      (erase-buffer)
      (insert "\n")
      (insert (format "%s\n\n" (propertize title 'face 'elfeed-show-title-face)))
      (insert (format "%s\t" (propertize feed-title 'face 'elfeed-search-feed-face)))
      (when (and author elfeed-show-entry-author)
        (insert (format "%s\n" (propertize author 'face 'elfeed-show-author-face))))
      (insert (format "%s\n\n" (propertize nicedate 'face 'elfeed-log-date-face)))
      (when tags
        (insert (format "%s\n"
                        (propertize tagsstr 'face 'elfeed-search-tag-face))))
      ;; (insert (propertize "Link: " 'face 'message-header-name))
      ;; (elfeed-insert-link link link)
      ;; (insert "\n")
      (cl-loop for enclosure in (elfeed-entry-enclosures elfeed-show-entry)
               do (insert (propertize "Enclosure: " 'face 'message-header-name))
               do (elfeed-insert-link (car enclosure))
               do (insert "\n"))
      (insert "\n")
      (if content
          (if (eq type 'html)
              (elfeed-insert-html content base)
            (insert content))
        (insert (propertize "(empty)\n" 'face 'italic)))
      (goto-char (point-min))))
  )

(after! elfeed-show
  (require 'url)

  (defvar elfeed-pdf-dir
    (expand-file-name "pdfs/"
                      (file-name-directory (directory-file-name elfeed-enclosure-default-dir))))

  (defvar elfeed-link-pdfs
    '(("https://www.jstatsoft.org/index.php/jss/article/view/v0\\([^/]+\\)" . "https://www.jstatsoft.org/index.php/jss/article/view/v0\\1/v\\1.pdf")
      ("http://arxiv.org/abs/\\([^/]+\\)" . "https://arxiv.org/pdf/\\1.pdf"))
    "List of alists of the form (REGEX-FOR-LINK . FORM-FOR-PDF)")

  (defun elfeed-show-pdf (entry)
    (interactive
     (list (or elfeed-show-entry (elfeed-search-selected :ignore-region))))
    (let ((link (elfeed-entry-link entry))
          (feed-name (plist-get (elfeed-feed-meta (elfeed-entry-feed entry)) :title))
          (title (elfeed-entry-title entry))
          (file-view-function
           (lambda (f)
             (when elfeed-show-entry
               (elfeed-kill-buffer))
             (pop-to-buffer (find-file-noselect f))))
          pdf)

      (let ((file (expand-file-name
                   (concat (subst-char-in-string ?/ ?, title) ".pdf")
                   (expand-file-name (subst-char-in-string ?/ ?, feed-name)
                                     elfeed-pdf-dir))))
        (if (file-exists-p file)
            (funcall file-view-function file)
          (dolist (link-pdf elfeed-link-pdfs)
            (when (and (string-match-p (car link-pdf) link)
                       (not pdf))
              (setq pdf (replace-regexp-in-string (car link-pdf) (cdr link-pdf) link))))
          (if (not pdf)
              (message "No associated PDF for entry")
            (message "Fetching %s" pdf)
            (unless (file-exists-p (file-name-directory file))
              (make-directory (file-name-directory file) t))
            (url-copy-file pdf file)
            (funcall file-view-function file))))))

  )

(defun my/run-sync-wiki ()
  "Run sync_wiki script."
  (interactive)
  (start-process-shell-command "sync-wiki" nil "~/.config/hypr/scripts/sync_wiki"))

;; Run wiki_sync script before Emacs exits.
(add-hook 'kill-emacs-hook #'my/run-sync-wiki)

(map! :desc "Run wiki sync" :n "= w" #'my/run-sync-wiki​) ;; FIXME

(defun my/push-dotfiles ()
  "Run push-dotfiles script."
  (interactive)
  (start-process-shell-command "push-dotfiles" nil "~/.config/hypr/scripts/push_dotfiles"))

(map! :desc "Push dotfiles" :n "= d" #'my/push-dotfiles)
