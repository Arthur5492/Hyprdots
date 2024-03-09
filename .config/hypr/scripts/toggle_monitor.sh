#!/usr/bin/env sh
#*TOGGLE MONITOR - find in js if monitor is on(dpmsStatus)
#   true:  disable monitor with keyword easily
#   false: enable monitor with his data(is need to not get error), hyprctl keyword $1, enable will get a stoi error  
if [ $(hyprctl monitors -j | jq ".[]|select(.name==\"$1\").dpmsStatus") = "true" ]; then 
    hyprctl keyword monitor $1,disable; 
else hyprctl keyword monitor $1,$2, $3, $4;
fi  