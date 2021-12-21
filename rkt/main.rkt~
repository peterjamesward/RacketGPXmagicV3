#lang racket/gui

; Make a frame by instantiating the frame% class
(define frame (new frame% [label "GPXmagic v3"]))
 
; Make a static text message in the frame
(define msg (new message% [parent frame]
                          [label "No track loaded."]))
 
(define (read-gpx-file button event)
  (define gpx-file-path (get-file "Read GPX file" frame #f #f "gpx" '()
                      '(("GPX Files" "*.gpx") ("Any" "*.*"))))
  (define gpx-file-name 
    (some-system-path->string
      (file-name-from-path gpx-file-path)))
  (send msg set-label gpx-file-name))
  
  ; Make a button in the frame
(new button% [parent frame]
             [label "Load a GPX file"]
             ; Callback procedure for a button click:
             [callback read-gpx-file])
 
; Show the frame by calling its show method
(send frame show #t)

