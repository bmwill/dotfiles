# ===== History file configuration =====

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=10000

setopt EXTENDED_HISTORY       # record timestamp of command in HISTFILE
setopt SHARE_HISTORY          # share history across multiple zsh sessions
setopt APPEND_HISTORY         # append to HISTFILE, rather than overwriting it
setopt INC_APPEND_HISTORY     # append incrementally instead of waiting until the shell exits
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS       # ignore duplicated commands history list
setopt HIST_IGNORE_SPACE      # ignore commands that start with space
setopt HIST_FIND_NO_DUPS      # ignore duplicates when searching
setopt HIST_REDUCE_BLANKS     # remove blank lines from history
setopt HIST_VERIFY            # show command with history expansion to user before running it

## History wrapper
function __history {
  local clear list
  zparseopts -E c=clear l=list

  if [[ -n "$clear" ]]; then
    # if -c provided, clobber the history file
    echo -n >| "$HISTFILE"
    echo >&2 History file deleted. Reload the session to see its effects.
  elif [[ -n "$list" ]]; then
    # if -l provided, run as if calling `fc' directly
    builtin fc "$@"
  else
    # unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}

# Configure the command execution time stamp show in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Timestamp format
case ${HIST_STAMPS-} in
  "mm/dd/yyyy") alias history='__history -f' ;;
  "dd.mm.yyyy") alias history='__history -E' ;;
  "yyyy-mm-dd") alias history='__history -i' ;;
  "") alias history='__history' ;;
  *) alias history="__history -t '$HIST_STAMPS'" ;;
esac
