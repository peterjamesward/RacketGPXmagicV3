#lang racket/gui

(require pict3d
         "track.rkt")

(provide show-3d
         my-3d)


; Derive a new canvas (a drawing window) class to handle events
(define my-canvas%
  (class pict3d-canvas%
    (field [my-camera (basis 'camera (point-at (pos 0 -1000 40) origin))]
           [my-pict (sphere origin 1/2)]
           [camera-distance 1000] ; metres away from whatever the focal point is (default to origin)
           [camera-azimuth 180] ; where the camera is relative to the origin
           [camera-elevation 30] ; from XY plane
           [dragging #f]
           [zoom 12])

    (define/public (camera-from-azimuth-elevation)
      (let* ([direction (angles->dir camera-azimuth camera-elevation)]
             [pos-vector (dir-scale direction camera-distance)]
             [camera-position (pos+ origin pos-vector)]
             [new-camera (basis 'camera (point-at camera-position origin))])
        (set! my-camera new-camera)
        (send this set-pict3d (combine my-pict my-camera))))

    (define/override (on-event mouse-event)
      (let ([parent (send this get-parent)]) (send parent set-label "MOUSEY")))
    ; Pan & rotate here.
    ;      (lambda (mouse-event) #f))

    (define/override (on-char event)
      ; Because mouse wheel comes in like this.
      (let ([parent (send this get-parent)] [which-key (send event get-key-code)])
        (cond
          [(equal? which-key 'wheel-up) (set! camera-distance (+ camera-distance 100))]
          [(equal? which-key 'wheel-down) (set! camera-distance (- camera-distance 100))]
          [#t (send parent set-label "other")])
        (send this camera-from-azimuth-elevation)))

    (define/public (update-picture track)
      (let ([new-pict (euclidean->picture track)])
        (set! my-pict new-pict)
        (send this set-pict3d (combine new-pict my-camera))))

    (super-new)))

(define (my-3d container)
  (new my-canvas% [parent container] [pict3d (combine (sphere origin 1/2) (light (pos 0 1 1)))]))

(define (show-point point)
  (cube
   (pos (euclidean-trackpoint-x point) (euclidean-trackpoint-y point) (euclidean-trackpoint-z point))
   1.0))

(define (euclidean->picture track)
  (let ([point-cloud (map show-point (track-info-euclidean-trackpoints track))])
    (parameterize ([current-pict3d-add-sunlight? #t]
                   [current-pict3d-add-indicators? #t]
                   [current-pict3d-background (rgba "blue" 128)])
      point-cloud)))


(define (show-3d widget track)
  (send widget update-picture track))