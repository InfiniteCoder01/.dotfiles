(require "helix/editor.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
; (require "helix/misc.scm")

(provide game-of-life gol-update)

;; Utilities
(define (make-list size item) (mutable-vector->list (make-vector size item)))
(define (push-front list item) (reverse (push-back (reverse list) item)))
(define (lines->string lines) (apply string-append (map (lambda (line) (string-append line "\n")) lines)))
(define (string-set string index value) (string-append (substring string 0 index) (make-string 1 value) (substring string (+ index 1) (string-length string))))

(define (map-wi list start-index mapper)
  (if (empty? list)
    list
    (push-front (map-wi(cdr list) (+ start-index 1) mapper) (mapper start-index (car list)))))

(define (map-nth list index mapper)
    (if (= index 0)
        (push-front (cdr list) (mapper (car list)))
        (push-front (map-nth (cdr list) (- index 1) mapper) (car list))))

;; Board
(define (make-board width height) (make-list height (make-string width #\ )))
(define (board-ref board x y) (string-ref (list-ref board y) x))
(define (board-set board x y value)
    (map-nth board y
        (lambda (line)
          (string-set line x value))))
(define (board-width board) (string-length (first board)))
(define (board-height board) (length board))

;; Neighbours
(define (board-count-cell board x y)
  (if (char=? (board-ref board x y) #\#) 1 0))

(define (board-count-line board x y)
  (+
   (if (> x 0) (board-count-cell board (- x 1) y) 0)
   (board-count-cell board x y)
   (if (< (+ x 1) (board-width board)) (board-count-cell board (+ x 1) y) 0)))

(define (neighbours board x y)
  (+
   (if (> y 0) (board-count-line board x (- y 1)) 0)
   (- (board-count-line board x y) (board-count-cell board x y))
   (if (< (+ y 1) (board-height board)) (board-count-line board x (+ y 1)) 0)))

;; Step
(define (step board)
  (map-wi board 0 (lambda (y line)
    (list->string (map-wi (string->list line) 0 (lambda (x cell)
      (let ((nc (neighbours board x y))) 
          (if (char=? cell #\#)
            (if (or (= nc 2) (= nc 3)) cell #\ )
            (if (= nc 3) #\# cell)))
))))))

;; Initial board
(define board-initial (make-board 80 40))
(define cx (/ (board-width board-initial) 2))
(define cy (/ (board-height board-initial) 2))
(set! board-initial (board-set board-initial cx cy #\#))
(set! board-initial (board-set board-initial cx (- cy 1) #\#))
(set! board-initial (board-set board-initial cx (+ cy 1) #\#))
(set! board-initial (board-set board-initial (- cx 1) cy #\#))
(set! board-initial (board-set board-initial (+ cx 1) (+ cy 1) #\#))

(define TITLE "[game-of-life]")
(define doc-id 'uninitialzed)

;;@doc
;;Game of life inside of helix
(define (game-of-life)
  (helix.new)
  (set-scratch-buffer-name! TITLE)
  (set! doc-id (editor->doc-id (editor-focus)))


  (helix.static.select_all)
  (helix.static.delete_selection)
  (helix.static.insert_string (lines->string board-initial))
  (helix.static.goto_line_start))

;; Update Game of life
(define (gol-update)
  (helix.static.select_all)
  (define state (split-many (helix.static.current-highlighted-text!) "\n"))
  (set! state (reverse (rest (reverse state))))
  (define new-state (step state))
  (helix.static.delete_selection)
  (helix.static.insert_string (lines->string new-state))
  (helix.static.goto_line_start))

(define GOL-KEYBINDINGS
  (hash "normal"
        (hash " " ':gol-update)))
