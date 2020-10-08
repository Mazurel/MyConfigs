#!/bin/sh

# © Mateusz Mazur 2020
# License: MIT
# This is my simple script for loading all configs from local machine

# Xmonad and Xmobar
[ ! -d xmonad ] && mkdir xmonad
cp ~/.xmonad/xmonad.hs ./xmonad/xmonad.hs
cp ~/.xmobarrc ./xmonad/xmobarrc.hs

# Nvim 
[ ! -d nvim ] && mkdir nvim
cp -r ~/.config/nvim/* ./nvim/

# Bash 
[ ! -d bash ] && mkdir bash
cp ~/.bashrc ./bash/bashrc.bash
cp ~/.bash_profile ./bash/bash_profile.bash


