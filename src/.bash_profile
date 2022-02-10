#
# ~/.bash_profile
#

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && . /usr/share/doc/pkgfile/command-not-found.bash

# Set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/bin" ]] ; then
	PATH="$HOME/bin:$PATH"
fi

# Stop bash saving duplicates to the history
export HISTCONTROL=ignoredups
 
# vi: ft=sh

