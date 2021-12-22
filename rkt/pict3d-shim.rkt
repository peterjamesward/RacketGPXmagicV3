#lang racket/gui

(require pict3d
         "track.rkt")

(provide show-3d)

(define (make-sphere point)
  (sphere
   (pos (euclidean-trackpoint-x point) (euclidean-trackpoint-y point) (euclidean-trackpoint-z point))
   1))

(define (euclidean->picture track)
  (let ([point-cloud (map make-sphere (track-info-euclidean-trackpoints track))])
    (combine point-cloud (light (pos 1000 1000 1000)))))

(define (show-3d widget track)
  (send widget set-pict3d (euclidean->picture track)))