;;;
;;; Org Mode
;;;

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))

(require 'org)
(require 'org-install)
(require 'org-protocol)
(server-start)


(defun my-custom-handler (data)
  (let ((content (org-protocol-split-data data t)))
    (delete-other-windows)
    (sit-for 2)
    (animate-sequence content 2))
  nil)

(setq org-protocol-protocol-alist
      '(("Screencast goodie"
         :protocol "screencast"
         :function my-custom-handler)))

;;
;; Standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-agenda-files (quote ("~/.org-tasks/client-projects.org"
                               "~/.org-tasks/home-projects.org"
                               "~/.org-tasks/studio-projects.org"
                               "~/.org-tasks/notes.org"
                               "~/.org-tasks/phone.org"
                               "~/.org-tasks/inbox.org"
                               "~/.org-tasks/mind.org"
                               "~/.org-tasks/archive.org")))

(defun gtd ()
   (interactive)
   (find-file "~/.org-tasks/todo.org")
)

(setq org-drawers (quote ("PROPERTIES" "CLOCK" "LOGBOOK" "NOTES" "COMMENTS" "LINKS")))

(setq org-todo-keywords (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!/!)")
 (sequence "WAITING(w@/!)" "SOMEDAY(S!)" "PROJECT(P@)" "OPEN(O@)" "|" "CANCELLED(c@/!)")
 (sequence "QUOTE(q!)" "QUOTED(Q!)" "|" "APPROVED(A@)" "EXPIRED(E@)" "REJECTED(R@)"))))

(setq org-todo-keyword-faces (quote (("TODO" :foreground "red" :weight bold)
 ("STARTED" :foreground "blue" :weight bold)
 ("DONE" :foreground "forest green" :weight bold)
 ("WAITING" :foreground "orange" :weight bold)
 ("SOMEDAY" :foreground "magenta" :weight bold)
 ("CANCELLED" :foreground "forest green" :weight bold)
 ("PROJECT" :foreground "red" :weight bold))))


(setq org-use-fast-todo-selection t)

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t) ("NEXT"))
              ("SOMEDAY" ("WAITING" . t))
              (done ("NEXT") ("WAITING"))
              ("TODO" ("WAITING") ("CANCELLED"))
              ("STARTED" ("WAITING"))
              ("PROJECT" ("CANCELLED") ("PROJECT" . t)))))

;;
;; Resume clocking tasks when emacs is restarted
(setq org-clock-persistence-insinuate)
;;
;; Yes it's long... but more is better ;)
(setq org-clock-history-length 35)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change task state to STARTED when clocking in
(setq org-clock-in-switch-to-state "STARTED")
;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Don't clock out when moving task to a done state
(setq org-clock-out-when-done nil)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Agenda clock report parameters (no links, 2 levels deep)
(setq org-agenda-clockreport-parameter-plist (quote (:link nil :maxlevel 2)))
; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")
; global Effort estimate values
(setq org-global-properties (quote (("Effort_ALL" . "0:10 0:30 1:00 2:00 3:00 4:00 5:00 6:00 8:00"))))
; generate unique attachment id's
(setq org-id-method (quote uuidgen))
; copy org attachments
(setq org-attach-method 'cp)
; set copy directory
(setq org-attach-directory "~/.org-tasks/data")
; underline the line in the agenda that you are on
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))

(add-hook 'org-clock-in-prepare-hook 
          'my-org-mode-ask-effort)

; use org-clock-in-prepare-hook to add an effort estimate. 
; This way you can easily have a "tea-timer" for your tasks when they don't 
; already have an effort estimate.
(defun my-org-mode-ask-effort ()
  "Ask for an effort estimate when clocking in."
  (unless (org-entry-get (point) "Effort")
    (let ((effort 
           (completing-read 
            "Effort: "
            (org-entry-get-multivalued-property (point) "Effort"))))
      (unless (equal effort "")
        (org-set-property "Effort" effort)))))


(org-remember-insinuate)
     (setq org-directory "~/.org-tasks/")
     (setq org-default-notes-file (concat org-directory "/notes.org"))
     (define-key global-map "\C-cr" 'org-remember)

;; Start clock if a remember buffer includes :CLOCK-IN:
(add-hook 'remember-mode-hook 'my-start-clock-if-needed 'append)


(defun my-start-clock-if-needed ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward " *:CLOCK-IN: *" nil t)
      (replace-match "")
      (org-clock-in))))


