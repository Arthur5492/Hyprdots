#!/usr/bin/env sh


# lock instance

lockFile="/tmp/hyrpdots$(id -u)swwwallpaper.lock"
[ -e "$lockFile" ] && echo "An instance of the script is already running..." && exit 1
touch "${lockFile}"
trap 'rm -f ${lockFile}' EXIT


# define functions

Wall_Update()
{
	if [ ! -d "${cacheDir}/${curTheme}" ] ; then
		mkdir -p "${cacheDir}/${curTheme}"
	fi

	local x_wall="$1"
	local x_update="${x_wall/$HOME/"~"}"
	cacheImg=$(basename "$x_wall")

	if [ ! -f "${cacheDir}/${curTheme}/${cacheImg}" ] ; then
		convert -strip "${x_wall}"[0] -thumbnail 500x500^ -gravity center -extent 500x500 "${cacheDir}/${curTheme}/${cacheImg}" &
	fi

	if [ ! -f "${cacheDir}/${curTheme}/${cacheImg}.rofi" ] ; then
		convert -strip -resize 2000 -gravity center -extent 2000 -quality 90 "$x_wall"[0] "${cacheDir}/${curTheme}/${cacheImg}.rofi" &
	fi

	if [ ! -f "${cacheDir}/${curTheme}/${cacheImg}.blur" ] ; then
		convert -strip -scale 10% -blur 0x3 -resize 100% "$x_wall"[0] "${cacheDir}/${curTheme}/${cacheImg}.blur" &
	fi

	wait
	jq -r --arg thm "$curTheme" --arg wal "$x_update" 'map(if.name == $thm then .imgPath = $wal else . end)' "${ThemeCtl}" > temp.json && mv temp.json "${ThemeCtl}"
	ln -fs "${x_wall}" "${wallSet}"
	ln -fs "${cacheDir}/${curTheme}/${cacheImg}.rofi" "${wallRfi}"
	ln -fs "${cacheDir}/${curTheme}/${cacheImg}.blur" "${wallBlr}"

}

Wall_Change()
{
	local x_switch=$1

	for (( i=0 ; i<${#Wallist[@]} ; i++ ))
	do
		if [ "${Wallist[i]}" == "${fullPath}" ] ; then

			if [ $x_switch == 'n' ] ; then
				nextIndex=$(( (i + 1) % ${#Wallist[@]} ))
			elif [ $x_switch == 'p' ] ; then
				nextIndex=$(( i - 1 ))
			fi

			Wall_Update "${Wallist[nextIndex]}"
			break
		fi
	done
}

Wall_Set()
{
	if [ -z $xtrans ] ; then
		xtrans="grow"
	fi

	#? getting the real path as symlinks too glitch
	swww img "$(readlink "${wallSet}")" \
	--transition-bezier .43,1.19,1,.4 \
	--transition-type "$xtrans" \
	--transition-duration 0.7 \
	--transition-fps 60 \
	--invert-y \
	--transition-pos "$( hyprctl cursorpos )"    

	#!pywal##############
	wal -q -s -t -i "$(readlink "${wallSet}")" -o "$HOME/.config/hypr/scripts/manualThemesPywal.sh" #executes dunst color change
	#!###################

	# wait for dunst
	while ! pidof dunst > /dev/null; do
	sleep 0.5
	done
	dunstify "t1" -a " ${cacheImg}" -i "${cacheDir}/${gtkTheme}/${cacheImg}" -r 91190 -t 2200
}


# set variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
wallSet="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.data/wall.set"
wallBlr="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.data/wall.blur"
wallRfi="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.data/wall.rofi"


curTheme=$(jq -r '.[] | select(.active == true) | .name' $ThemeCtl)
fullPath=$(jq -r '.[] | select(.active == true) | .imgPath' $ThemeCtl)
wallName=$(basename "$fullPath")
wallPath=$(dirname "$fullPath")
mapfile -d '' Wallist < <(find ${wallPath} -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z)

if [ ! -f "$fullPath" ] ; then
	if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/swww/$curTheme" ] ; then
		wallPath="${XDG_CONFIG_HOME:-$HOME/.config}/swww/$curTheme"
		mapfile -d '' Wallist < <(find ${wallPath} -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z)
		fullPath="${Wallist[0]}"
	else
		echo "ERROR: wallpaper $fullPath not found..."
		exit 1
	fi
fi


	
# evaluate options

while getopts "nps:" option ; do
	case $option in
	n ) # set next wallpaper
		xtrans="grow"
		Wall_Change n ;;
	p ) # set previous wallpaper
		xtrans="outer"
		Wall_Change p ;;
	s ) # set input wallpaper
		if [ -f "$OPTARG" ] ; then
			Wall_Update "$OPTARG"
		fi ;;
	* ) # invalid option
		echo "n : set next wall"
		echo "p : set previous wall"
		echo "s : set input wallpaper"
		exit 1 ;;
	esac
done


# check swww daemon and set wall

swww query
if [ $? -eq 1 ] ; then
	swww init
fi

Wall_Set
