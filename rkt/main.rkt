#lang racket/gui

(require xml
         "track.rkt"
         "import-from-gpx.rkt")

; Make a frame by instantiating the frame% class
(define frame (new frame% [label "GPXmagic v3"]))

; Make a static text message in the frame
(define msg (new message% [parent frame] [label "No track loaded."]))

(define (read-gpx-file button event)
  (define gpx-file-path
    (get-file "Read GPX file" frame #f #f "gpx" '() '(("GPX Files" "*.gpx") ("Any" "*.*"))))
  (when ((or/c path-string? path-for-some-system?) gpx-file-path)

    (send msg set-label gpx-file-name)))


; Make a button in the frame
(new button%
     [parent frame]
     [label "Load a GPX file"]
     ; Callback procedure for a button click:
     [callback read-gpx-file])

; Show the frame by calling its show method
(send frame show #t)