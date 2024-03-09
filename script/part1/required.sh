# ------------------------------------------------------
# Check for required packages to run the installation
# ------------------------------------------------------

# pacman
if [ -f /etc/pacman.conf ]; then
    echo -e "\033[0;32m[PACMAN]\033[0m adding extra spice to pacman..."

    sudo sed -i "/^#Color/c\Color" /etc/pacman.conf
    sudo sed -i "/^#VerbosePkgLists/c\VerbosePkgLists" /etc/pacman.conf
    sudo sed -i "/^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

    sudo pacman -Syyu
    sudo pacman -Fy
fi

# Check for required packages
echo ":: Checking that required packages for the installation are installed..."
_installPackagesPacman "rsync" "gum" "figlet" "stow" "git"; 
echo ""

# Double check rsync
if ! command -v rsync &> /dev/null; then
    echo ":: Force rsync installation"
    sudo pacman -S rsync --noconfirm
else
    echo ":: rsync double checked"
fi
echo ""