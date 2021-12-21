#lang racket/gui

;; Utils for track and track points.

(require "track.rkt")

(provide trackpoint-as-vector track-as-vectors)

;; Map widget requires a vector of latitude, longitude.
(define (trackpoint-as-vector tp)
  (vector (trackpoint-latitude tp) (trackpoint-longitude tp)))

(define (track-as-vectors track)
  (map trackpoint-as-vector (track-trackpoints track)))