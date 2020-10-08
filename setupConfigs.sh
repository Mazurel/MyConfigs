#!/bin/sh

# © Mateusz Mazur 2020
# License: MIT
# Setup all configs

# Xmonad and xmobar
[ ! -d ~/.xmonad ] && mkdir ~/.xmonad
cp ./xmonad/xmonad.hs ~/.xmonad/xmonad.hs
cp ./xmonad/xmobarrc.hs ~/.xmobarrc

# Nvim
[ ! -d ~/.config ] && mkdir ~/.config
[ ! -d ~/.config/nvim ] && mkdir ~/.config/nvim
cp -r ./nvim/* ~/.config/nvim/


# Bash
cp ./bash/bashrc.bash ~/.bashrc
cp ./bash/bash_profile.bash ~/.bash_profile
