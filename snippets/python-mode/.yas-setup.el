(defun python-split-args (arg-string)
  "Split a python argument string into ((name, default)..) tuples"
  (mapcar '(lambda (x)
             (split-string x "[[:blank:]]*=[[:blank:]]*" t))
          (split-string arg-string "[[:blank:]]*,[[:blank:]]*" t)))

(defun python-args-to-docstring ()
  "return docstring format for the python arguments in yas-text"
  (let* ((indent (concat "\n" (make-string (current-column) 32)))
         (args (python-split-args yas-text))
         (max-len (if args (apply 'max (mapcar '(lambda (x) (length (nth 0 x))) args)) 0))
         (formatted-args (mapconcat
                '(lambda (x)
                   (concat (nth 0 x) (make-string (- max-len (length (nth 0 x))) ? ) " -- "
                           (if (nth 1 x) (concat "\(default " (nth 1 x) "\)"))))
                args
                indent)))
    (unless (string= formatted-args "")
      (mapconcat 'identity (list "Keyword Arguments:" formatted-args) indent))))

(defun python-super-class (&optional default)
  "Get the name of wrapping class or DEFAULT if no class is found"
  (save-excursion
    (if (search-backward-regexp "class \\([a-zA-Z0-9]+\\)" nil t)
        (buffer-substring (match-beginning 1)
                          (match-end 1))
      (or default "Class"))))

(defun python-super-function (&optional default)
  "Get the name of wrapping function or DEFAULT if no function is found"
  (save-excursion
    (if (search-backward-regexp "def \\([a-zA-Z0-9_]+\\)" nil t)
        (buffer-substring (match-beginning 1)
                          (match-end 1))
      (or default "function"))))

(defun python-super-args (&optional default)
  "Get the arguments of wrapping function or DEFAULT if no function is found"
  (save-excursion
    (if (search-backward-regexp "def .+(self, \\(.+\\))" nil t)
        (buffer-substring (match-beginning 1)
                          (match-end 1))
      (or default ""))))
