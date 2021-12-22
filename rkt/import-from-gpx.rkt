#lang racket

(provide import-from-gpx)

(require "track.rkt"
         xml
         sugar
         xml/path)


(define (trackpoint-helper accumulator longitudes latitudes altitudes)
  (if (or (empty? longitudes) (empty? latitudes) (empty? altitudes))
      (reverse accumulator)
      (trackpoint-helper (cons (trackpoint (string->number (first longitudes))
                                           (string->number (first latitudes))
                                           (string->number (first altitudes)))
                               accumulator)
                         (rest longitudes)
                         (rest latitudes)
                         (rest altitudes))))


(define (import-from-gpx file-path)
  (define file-name (some-system-path->string (file-name-from-path file-path)))
  (define as-xml (xml->xexpr (document-element (read-xml (open-input-file file-path)))))
  (define track-name (se-path* '(gpx trk name) as-xml))
  (define longitudes (se-path*/list '(gpx trk trkseg trkpt #:lon) as-xml))
  (define latitudes (se-path*/list '(gpx trk trkseg trkpt #:lat) as-xml))
  (define altitudes (se-path*/list '(gpx trk trkseg trkpt ele) as-xml))
  (define trackpoints (trackpoint-helper '() longitudes latitudes altitudes))
  (track file-name track-name trackpoints null))