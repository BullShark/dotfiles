#
# ~/.zprofile
#

[[ -f "$HOME/.profile" ]] && emulate sh -c "source '$HOME/.profile'"

[[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]] && . /usr/share/doc/pkgfile/command-not-found.zsh

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

