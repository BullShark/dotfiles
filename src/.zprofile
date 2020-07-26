#
# ~/.zprofile
#

[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

#[[ -e ~/.zshrc ]] && source ~/.zshrc

[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

