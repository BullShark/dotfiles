# Used to share profiles between bash and zsh
#
# ~/.profile
#

# Proton
export PATH="$PATH:$HOME/.local/share/Steam/steamapps/common/Proton 3.7"
#[[ -f ~/.proton ]] && export STEAM_COMPAT_DATA_PATH="~/.proton"
export STEAM_COMPAT_DATA_PATH="~/.proton"

# Man pages
export MANPAGER='less -s -M +Gg'	# Display percentage in the document
export LESS="--RAW-CONTROL-CHARS"	# Get color support for 'less'
[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP	# Use colors for less, man, etc.

# Miscellaneous
export EDITOR="vim"
export MANGOHUD="1"
# Netbeans Building Project Fix:
# https://stackoverflow.com/questions/6448163/a-fatal-error-has-been-detected-by-the-java-runtime-environment-sigsegv-libjvm/7515836
export LD_BIND_NOW=1
#export BROWSER="/usr/bin/chromium"

# Npm
#export PATH="$PATH:$HOME/.npm/bin"

# Android-dev
export PATH="$PATH:$HOME/Android/Sdk/tools/bin"
export PATH="$PATH:$HOME/Android/Sdk/platform-tools"
export PATH="$PATH:$HOME/Android/Sdk/build-tools/30.0.1"
export PATH="$PATH:$HOME/Android/Sdk/tools"

# Silence these messages 'Picked up _JAVA_OPTIONS=...'
_SILENT_JAVA_OPTIONS="$_JAVA_OPTIONS"
unset _JAVA_OPTIONS
alias java='java "$_SILENT_JAVA_OPTIONS"'

# More Java
export JAVA_HOME="/opt/jdk-16.0.1"
export PATH="$PATH:/opt/jdk-16.0.1/bin"

# Best editor
export EDITOR="vim"

# vi: ft=sh

