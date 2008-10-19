;; Other configuration;; no splash screen(setq inhibit-startup-message t);; use UTF-8(prefer-coding-system 'utf-8);; make pretty(global-font-lock-mode 1) ;; shows current selected region(setq-default transient-mark-mode t);; indent via spaces not tabs(setq-default indent-tabs-mode nil);; titlebar = buffer unless filename(setq frame-title-format '(buffer-file-name "%f" ("%b")));; show paired parenthasis(show-paren-mode 1);(set-default-font "-adobe-courier-bold-o-normal--18-180-75-75-m-110-iso8859-13");; TAB => 4*'\b'(setq default-tab-width 4);; turn off tool bar, and menu bar(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1));; Make sure we have font-lock to start with(require 'font-lock);; log the time of the things I have done(setq-default org-log-done t);; get rid of yes-or-no questions - y or n is enough(defalias 'yes-or-no-p 'y-or-n-p);; When things go wrong, turn this on;(toggle-debug-on-error t)