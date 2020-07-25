#
# ~/.zprofile
#

#[[ -e ~/.zshrc ]] && source ~/.zshrc

[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

