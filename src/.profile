# Used to share profiles between bash and zsh
#
# ~/.profile
#

# Proton
export PATH="$PATH:$HOME/.local/share/Steam/steamapps/common/Proton 5.0"
export STEAM_COMPAT_DATA_PATH="/home/bullshark/.proton"

# Homebrew
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info${INFOPATH+:$INFOPATH}";

# Man pages
export MANPAGER='less -s -M +Gg'	# Display percentage in the document
export LESS="--RAW-CONTROL-CHARS"	# Get color support for 'less'
[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP	# Use colors for less, man, etc.

# Miscellaneous
export EDITOR="vim"
export MANGOHUD=1
export HOMEBREW_CLEANUP_MAX_AGE_DAYS=0

# vi: ft=sh

