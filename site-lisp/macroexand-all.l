;;;; -*- mode: lisp -*-
;;;;
;;;; macroexand-all --- expand macro-calls recursively.
;;;;
;;;; Author: bowbow99 <bowbow99@gmail.com>
;;;; Created: 2009-07-22 14:40:36
;;;; Updated: 2009-07-22 17:19:58
;;;;

(defun macroexpand-all (form)
  (labels ((expand-cddr (form)
             (list* (car form) (cadr form)
                    (mapcar #'macroexpand-all (cddr form)))))
    (setq form (macroexpand form))
    (if (atom form)
        form
      (case (car form)
        (function
         (list (car form)
               (if (symbolp (cadr form)) (cadr form)
                 (expand-cddr (cadr form)))))
        ((let let*)
         (list* (car form)
                (mapcar (lambda (pair)
                          (if (atom pair) pair
                            (cons (car pair)
                                  (mapcar #'macroexpand-all (cdr pair)))))
                  (cadr form))
                (mapcar #'macroexpand-all (cddr form))))
        ((multiple-value-bind eval-when function quote)
         (expand-cddr form))
        (t (cons (car form)
                 (mapcar #'macroexpand-all (cdr form))))))))


;;;; macroexand-all ends here
