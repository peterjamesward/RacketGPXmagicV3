#lang racket/gui

(require "track.rkt"
         "import-from-gpx.rkt")

; Make a frame by instantiating the frame% class
(define frame (new frame% [label "GPXmagic v3"]))

; Make a static text message in the frame
(define show-track-name (new message% [parent frame] [label "No track loaded."]))
(define show-track-length (new gauge% [parent frame] [label "Points"] [range 6]))

(define (read-gpx-file button event)
  (define gpx-file-path
    (get-file "Read GPX file" frame #f #f "gpx" '() '(("GPX Files" "*.gpx") ("Any" "*.*"))))
  (when ((or/c path-string? path-for-some-system?) gpx-file-path)
    (define my-track (import-from-gpx gpx-file-path))
    (if (string? (track-error-message my-track))
        (send show-track-name set-label "Problem with file")
        (begin
          (send show-track-name set-label (track-trackname my-track))
          (send show-track-length
                set-value
                (exact-round (log (length (track-trackpoints my-track)) 10)))))))


; Make a button in the frame
(new button%
     [parent frame]
     [label "Load a GPX file"]
     ; Callback procedure for a button click:
     [callback read-gpx-file])

; Show the frame by calling its show method
(send frame show #t)