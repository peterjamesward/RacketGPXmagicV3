#lang racket

(provide (struct-out track)
         (struct-out trackpoint))

;; Define our pervasive types for general use.

(struct trackpoint (longitude latitude altitude))

(struct track (filename trackname trackpoints error-message))