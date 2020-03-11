# ===== ZLE (Zsh Line Editor) and Key-Bindings =====

# Stop ctrl-s and ctrl-q from sending START/STOP signals
unsetopt FLOW_CONTROL
stty -ixon -ixoff
# Allow comments in interactive shells
setopt INTERACTIVE_COMMENTS
# Require use of exit of logout to exit
setopt IGNORE_EOF

# Don't highlight pasted text
zle_highlight+=(paste:none)

# Use emacs-like key bindings by default
bindkey -e

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Use human-friendly identifiers.
# Most terminals send "ESC x" when Meta-x is pressed,
# meaning ESC and META are equivalent for most cases.
#
# Control           '^' or '\C-'
# Escape            '\e'
# Meta              '\e'
# Meta + Control    '\e^'
# Backspace         '^?'
# Tab               '^I'
# Enter             '^M'
typeset -A key
key=(
    'F1'            "$terminfo[kf1]"
    'F2'            "$terminfo[kf2]"
    'F3'            "$terminfo[kf3]"
    'F4'            "$terminfo[kf4]"
    'F5'            "$terminfo[kf5]"
    'F6'            "$terminfo[kf6]"
    'F7'            "$terminfo[kf7]"
    'F8'            "$terminfo[kf8]"
    'F9'            "$terminfo[kf9]"
    'F10'           "$terminfo[kf10]"
    'F11'           "$terminfo[kf11]"
    'F12'           "$terminfo[kf12]"
    'Insert'        "$terminfo[kich1]"
    'Delete'        "$terminfo[kdch1]"
    'Home'          "$terminfo[khome]"
    'PageUp'        "$terminfo[kpp]"
    'End'           "$terminfo[kend]"
    'PageDown'      "$terminfo[knp]"
    'Up'            "$terminfo[kcuu1]"
    'Left'          "$terminfo[kcub1]"
    'Down'          "$terminfo[kcud1]"
    'Right'         "$terminfo[kcuf1]"
    'BackTab'       "$terminfo[kcbt]"
)

# Unbind Ctrl-S so that we can use that as a leader key
bindkey -r '^s'

# Basic movement
bindkey "${key[Down]}" down-line-or-history
bindkey "${key[Up]}" up-line-or-history
bindkey "${key[Left]}" backward-char
bindkey "${key[Right]}" forward-char
bindkey "${key[Home]}" beginning-of-line
bindkey "${key[End]}" end-of-line

bindkey "${key[Delete]}" delete-char

bindkey '^j' down-line-or-history
bindkey '^k' up-line-or-history

# [PageUp] or [Ctrl-S p] search history backward for entry beginning with typed text
# [PageDown] or [Ctrl-S P] search history forward for entry beginning with typed text
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
bindkey "${key[PageUp]}" history-beginning-search-bakward-end
bindkey "^sp" history-beginning-search-bakward-end
bindkey "${key[PageDown]}" history-beginning-search-forward-end
bindkey "^sP" history-beginning-search-forward-end

# [Space] history expansion (things like '!!', '!$', etc)
bindkey ' ' magic-space

# [Ctrl-S f] Insert files and test globbing
autoload -U insert-files && zle -N insert-files
bindkey '^sf' insert-files

# [Ctrl-S Ctrl-E] edit the current command line in $VISUAL or $EDITOR
autoload -U edit-command-line && zle -N edit-command-line
bindkey '^s^e' edit-command-line
bindkey '^x^e' edit-command-line

# [Ctrl-X i] Insert Unicode character
# usage example: 'ctrl-x i' 00A7 'ctrl-x i' will give you an §
# See for example http://unicode.org/charts/ for unicode characters code
autoload -U insert-unicode-char && zle -N insert-unicode-char
bindkey '^xi' insert-unicode-char

