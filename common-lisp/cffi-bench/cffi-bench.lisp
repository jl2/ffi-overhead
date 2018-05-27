;;;; cffi-bench.lisp
;;
;;;; Copyright (c) 2018 Jeremiah LaRocco <jeremiah_larocco@fastmail.com>

(in-package #:cffi-bench)

(declaim (optimize (speed 3) (safety 0) (debug 0)))

(cffi:load-foreign-library "libnewplus.so" :search-path "/home/jeremiah/src/lisp/cffi-bench/")
(declaim (inline plusone current-timestamp))

(cffi:defcfun "plusone" :int (x :int))
(cffi:defcfun "current_timestamp" :long)

(defun run (count)
  (declare (optimize (speed 3) (safety 0) (debug 0))
           (type fixnum count))
  (with-foreign-objects ((x :long 0))
    (let ((start (current-timestamp)))
      (loop for i fixnum upto count do
           (setf (mem-ref x :int) (foreign-funcall "plusone" :int (mem-ref x :int) :int)))
      (let* ((end (current-timestamp))
             (elapsed (- end start)))
        (format t "~a~%" elapsed)))))

(defun main ()
  (let* ((args (cdr sb-ext:*posix-argv*))
        (arg-len (length args))
        (count (if (> arg-len 0) (parse-integer (car args)) 0)))
    (declare (type list args)
             (type fixnum arg-len count))
    (format t "Args: ~a~% args" args)

    (cffi:load-foreign-library "libnewplus.so" :search-path "/home/jeremiah/src/lisp/cffi-bench/")

    (cond ((= arg-len 0)
           (format t "First arg (0 - 2000000000) is required.~%"))
          ((or (<= count 0) (> count 2000000000))
           (format t "Must be a positive number not exceeding 2 billion.~%"))
          (t
           (run count)))))

(defun build ()
  (sb-ext:save-lisp-and-die "hello-cl" :toplevel #'main :executable t))
