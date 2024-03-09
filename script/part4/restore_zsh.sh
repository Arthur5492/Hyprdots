
if gum confirm "Do you want to remove bshrc?" ;then
  echo "Removing bshrc"
  files_to_remove=(".bashrc" ".bash_history" ".bash_logout" ".bash_profile")

  for file in "${files_to_remove[@]}"; do
    if [ -f "$HOME/$file" ]; then
      echo "Removing $file"
      rm "$HOME/$file"
    fi
  done

fi
echo ""
echo "Add zsh shell and oh-my-zsh"

# add zsh plugins
if pkg_installed zsh && pkg_installed oh-my-zsh-git ; then

    # set variables
    Zsh_rc="${ZDOTDIR:-$HOME}/.zshrc"
    Zsh_Path="/usr/share/oh-my-zsh"
    Zsh_Plugins="$Zsh_Path/custom/plugins"
    Fix_Completion=""

    # generate plugins from list
    while read r_plugin
    do
        z_plugin=$(echo $r_plugin | awk -F '/' '{print $NF}')
        if [ "${r_plugin:0:4}" == "http" ] && [ ! -d $Zsh_Plugins/$z_plugin ] ; then
            sudo git clone $r_plugin $Zsh_Plugins/$z_plugin
        fi
        if [ "$z_plugin" == "zsh-completions" ] && [ `grep 'fpath+=.*plugins/zsh-completions/src' $Zsh_rc | wc -l` -eq 0 ]; then
            Fix_Completion='\nfpath+=${ZSH_CUSTOM:-${ZSH:-/usr/share/oh-my-zsh}/custom}/plugins/zsh-completions/src'
        else
            w_plugin=$(echo ${w_plugin} ${z_plugin})
        fi
    done < <(cut -d '#' -f 1 restore_zsh.lst | sed 's/ //g')

    # update plugin array in zshrc
    echo "intalling zsh plugins (${w_plugin})"
    sed -i "/^plugins=/c\plugins=($w_plugin)$Fix_Completion" $Zsh_rc
fi

# set shell
    chsh -s "$(which Zsh)"
    stow -d $cloneDir/.config/zsh #link .zshrc config







