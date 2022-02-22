# ===== Aliases =====

alias b='${(z)BROWSER}'
#a# open default editor
alias e='${(z)VISUAL:-${(z)EDITOR}}'
alias v='${(z)VISUAL:-${(z)EDITOR}}'
alias p='${(z)PAGER}'
alias sa='alias | grep -i'
alias type='type -a'

# prefer nvim to vim if its available
if (( $+commands[nvim] )); then
    alias vim='nvim'
fi

# Always enable colored `grep` output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Don't do shell globbing with git
# use '=git' if you really need shell globbing
alias git='noglob git'

# File Download
if (( $+commands[curl] )); then
    alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif (( $+commands[wget] )); then
    alias get='wget --continue --progress=bar --timestamping'
fi

# Resource Usage
alias df='df -kh'
alias du='du -kh'

if [[ "$OSTYPE" == (darwin*|*bsd*) ]]; then
    alias topc='top -o cpu'
    alias topm='top -o vsize'
else
    alias topc='top -o %CPU'
    alias topm='top -o %MEM'
fi

# Serves a directory via HTTP.
if (( $+commands[python3] )); then
    alias http-serve='python3 -m http.server'
else
    alias http-serve='python -m SimpleHTTPServer'
fi

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Ring the terminal bell; useful when executing time-consuming commands
alias badge="tput bel"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Reload the shell (i.e. invoke as a login shell)
alias reload='(( ! ${#jobstates} )) && exec $SHELL -l || echo "zsh: you have suspended jobs"'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# ---- macos aliases --------------------------------------------------
if [[ "$OSTYPE" == darwin* ]]; then
    # Merge PDF files
    # Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
    alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

    # Lock the screen (when going AFK)
    #alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
    alias afk="osascript -e 'tell application \"System Events\" to sleep'"

    # Adjust System Volume: http://xkcd.com/530/
    alias mute="osascript -e 'set volume output muted true'"
    alias unmute="osascript -e 'set volume output muted false'"
    alias pumpitup="osascript -e 'set volume 7'"

    # Show/hide hidden files in Finder
    alias showfinder="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefinder="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

    # Show/hide all desktop icons (useful when presenting)
    alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
    alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

    # Flush Directory Service cache
    alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

    # Recursively delete `.DS_Store` files
    alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

    # Empty the Trash on all mounted volumes and the main HDD.
    # Also, clear Apple’s System Logs to improve shell startup speed.
    # Finally, clear download history from quarantine. https://mths.be/bum
    alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; \
        sudo rm -rfv ~/.Trash; \
        sudo rm -rfv /private/var/log/asl/*.asl; \
        sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
fi
