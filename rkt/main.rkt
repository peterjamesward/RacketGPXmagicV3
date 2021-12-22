#lang racket/gui

(require map-widget
         "map-shim.rkt"
         "track.rkt"
         "track-utils.rkt"
         "import-from-gpx.rkt")

; Make a frame by instantiating the frame% class
(define file-frame (new frame% [label "GPXmagic v3"] [width 600] [height 100]))
(define map-frame (new frame% [label "GPXmagic v3"] [width 600] [height 500]))
(define opengl-frame (new frame% [label "GPXmagic v3"] [width 600] [height 500]))

; Put some controls in the frame.
(define show-track-name (new message% [parent file-frame] [label "No track loaded."]))
(define show-track-length (new gauge% [parent file-frame] [label "Points"] [range 6]))
(define my-map (new map-widget% [parent map-frame]))

(define (read-gpx-file button event)
  (define gpx-file-path
    (get-file "Read GPX file" map-frame #f #f "gpx" '() '(("GPX Files" "*.gpx") ("Any" "*.*"))))
  (when ((or/c path-string? path-for-some-system?) gpx-file-path)
    (define my-track (import-from-gpx gpx-file-path))
    (if (string? (track-error-message my-track))
        (send show-track-name set-label "Problem with file")
        (let ([vectorised-track (track-as-vectors my-track)])
          (send show-track-name set-label (track-trackname my-track))
          (send show-track-length
                set-value
                (exact-round (log (length (track-trackpoints my-track)) 10)))
          (show-track-on-map my-map my-track)
          (send map-frame show #t)))))


; Make a button in the frame
(new button%
     [parent file-frame]
     [label "Load a GPX file"]
     ; Callback procedure for a button click:
     [callback read-gpx-file])

; Show the frame by calling its show method
(send file-frame show #t)