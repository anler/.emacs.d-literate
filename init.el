(require 'cask "~/.cask/cask.el")
(add-to-list 'load-path (expand-file-name "~/elisp/org-mode/lisp"))
(add-to-list 'load-path (expand-file-name "~/elisp/org-mode/contrib/lisp"))

(cask-initialize)
(require 'pallet)

(defun load-init (path)
  "Load"
  (with-temp-buffer
    (insert-file path)
    (goto-char (point-min))
    (while (not (eobp))
      (forward-line 1)
      (cond
       ;; Report Headers
       ((looking-at
         "\\* +.*$")
        (message "%s" (match-string 0)))
       ;; Evaluate Code Blocks
       ((looking-at "^#\\+BEGIN_SRC elisp$")
        (let ((l (match-end 0)))
          (search-forward "\n#+END_SRC")
          (eval-region l (match-beginning 0))))
       ;; Finish on the next level-1 header
       ((looking-at "^\\* ")
        (goto-char (point-max)))))))

(load-init "~/.emacs.d/README.org")
