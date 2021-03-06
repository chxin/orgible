;; ===== set org-mode for org, org_archive, txt
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
;;
;; ===== agenda file: refile, search agenda
;; manage manually!
(if (boundp 'org-user-agenda-files)
    (setq org-agenda-files org-user-agenda-files)
  (setq org-agenda-files (quote ("~/Documents/Garage/orgible/inbox.org"
                                 "~/Documents/Garage/orgible/refile/"
                                 "~/Documents/Garage/orgible/oxrign/"
                                 ))))
;; ===== Standard key bindings
;; Custom Key Bindings
(global-set-key (kbd "C-c b f") 'bh/org-todo)
(global-set-key (kbd "C-c b w") 'bh/widen)
(global-set-key (kbd "C-c b t") 'bh/set-truncate-lines)
(global-set-key (kbd "C-c b s") 'bh/show-org-agenda)
(global-set-key (kbd "C-c b h") 'bh/hide-other)
(global-set-key (kbd "C-c b g") 'bh/toggle-next-task-display)
(global-set-key (kbd "C-c b i") 'bh/punch-in)
(global-set-key (kbd "C-c b o") 'bh/punch-out)
(global-set-key (kbd "C-c b m") 'bh/make-org-scratch)
(global-set-key (kbd "C-c b x") 'boxquote-region)
(global-set-key (kbd "C-c b '") 'bh/switch-to-scratch)
(global-set-key (kbd "C-c b #") 'bh/insert-inactive-timestamp)
(global-set-key (kbd "C-c b !") 'bh/toggle-insert-inactive-timestamp)
(global-set-key (kbd "C-c b l") 'bh/clock-in-last-task)
(global-set-key (kbd "C-c b p") 'bh/save-then-publish)
(global-set-key (kbd "C-c c") 'org-capture)
(defun bh/hide-other ()
  (interactive)
  (save-excursion
    (org-back-to-heading 'invisible-ok)
    (hide-other)
    (org-cycle)
    (org-cycle)
    (org-cycle)))
(defun bh/set-truncate-lines ()
  "Toggle value of truncate-lines and refresh window display."
  (interactive)
  (setq truncate-lines (not truncate-lines))
  ;; now refresh window display (an idiom from simple.el):
  (save-excursion
    (set-window-start (selected-window)
                      (window-start (selected-window)))))
(defun bh/make-org-scratch ()
  (interactive)
  (find-file "/tmp/publish/scratch.org")
  (gnus-make-directory "/tmp/publish"))
(defun bh/switch-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))
;; ===== org todo keywords
;;; "@" to add comments
;;; "!" to add timestamp
(setq system-time-locale "C")
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "SCHEDULE(s)" "DEADLINE(d)" "WAITING(w@)" "HOLD(h@/!)" "|" "CANCELLED(c@)" "FINISHED(f!)" "PHONE" "MEETING"))))
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("FINISHED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              ("DONE" ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))
(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
;; ===== org capture
(setq org-directory "~/Documents/Garage/orgible")
(setq org-default-notes-file "~/Documents/Garage/orgible/inbox.org")
;; I use C-c c to start capture mode
(global-set-key (kbd "C-c c") 'org-capture)
;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "Todo" entry (file "~/Documents/Garage/orgible/inbox.org")
                "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "Respond" entry (file "~/Documents/Garage/orgible/inbox.org")
                "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "Note" entry (file "~/Documents/Garage/orgible/inbox.org")
                "* %? :NOTE:\n%U\n%F\n%a\n" :clock-in t :clock-resume t)
              ("i" "Interrupt" entry (file+datetree "~/Documents/Garage/orgible/inbox.org")
                "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "Review" entry (file "~/Documents/Garage/orgible/inbox.org")
                "* TODO Review %c\t%F\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/Documents/Garage/orgible/inbox.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone Call" entry (file "~/Documents/Garage/orgible/inbox.org")
                "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("e" "Email" entry (file "~/Documents/Garage/orgible/inbox.org")
               "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n" :immediate-finish t)
              ("h" "Habit" entry (file "~/Documents/Garage/orgible/inbox.org")
               "* NEXT %?\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n%U\n%a\n"))))
;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    ;; (org-remove-empty-drawer-at "LOGBOOK" (point))))
    (org-remove-empty-drawer-at (point))))
(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)
;; ===== org refile
; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes (quote confirm))
;; (setq org-completion-use-ido t)
;; (setq ido-everywhere t)
;; (setq ido-max-directory-size 100000)
;; (ido-mode (quote both))
;; (setq ido-default-file-method 'selected-window)
;; (setq ido-default-buffer-method 'selected-window)
(setq org-indirect-buffer-display 'current-window)
;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq org-refile-target-verify-function 'bh/verify-refile-target)
;; ===== org agenda
;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)
;; Compact the block agenda view
(setq org-agenda-compact-blocks t)
;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("n" "notes" tags "NOTE"
                ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "habits" tags-todo "STYLE=\"habit\""
                ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                  '(todo-state-down effort-up category-keep))))
              ("O" "Office block agenda"
                ((agenda "" ((org-agenda-span 1)))
                ;; limits the agenda display to a single day
                (tags-todo "+PRIORITY=\"A\"")
                (tags-todo "computer|office|phone")
                (tags "project+CATEGORY=\"elephants\"")
                (tags "review" ((org-agenda-files '("/Users/xin/Documents/Garage/orgible/inbox.org"))))
                ;; limits the tag search to the file circuspeanuts.org
                (todo "WAITING"))
                ((org-agenda-compact-blocks t))) ;; options set here apply to the entire block
              ("W" "Weekly Review"
                ((agenda "" ((org-agenda-span 7))); review upcoming deadlines and appointments
                                      ; type "l" in the agenda to review logged items
                (stuck "") ; review stuck projects as designated by org-stuck-projects
                (todo "PROJECT") ; review all projects (assuming you use todo keywords to designate projects)
                (todo "MAYBE") ; review someday/maybe items
                (todo "WAITING"))) ; review waiting items
              ("p" "agenda"
                ((agenda "" nil)
                (tags "refile"
                      ((org-agenda-overriding-header "tasks to refile")
                        (org-tags-match-list-sublevels nil)))
                (tags-todo "-cancelled/!"
                            ((org-agenda-overriding-header "stuck projects")
                            (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                            (org-agenda-sorting-strategy
                              '(category-keep))))
                (tags-todo "-hold-cancelled/!"
                            ((org-agenda-overriding-header "projects")
                            (org-agenda-skip-function 'bh/skip-non-projects)
                            (org-tags-match-list-sublevels 'indented)
                            (org-agenda-sorting-strategy
                              '(category-keep))))
                (tags-todo "-cancelled/!next"
                            ((org-agenda-overriding-header (concat "project next tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including waiting and scheduled tasks)")))
                            (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                            (org-tags-match-list-sublevels t)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                              '(todo-state-down effort-up category-keep))))
                (tags-todo "-refile-cancelled-waiting-hold/!"
                            ((org-agenda-overriding-header (concat "project subtasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including waiting and scheduled tasks)")))
                            (org-agenda-skip-function 'bh/skip-non-project-tasks)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                              '(category-keep))))
                (tags-todo "-refile-cancelled-waiting-hold/!"
                            ((org-agenda-overriding-header (concat "standalone tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including waiting and scheduled tasks)")))
                            (org-agenda-skip-function 'bh/skip-project-tasks)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                              '(category-keep))))
                (tags-todo "-cancelled+waiting|hold/!"
                            ((org-agenda-overriding-header (concat "waiting and postponed tasks"
                                                                  (if bh/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including waiting and scheduled tasks)")))
                            (org-agenda-skip-function 'bh/skip-non-tasks)
                            (org-tags-match-list-sublevels nil)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
                (tags "-refile/"
                      ((org-agenda-overriding-header "tasks to archive")
                        (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                        (org-tags-match-list-sublevels nil))))
                nil))))
(defun bh/org-auto-exclude-function (tag)
  "Automatic task exclusion in the agenda with / RET"
  (and (cond
        ((string= tag "hold")
         t)
        ((string= tag "farm")
         t))
       (concat "-" tag)))
(setq org-agenda-auto-exclude-function 'bh/org-auto-exclude-function)
;; ===== time clock in and out
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)
(setq bh/keep-clock-running nil)
(defun bh/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task has-subtask))))
(defun bh/is-project-subtree-p ()
  "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
                              (point))))
    (save-excursion
      (bh/find-project-task)
      (if (equal (point) task)
          nil
        t))))
(defun bh/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))
(defun bh/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
        (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq is-subproject t))))
    (and is-a-task is-subproject)))
(defun bh/clock-in-to-next (kw)
  "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
           (bh/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
           (bh/is-project-p))
      "TODO"))))
(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))
(defun bh/punch-in (arg)
  "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
  (interactive "p")
  (setq bh/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; We're in the agenda
      ;;
      (let* ((marker (org-get-at-bol 'org-hd-marker))
             (tags (org-with-point-at marker (org-get-tags-at))))
        (if (and (eq arg 4) tags)
            (org-agenda-clock-in '(16))
          (bh/clock-in-default-task-as-default)))
    ;;
    ;; We are not in the agenda
    ;;
    (save-restriction
      (widen)
      ; Find the tags on the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
          (org-clock-in '(16))
        (bh/clock-in-default-task-as-default)))))
(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))
(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))
(defun bh/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
        (widen)
        (while (and (not parent-task) (org-up-heading-safe))
          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq parent-task (point))))
        (if parent-task
            (org-with-point-at parent-task
              (org-clock-in))
          (when bh/keep-clock-running
            (bh/clock-in-default-task)))))))
(defvar bh/default-task-id "EB155A82-92B2-4F25-A3C6-0304591AF2F9")
(defun bh/clock-in-default-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find bh/default-task-id 'marker)
    (org-clock-in '(16))))
(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
             (not org-clock-clocking-in)
             (marker-buffer org-clock-default-task)
             (not org-clock-resolving-clocks-due-to-idleness))
    (bh/clock-in-parent-task)))
(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)
(require 'org-id)
(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker)
    (org-clock-in nil)))
(defun bh/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
         (cond
          ((eq arg 4) org-clock-default-task)
          ((and (org-clock-is-active)
                (equal org-clock-default-task (cadr org-clock-history)))
           (caddr org-clock-history))
          ((org-clock-is-active) (cadr org-clock-history))
          ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
          (t (car org-clock-history)))))
    (widen)
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))
(setq org-time-stamp-rounding-minutes (quote (1 1)))
(setq org-agenda-clock-consistency-checks
      (quote (:max-duration "4:00"
              :min-duration 0
              :max-gap 0
              :gap-ok-around ("4:00"))))
;; ===== time report
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
      (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))
; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")
; global Effort estimate values
; global STYLE property values for completion
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                    ("STYLE_ALL" . "habit"))))
;; Agenda log mode items to display (closed and state changes by default)
;; ===== Tags
; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@errand" . ?e)
                            ("@office" . ?o)
                            ("@home" . ?H)
                            ("@farm" . ?f)
                            (:endgroup)
                            ("WAITING" . ?w)
                            ("HOLD" . ?h)
                            ("PERSONAL" . ?P)
                            ("WORK" . ?W)
                            ("FARM" . ?F)
                            ("ORG" . ?O)
                            ("NORANG" . ?N)
                            ("crypt" . ?E)
                            ("NOTE" . ?n)
                            ("CANCELLED" . ?c)
                            ("FLAGGED" . ??))))
; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))
; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)
;; ===== archive
(setq org-archive-location "~/Documents/Garage/orgible/refile/archive.org::datetree/* Finished Tasks")
;; ===== org projectile
(setq org-projectile-projects-file
      "~/Documents/Garage/orgible/refile/projects.org")
;; (with-eval-after-load 'org-projectile
;; (push (org-projectile-project-todo-entry) org-capture-templates)
;;   (push (org-projectile-project-todo-entry
;;          :capture-template org-projectile-capture-template
;;          :capture-heading "Project ToDo"
;;          :capture-character "l") org-capture-templates)
;; )
;; (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))

;; end
(provide 'norange-gtd)
