# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Path to powerlevel10k theme
source ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme

# List of plugins used
plugins=()
source $ZSH/oh-my-zsh.sh


# Helpful aliases
alias  l='lsd -lh  --icons=auto' # long list

# Handy change dir shortcuts
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias v='nvim'

# Fixes "Error opening terminal: xterm-kitty" when using the default kitty term to open some programs through ssh
alias ssh='kitten ssh'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

#Display Pokemon
pokemon-colorscripts --no-title -r

#Tuizin Config
unsetopt BEEP #Remove beep sound
