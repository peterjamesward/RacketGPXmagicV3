#lang racket/gui

(require pict3d
         "track.rkt")

(provide show-3d)

(define (show-point point)
  (cube
   (pos (euclidean-trackpoint-x point) (euclidean-trackpoint-y point) (euclidean-trackpoint-z point))
   1.0))

(define (euclidean->picture track)
  (define camera (basis 'camera (point-at (pos 500 500 40) origin)))
  (let ([point-cloud (map show-point (track-info-euclidean-trackpoints track))])
    (parameterize ([current-pict3d-add-sunlight? #t]
                   [current-pict3d-add-indicators? #t]
                   [current-pict3d-background (rgba "blue" 128)])
      (combine point-cloud camera))))

               
(define (show-3d widget track)
  (send widget set-pict3d (euclidean->picture track)))