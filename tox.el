;;; tox.el --- Provide command to select and activate tox virtualenv

;; Version: 0.0.0
;; Package-Requires: (pyvenv projectile)

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
      (message "No virtualenv directory found in .tox directory"))))

(dolist (m spacemacs--python-pyvenv-modes)
  (spacemacs/set-leader-keys-for-major-mode m
    "vt" 'tox-pyenv-activate))

(provide 'emacs-tox)

;;; tox.el ends here