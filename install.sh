#!/bin/bash

# Set installation mode
mode="live"
if [ ! -z $1 ]; then
    mode="dev"
    echo "IMPORTANT: DEV MODE ACTIVATED. "
    echo "Existing dotfiles folder will not be modified."
    echo "Symbolic links will not be created."
fi

source script/global/library.sh #Useful Functions
source script/global/globalVariables.sh #Variables in general

#Part 1: Basics
source script/part1/required.sh #install required packages
source script/part1/confirm-start.sh #confirm if wanna
source script/part1/yay.sh #install yay
source script/part1/backup.sh #?Dont need?
source script/part1/preparation.sh
source script/part1/installer.sh

#Part 2: installing packages 
#*Load&Install general packages
	source script/part2/general-packages.sh #load packages
	source script/global/install-packages.sh #Install loaded packages
#*Load&Install Hyprland packages
	source script/part2/hyprland-packages #load Hyprland Packages
	source script/global/install-packages.sh #install loaded packages
#*Install pywal
    source script/part2/pywal.sh 

#Part 3: restore bigger files(fonts,gtk) from .jar and enable services with systemctl
source script/part3/restore_fnt.sh
source script/part3/system_ctl.sh

#!Create symbolic links .config -> $HOME
stow --verbose --target=$HOME --restow */
#!

#Part 4 - Post install configs
source script/part4/create_cache.sh #Create background cache
source script/part4/restore_zsh.sh #Restore shell config
source script/part4/displaymanager.sh #remove current display manager & install sddm

xdg-user-dirs-update

startReboot=$(gum choose "Installation finished!" "Reboot Now" "Later")

if [ $startReboot == "Reboot Now" ]; then
    sudo reboot now
elif [$startReboot == "Later" ]; then
    echo "Please reboot when you can :/"
fi
