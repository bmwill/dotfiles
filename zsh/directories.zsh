# ===== Directory Movement and Listing =====

# Changing/making/removing directory
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHDMINUS
DIRSTACKSIZE=10

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
}
compdef _dirs d

function gd () {
    local directory="$(git rev-parse --show-toplevel 2>/dev/null)"

    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        cd $(git rev-parse --show-toplevel 2>/dev/null)
    else
        echo "Not in a git repo" 1>&2
        return 1
    fi
}

#=======================================#
#           Configure `ls`              #
#=======================================#

#-----------------------------------------------------------#
#   Configure LSCOLORS                                      #
#   Env variable used by OSX `ls`                           #
#                                                           #
#   Colors                                                  #
#   a   black             A   bold black                    #
#   b   red               B   bold red                      #
#   c   green             C   bold green                    #
#   d   brown             D   bold brown                    #
#   e   blue              E   bold blue                     #
#   f   magenta           F   bold magenta                  #
#   g   cyan              G   bold cyan                     #
#   h   light grey        H   bold light grey               #
#   x   Default                                             #
#                                                           #
#   The default is "exfxcxdxbxegedabagacad"                 #
#   Where each pair 'fb' is Foreground+Background           #
#-----------------------------------------------------------#
LSCOLORS="ex"       # Directory
LSCOLORS+="fx"      # Symbolic Link
LSCOLORS+="cx"      # Socket
LSCOLORS+="dx"      # Pipe
LSCOLORS+="bx"      # Executable
LSCOLORS+="eg"      # Block Special
LSCOLORS+="ed"      # Character Special
LSCOLORS+="ab"      # executable with setuid bit set
LSCOLORS+="ag"      # executable with setgid bit set
LSCOLORS+="ac"      # directory writable to others, with sticky bit
LSCOLORS+="ad"      # directory writable to others, without sticky bit

#-----------------------------------------------------------#
#   Configure LS_COLORS                                     #
#   Env variable used by GNU `ls`                           #
#                                                           #
#   Colors                  Backgrounds                     #
#   30  Black                40  Black Background           #
#   31  Red                  41  Red Background             #
#   32  Green                42  Green Background           #
#   33  Orange               43  Orange Background          #
#   34  Blue                 44  Blue Background            #
#   35  Purple               45  Purple Background          #
#   36  Cyan                 46  Cyan Background            #
#   37  Grey                 47  Grey Backgorund            #
#   90  Dark Grey           100  Dark Grey Background       #
#   91  Light Red           101  Light Red Background       #
#   92  Light Green         102  Light Green Background     #
#   93  Yellow              103  Yellow Background          #
#   94  Light Blue          104  Light Blue Background      #
#   95  Light Purple        105  Light Purple Background    #
#   96  Turquoise           106  Turquoise Background       #
#   97  White                                               #
#                                                           #
#                    Effects                                #
#   00  Default Color       07  Reversed                    #
#   01  Bold                08  Concealed                   #
#   04  Underlined                                          #
#-----------------------------------------------------------#
LS_COLORS="no=00"       # Global default
LS_COLORS+=":fi=00"     # Normal file
LS_COLORS+=":di=34"     # Directory
LS_COLORS+=":ln=35"     # Symbolic Link
LS_COLORS+=":so=32"     # Socket
LS_COLORS+=":pi=33"     # Named Pipe
LS_COLORS+=":ex=31"     # Executable file
LS_COLORS+=":bd=34;46"  # Block Device
LS_COLORS+=":cd=34;33"  # Character Device
LS_COLORS+=":su=30;41"  # SetUID: File that is setuid (u+s)
LS_COLORS+=":sg=30;46"  # SetGID: File that is setgid (g+s)
LS_COLORS+=":tw=30;42"  # Directory: sticky and other-writable (+t,o+w)
LS_COLORS+=":ow=30;43"  # Directory: other-writable (o+w)
LS_COLORS+=":or=31;40"  # Orphan: Symlink pointing to non-existent file
LS_COLORS+=":mi=31;40"  # Non-existent file pointed to by Symlink
LS_COLORS+=":*.tar=32"  # *.extension for file specific coloring

#TODO configure LS_COLORS
# Select a theme to be used for ls coloring from `.zsh/.dircolors`
#ls_theme="$ZDOTDIR/.dircolors/LS_COLORS"

# Detect which `ls` flavor is in use
if ls --color >/dev/null 2>&1; then # GNU `ls`
    alias ls="ls --color"
    [[ -f "$ls_theme" ]] && eval "$(dircolors -b "$ls_theme")" || export LS_COLORS
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Use LS_COLORS for list completion
elif gls >/dev/null 2>&1; then # GNU coreutils
    alias ls="gls --color"
    [[ -f "$ls_theme" ]] && eval "$(gdircolors -b "$ls_theme")" || export LS_COLORS
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Use LS_COLORS for list completion
else # OS X `ls`
    alias ls="ls -G"
    export LSCOLORS
fi
unset ls_theme

# Some convenient `ls` aliases
alias la="ls -A"
alias ll="ls -AlhF"
alias l="ls -lhF"
alias lsd="ls -lhd -- */"

# Show me the size (sorted) of only the folders in this directory
alias folders="find . -maxdepth 1 -type d -print | xargs du -shk | sort -rn"