# Vim like abbreviation expansion (iabbrev).
# less risky than the global aliases but powerful as well
# just type the abbreviation keys and afterwards [Ctrl-Space] to expand it
typeset -A abbreviations
abbreviations=(
    # key   # value                 # (additional doc string)
    'BG'    '& exit'
    'C'     '| wc -l'
    'G'     '|& rg'
    'Hl'    ' --help |& less -r'    # (Display help in pager)
    'H'     '| head'
    'L'     '| less'
    'LL'    '|& less -r'
    'M'     '| most'
    'T'     '| tail'
    'N'     '&>/dev/null'           # (No Output)
    'R'     '| tr A-z N-za-m'       # (ROT13)
    'SL'    '| sort | less'
    'S'     '| sort -u'
    'V'     '|& vim -'
)

# [Ctrl-Space] Perform abbreviation expansion
# [Ctrl-S Space] Perform abbreviation expansion
function zle-abbreviations {
    emulate -L zsh
    setopt extendedglob
    local MATCH

    LBUFFER=${LBUFFER%%(#m)[.\-+:|_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
}
zle -N zle-abbreviations
bindkey '^ ' zle-abbreviations
bindkey '^s ' zle-abbreviations

# [Ctrl-S b] Display list of abbreviations that would expand
function help-abbreviations {
    print "Available abbreviations for expansion:"

    print -a -C 2 ${(kv)abbreviations}
}
function zle-help-abbreviations {
    zle -M "$(help-abbreviations)"
}
zle -N zle-help-abbreviations
bindkey '^sb' zle-help-abbreviations

# [Ctrl-Z] Smart shortcut for typing 'fg<Enter>'
function smart-fg {
  if (( ${#jobstates} )); then
    zle .push-input
    [[ -o HIST_IGNORE_SPACE ]] && BUFFER=' ' || BUFFER=''
    BUFFER="${BUFFER}fg"
    zle .accept-line
  else
    zle -M 'No background jobs. Doing nothing.'
  fi
}
zle -N smart-fg
bindkey '^z' smart-fg

# [Ctrl-S d] Insert the actual date in the form yyyy-mm-dd
function insert-datestamp {
    LBUFFER+=${(%):-'%D{%Y-%m-%d}'}
}
zle -N insert-datestamp
bindkey '^sd' insert-datestamp

# [Ctrl-S 1] jump to after the first word on the cmdline, useful to add options.
function jump-after-first-word {
    local words
    words=(${(z)BUFFER})

    if (( ${#words} <= 1 )) ; then
        CURSOR=${#BUFFER}
    else
        CURSOR=${#${words[1]}}
    fi
}
zle -N jump-after-first-word
bindkey '^s1' jump-after-first-word

# [Ctrl-O s] prepend command line with 'sudo '
function prepend-sudo {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR+5 ))
    fi
}
zle -N prepend-sudo
bindkey '^ss' prepend-sudo

# [Ctrl-S M] Create directory under cursor or the selected area
# To select an area press ctrl-@ or ctrl-space and use the cursor.
# Use case: you type "mv abc ~/testa/testb/testc/" and remember that the
# directory does not exist yet -> press [Ctrl-S M] and problem solved!
function inplace-mkdir {
    local PATHTOMKDIR
    if ((REGION_ACTIVE==1)); then
        local F=$MARK T=$CURSOR
        if [[ $F -gt $T ]]; then
            F=${CURSOR}
            T=${MARK}
        fi
        # get marked area from buffer and eliminate whitespace
        PATHTOMKDIR=${BUFFER[F+1,T]%%[[:space:]]##}
        PATHTOMKDIR=${PATHTOMKDIR##[[:space:]]##}
    else
        local bufwords iword
        bufwords=(${(z)LBUFFER})
        iword=${#bufwords}
        bufwords=(${(z)BUFFER})
        PATHTOMKDIR="${(Q)bufwords[iword]}"
    fi
    [[ -z "${PATHTOMKDIR}" ]] && return 1
    PATHTOMKDIR=${~PATHTOMKDIR}
    if [[ -e "${PATHTOMKDIR}" ]]; then
        zle -M " path already exists, doing nothing"
    else
        zle -M "$(mkdir -p -v "${PATHTOMKDIR}")"
        zle end-of-line
    fi
}
zle -N inplace-mkdir
bindkey '^sM' inplace-mkdir

# [Ctrl-X Ctrl-X] complete word from history
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history
bindkey '^x^x' hist-complete

# [Esc-m] insert last typed word
bindkey '\em' copy-prev-shell-word
# [Esc-w] Kill from the cursor to the mark
bindkey '\ew' kill-region
# [Esc-l] run command: ls
bindkey -s '\el' 'ls^M'
# [Ctrl-r] Search backward incrementally for a specified string.
# The string may begin with ^ to anchor the search to the beginning of the line.
bindkey '^r' history-incremental-search-backward

# ---- menu completion ------------------------------------------------

# [Esc-i] or [Meta-i] trigger menu completion
bindkey '\ei' menu-complete
# [Ctrl-S Ctrl-I] trigger menu completion
bindkey '^s^i' menu-complete

# [Shift-Tab] menu selection:  move through the completion menu backwards
bindkey -M menuselect "${key[BackTab]}" reverse-menu-complete
# [Ctrl-K] menu selection: cycle through the completion menu backwards
bindkey -M menuselect '^k' reverse-menu-complete
# [Ctrl-J] menu selection: cycle through the completion menu Forwards
bindkey -M menuselect '^j' menu-complete

# [+] menu selection: pick item but stay in the menu
bindkey -M menuselect '+' accept-and-menu-complete
# [Ctrl-O] menu selection: accept a completion and try to complete again
# Very useful with completing directories, with 'undo' you have a simple file browser
bindkey -M menuselect '^o' accept-and-infer-next-history

# ---- zle & keybinding help ------------------------------------------

# The 'help-zle' function searches through sourced files looking for comments
# which describe key bindings, lines of the form "# [<key>] <desc>", and
# compiles them into an easy to read list of keybindings.

# set location of help-zle cache file
_HELP_ZLE_CACHE_FILE=~/.cache/zsh_help_zle_lines.zsh
# helper function for help-zle, actually generates the help text
function _help_zle_parse_keybindings() {
    emulate -L zsh
    setopt extendedglob
    unsetopt ksharrays  #indexing starts at 1

    # choose files that help-zle will parse for keybindings
    local keybinding_files=(
        ${ZDOTDIR}/*.zsh
        ${ZDOTDIR}/zshrc
        ~/.zshrc.local
    )

    local f
    if [[ -r $_HELP_ZLE_CACHE_FILE ]]; then
        local load_cache=0
        for f ($keybinding_files) [[ $f -nt $_HELP_ZLE_CACHE_FILE ]] && load_cache=1
        [[ $load_cache -eq 0 ]] && . $_HELP_ZLE_CACHE_FILE && return
    fi

    # fill with default keybindings, possibly to be overwritten in a file later
    local -A help_zle_keybindings
    help_zle_keybindings=(
        '[Ctrl-@]'              "set Mark"
        '[Ctrl-X Ctrl-J]'       "vi-join lines"
        '[Ctrl-X Ctrl-B]'       "jump to matching brace"
        '[Ctrl-_]'              "undo"
        '[Ctrl-X Ctrl-F <c>]'   "find <c> in cmdline"
        '[Ctrl-A]'              "goto beginning of line"
        '[Ctrl-E]'              "goto end of line"
        '[Ctrl-T]'              "transpose charaters"
        '[Alt-T]'               "transpose words"
        '[Alt-S]'               "spellcheck word"
        '[Ctrl-K]'              "backward kill buffer"
        '[Ctrl-U]'              "forward kill buffer"
        '[Ctrl-Y]'              "insert previously killed word/string"
        "[Alt-']"               "quote line"
        '[Alt-"]'               "quote from mark to cursor"
        '[Alt-<arg>]'           "repeat next cmd/char <arg> times (<Alt>-<Alt>1<Alt>0a -> -10 times 'a')"
        '[Alt-U]'               "make next word Uppercase"
        '[Alt-L]'               "make next word lowercase"
        '[Ctrl-X G]'            "preview expansion under cursor"
        '[Alt-Q]'               "push current CL into background, freeing it. Restore on next CL"
        '[Alt-.]'               "insert (and interate through) last word from prev CLs"
        '[Alt-,]'               "complete word from newer history (consecutive hits)"
        '[Alt-M]'               "repeat last typed word on current CL"
        '[Ctrl-V]'              "insert next keypress symbol literally (e.g. for bindkey)"
        '[Alt-H]'               "show help/manpage for current command"
        '!!:n*<Tab>'            "insert last n arguments of last command"
        '!!:n-<Tab>'            "insert arguments n..N-2 of last command (e.g. mv s s d)"
    )

    # init global variables
    unset _help_zle_lines _help_zle_sln
    typeset -g -a _help_zle_lines
    typeset -g _help_zle_sln=1

    local k v cline
    local desc contents
    # search config files in the order they a called (and thus the order in which they overwrite keybindings)
    for f in $keybinding_files; do
        [[ -r "$f" ]] || continue   # skip if not readable
        contents="$(<$f)"
        for cline in "${(f)contents}"; do
            # zsh pattern: match lines like: # [<keys>] <description>
            if [[ "$cline" == (#s)(#b)[[:space:]]#\#[[:space:]]#(\[*\])[[:space:]]#(*)[[:space:]]#(#e) ]]; then
                k="${match[1]}"
                desc="${match[2]}"

                # keys and description found?
                if [[ -n $k && -n $desc ]]; then
                    # Place keybinding in array
                    # possibly overwriting defaults or stuff found in earlier files
                    help_zle_keybindings[${k}]=$desc
                fi
            fi
        done
    done
    unset contents

    # calculate length of keybinding column
    local kstrlen=0
    for k (${(k)help_zle_keybindings[@]}) ((kstrlen < ${#k})) && kstrlen=${#k}
    # convert the assoc array into preformated lines, which we are able to sort
    for k v in ${(kv)help_zle_keybindings[@]}; do
        # pad keybinding-string to kstrlen chars
        _help_zle_lines+=("${(r:kstrlen:)k}${v}")
    done

    # sort lines alphabetically
    _help_zle_lines=("${(i)_help_zle_lines[@]}")
    [[ -d ${_HELP_ZLE_CACHE_FILE:h} ]] || mkdir -p "${_HELP_ZLE_CACHE_FILE:h}"
    echo "_help_zle_lines=(${(q)_help_zle_lines[@]})" >| $_HELP_ZLE_CACHE_FILE
    zcompile $_HELP_ZLE_CACHE_FILE
}

# Provides (partially autogenerated) help on keybindings and the zsh line editor
function help-zle() {
    emulate -L zsh

    # generate help lines if it hasn't been done already
    _help_zle_parse_keybindings

    echo "${(F)_help_zle_lines}"
}

# set number of lines to display per page
ZLE_HELP_LINES_PER_PAGE=20
typeset -g _help_zle_sln
typeset -g -a _help_zle_lines
function zle-help-zle() {
    emulate -L zsh
    unsetopt ksharrays  # indexing starts at 1

    # generate help lines if it hasn't been done already
    _help_zle_parse_keybindings

    # go back to start of the help lines if they've already all been displayed
    [[ $_help_zle_sln -gt ${#_help_zle_lines} ]] && _help_zle_sln=1
    local sln=$_help_zle_sln

    # note that _help_zle_sln is a global var, meaning we remember the last page we viewed
    _help_zle_sln=$((_help_zle_sln + ZLE_HELP_LINES_PER_PAGE))
    zle -M "${(F)_help_zle_lines[sln,_help_zle_sln-1]}"
}
zle -N zle-help-zle
# [Ctrl-S h] display help for keybindings and ZLE
bindkey '^sh' zle-help-zle
