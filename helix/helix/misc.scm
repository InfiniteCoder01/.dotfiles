(require-builtin helix/core/misc as helix.)
(provide hx.cx->pos)
(define (hx.cx->pos)
    (helix.hx.cx->pos *helix.cx*))

(provide pop-last-component!)
(define (pop-last-component! arg)
    (helix.pop-last-component! *helix.cx* arg))

(provide hx.custom-insert-newline)
(define (hx.custom-insert-newline arg)
    (helix.hx.custom-insert-newline *helix.cx* arg))

(provide push-component!)
(define (push-component! arg)
    (helix.push-component! *helix.cx* arg))

(provide enqueue-thread-local-callback)
(define (enqueue-thread-local-callback arg)
    (helix.enqueue-thread-local-callback *helix.cx* arg))

    (provide send-lsp-command)
    ;;@doc
    ;; Send an lsp command. The `lsp-name` must correspond to an active lsp.
    ;; The method name corresponds to the method name that you'd expect to see
    ;; with the lsp, and the params can be passed as a hash table. The callback
    ;; provided will be called with whatever result is returned from the LSP,
    ;; deserialized from json to a steel value.
    ;; 
    ;; # Example
    ;; ```scheme
    ;; (define (view-crate-graph)
    ;;   (send-lsp-command "rust-analyzer"
    ;;                     "rust-analyzer/viewCrateGraph"
    ;;                     (hash "full" #f)
    ;;                     ;; Callback to run with the result
    ;;                     (lambda (result) (displayln result))))
    ;; ```
    (define (send-lsp-command lsp-name method-name params callback)
        (helix.send-lsp-command *helix.cx* lsp-name method-name params callback))
            
(provide enqueue-thread-local-callback-with-delay)
(define (enqueue-thread-local-callback-with-delay arg1 arg2)
    (helix.enqueue-thread-local-callback-with-delay *helix.cx* arg1 arg2))

(provide helix-await-callback)
(define (helix-await-callback arg1 arg2)
    (helix.helix-await-callback *helix.cx* arg1 arg2))
