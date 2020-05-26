;;; tox-pyvenv.el --- Provide command to select and activate tox virtualenv

;; Version: 0.0.0
;; Package-Requires: (pyvenv projectile)

(require 'pyvenv)
(require 'projectile)

(defun tox-dir ()
  "Return the path to (and including) the .tox directory."
  (concat (projectile-project-root) (file-name-as-directory ".tox")))

(defun find-venv-dir-names ()
  "Return the names of the tox virtualenv directories.
This function uses a regex to determine which entries in the .tox
directory represent a virtualenv directory. Currently it matches
names like py27, py36-coverage or even py45-future."
  (directory-files (tox-dir) nil "^py[[:digit:]]+[-]?.*"))

(defun select-venv-dir-name ()
  "Return the name of the tox virtualenv directory that the user selects.
If there is only one such directory, this function returns its
name without asking the user."
  (let ((venv-dirs (find-venv-dir-names)))
    (if (eql (length venv-dirs) 1)
        (car venv-dirs)
      (completing-read "Select tox virtualenv: " venv-dirs))))

(defun absolute-path (venv-dir-name)
  "Return the path to (and including) tox virtualenv directory
VENV-DIR-NAME."
  (concat (tox-dir) venv-dir-name))

(defun tox-pyvenv-activate ()
  "Activate the tox virtualenv that the user selects."
  (interactive)
  (let ((venv-dir (absolute-path (select-venv-dir-name))))
    (if (file-directory-p venv-dir)
        (progn
          (pyvenv-activate venv-dir)
          (message "Activated virtualenv in %s" venv-dir))
      (message "No virtualenv directory found in .tox directory"))))

(provide 'tox-pyvenv)

;;; tox-pyvenv.el ends here
