#lang racket

(provide import-from-gpx)

(require "track.rkt")

(define (import-from-gpx file-path)
  (define file-name (some-system-path->string (file-name-from-path gpx-file-path)))
  (define as-xml (xml->xexpr (document-element (read-xml (open-input-file gpx-file-path))))))