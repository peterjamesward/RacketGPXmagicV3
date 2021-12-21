#lang racket

(provide import-from-gpx)

(require "track.rkt"
         xml)

(define (import-from-gpx file-path)
  (define file-name (some-system-path->string (file-name-from-path file-path)))
  (define as-xml (xml->xexpr (document-element (read-xml (open-input-file file-path)))))
  (track file-name "trackname" "trackpoints"))