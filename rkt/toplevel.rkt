#lang racket/base


(require framework/splash
        ;  geoid
        ;  map-widget
        ;  racket/async-channel
         racket/class
         racket/gui/base
        ;  racket/match
        ;  racket/math
        ;  tzgeolookup
        ;  "gps-segments/view-gps-segments.rkt"
        ;  "import.rkt"
        ;  "metrics.rkt"
        ;  "models/elevation-correction.rkt"
        ;  "session-inspector/view-session.rkt"
        ;  "time-in-zone.rkt"
        ;  "trend-charts/view-trends.rkt"
        ;  "utilities.rkt"
        ;  "view-activities.rkt"
        ;  "view-athlete-metrics.rkt"
        ;  "view-calendar.rkt"
        ;  "view-equipment.rkt"
        ;  "view-reports.rkt"
        ;  "weather.rkt"
        ;  "widgets/main.rkt"
        ;  "workout-editor/view-workouts.rkt"
         )

(provide toplevel-window%)

(define toplevel-window%
  (class object%
    (super-new)


    ;;; Construct the toplevel frame and initial panels
    (define tl-frame
      (let-values ()
        (let ((dims  (cons 1200 750)))
          (new
           (class frame% (init) (super-new))
           [width (car dims)] [height (cdr dims)]
           [style '(fullscreen-button)]
           [label "GPXmagic v3" ]))))
    (send tl-frame create-status-line)
    (queue-callback
     (lambda () (shutdown-splash) (close-splash))
     #f)

    (define tl-panel            ; Holds all the widgets in the toplevel window
      (new horizontal-pane% [parent tl-frame] [spacing 0]))

    (define left-panel             ; Holds the section selector and log window
      (new vertical-pane%
           [parent tl-panel]
           [stretchable-width #f]
           [spacing 5]))


    ))
