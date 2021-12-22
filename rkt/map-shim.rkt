#lang racket/gui

(require map-widget
         "track-utils.rkt")

(provide show-track-on-map)

(define (show-track-on-map map track)
  (let ([vectorised-track (track-as-vectors track)])
    (send map clear)
    (send map add-track vectorised-track 'track)
    (send map add-marker (first vectorised-track) "orange" +1 (make-color 255 120 0))
    (send map resize-to-fit 'track)
    (send map center-map)))