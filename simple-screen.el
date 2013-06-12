;; simple_screen.el -- Simple screen configuration manager

;; Copyright (C) 2012,2013 Tadashi Watanabe <wac@umiushi.org>

;; Author: Tadashi Watanabe <wac@umiushi.org>
;; Maintainer: Tadashi Watanabe <wac@umiushi.org>
;; Version: 
;; Keywords: tools

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

;;; Commentary

;;; Code:

(defvar simple-screen-vector (make-vector 10 (current-window-configuration)))
(defvar simple-screen-buffer-name-vector (make-vector 10 ""))
(defvar simple-screen-window-point-vector (make-vector 10 nil))
(defvar simple-screen-current-index 0)
(defvar simple-screen-mode-line "")

(define-prefix-command 'simple-screen-map)
(global-set-key (kbd "C-z") 'simple-screen-map)
(define-key simple-screen-map "w" 'simple-screen-show-screen)
(define-key simple-screen-map "0" 'simple-screen-0)
(define-key simple-screen-map "1" 'simple-screen-1)
(define-key simple-screen-map "2" 'simple-screen-2)
(define-key simple-screen-map "3" 'simple-screen-3)
(define-key simple-screen-map "4" 'simple-screen-4)
(define-key simple-screen-map "5" 'simple-screen-5)
(define-key simple-screen-map "6" 'simple-screen-6)
(define-key simple-screen-map "7" 'simple-screen-7)
(define-key simple-screen-map "8" 'simple-screen-8)
(define-key simple-screen-map "9" 'simple-screen-9)

(defun simple-screen-update-mode-line (index)
  (mapc #'(lambda (buffer)
  	    (when (not (eq ? (aref (buffer-name buffer) 0)))
  	      (with-current-buffer buffer
  		(when (and (get-buffer-window buffer)
			   (listp mode-line-format)
  			   (not (memq 'simple-screen-mode-line mode-line-format)))
  		  ;; (message "set mode-line %s" (prin1-to-string buffer))
  		  (setq mode-line-format (append mode-line-format (list 'simple-screen-mode-line)))))))
  	(buffer-list))
  (setq simple-screen-mode-line (format "[%d]" index)))

(defun simple-screen-window-configuration-change-hook ()
  (simple-screen-update-mode-line simple-screen-current-index))

(unless (featurep 'simple-screen)
  (aset simple-screen-buffer-name-vector simple-screen-current-index (buffer-name))
  (add-hook 'window-configuration-change-hook 'simple-screen-window-configuration-change-hook)
  (simple-screen-update-mode-line simple-screen-current-index)
  (force-mode-line-update))

(defun simple-screen-save-window-point (index)
  (aset simple-screen-window-point-vector index (window-point (selected-window))))

(defun simple-screen-load-window-point (index)
  (when (aref simple-screen-window-point-vector index)
    (set-window-point (selected-window) (aref simple-screen-window-point-vector index))))

(defun simple-screen-core (index)
  (when (not (= index simple-screen-current-index))
    (aset simple-screen-buffer-name-vector simple-screen-current-index (buffer-name))
    (let ((configuration (aref simple-screen-vector index)))
      (aset simple-screen-vector simple-screen-current-index (current-window-configuration))
      (simple-screen-save-window-point simple-screen-current-index)
      (set-window-configuration (aref simple-screen-vector index))
      (simple-screen-load-window-point index)
      (simple-screen-update-mode-line index)
      (aset simple-screen-buffer-name-vector index (buffer-name))))
  (setq simple-screen-current-index index))

(defun simple-screen-show-screen ()
  (interactive)
  (message (let ((index -1))
	     (mapconcat #'(lambda (a)
			    (setq index (1+ index))
			    (if (= index simple-screen-current-index)
				(format "%d:CURRENT " index)
			      (when (> (length (aref simple-screen-buffer-name-vector index)) 0)
				  (format "%d:%s " index a))))
			simple-screen-buffer-name-vector ""))))
(defun simple-screen-clear-screen ()
  (interactive)
  (setq simple-screen-buffer-name-vector (make-vector 10 "")))
(defun simple-screen-0 ()
  (interactive)
  (simple-screen-core 0))
(defun simple-screen-1 ()
  (interactive)
  (simple-screen-core 1))
(defun simple-screen-2 ()
  (interactive)
  (simple-screen-core 2))
(defun simple-screen-3 ()
  (interactive)
  (simple-screen-core 3))
(defun simple-screen-4 ()
  (interactive)
  (simple-screen-core 4))
(defun simple-screen-5 ()
  (interactive)
  (simple-screen-core 5))
(defun simple-screen-6 ()
  (interactive)
  (simple-screen-core 6))
(defun simple-screen-7 ()
  (interactive)
  (simple-screen-core 7))
(defun simple-screen-8 ()
  (interactive)
  (simple-screen-core 8))
(defun simple-screen-9 ()
  (interactive)
  (simple-screen-core 9))

;; 
(provide 'simple-screen)
