;;; meow-init.el --- Meow initializer
;;; -*- lexical-binding: t -*-

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

;;; Initializers

(defun meow--normal-init ()
  (when meow-normal-mode
    (meow-insert-mode -1)
    (meow-motion-mode -1)
    (unless meow--keymap-loaded
      (let ((keymap (meow--get-mode-leader-keymap major-mode t)))
        (define-key meow-normal-state-keymap (kbd "SPC") keymap)
        (setq-local meow--keymap-loaded t)))))

(defun meow--insert-init ()
  (when meow-insert-mode
    (meow-normal-mode -1)
    (meow-motion-mode -1)))

(defun meow--motion-init ()
  (when meow-motion-mode
    (meow-normal-mode -1)
    (meow-insert-mode -1)
    (unless meow--keymap-loaded
      (let ((keymap (meow--get-mode-leader-keymap major-mode t)))
        (define-key meow-motion-state-keymap (kbd "SPC") keymap))
      (setq-local meow--keymap-loaded t))))

(defun meow--keypad-init ()
  (setq meow--prefix-arg current-prefix-arg
        meow--keypad-keys nil
        meow--use-literal nil
        meow--use-meta nil))

(defun meow--enable ()
  (if (apply #'derived-mode-p meow-normal-state-mode-list)
      (meow--switch-state 'normal)
    (meow--switch-state 'motion)))

(defun meow--disable ()
  (meow-normal-mode -1)
  (meow-insert-mode -1)
  (meow-motion-mode -1))

(defun meow--global-enable ()
  (global-set-key (kbd "<escape>") 'meow-escape-or-normal-modal)
  (meow--mc-setup)
  (when (featurep 'wgrep)
    (require 'meow-wgrep)
    (meow--wgrep-setup))
  (when (featurep 'yasnippet)
    (require 'meow-yas)
    (meow--yas-setup))
  (add-hook 'post-command-hook 'meow--post-command-function))

(defun meow--global-disable ()
  (global-unset-key (kbd "<escape>"))
  (remove-hook 'post-command-hook 'meow--post-command-function))

(provide 'meow-init)
;;; meow-init.el ends here