#
# ~/.zprofile
#

#[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# XXX Use maybe a similar line from /etc/zsh/zprofile here to source ~/.profile
# XXX $HOME/.profile is not a part of the Zsh startup files and is not sourced by Zsh unless Zsh is invoked as sh or ksh and started as a login shell. For more details about the sh and ksh compatibility modes refer to zsh(1).
#
# https://wiki.archlinux.org/index.php/Zsh
# http://zsh.sourceforge.net/Doc/Release/zsh_toc.html

source /usr/share/doc/pkgfile/command-not-found.zsh
