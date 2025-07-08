#!/usr/bin/env bash

./link.sh ~/.config/sway sway
./link.sh ~/.config/waybar waybar
./link.sh ~/.config/nvim nvim
./link.sh ~/.config/helix helix
./link.sh ~/.config/zed zed
./link.sh ~/.config/starship.toml starship/starship.toml
./link.sh ~/.xonshrc xonsh/.xonshrc

# ZSH
./link.sh ~/.zshrc zsh/.zshrc
./link.sh ~/.oh-my-zsh/custom zsh/.oh-my-zsh/custom

# Tmux
./link.sh ~/.tmux.conf tmux/.tmux.conf
./link.sh ~/.tmux tmux/.tmux

# Emacs
./link.sh ~/.emacs.d emacs/.emacs.d
./link.sh ~/.doom.d emacs/.doom.d

# VS Code
./link.sh ~/.config/Code/User/keybindings.json VSCode/keybindings.json
./link.sh ~/.config/Code/User/settings.json VSCode/settings.json

# Aseprite
./link.sh ~/.config/aseprite/aseprite.ini aseprite/aseprite.ini
./link.sh ~/.config/aseprite/palettes aseprite/palettes
./link.sh ~/.config/aseprite/scripts aseprite/scripts
./link.sh ~/.config/aseprite/user.aseprite-brushes aseprite/user.aseprite-brushes

# PrusaSlicer
./link.sh ~/.config/PrusaSlicer/filament PrusaSlicer/filament
./link.sh ~/.config/PrusaSlicer/print PrusaSlicer/print
./link.sh ~/.config/PrusaSlicer/printer PrusaSlicer/printer
./link.sh ~/.config/PrusaSlicer/sla_material PrusaSlicer/sla_material
./link.sh ~/.config/PrusaSlicer/sla_print PrusaSlicer/sla_print
./link.sh ~/.config/PrusaSlicer/vendor PrusaSlicer/vendor
