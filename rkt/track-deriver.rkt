#lang racket/gui

(provide derive-full-track-info)

(require "list-utils.rkt"
         "track-utils.rkt"
         "track.rkt")

;; Take a lon, lat, alt track from GPX, convert to Euclidean space, derive some frequently used stuff.
(define (derive-full-track-info raw-track)
  (define min-lon (minimum-of trackpoint-longitude (track-trackpoints raw-track)))
  (define max-lon (maximum-of trackpoint-longitude (track-trackpoints raw-track)))
  (define min-lat (minimum-of trackpoint-latitude (track-trackpoints raw-track)))
  (define max-lat (maximum-of trackpoint-latitude (track-trackpoints raw-track)))

  (define earthly-bounds
    ; Bounding box vector min lon, max lon, min lat, max lat, min alt, max alt; not the same as map chappy.
    (vector min-lon max-lon min-lat max-lat))

  (define ref-lon-lat
    ; This point maps to the Euclidean origin, so we'll use the centre of the bounding box.
    (vector (* 0.5 (+ min-lon max-lon)) (* 0.5 (+ min-lat max-lat))))

  (define euclideans
    (map (lambda (raw) (earth->euclidean ref-lon-lat raw)) (track-trackpoints raw-track)))

  ; I know, we could just transform the bounds!
  (define min-x (minimum-of euclidean-trackpoint-x euclideans))
  (define max-x (maximum-of euclidean-trackpoint-x euclideans))
  (define min-y (minimum-of euclidean-trackpoint-y euclideans))
  (define max-y (maximum-of euclidean-trackpoint-y euclideans))
  (define min-z (minimum-of euclidean-trackpoint-z euclideans))
  (define max-z (maximum-of euclidean-trackpoint-z euclideans))
  (define segments '())
  (define vertices '())

  (track-info (track-filename raw-track)
              (track-trackname raw-track)
              ""
              earthly-bounds
              ref-lon-lat
              (track-trackpoints raw-track)
              euclideans
              (vector min-x max-x min-y max-y min-z max-z)
              segments
              vertices))


;        (filename ; string
;         trackname ; path
;         error-message ; string))
;         earth-bounds ; vector [ min lon, max lon, min lat, max lat ]
;         reference-lonlat ; pair of float degrees, used to translate between Euclidean and Earth coordinates.
;         trackpoints ; list trackpoint
;         euclidean-trackpoints ; like it says
;         euclidean-bounds ; vector [ min x, max x, min y, max y, min z, max z ]
;         segments ; list segment
;         vertices ; list vertex
;         ))
