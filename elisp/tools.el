;; ===== autocompletion mode
(setq auto-completion-enable-sort-by-usage t
      auto-completion-enable-snippets-in-popup t)

;; ===== leetcode mode
(setq-default leetcode-prefer-language "cpp")
(setq-default leetcode-prefer-sql "mysql")
;; ===== translate
(setq-default google-translate-default-source-language "en")
(setq-default google-translate-default-target-language "zh-cn")
(setq-default google-translate-translation-directions-alist '(("en" . "zh-cn")("zh-cn" . "en")))
(setq-default google-translate--tkk-url "http://translate.google.cn")
(setq-default google-translate-base-url "http://translate.google.cn/translate_a/single")
(setq-default google-translate-listen-url "http://translate.google.cn/translate_tts")
(setq-default google-translate-output-destination 'echo-area)
(setq-default google-translate-pop-up-buffer-set-focus t)
;; ===== elfeed mode
(setq rmh-elfeed-org-files (list
                            "~/Documents/Garage/orgible/elfeed.org"
                            ))

;; ===== email mu4e mode
(setq mu4e-account-alist t
      mu4e-enable-notifications t
      mu4e-installation-path "/usr/local/Cellar/mu/1.2.0_1/share/emacs/site-lisp/mu/mu4e")

(setq mu4e-account-alist
      '(
        ;; ("outlook"
        ;;  ;; under each account, set the account-specific variables you want.
        ;;  (mu4e-sent-messages-behavior sent)
        ;;  (mu4e-sent-folder "/outlook/.sent-mail")
        ;;  (mu4e-drafts-folder "/outlook/.drafts")
        ;;  (user-mail-address "chengxinhust@outlook.com")
        ;;  (user-full-name "chxin"))
        ("college"
         (mu4e-sent-messages-behavior sent)
         (mu4e-sent-folder "/college/.sent-items")
         (mu4e-drafts-folder "/college/.drafts")
         (user-mail-address "chengxin@hust.edu.cn")
         (user-full-name "xin cheng"))
        ("163"
         (mu4e-sent-messages-behavior sent)
         (mu4e-sent-folder "/163/.sent-items")
         (mu4e-drafts-folder "/163/.drafts")
         (user-mail-address "chengxinhust@163.com")
         (user-full-name "xin cheng"))
        ))
;; (mu4e/mail-account-reset)
;; set up some common mu4e variables
(setq mu4e-maildir "~/.mail"
      mu4e-trash-folder "/.mail/.trash"
      mu4e-refile-folder "/.mail/.archive"
      mu4e-get-mail-command "offlineimap"
      mu4e-update-interval 3600
      mu4e-compose-signature-auto-include nil
      mu4e-view-show-images t
      mu4e-view-show-addresses t)
;; mail directory shortcuts
(setq mu4e-maildir-shortcuts
      '(
        ;; ("/outlook/inbox" . ?w
        ("/163/inbox" . ?1)
        ("/college/inbox" . ?c)))
;; bookmarks
(setq mu4e-bookmarks
      `(("flag:unread and not flag:trashed" "unread messages" ?u)
        ("date:today..now" "today's messages" ?t)
        ("date:7d..now" "last 7 days" ?w)
        ("mime:image/*" "messages with images" ?p)
        (,(mapconcat 'identity
                     (mapcar
                      (lambda (maildir)
                        (concat "maildir:" (car maildir)))
                      mu4e-maildir-shortcuts) " or ")
         "all inboxes" ?i)))
;; os notifications
(setq mu4e-enable-notifications t)
(with-eval-after-load 'mu4e-alert
  ;; enable desktop notifications
  ;; (mu4e-alert-set-default-style 'notifications)) ; for linux
  ;; (mu4e-alert-set-default-style 'libnotify))  ; alternative for linux
  (mu4e-alert-set-default-style 'notifier))   ; for mac osx (through the
                                        ; terminal notifier app)
;; (mu4e-alert-set-default-style 'growl))      ; alternative for mac osx
(setq mu4e-enable-mode-line t)
;; ===== eww
;; (defun eww-toggle-images ()
;;   "toggle whether images are loaded and reload the current page fro cache."
;;   (interactive)
;;   (setq shr-inhibit-images (not shr-inhibit-images))
;;   (eww-reload t)
;;   (message "images are now %s"
;;            (if shr-inhibit-images "off" "on")))
;; ;; toggle image display
;; (define-key eww-mode-map (kbd "i") #'eww-toggle-images)
;; (define-key eww-link-keymap (kbd "i") #'eww-toggle-images)
;; ;; minimal rendering by default
;; (setq shr-inhibit-images t)   ; toggle with `i`
;; (setq shr-use-fonts nil)      ; toggle with `f`
(setq browse-url-browser-function 'eww-browse-url)
;; ===== shell mode
(setq shell-default-shell 'term
      shell-default-height 30
      shell-default-position 'bottom)


;; end
(provide 'tools)
