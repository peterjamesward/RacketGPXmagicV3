#lang racket/gui

(require pict3d
         "track.rkt")

(provide show-3d
         my-3d)

; Derive a new canvas (a drawing window) class to handle events
(define my-canvas%
  (class pict3d-canvas%
    (field [my-camera (basis 'camera (point-at (pos 500 500 40) origin))]
           [my-pict (sphere origin 1/2)]
           [dragging #f]
           [zoom 12])
    (define/override (on-event mouse-event) (lambda (mouse-event) #f))


    (define/override (on-char event)
      ; Because mouse wheel comes in like this.
      (lambda (key-event)
        (let ([which-key (send event get-key-code)])
          (cond
            [(equal? which-key 'wheel-up) (set! zoom (min 21 (+ 1 zoom)))]
            [(equal? which-key 'wheel-down) (set! zoom (max 1 (- zoom 1)))]
            [(equal? which-key 'shift) (set! zoom (min 21 (+ 1 zoom)))]
            [(equal? which-key 'rshift) (set! zoom (max 1 (- zoom 1)))])
          (set! my-camera (basis 'camera (point-at (* 10 zoom) (* 10 zoom) (* 5 zoom) origin)))
          (send this set-pict3d (combine my-pict my-camera)))))

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