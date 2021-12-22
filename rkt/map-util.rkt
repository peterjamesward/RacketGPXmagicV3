#lang racket/base

(require racket/flonum
         racket/math)

(provide earth-radius
         tile-size
         metres-per-degree
         haversin
         inv-haversin
         map-distance/radians
         map-bearing/radians)

;; Formulas from http://www.movable-type.co.uk/scripts/latlong.html

(define earth-radius (->fl 6371000)) ; meters
(define tile-size 256) ; size of the map tiles, in pixels

(define metres-per-degree (/ earth-radius 360.0))

(define (haversin theta)
  (fl/ (fl- 1.0 (flcos theta)) 2.0))

(define (inv-haversin h)
  (fl* 2.0 (flasin (flsqrt h))))

;; Calculate the distance in meters between two map coordinates
(define (map-distance/radians lat1 lon1 lat2 lon2)
  (let ([delta-lat (fl- lat2 lat1)] [delta-lon (fl- lon2 lon1)])
    (let* ([a (fl+ (haversin delta-lat) (fl* (fl* (flcos lat1) (flcos lat2)) (haversin delta-lon)))]
           [c (inv-haversin a)])
      (fl* c earth-radius))))

(define (map-distance/degrees lat1 lon1 lat2 lon2)
  (map-distance/radians (degrees->radians lat1)
                        (degrees->radians lon1)
                        (degrees->radians lat2)
                        (degrees->radians lon2)))

;; Calculate the initial bearing for traveling between two map coordinates
;; (bearing is returned in radians).  note that the bearing will have to
;; change as one travers towards lat2, lon2 and has to be re-computed
;; periodically.
(define (map-bearing/radians lat1 lon1 lat2 lon2)
  (let ([delta-lon (fl- lon2 lon1)])
    (let ([y (fl* (flsin delta-lon) (flcos lat2))]
          [x (fl- (fl* (flcos lat1) (flsin lat2))
                  (fl* (fl* (flsin lat1) (flcos lat2)) (flcos delta-lon)))])
      (flatan (/ y x)))))

(define (map-bearing/degrees lat1 lon1 lat2 lon2)
  (map-bearing/radians (degrees->radians lat1)
                       (degrees->radians lon1)
                       (degrees->radians lat2)
                       (degrees->radians lon2)))