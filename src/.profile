# Used to share profiles between bash and zsh
#
# ~/.profile
#

# Proton
[[ -d "$HOME/.local/share/Steam/steamapps/common/Proton - Experimental" ]] && export PATH="$PATH:$HOME/.local/share/Steam/steamapps/common/Proton - Experimental"
[[ -d "$HOME/.proton" ]] && export STEAM_COMPAT_DATA_PATH="$HOME/.proton"

# Man pages
export MANPAGER='less -s -M +Gg'	# Display percentage in the document
export LESS="--RAW-CONTROL-CHARS"	# Get color support for 'less'
[[ -f "$HOME/.LESS_TERMCAP" ]] && . "$HOME/.LESS_TERMCAP"	# Use colors for less, man, etc.

# Miscellaneous
export EDITOR="vim"
[[ -f /usr/bin/mangohud ]] && export MANGOHUD="1"

# Netbeans Building Project Fix:
# https://stackoverflow.com/questions/6448163/a-fatal-error-has-been-detected-by-the-java-runtime-environment-sigsegv-libjvm/7515836
# Can netbeans be found in a bin directory? Then it is installed.
if locate --limit 1 --regex '.*bin/netbeans$' 1>/dev/null 2>&1 ; then
    export LD_BIND_NOW="1"
fi

[[ -f "/usr/bin/chromium" ]] && export BROWSER="/usr/bin/chromium"

# Npm
#export PATH="$PATH:$HOME/.npm/bin"

# Android-dev
if [[ -d ~/Android/Sdk/ ]]; then
    export PATH="$PATH:$HOME/Android/Sdk/tools/bin"
    export PATH="$PATH:$HOME/Android/Sdk/platform-tools"
    export PATH="$PATH:$HOME/Android/Sdk/build-tools/32.0.0"
    export PATH="$PATH:$HOME/Android/Sdk/tools"
fi

# Antialiasing for fonts with Java
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp -Dswing.aatext=true --enable-preview'

# Silence these messages 'Picked up _JAVA_OPTIONS=...'
#_SILENT_JAVA_OPTIONS="$_JAVA_OPTIONS"
#unset _JAVA_OPTIONS
#alias java='java "$_SILENT_JAVA_OPTIONS"'

# Turn ally (accessibility) features off to avoid getting an error message
#export NO_AT_BRIDGE=1
#unset DBUS_SESSION_BUS_ADDRESS

# vi: ft=sh

