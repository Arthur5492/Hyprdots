#!/usr/bin/env sh


# set variables
ScrDir=`dirname "$(realpath "$0")"`
source "${ScrDir}/globalcontrol.sh"
readarray -t theme_ctl < <( cut -d '|' -f 2 $ThemeCtl )


# define functions
Theme_Change()
{
    local x_switch=$1
    local curTheme=$(jq -r '.[] | select(.active == true) | .name' $ThemeCtl)
    for (( i=0 ; i<${#theme_ctl[@]} ; i++ ))
    do
        if [ "${theme_ctl[i]}" == "${curTheme}" ] ; then
            if [ $x_switch == 'n' ] ; then
                nextIndex=$(( (i + 1) % ${#theme_ctl[@]} ))
            elif [ $x_switch == 'p' ] ; then
                nextIndex=$(( i - 1 ))
            fi
            ThemeSet="${theme_ctl[nextIndex]}"
            break
        fi
    done
}


# evaluate options
while getopts "nps:t" option ; do
    case $option in

    n ) # set next theme
        Theme_Change n
        export xtrans="grow" ;;

    p ) # set previous theme
        Theme_Change p
        export xtrans="outer" ;;

    s ) # set selected theme
        ThemeSet="$OPTARG" ;;

    t ) # display tooltip
        echo ""
        echo "󰆊 Next/Previous Theme"
        exit 0 ;;

    * ) # invalid option
        echo "n : set next theme"
        echo "p : set previous theme"
        echo "s : set theme from parameter"
        echo "t : display tooltip"
        exit 1 ;;
    esac
done


#Current Theme name
currentTheme=$(jq -r '.[] | select(.active == true) | .name' $ThemeCtl)

# update theme control
echo "Selected theme: $ThemeSet"

if [ "$ThemeSet" == "$currentTheme" ]; then
	echo "$ThemeSet is already setted"
else
	jq 'map(.active = false)' $ThemeCtl > temp.json && mv temp.json $ThemeCtl #Deactivate all themes
	jq --arg ThemeSet "$ThemeSet" '(map(if .name == $ThemeSet then .active = true else . end))' $ThemeCtl > temp.json && mv temp.json $ThemeCtl #Activate $ThemeSet
fi


# swwwallpaper
getWall=$(jq -r '.[] | select(.active == true) | .imgPath' $ThemeCtl)
getName=`basename "$getWall"`
ln -fs "$getWall" "$ConfDir/swww/wall.data/wall.set"
ln -fs "$cacheDir/${ThemeSet}/${getName}.rofi" "$ConfDir/swww/wall.data/wall.rofi"
ln -tfs "$cacheDir/${ThemeSet}/${getName}.blur" "$ConfDir/swww/wall.data/wall.blur"
"${ScrDir}/swwwallpaper.sh"

if [ $? -ne 0 ] ; then
    echo "ERROR: Unable to set wallpaper"
    exit 1
fi

dunstify "t1" -a " ${ThemeSet}" -i "~/.config/dunst/icons/hyprdots.png" -r 91190 -t 2200

# # kitty
# ln -fs $ConfDir/kitty/themes/${ThemeSet}.conf $ConfDir/kitty/themes/theme.conf
# killall -SIGUSR1 kitty


# rofi
# cp $ConfDir/rofi/themes/${ThemeSet}.rasi $ConfDir/rofi/themes/theme.rasi


# # kvantum QT - Dolphin color
kvantummanager --set "${ThemeSet}"

# qt5ct - Dolphin icon theme
sed -i "/^color_scheme_path=/c\color_scheme_path=$ConfDir/qt5ct/colors/${ThemeSet}.conf" $ConfDir/qt5ct/qt5ct.conf
IconSet=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")
sed -i "/^icon_theme=/c\icon_theme=${IconSet}" $ConfDir/qt5ct/qt5ct.conf


# qt6ct - Qt6 apps icon theme
sed -i "/^color_scheme_path=/c\color_scheme_path=$ConfDir/qt6ct/colors/${ThemeSet}.conf" $ConfDir/qt6ct/qt6ct.conf
sed -i "/^icon_theme=/c\icon_theme=${IconSet}" $ConfDir/qt6ct/qt6ct.conf


# # gtk3 - nwg-look is better
# sed -i "/^gtk-theme-name=/c\gtk-theme-name=${ThemeSet}" $ConfDir/gtk-3.0/settings.ini
# sed -i "/^gtk-icon-theme-name=/c\gtk-icon-theme-name=${IconSet}" $ConfDir/gtk-3.0/settings.ini


# # gtk4 - nwg-look is better
# rm $ConfDir/gtk-4.0
# ln -s /usr/share/themes/$ThemeSet/gtk-4.0 $ConfDir/gtk-4.0


# flatpak GTK
# flatpak --user override --env=GTK_THEME="${ThemeSet}"
# flatpak --user override --env=ICON_THEME="${IconSet}"
