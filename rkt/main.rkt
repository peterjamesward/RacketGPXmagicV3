#lang racket/gui

; Make a frame by instantiating the frame% class
(define frame (new frame% [label "GPXmagic v3"]))
 
; Make a static text message in the frame
(define msg (new message% [parent frame]
                          [label "No track loaded."]))
 
; Make a button in the frame
(new button% [parent frame]
             [label "Load a GPX file"]
             ; Callback procedure for a button click:
             [callback (lambda (button event)
                         (send msg set-label "Not yet implemented."))])
 
; Show the frame by calling its show method
(send frame show #t)