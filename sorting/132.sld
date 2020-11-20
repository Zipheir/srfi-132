;;; If the (rnrs sorting) library is available, its sorting procedures
;;; are likely to be faster than the procedures defined by the SRFI 132
;;; reference implementation.  To use the (rnrs sorting) library if it
;;; is available, uncomment the following library definition.

#;
(define-library (srfi 132 use-r6rs-sorting))

(define-library (srfi 132 sorting)

  (export list-sorted?               vector-sorted?
          list-sort                  vector-sort
          list-stable-sort           vector-stable-sort
          list-sort!                 vector-sort!
          list-stable-sort!          vector-stable-sort!
          list-merge                 vector-merge
          list-merge!                vector-merge!
          list-delete-neighbor-dups  vector-delete-neighbor-dups
          list-delete-neighbor-dups! vector-delete-neighbor-dups!
          vector-find-median         vector-find-median!
          vector-select!             vector-separate!
          )

  (import (except (scheme base) vector-copy vector-copy!)
          (rename (only (scheme base) vector-copy vector-copy! vector-fill!)
                  (vector-copy  r7rs-vector-copy)
                  (vector-copy! r7rs-vector-copy!)
                  (vector-fill! r7rs-vector-fill!))
          (scheme cxr)
          (only (srfi 27) random-integer))

  (cond-expand

   ((and (library (srfi 132 use-r6rs-sorting))
         (library (rnrs sorting)))
    (import (rename (rnrs sorting)
                    (list-sort    r6rs-list-sort)
                    (vector-sort  r6rs-vector-sort)
                    (vector-sort! r6rs-vector-sort!))))
   (else))

  (cond-expand
   ((library (rnrs base))
    (import (only (rnrs base) assert)))
   (else
    (begin
     (define (assert x)
       (if (not x)
           (error "assertion failure"))))))

  ;; If the (srfi 132 use-r6rs-sorting) library is defined above,
  ;; we'll use the (rnrs sorting) library for all sorting and trim
  ;; Olin's reference implementation to remove unnecessary code.
  ;; The merge.scm file, for example, extracts the list-merge,
  ;; list-merge!, vector-merge, and vector-merge! procedures from
  ;; Olin's lmsort.scm and vmsort.scm files.

  (cond-expand

   ((and (library (srfi 132 use-r6rs-sorting))
         (library (rnrs sorting)))
    (include "sorting/merge.scm")
    (include "sorting/delndups.scm")     ; list-delete-neighbor-dups etc
    (include "sorting/sortp.scm")        ; list-sorted?, vector-sorted?
    (include "sorting/vector-util.scm")
    (include "sorting/sortfaster.scm"))

   (else
    (include "sorting/delndups.scm")     ; list-delete-neighbor-dups etc
    (include "sorting/lmsort.scm")       ; list-merge, list-merge!
    (include "sorting/sortp.scm")        ; list-sorted?, vector-sorted?
    (include "sorting/vector-util.scm")
    (include "sorting/vhsort.scm")
    (include "sorting/visort.scm")
    (include "sorting/vmsort.scm")       ; vector-merge, vector-merge!
    (include "sorting/vqsort2.scm")
    (include "sorting/vqsort3.scm")
    (include "sorting/sort.scm")))

  (include "sorting/select.scm")

  )

(define-library (srfi 132)

  (export list-sorted?               vector-sorted?
          list-sort                  vector-sort
          list-stable-sort           vector-stable-sort
          list-sort!                 vector-sort!
          list-stable-sort!          vector-stable-sort!
          list-merge                 vector-merge
          list-merge!                vector-merge!
          list-delete-neighbor-dups  vector-delete-neighbor-dups
          list-delete-neighbor-dups! vector-delete-neighbor-dups!
          vector-find-median         vector-find-median!
          vector-select!             vector-separate!
          )

  (import (srfi 132 sorting)))
