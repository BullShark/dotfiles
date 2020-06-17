#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" "\e[${value};...;${value}m"
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval "$(dircolors -b ~/.dir_colors)"
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval "$(dircolors -b /etc/DIR_COLORS)"
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

# Mimic Zsh run-help ability (Alt + h)
bind '"\eh": "\C-a\eb\ed\C-y\e#man \C-y\C-m\C-p\C-p\C-a\C-d\C-e"'

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
# Auto-resize, check and adjust column width and height after each command
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Auto cd when entering just a path
shopt -s autocd

##############################################################
# ALIASES
#

alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias vp='vim PKGBUILD'
alias more='less'

alias h='history'
#alias hv='history | view -' # Pipe history to read-only VIM
alias hg='history | grep -iE --' # History grep/search

# Added safety and verbose
alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'

# Lazy typing
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd $-' # Back to previous dir
alias cls='clear'
alias _='sudo' # Simple sudo
alias sl='ls'

# LS Fu
alias ls='ls --color=auto'
alias la='ls -lhaZ'
alias lsa='ls -shaCF' # Does not show SE info

# Gets WAN ip
#alias myip='dig myip.opendns.com @resolver1.opendns.com +short'
alias myip='curl -4 icanhazip.com'
alias myip6='curl -6 icanhazip.com'

# Weather info in colors
alias weather='curl wttr.in'

# Moon Phase
alias moon='curl wttr.in/Moon'

# Run youtube-dl for music without looking at --help every time
alias yt-audio='youtube-dl -x --audio-quality 0 --audio-format mp3 --add-metadata'

# Use larger units
alias iostat='iostat --human'

# What GCC "native" know about the CPU and what flags native enables on your machine
alias gcc-info='gcc -march=native -v -Q --help=target; echo; gcc -v -E -x c /dev/null -o /dev/null -march=native 2>&1 | grep /cc1'

# List of the top ten most used commands
alias most-often="history | awk '{print \$2}' | sort | uniq -c | sort -rn | head"

#-------------------------------------------------------------
# ss: socket statistics
# -a all
# -l listening
# -o timer info
# -e extended/detailed socket info
# -m memory info
# -p processes using socket
# -i internal tcp info
# -r try to resolve numeric port/addr
# -s summary statistics
# -Z Implies -p with SE Audit info
# -z Implies -Z with more SE Fu, more verbose
# -n numeric, no resolve
# -b bpf (berkeley pcap/tcpdump filters), -4, -6, -0 packet (-f link),
# -t tcp, -u udp, -d dccp, -w raw, -x unix (-f unix)
# -- family, socket tables, ...
#-------------------------------------------------------------
alias sss='sudo ss -aloempin'

#-------------------------------------------------------------
# lsof: list open files
# -i Without args, selects the listing of all IP network files
# -n Prevent conversion of net numbers to net names
# -P Prevent conversion of port numbers to port names
#-------------------------------------------------------------
alias lsofnet='sudo lsof -i -n -P'

##############################################################
# FUNCTIONS
#

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Bash Power Prompt - AskApache.org
# http://www.askapache.com/linux/bash-power-prompt.html
#export AA_P="export PVE=\"\\033[m\\033[38;5;2m\"\$(( \`sed -n \"s/MemFree:[\\t ]\\+\\([0-9]\\+\\) kB/\\1/p\" /proc/meminfo\` / 1024 ))\"\\033[38;5;22m/\"\$((\`sed -n \"s/MemTotal:[\\t ]\\+\\([0-9]\\+\\) kB/\\1/p\" /proc/meminfo\`/ 1024 ))MB\"\\t\\033[m\\033[38;5;55m\$(< /proc/loadavg)\\033[m\";echo -en \"\"" \
#export PROMPT_COMMAND="history -a;((\$SECONDS % 10==0 ))&&eval \"\$AA_P\";echo -en \"\$PVE\";" \
#export PS1="\\[\\e[m\\n\\e[1;30m\\][\$\$:\$PPID \\j:\\!\\[\\e[1;30m\\]]\\[\\e[0;36m\\] \\T \\d \\[\\e[1;30m\\][\\[\\e[1;34m\\]\\u@\\H\\[\\e[1;30m\\]:\\[\\e[0;37m\\]\${SSH_TTY} \\[\\e[0;32m\\]+\${SHLVL}\\[\\e[1;30m\\]] \\[\\e[1;37m\\]\\w\\[\\e[0;37m\\] \\n(\$SHLVL:\\!)\\\$ " \
#export PVE="\\033[m\\033[38;5;2m813\\033[38;5;22m/1024MB\\t\\033[m\\033[38;5;55m0.25 0.22 0.18 1/66 26820\\033[m" && eval $AA_P

# Set debugging options
function debug {
  set -o nounset
  set -o xtrace
  set -o verbose
}

# Unset debugging options
function xdebug {
  set +o nounset
  set +o xtrace
  set +o verbose
}

# Grep ps output and always display the first line from ps, the column names
function psgrep {
  if [[ $# -eq 1 && $1 != '-h' && $1 != '--help' ]]
  then
    ps aux | head -n 1
    ps aux | awk '{if(NR>1)print}' | grep -Ei "$1"
  else
    echo "Usage: $0 [GREP_OPTIONS] regexp"
  fi
}

# Gets TOR ip
function torip {
  http_proxy="http://localhost:8118" wget -q http://ipchicken.com -O- | \
    grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}){1}' | \
    tr -d '[:space:]'
  echo
}

# Renew TOR ip
function renewtorip {
  sudo systemctl restart tor
  sudo systemctl restart privoxy
}

# Restart KDE; Useful if hung
function restartkde {
  kquitapp5 plasmashell
  kstart5 plasmashell
}

# Re-detect sound devices
function soundfix {
  pacmd unload-module module-udev-detect && pacmd load-module module-udev-detect
}

# Extract icon from exe
function exeicon {
  7z x "$*" .rsrc/ICON
  mv .rsrc dotrsrc # Unhide it
}

# Clean temporary files created by pacman, pamac, octopi, yay, flatpak, snap, and brew
function sweep {
  sudo -i -u root bash << 'EOF'             # Execute all as root
  # Remove cache files if yay is not running
  killall -q -0 yay || rm -rvf $HOME/.cache/yay/* /root/.cache/yay/*

  # Clear all pacman download cache and databases
  pacman -Scc --noconfirm

  # Clear logs older than 3 days
  journalctl --vacuum-time=3d

  # Removes old revisions of snaps
  # CLOSE ALL SNAPS BEFORE RUNNING THIS
  snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done
  #XXX http://mywiki.wooledge.org/BashProgramming/05
EOF
  # Yay and pamac cleanup
  yes | yay -Scc
  pamac clean -k 0

  # Flatpak uses /var/tmp and that's cleared by /etc/rc.local on boot

  # Homebrew cleanup
  brew cleanup
  brew cleanup --prune 0
  brew cleanup -s
  rm -rvf "$(brew --cache)"
}

# View manpages in vim with vim's color scheme and less macros
function man {
  if [[ $# != 0 && $1 != '-k' && $1 != '-h' && $1 != '--help' ]]
  then
    /usr/bin/man "$@" | \
      col -b | \
      /usr/share/vim/vim82/macros/less.sh -R -c 'set ft=man nomod nolist nonumber' -
  else
    man "$@"
  fi
}

