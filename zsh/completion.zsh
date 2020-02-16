# ===== Completion Configuration =====

zmodload zsh/complist # enable menuselect keymap

unsetopt MENU_COMPLETE   # do not autoselect the first completion entry
unsetopt AUTO_MENU       # do not autoselect from menu on successive tab press
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
#zstyle ':completion:*:*:*:*:*' menu no=5 select interactive # Highlight selection in menu

# Automatically update PATH entries
zstyle ':completion:*' rehash true

# Don't insert a literal tab when trying to complete in an empty buffer
zstyle ':completion:*' insert-tab false

# Enable approximate completions
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'

# Complete '..' special directories
zstyle ':completion:*' special-dirs '..'

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Always use menu selection for `cd -`
zstyle ':completion:*:*:cd:*:directory-stack' force-list always
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# Use default coloring for list completion
# LS_COLORS will be used instead if available (setup in directories.zsh)
zstyle ':completion:*' list-colors ''

# Prettier completion for processes
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# Use completion cache
zstyle ':completion::complete:*' use-cache 1

# Enable:
#   * Hyphen insensitive matching
#   * Case insensitive matching for lowercase letters
zstyle ':completion:*' matcher-list 'm:{a-z-_}={A-Z_-}' 'r:|=*' 'l:|=* r:|=*'

# Group results by category
zstyle ':completion:*' group-name ''

# Don't complete uninteresting things unless we really want to.
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'
zstyle '*' single-ignored show

# ----- Custom Completion Scripts -----
mkdir -p "$ZDOTDIR/completions"
fpath=($ZDOTDIR/completions $fpath)

# Homebrew
if type brew >/dev/null 2>&1; then
    fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

# Git
zstyle ':completion:*:*:git:*' verbose false # Turn off verbose mode for git

# Rust
if type rustup >/dev/null 2>&1; then
    if [ ! -f "$ZDOTDIR/completions/_cargo" ]; then
        rustup completions zsh cargo >"$ZDOTDIR/completions/_cargo"
    fi
    if [ ! -f "$ZDOTDIR/completions/_rustup" ]; then
        rustup completions zsh rustup >"$ZDOTDIR/completions/_rustup"
    fi
fi

# ----- Turn on completion system -----
autoload -Uz compinit && compinit
# Enable compatibility with bash completion functions
autoload -Uz bashcompinit && bashcompinit
