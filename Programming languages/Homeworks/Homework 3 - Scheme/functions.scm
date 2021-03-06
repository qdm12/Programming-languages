; Part 1
;;; Base Case: L contains one element, return the first element of L, (car L).
;;; Assumption: find-min works on (cdr L), returning the smallest element of (cdr L).
;;; Step: Let x be the result of calling (find-min (cdr L)). If (car L) is less 
;;;       than x, return (car L). Otherwise, return x.
(define (find-min L)
    (cond ((null? (cdr L)) (car L))
          ((< (find-min (cdr L)) (car L)) (find-min (cdr L)))
          (else (car L))))
; (find-min '(3 2 7 6 9 10))
          
; Part 2
;;; Base Case: L contains a single element. Return a list containing (car L) and ()
;;; Assumption: Assume (find-min-rest (cdr L)) returns a list of the 
;;;             minimum in (cdr L) and the rest of the values in (cdr L).
;;; Step: If (car L) < first element of (find-min-rest (cdr L)), return a list 
;;;       containing (car L) and a list containing the first element of 
;;;       (find-min-rest (cdr L)) and the values in the second element of 
;;;       (find-min-rest (cdr L)). 
;;;       Otherwise, return a list containing the first element of 
;;;       (find-min-rest (cdr L)) and another list containing (car L) and the
;;;       values in the second element of (find-min-rest (cdr L)). 
(define (find-min-rest L)
    (cond ((null? (cdr L)) (list (car L) '()))
          (else (let* ((result (find-min-rest (cdr L)))
                       (min (car result))
                       (rest (cadr result)))
                      (if (< (car L) min)
                          (list (car L) (cons min rest))
                          (list min (cons (car L) rest))
                      )
                 )) ))
; (find-min-rest '(3 4 1 2 5 7 7))

; Part 3
;;; Base Case: L is empty, return an empty list
;;; Assumption: sort works on (cadr (find-min-rest L)), returning a sorted list
;;;             of the rest of L (see find-min-rest).
;;; Step: Cons the minimum of L with the rest of the list which is sorted
(define (sort L)
    (cond ((null? L) '())
          (else (cons (car (find-min-rest L)) (sort (cadr (find-min-rest L)))))
    ))
; (sort '(4 2 6 7 7))


; Part 4
;;; Base Case: L contains no element, return 0.
;;; Assumption: sum-list works on (car L) and (cdr L), returning the sum of 
;;;             (car L) + (cdr L).
;;; Step: Let x be the sum (car L) represents. If (car L) is a list, x is 
;;;       calculated recursively. Otherwise, x is simply (car L). The sum 
;;;       returned is x + sum of the rest, (cdr L).
(define (sum-list L)
    (cond ((null? L) 0)
          ((list? (car L)) (+ (sum-list (car L)) (sum-list (cdr L))))
          (else (+ (car L) (sum-list (cdr L))))))
; (sum-list '(2 3 (4 5) (6 (7 8)) 9))

; Part 5
;;; Base Case: L1 contains no element, return an empty list.
;;; Assumption: map2 works on (cdr L1) and (cdr L2).
;;; Step: If the list is non-empty, consolidate the function f taking the first 
;;;       element of L1 and L2 with the next ones through map2 recursive call.
(define (map2 f L1 L2)
    (if (null? L1)
        '()
        (cons (f (car L1)(car L2)) (map2 f (cdr L1)(cdr L2)))))
; (map2 (lambda (x y) (+ x y)) '(1 2 3 4 5) '(10 20 30 40 50))

; Part 6
;;; Base Case: n > m, return an empty list.
;;; Assumption: nums-from works for any n and any m.
;;; Step: If n > m, stop the process by returning an empty list. Otherwise, 
;;;       consolidate n with n+1, n+2 and so on until n > m.
(define (nums-from n m)
    (if (> n m)
        '()
        (cons n (nums-from (+ 1 n) m))))
; (nums-from 5 15)

; Part 7
;;; Base Case: The list L is empty, return an empty list.
;;; Assumption: remove-mults works for (cdr L)
;;; Step: If (car L) mod m > 0, consolidate (car L) with the next recursive 
;;;       non-multiples found. Otherwise, skip (car L) and move on to the next 
;;;       recursive call on (cdr L).
(define (remove-mults m L)
    (cond ((null? L) '())
          ((> (modulo (car L) m) 0) (cons (car L) (remove-mults m (cdr L))))
          (else (remove-mults m (cdr L)))))
; (remove-mults 3 '(1 2 3 4 5 6 7 8 9))
; (remove-mults 2 (nums-from 2 20))

; Part 8
;;; Base Case: The list L is empty, return an empty list.
;;; Assumption: sieve works on (remove-mults (car L) (cdr L))
;;; Step: Consolidate (car L) with (sieve (remove-mults (car L) (cdr L)))
(define (sieve L)
    (cond ((null? L) '())
          (else (cons (car L) (sieve (remove-mults (car L) (cdr L)))))))
; (sieve '(4 5 6 7 8 9 10 11 12 13 14 15 16 17))
 
; Part 9 - not recursive
(define (primes n)
    (sieve (nums-from 2 n)))
    
; Part 10
;;; Base Case: If a > n, return an empty list.
;;; Assumption: gen-fn-list-helper works on any a and n.
;;; Step: Consolidate the result with the results of the recursive calls.
(define (gen-fn-list n)
    (define (gen-fn-list-helper a n)
        (cond ((> a n) '())
              (else (cons (lambda (x) (+ x a)) (gen-fn-list-helper (+ 1 a) n)))))
    (gen-fn-list-helper 1 n))