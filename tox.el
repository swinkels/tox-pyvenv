(require 'pyvenv)
(require 'projectile)

(defun tox-dir ()
  (concat (projectile-project-root) (file-name-as-directory ".tox")))

(defun find-venv-dir-names ()
  (directory-files (tox-dir) nil "^py[[:digit:]]+[-]?.*"))

(defun select-venv-dir-name ()
  (let ((venv-dirs (find-venv-dir-names)))
    (if (eql (length venv-dirs) 1)
        (car venv-dirs)
      (completing-read "Select tox virtualenv: " venv-dirs))))

(defun absolute-path (venv-dir-name)
  (concat (tox-directory) venv-dir-name))

(defun tox-pyenv-activate ()
  (interactive)
  (let ((venv-dir (absolute-path (select-venv-dir-name))))
    (if (file-directory-p venv-dir)
        (progn
          (pyvenv-activate venv-dir)
          (message "Activated virtualenv in %s" venv-dir))
      (message "No py36 virtualenv exists in .tox directory"))))

(dolist (m spacemacs--python-pyvenv-modes)
  (spacemacs/set-leader-keys-for-major-mode m
    "vt" 'tox-pyenv-activate))
