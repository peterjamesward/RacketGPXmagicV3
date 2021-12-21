#lang racket/gui

(require map-widget
         "track.rkt"
         "track-utils.rkt"
         "import-from-gpx.rkt")

; Make a frame by instantiating the frame% class
(define frame (new frame% [label "GPXmagic v3"] [width 600] [height 500]))

; Put some controls in the frame.
(define show-track-name (new message% [parent frame] [label "No track loaded."]))
(define show-track-length (new gauge% [parent frame] [label "Points"] [range 6]))
(define my-map (new map-widget% [parent frame]))

(define (read-gpx-file button event)
  (define gpx-file-path
    (get-file "Read GPX file" frame #f #f "gpx" '() '(("GPX Files" "*.gpx") ("Any" "*.*"))))
  (when ((or/c path-string? path-for-some-system?) gpx-file-path)
    (define my-track (import-from-gpx gpx-file-path))
    (if (string? (track-error-message my-track))
        (send show-track-name set-label "Problem with file")
        (let ((vectorised-track (track-as-vectors my-track)))
          (send show-track-name set-label (track-trackname my-track))
          (send show-track-length
                set-value
                (exact-round (log (length (track-trackpoints my-track)) 10)))
          (send my-map clear)
          (send my-map add-track vectorised-track 'track)
          (send my-map add-marker (first vectorised-track) "orange" +1 (make-color 255 120 0))
          (send my-map resize-to-fit 'track)
          (send my-map center-map)))))


; Make a button in the frame
(new button%
     [parent frame]
     [label "Load a GPX file"]
     ; Callback procedure for a button click:
     [callback read-gpx-file])

; Show the frame by calling its show method
(send frame show #t)