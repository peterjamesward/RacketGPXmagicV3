#lang racket/base

(provide minimum
         maximum
         minimum-of
         maximum-of)

(define (minimum xs)
  (foldl min +inf.0 xs))

(define (maximum xs)
  (foldl max -inf.0 xs))

(define (minimum-of f xs)
  (foldl (λ (x accum) (min (f x) accum)) +inf.0 xs))

(define (maximum-of f xs)
  (foldl (λ (x accum) (max (f x) accum)) -inf.0 xs))