;; I use C-M-r to start org-remember
(global-set-key (kbd "C-M-r") 'org-remember)

;; Keep clocks running
(setq org-remember-clock-out-on-exit nil)

;; C-c C-c stores the note immediately
(setq org-remember-store-without-prompt t)

;; I don't use this -- but set it in case I forget to specify a location in a future template
(setq org-remember-default-headline "Tasks")

;; 3 remember templates for TODO tasks, Notes, and Phone calls
(setq org-remember-templates (quote (("todo" ?t "* TODO %?
  %u
  %a" "~/hgfiles/org/tasks.org" bottom nil)
                                     ("note" ?n "* %?                                      :NOTE:
  %u
  %a" nil bottom nil)
                                     ("phone" ?p "* PHONE %:name - %:company -                :PHONE:
  Contact Info: %a
  %u
  :CLOCK-IN:
  %?" "~/.org-tasks/phone.org" bottom nil))))



;;
;; REFILES
;;
; Use IDO for target completion
(setq org-completion-use-ido t)

; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel . 5))))

; Targets start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))

;;
;; Custom Agendas
;;
(setq org-agenda-custom-commands 
      (quote (("P" "Projects" tags "/!PROJECT" ((org-use-tag-inheritance nil)))
              ("s" "Started Tasks" todo "STARTED" ((org-agenda-todo-ignore-with-date nil)))
              ("w" "Tasks waiting on something" tags "WAITING" ((org-use-tag-inheritance nil)))
              ("r" "Refile New Notes and Tasks" tags "REFILE" ((org-agenda-todo-ignore-with-date nil)))
              ("n" "Notes" tags "NOTES" nil))))

; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@Errand" . ?e)
                            ("@Work" . ?w)
                            ("@Home" . ?h)
                            ("@Phone" . ?p)
                            ("@Mind" . ?m)
                            ("@Studio" . ?s)
                            (:endgroup)
                            ("NEXT" . ?N)
                            ("PROJECT" . ?P)
                            ("WAITING" . ?W)
                            ("HOME" . ?H)
                            ("ORG" . ?O)
                            ("PLAY" . ?p)
                            ("R&D" . ?r)
                            ("MIND" . ?m)
                            ("STUDIO" . ?S)
                            ("CANCELLED" . ?C))))

;;
;; REMINDERS
;;
; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)

; Erase all reminders and rebuilt reminders for today from the agenda
(defun my-org-agenda-to-appt ()
  (interactive)
  (setq appt-time-msg-list nil)
  (org-agenda-to-appt))

; Rebuild the reminders everytime the agenda is displayed
(add-hook 'org-finalize-agenda-hook 'my-org-agenda-to-appt)

; This is at the end of my .emacs - so appointments are set up when Emacs starts
; TODO: FIX THIS!!
;(my-org-agenda-to-appt)

; Activate appointments so we get notifications
(appt-activate t)

