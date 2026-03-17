#!/usr/bin/env bash

./link.sh ~/.config/sway sway
./link.sh ~/.config/swaync swaync
./link.sh ~/.config/waybar waybar
./link.sh ~/.config/kitty kitty
./link.sh ~/.config/helix helix
./link.sh ~/.config/zed zed
./link.sh ~/.config/starship.toml starship/starship.toml
./link.sh ~/.config/xonsh xonsh
./link.sh ~/.config/tmux tmux

# ZSH
./link.sh ~/.zshrc zsh/.zshrc
./link.sh ~/.oh-my-zsh/custom zsh/.oh-my-zsh/custom

# Aseprite
./link.sh ~/.config/aseprite/aseprite.ini aseprite/aseprite.ini
./link.sh ~/.config/aseprite/palettes aseprite/palettes
./link.sh ~/.config/aseprite/scripts aseprite/scripts
./link.sh ~/.config/aseprite/user.aseprite-brushes aseprite/user.aseprite-brushes

# PrusaSlicer
./link.sh ~/.config/PrusaSlicer/filament PrusaSlicer/filament
./link.sh ~/.config/PrusaSlicer/print PrusaSlicer/print
./link.sh ~/.config/PrusaSlicer/printer PrusaSlicer/printer
