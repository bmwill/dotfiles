# ===== Prompt Configuration =====

# Underline the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
  user_style="%F{red}%U%n%u%f"
else
  user_style="%F{red}%n%f"
fi

# Underline the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
  host_style="%F{cyan}%U%m%u%f"
else
  host_style="%F{cyan}%m%f"
fi

setopt prompt_subst

PROMPT=''
PROMPT+='%(?.%F{green}✓.%F{red}✗%?)%f ' # Exit Code
PROMPT+='${user_style}@${host_style} ' # user@host
PROMPT+='%F{red}[ %f${PWD/#$HOME/~} %F{red}]%f' # Working directory
PROMPT+='%F{red}λ%f ' # Prompt char

# Set the Right Prompt to contain Git info
if type brew >/dev/null 2>&1; then
    source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh

    RPROMPT='%F{240}$(__git_ps1 "± (%s)")%f'
fi

# Set the continuation interactive prompt
PS2='%F{161}%_ %F{yellow}→ %f'
