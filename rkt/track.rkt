#lang racket

(provide track trackpoint)

;; Define our pervasive types for general use.

(struct trackpoint (longitude latitude altitude))

(struct track (filename trackname trackpoints))