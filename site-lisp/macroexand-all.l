;;;; -*- mode: lisp -*-
;;;;
;;;; macroexand-all --- expand macro-calls recursively.
;;;;
;;;; Author: bowbow99 <bowbow99@gmail.com>
;;;; Created: 2009-07-22 14:40:36
;;;; Updated: 2009-07-22 15:23:38
;;;;


(defun group (list n)
  (if (<= (length list) n)
      (list list)
    (cons (subseq list 0 n)
          (group (nthcdr n list) n))))

(defun macroexpand-all (form)
  (setq form (macroexpand form))
  (if (atom form) form
    (case (car form)
      ((multiple-value-bind eval-when function quote)
       (list* (car form)
              (cadr form)
              (mapcar #'macroexpand-all (cddr form))))
      (t
       (cons (car form)
             (mapcar #'macroexpand-all (cdr form)))))))






;;;; macroexand-all ends here
