==================================
My Emacs Configuration
==================================

This is my emacs configs which I'm currently running under version 23.0.92.

**Usage**

git clone git://github.com/gregnewman/20seven-emacs.git

ln -s ~/20seven-emacs ~/.emacs.d
git submodule init
git submodule update

***NOTE***
Check proper initialization of submodules (org-mode repo return timeouts from time to time)

These configs are used daily for my work to include but not limited to Python/Django, Rails, CSS, JS and GTD (ord-mode).

**Submodules**

I try to use as many submodules as I can to keep up to date with development releases. Current submodules are:

* vendor/color-theme/color-theme-github (heads/master)
* vendor/color-theme/color-theme-merbivore (heads/master)
* vendor/color-theme/twilight-emacs (heads/master)
* vendor/emacs-grep-o-matic (heads/master)
* vendor/org-mode (release_6.30d-6-g206660b)
* vendor/remember-2.0 (v2.0-1-gc427b15)
* vendor/slime (heads/master)
* vendor/smex (heads/master)
* vendor/yasnippet/snippets/django-mode (heads/master)
