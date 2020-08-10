#
# ~/.zprofile
#

[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

