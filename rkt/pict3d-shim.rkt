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
           [mouse-start #f]
           [zoom 12])

    (define/public (camera-from-azimuth-elevation)
      (let* ([direction (angles->dir camera-azimuth camera-elevation)]
             [pos-vector (dir-scale direction camera-distance)]
             [camera-position (pos+ origin pos-vector)]
             [new-camera (basis 'camera (point-at camera-position origin))])
        (set! my-camera new-camera)
        (send this set-pict3d (combine my-pict my-camera))))

    (define origin-x 0)
    (define origin-y 0)
    (define last-mouse-x #f)
    (define last-mouse-y #f)

    ;; Handle a mouse event.  Return #t if the event was handled, #f
    ;; otherwise.
    (define/override (on-event event)
      (cond
        [(send event button-down? 'left)
         (set! last-mouse-x (send event get-x))
         (set! last-mouse-y (send event get-y))
         ;; Return as "Not handled', let others maybe handle it
         #f]
        [(send event button-up? 'left)
         (set! last-mouse-x #f)
         (set! last-mouse-y #f)
         ;; Return as "Not handled', let others maybe handle it
         #f]
        [(send event dragging?)
         (let ([mouse-x (send event get-x)] [mouse-y (send event get-y)])
           (when (and last-mouse-x last-mouse-y)
             (set! origin-x (- origin-x (- mouse-x last-mouse-x)))
             (set! origin-y (- origin-y (- last-mouse-y mouse-y)))
             (set! camera-azimuth origin-x)
             (set! camera-elevation origin-y)
             (send this camera-from-azimuth-elevation)
             (set! last-mouse-x mouse-x)
             (set! last-mouse-y mouse-y)))
         ;; Event was handled
         #t]
        ;; Not handled
        [#t #f]))


    (define/override (on-char event)
      ; Because mouse wheel comes in like this.
      (let ([parent (send this get-parent)] [which-key (send event get-key-code)])
        (cond
          [(equal? which-key 'wheel-down) (set! camera-distance (min 1000 (* camera-distance 1.1)))]
          [(equal? which-key 'wheel-up) (set! camera-distance (max 2 (* camera-distance 0.9)))])
        (send this camera-from-azimuth-elevation)
        #t))

    (define/public (update-picture track)
      (let ([new-pict (euclidean->picture track)])
        (set! my-pict new-pict)
        (send this
              set-pict3d
              (parameterize ([current-pict3d-add-sunlight? #t]
                             [current-pict3d-add-indicators? #t]
                             [current-pict3d-background (rgba "blue" 0)]
                             [current-pict3d-fov 45])
                (combine new-pict my-camera)))))

    (super-new)))

(define (my-3d container)
  (let ([the-canvas (new my-canvas%
                         [parent container]
                         [pict3d (combine (sphere origin 1/2) (light (pos 0 1 1)))])])
    (send the-canvas wheel-event-mode 'one)
    the-canvas))

(define (show-point point)
  (cube
   (pos (euclidean-trackpoint-x point) (euclidean-trackpoint-y point) (euclidean-trackpoint-z point))
   1.0))

(define (euclidean->picture track)
  (map show-point (track-info-euclidean-trackpoints track)))



(define (show-3d widget track)
  (send widget update-picture track))