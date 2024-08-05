# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
source $HOME/.config/plasma-workspace/env/path.sh

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  nix-zsh-completions
  zsh-eza
)

source $ZSH/oh-my-zsh.sh

# User configuration
alias clear-desktop-cache="sudo rm -rf /usr/share/mime/mime.cache /usr/share/applications/mimeinfo.cache ~/.local/share/applications/mimeinfo.cache ~/.local/share/mime/mime.cache"
alias flake-new="wget https://gist.githubusercontent.com/InfiniteCoder01/e3b8f14405114a7cff1618d807612545/raw/flake.nix -O flake.nix"

alias x="eza --icons"
alias xa="eza --icons --all"
alias xl="eza --icons --long"
alias xla="eza --icons --long --all"
alias xt="eza --icons --tree"
alias xta="eza --icons --tree --all"

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
