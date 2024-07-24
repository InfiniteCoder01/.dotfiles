alias x = eza --icons
alias xa = eza --icons --all
alias xl	= eza --icons --long
alias xla = eza --icons --long --all
alias xt	= eza --icons --tree
alias xta = eza --icons --tree --all

alias clear-desktop-cache = sudo rm -rf /usr/share/mime/mime.cache /usr/share/applications/mimeinfo.cache ~/.local/share/applications/mimeinfo.cache ~/.local/share/mime/mime.cache
alias flake-new = wget https://gist.githubusercontent.com/InfiniteCoder01/e3b8f14405114a7cff1618d807612545/raw/2bd7baaeb9d0d9226aadcd555375acf3370c6073/flake.nix -O flake.nix

$env.PATH = ($env.PATH ++ ":~/.cargo/bin")
source ~/.zoxide.nu

$env.config = {
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
    }]
  }

  completions: {
    external: {
        enable: true
        completer: {|spans|
          carapace $spans.0 nushell ...$spans | from json
        }
    }
  }
}

use ~/.cache/starship/init.nu
