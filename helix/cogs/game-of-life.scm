(require (prefix-in helix.static. "helix/static.scm"))

; (require "helix/editor.scm")
; (require (prefix-in helix. "helix/commands.scm"))
; (require (prefix-in helix.static. "helix/static.scm"))
; (require "helix/misc.scm")

(require (only-in "labelled-buffers.scm"
                  make-new-labelled-buffer!
                  temporarily-switch-focus
                  open-labelled-buffer
                  maybe-fetch-doc-id))

(provide game-of-life)

(define ID "github.com/InfiniteCoder01/helix-game-of-life")

;;@doc
;;Game of life inside of helix
(define (game-of-life)
  (define doc-id (maybe-fetch-doc-id ID))
  (unless doc-id
    (make-new-labelled-buffer! #:label ID))

  (open-labelled-buffer ID)

  (temporarily-switch-focus
    (lambda ()
      (open-labelled-buffer ID)

      (helix.static.select_all)
      (helix.static.delete_selection)

      (helix.static.insert_string "TEST")
      (helix.static.open_below)
      (helix.static.goto_line_start))))
