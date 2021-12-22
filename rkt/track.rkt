#lang racket

(provide (struct-out track)
         (struct-out track-info)
         (struct-out trackpoint)
         (struct-out euclidean-trackpoint)
         (struct-out segment)
         (struct-out vertex))

;; Define our pervasive types for general use.

(struct trackpoint
        (longitude ; float degrees
         latitude ; float degrees
         altitude ; float metres
         ))

(struct euclidean-trackpoint
        (based-on ; trackpoint
         x ; float metres from start point
         y ; ditto
         z ; ditto
         ))

(struct track
        (filename ; string
         trackname ; path
         trackpoints ; list trackpoint
         error-message ; string
         ))

;; Track with all the derivations
(struct track-info
        (filename ; string
         trackname ; path
         error-message ; string))
         earth-bounds ; vector [ min lon, max lon, min lat, max lat ]
         reference-lonlat ; pair of float degrees, used to translate between Euclidean and Earth coordinates.
         trackpoints ; list trackpoint
         euclidean-trackpoints ; like it says
         euclidean-bounds ; vector [ min x, max x, min y, max y, min z, max z ]
         segments ; list segment
         vertices ; list vertex
         ))

(struct segment
        (start-at ; trackpoint
         end-at ; trackpoint
         road-vector ; vector3d metres
         gradient ; float %
         earth-length ; float metres
         ))

(struct vertex
        (preceded-by ; segment
         followed-by ; segment
         direction-change ; float radians
         gradient-change ; float %
         ))
