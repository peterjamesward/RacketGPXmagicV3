#lang racket/gui

;; Utils for track and track points.

(require "track.rkt"
         "map-util.rkt")

(provide trackpoint-as-vector
         track-as-vectors
         earth->euclidean
         euclidean->earth
         tabulate)

;; Map widget requires a vector of latitude, longitude.
(define (trackpoint-as-vector tp)
  (vector (trackpoint-latitude tp) (trackpoint-longitude tp)))

(define (track-as-vectors track)
  (map trackpoint-as-vector (track-trackpoints track)))

(define (earth->euclidean ref-point earth-point)
  ; Express x, y in metres offset from central lon, lat but with z = altitude
  (let* ([ref-lon (vector-ref ref-point 0)]
         [ref-lat (vector-ref ref-point 1)]
         [pt-lon (trackpoint-longitude earth-point)]
         [pt-lat (trackpoint-latitude earth-point)]
         [x (* metres-per-degree (- pt-lon ref-lon) (cos (degrees->radians ref-lat)))]
         [y (* metres-per-degree (- pt-lat ref-lat))]
         [z (trackpoint-altitude earth-point)])
    (euclidean-trackpoint earth-point x y z)))

(define (euclidean->earth ref-point euclidean-point)
  (let* ([ref-lon (vector-ref ref-point 0)]
         [ref-lat (vector-ref ref-point 1)]
         [pt-lon (+ ref-lon
                    (/ (euclidean-trackpoint-x euclidean-point)
                       metres-per-degree
                       (cos (degrees->radians ref-lat))))]
         [pt-lat (+ ref-lat (/ (euclidean-trackpoint-y euclidean-point) metres-per-degree))])
    (trackpoint pt-lon pt-lat (euclidean-trackpoint-z euclidean-point))))

(define (tabulate euclideans)
  (define (print-euclidean euclidean)
    (display (format " ~a ~a ~a \n"
                     (euclidean-trackpoint-x euclidean)
                     (euclidean-trackpoint-y euclidean)
                     (euclidean-trackpoint-z euclidean))))
  (map print-euclidean euclideans))