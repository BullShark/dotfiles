# Used to share profiles between bash and zsh
#
# ~/.profile
#

# Proton
export PATH="$PATH:$HOME/.local/share/Steam/steamapps/common/Proton 5.0"
export STEAM_COMPAT_DATA_PATH="/home/bullshark/.proton"

# Man pages
export MANPAGER='less -s -M +Gg'	# Display percentage in the document
export LESS="--RAW-CONTROL-CHARS"	# Get color support for 'less'
[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP	# Use colors for less, man, etc.

# Miscellaneous
export EDITOR="vim"
export MANGOHUD=1

# Android-dev
export PATH="$PATH:$HOME/Android/Sdk/tools/bin"
export PATH="$PATH:$HOME/Android/Sdk/platform-tools"
export PATH="$PATH:$HOME/Android/Sdk/build-tools/30.0.1"
export PATH="$PATH:$HOME/Android/Sdk/tools"

# vi: ft=sh

