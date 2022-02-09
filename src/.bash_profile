#
# ~/.bash_profile
#

# shellcheck source=./.profile
[[ -f "$HOME/.profile" ]] && . "$HOME/.profile"

# shellcheck source=./.bashrc
[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

# shellcheck source=/usr/share/doc/pkgfile/command-not-found.bash
[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && . /usr/share/doc/pkgfile/command-not-found.bash

# Set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/bin" ]] ; then
	PATH="$HOME/bin:$PATH"
fi

# Stop bash saving duplicates to the history
export HISTCONTROL=ignoredups
 
# SDK Manager
# shellcheck source=./.sdkman/bin/sdkman-init.sh
[[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# vi: ft=sh

