#!/usr/bin/env sh
pathConservationMode="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
mode=$(cat "$pathConservationMode")
message=""

if [ $mode -eq 1 ];then 
  mode=0
  message="Conservation mode deactivated"

elif [ $mode -eq 0 ];then
  mode=1
  message="Conservation mode activated"

fi

echo $mode | sudo tee $pathConservationMode

dunstify "t1" -a " $message " -i "~/.config/dunst/icons/battery.svg" -r 666 -t 2200



