#lang racket

(provide import-from-gpx)

(require "track.rkt"
         xml
         xml/path)

(define (trackpoint-from-gpx trkpt)
  (let ([longitude (string->number (se-path* '(trkpt #:lon) trkpt))]
        [latitude (string->number (se-path* '(trkpt #:lat) trkpt))]
        [altitude (string->number (se-path* '(trkpt ele) trkpt))])
    (print altitude)
    (trackpoint longitude latitude altitude)))


(define (import-from-gpx file-path)
  (define file-name (some-system-path->string (file-name-from-path file-path)))
  (define as-xml (xml->xexpr (document-element (read-xml (open-input-file file-path)))))
  (define track-name (se-path* '(gpx trk name) as-xml))
  (define raw-points (se-path*/list '(gpx trk trkseg) as-xml))
  (define trackpoints (map trackpoint-from-gpx raw-points))
  (track file-name track-name trackpoints null))