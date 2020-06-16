#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && . /usr/share/doc/pkgfile/command-not-found.bash

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

# Proton
export PATH="$PATH:$HOME/.local/share/Steam/steamapps/common/Proton 5.0"
export STEAM_COMPAT_DATA_PATH="/home/bullshark/.proton"

# Homebrew
export HOMEBREW_PREFIX="/home/bullshark/.linuxbrew";
export HOMEBREW_CELLAR="/home/bullshark/.linuxbrew/Cellar";
export HOMEBREW_REPOSITORY="/home/bullshark/.linuxbrew/Homebrew";
export PATH="/home/bullshark/.linuxbrew/bin:/home/bullshark/.linuxbrew/sbin${PATH+:$PATH}";
export MANPATH="/home/bullshark/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/home/bullshark/.linuxbrew/share/info${INFOPATH+:$INFOPATH}";

# Man pages
export MANPAGER='less -s -M +Gg'	# Display percentage in the document
export LESS="--RAW-CONTROL-CHARS"	# Get color support for 'less'
[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP	# Use colors for less, man, etc.

# Miscellaneous
export EDITOR="vim"
export MANGOHUD=1
export HOMEBREW_CLEANUP_MAX_AGE_DAYS=0