; If we leave Emacs running overnight - reset the appointments one minute after midnight
(run-at-time "24:01" nil 'my-org-agenda-to-appt)


;;
;; NARROW THE VIEW TO A SUBTREE
;;
(global-set-key (kbd "<f5>") 'my-org-todo)

(defun my-org-todo ()
  (interactive)
  (org-narrow-to-subtree)
  (org-show-todo-tree nil)
  (widen))


;;
;; Remove Tasks With Dates From The Global Todo Lists
;;
;; Keep tasks with dates off the global todo lists
(setq org-agenda-todo-ignore-with-date t)

;; Remove completed deadline tasks from the agenda view
(setq org-agenda-skip-deadline-if-done t)

;; Remove completed scheduled tasks from the agenda view
(setq org-agenda-skip-scheduled-if-done t)


;; Show all future entries for repeating tasks
(setq org-agenda-repeating-timestamp-show-all t)

;; Show all agenda dates - even if they are empty
(setq org-agenda-show-all-dates t)

;; Sorting order for tasks on the agenda
(setq org-agenda-sorting-strategy
      (quote ((agenda time-up priority-down effort-up category-up)
              (todo priority-down)
              (tags priority-down))))

;; Start the weekly agenda today
(setq org-agenda-start-on-weekday nil)

;; Disable display of the time grid
(setq org-agenda-time-grid
      (quote (nil "----------------"
                  (800 1000 1200 1400 1600 1800 2000))))


(load "~/.emacs.d/vendor/org-mode/contrib/lisp/org-checklist")
;; to use it in a task you simply set the property RESET_CHECK_BOXES to t like this

;; save all org files every minute
(run-at-time "00:59" 3600 'org-save-all-org-buffers)
;; after save push to mobile stage dir
(add-hook 'after-save-hook 'org-mobile-push)

;; Custom Key Bindings
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "<f5>") 'my-org-todo)
(global-set-key (kbd "<S-f5>") 'widen)
(global-set-key (kbd "<f7>") 'set-truncate-lines)
(global-set-key (kbd "<f8>") 'org-cycle-agenda-files)
(global-set-key (kbd "<f9> b") 'bbdb)
(global-set-key (kbd "<f9> c") 'calendar)
(global-set-key (kbd "<f9> f") 'boxquote-insert-file)
(global-set-key (kbd "<f9> g") 'gnus)
(global-set-key (kbd "<f9> o") 'org-occur)
(global-set-key (kbd "<f9> r") 'boxquote-region)
(global-set-key (kbd "<f9> u") (lambda ()
                                 (interactive)
                                 (untabify (point-min) (point-max))))
(global-set-key (kbd "<f9> v") 'visible-mode)
(global-set-key (kbd "C-<f9>") 'previous-buffer)
(global-set-key (kbd "C-x n r") 'narrow-to-region)
(global-set-key (kbd "C-<f10>") 'next-buffer)
(global-set-key (kbd "<f11>") 'org-clock-goto)
(global-set-key (kbd "C-s-<f12>") 'my-save-then-publish)


;; MOBILE ORG
(require 'org-mobile)

(setq org-mobile-directory "~/.org-tasks/stage/") 
(setq org-mobile-inbox-for-pull "~/.org-tasks/inbox.org")

;; journaling hack taken from
;; http://metajack.im/2009/01/01/journaling-with-emacs-orgmode/
(defvar org-journal-file "~/.org-tasks/journal.org"
  "Path to OrgMode journal file.")
(defvar org-journal-date-format "%Y-%m-%d"
  "Date format string for journal headings.")

(defun org-journal-entry ()
  "Create a new diary entry for today or append to an existing one."
  (interactive)
  (switch-to-buffer (find-file org-journal-file))
  (widen)
  (let ((today (format-time-string org-journal-date-format)))
    (beginning-of-buffer)
    (unless (org-goto-local-search-headings today nil t)
      ((lambda () 
         (org-insert-heading)
         (insert today)
         (insert "\n\n  \n"))))
    (beginning-of-buffer)
    (org-show-entry)
    (org-narrow-to-subtree)
    (end-of-buffer)
    (backward-char 2)
    (unless (= (current-column) 2)
      (insert "\n\n  "))))

(global-set-key (kbd "C-c j") 'org-journal-entry)


;; set appt waring to 15 minutes prior to appointment
(setq appt-message-warning-time 15)
;; use todochiku for growl notifications of events
(setq org-show-notification-handler
  '(lambda (notification)
    (todochiku-message "org-mode notification" notification
      (todochiku-icon 'emacs))))

;; set org indent
;(setq org-indent-mode t)
;; set speed commands
(setq org-use-speed-commands t)