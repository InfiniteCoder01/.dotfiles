(require-builtin helix/core/keymaps as helix.keymaps.)
(require "helix/configuration.scm")

(define (add-global-keybinding map)
  (define global-bindings (get-keybindings))
  (helix.keymaps.helix-merge-keybindings
    global-bindings
    (~> map (value->jsexpr-string) (helix.keymaps.helix-string->keymap)))

  (keybindings global-bindings) )

(add-global-keybinding (hash "normal" (hash "C-x" ":gol-update")))
