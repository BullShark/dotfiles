#
# ~/.bash_profile
#

[[ -f ~/.profile ]] && . ~/.profile

[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && . /usr/share/doc/pkgfile/command-not-found.bash

# Set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/bin" ]] ; then
	PATH="$HOME/bin:$PATH"
fi

# Stop bash saving duplicates to the history
export HISTCONTROL=ignoredups
 
# SDK Manager
[[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# vi: ft=sh

