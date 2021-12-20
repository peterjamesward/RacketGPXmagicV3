#lang racket/base
;; activity-log-main.rkt -- main application entry point
;;
;; This file is part of ActivityLog2, an fitness activity tracker
;; Copyright (C) 2015, 2020 Alex Harsányi <AlexHarsanyi@gmail.com>
;;
;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation, either version 3 of the License, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
;; more details.

(require framework/splash
         racket/class
         "toplevel.rkt"
        ;  "utilities.rkt"
        ;  "app-info.rkt"
         )

(provide main)

(define dbfile-key 'activity-log:database-file)

(define (main)
  (with-handlers
    (((lambda (e) #t)
      (lambda (e)
        ;; Reset the default database on exception, next restard, this will
        ;; prompt the user to open another database...
        ;; Don't attempt to shut down workers here, as we might make a bad
        ;; problem worse...
        (exit 1))))
    (define database-file "NOPE")
    (begin
      (let ((tl (new toplevel-window% [database-path database-file])))
        (send tl run)))))
