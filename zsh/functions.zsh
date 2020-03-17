#f# Use 'view' to read manpages, in order to enable colors, regex - search, etc.
function vman() {
    man $1 | col -b | \
        view \
        -c 'map q :q<CR>' \
        -c 'set nonumber' \
        -c 'hi StatusLine ctermbg=green| set ft=man nomod nolist' -
}

#f# grep for running process, like: 'any vim'
function any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any <keyword>" >&2 ; return 1
    else
        ps xauwww | grep -i -e "[${1[1]}]${1[2,-1]}"
    fi
}

#f# show activity of top cpu or mem processes
function activity() {
    emulate -L zsh
    local n mem cpu sort
    zparseopts -E n:=n -mem=mem -cpu=cpu

    n=${n[-1]:-5}
    sort=${${${cpu:+cpu}:-${mem:+mem}}:-cpu}

    top -l 2 -o $sort -n $n -stats pid,command,cpu,mem | tail -$(( $n + 1 ))
}

#f# Provide useful information on zsh globbing
# See zshexpn(1) for more info
function help-zshglob() {
    cat <<EOF
    /      directories
    .      plain files
    @      symbolic links
    =      sockets
    p      named pipes (FIFOs)
    *      executable plain files (0100)
    %      device files (character or block special)
    %b     block special files
    %c     character special files
    r      owner-readable files (0400)
    w      owner-writable files (0200)
    x      owner-executable files (0100)
    A      group-readable files (0040)
    I      group-writable files (0020)
    E      group-executable files (0010)
    R      world-readable files (0004)
    W      world-writable files (0002)
    X      world-executable files (0001)
    s      setuid files (04000)
    S      setgid files (02000)
    t      files with the sticky bit (01000)

    print *(m-1)          # Files modified up to a day ago
    print *(a1)           # Files accessed a day ago
    print *(@)            # Just symlinks
    print *(Lk+50)        # Files bigger than 50 kilobytes
    print *(Lk-50)        # Files smaller than 50 kilobytes
    print **/*.c          # All *.c files recursively starting in \$PWD
    print **/*.c~file.c   # Same as above, but excluding 'file.c'
    print (foo|bar).*     # Files starting with 'foo' or 'bar'
    print *~*.*           # All Files that do not contain a dot
    chmod 644 *(.^x)      # make all plain non-executable files publically readable
    print -l *(.c|.h)     # Lists *.c and *.h
    print **/*(g:users:)  # Recursively match all files that are owned by group 'users'
    echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print \$1}'<
EOF
}

# Helper function used to create help pages from configuration files
# $1 - description pattern (e.g. 'a' for alias or 'f' for function)
# $2 - key pattern used to match the name of help item
function _help() {
    emulate -L zsh
    setopt extendedglob
    unsetopt ksharrays  #indexing starts at 1

    # choose files to parse for help info
    local files=(
        ${ZDOTDIR}/*.zsh
        ${ZDOTDIR}/zshrc
        ~/.zshrc.local
    )

    local -A help_items

    local k v cline contents
    local last_desc             # last description starting with #"$1"#
    local num_lines_elapsed=0   # number of lines between last description and help item

    # search config files in the order they a called,
    # this also dictates the order which things are overwritten
    local f
    for f in $files; do
        [[ -r "$f" ]] || continue   # skip if not readable
        contents="$(<$f)"
        for cline in "${(f)contents}"; do
            # zsh pattern: match lines like: #"$1"# <description>
            if [[ "$cline" == (#s)[[:space:]]#\#${~1}\#[[:space:]]##(#b)(*)[[:space:]]#(#e) ]]; then
                last_desc="$match[*]"
                num_lines_elapsed=0
            # zsh pattern: match lines indicated by $2 for aliases or functions
            #              ignores lines that are commentend out
            elif [[ "$cline" == (#s)[[:space:]]#[^#]#(#b)${~2}*(#e) ]]; then
                k=$match[1]

                # keys and description found? (and description isn't too far away)
                if [[ -n $last_desc && $num_lines_elapsed -lt 2 && -n $match[1] ]]; then
                    # Put the help item into the assoc array,
                    # possibly overwriting things found in previous files
                    help_items[${k}]=$last_desc
                fi
                last_desc=""
            else
              ((num_lines_elapsed++))
            fi
        done
    done
    unset contents

    # calculate length of keybinding column
    local kstrlen=0
    for k (${(k)help_items[@]}) ((kstrlen < ${#k})) && kstrlen=${#k}
    kstrlen=$(( kstrlen + 5 ))

    # convert the assoc array into preformated lines, which we are able to sort
    local -a help_lines
    for k v in ${(kv)help_items[@]}; do
        # pad keybinding-string to kstrlen chars
        help_lines+=("${(r:kstrlen:)k}${v}")
    done
    # sort lines alphabetically and print them
    help_lines=("${(i)help_lines[@]}")
    echo "${(F)help_lines[@]}"
}

#f# list configured aliases
function help-aliases() {
    _help "a" "alias[[:space:]]##(*)="
}

#f# list configured functions
function help-functions() {
    _help "f" "function[[:space:]]##(*)[[:space:]]#\(\)"
}
