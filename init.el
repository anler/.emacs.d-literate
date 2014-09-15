(require 'cask "~/.cask/cask.el")

;; Path to manually installed tramp version (2.2.10) since couldn't use sudo with
;; the default one (2.2.6) in Fedora 20
(add-to-list 'load-path (expand-file-name "/usr/local/share/emacs/site-lisp"))

(cask-initialize)
(require 'pallet)
(require 'cl)

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
(load "~/.emacs.d/custom-load-path.el" 'noerror)
