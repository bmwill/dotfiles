# ===== Completion Configuration =====

zmodload zsh/complist # enable menuselect keymap

unsetopt MENU_COMPLETE   # do not autoselect the first completion entry
unsetopt AUTO_MENU       # do not autoselect from menu on successive tab press
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _correct _approximate

# Increase the number of allowed errors based on the length of the typed word.
# But make sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3)) numeric)'

# Offer the original string as a match
zstyle ':completion:*:match:*' original true
zstyle ':completion:*:approximate:*' original true
zstyle ':completion:*:correct:*' original true

# Separate matches into groups
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group 'yes'

# Provide helpful descriptions for options
zstyle ':completion:*' verbose yes
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# Prettier messages
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'

#zstyle ':completion:*:*:*:*:*' menu select=5 # Highlight selection in menu

zstyle ':completion:*:functions' ignored-patterns '_*'

# Automatically update PATH entries
zstyle ':completion:*:commands' rehash true

# Don't insert a literal tab when trying to complete in an empty buffer
zstyle ':completion:*' insert-tab false

# Complete '..' special directories
zstyle ':completion:*' special-dirs '..'

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Always use menu selection for `cd -`
zstyle ':completion:*:*:cd:*:directory-stack' force-list always
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# complete manuals by their section
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true
#zstyle ':completion:*:man:*' menu yes select

# Use LS_COLORS for path completions
function _set-list-colors() {
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    unfunction _set-list-colors
}
sched 0 _set-list-colors  # deferred since LC_COLORS might not be available yet

# Prettier completion for processes
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# Provide more processes in completion of programs like killall
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# Use completion cache
zstyle ':completion:*:complete:*' use-cache true

# Enable:
#   * Hyphen insensitive matching
#   * Case insensitive matching for lowercase letters
zstyle ':completion:*' matcher-list 'm:{a-z-_}={A-Z_-}'

# ----- Custom Completion Scripts -----
COMPLETIONS_DIR="$ZDOTDIR/.completions"
mkdir -p "$COMPLETIONS_DIR"
fpath=("$COMPLETIONS_DIR" $fpath)

# Homebrew
if type brew >/dev/null 2>&1; then
    fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

# Git
zstyle ':completion:*:*:git:*' verbose false # Turn off verbose mode for git

# Rust
if type rustup >/dev/null 2>&1; then
    if [ ! -f "$COMPLETIONS_DIR/_cargo" ]; then
        rustup completions zsh cargo >"$COMPLETIONS_DIR/_cargo"
    fi
    if [ ! -f "$COMPLETIONS_DIR/_rustup" ]; then
        rustup completions zsh rustup >"$COMPLETIONS_DIR/_rustup"
    fi
fi

unset COMPLETIONS_DIR

# ----- Turn on completion system -----
autoload -Uz compinit && compinit
# Enable compatibility with bash completion functions
autoload -Uz bashcompinit && bashcompinit
