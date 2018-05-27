;;;; package.lisp
;;
;;;; Copyright (c) 2018 Jeremiah LaRocco <jeremiah_larocco@fastmail.com>


(defpackage #:cffi-bench
  (:use #:cl #:cffi)
  (:export #:run
           #:main
           #:build))
