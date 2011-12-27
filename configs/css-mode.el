;; css-mode
(defvar cssm-indent-level 2 "The indentation level inside rules.")
(defvar cssm-mirror-mode t
  "Whether brackets, quotes etc should be mirrored automatically on
  insertion.")
(defvar cssm-newline-before-closing-bracket t
  "In mirror-mode, controls whether a newline should be inserted before the
closing bracket or not.")
(defvar cssm-indent-function 'cssm-c-style-indenter
  "Which function to use when deciding which column to indent to. To get
C-style indentation, use cssm-c-style-indenter. To get old-style indentation,
use cssm-old-style-indenter.")
