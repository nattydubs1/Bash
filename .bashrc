# ~/.bashrc:

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ────────────────────────────────────────────────────────────────
# RAM-ONLY HISTORY
# ────────────────────────────────────────────────────────────────
umask 077                       # Set default privacy filter
export HISTFILE=/dev/null       # Direct history to the void (SSD safety)
export HISTSIZE=500             # Small working memory in RAM only
export HISTFILESIZE=0           # Ensure no file is ever written
export HISTCONTROL=ignoreboth:erasedups 
shopt -u histappend             # Stop appending to files

# Ignore common and sensitive commands
export HISTIGNORE="ls:cd:exit:pwd:veracrypt*:vault-*:ghost:up:sudo*:history*"

# Wipe RAM buffer on exit
trap 'history -c' EXIT

# Editors & pagers
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R --use-color -Dd+r$Du+b'

# Force-disable Kitty shell integration (prevents injection of raw escapes)
unset KITTY_INSTALLATION_DIR
unset KITTY_SHELL_INTEGRATION

# Debian chroot (keep if needed)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Kitty title for xterm-like terms (keep but simplified)
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# ls/grep color support + aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Aliases 
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lah --color=auto'
alias la='ls -A'
alias rm='rm -Iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias df='df -h'
alias free='free -h'
alias ports='ss -tulpn'
alias dnfup='sudo dnf upgrade --refresh'
alias pacup='sudo pacman -Syu'
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias reload='source ~/.bashrc'
alias mkdir='mkdir -p'

# Host Updates (Atomic)
alias up='sudo rpm-ostree upgrade'

# Boxes
alias work='distrobox enter nvim-dev'
alias study='distrobox enter linux-plus-lab'

# Bye,bye
alias nuke='history -c && rm -f ~/.bash_history && touch ~/.bash_history && history -w && exit'

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ────────────────────────────────────────────────────────────────
# MISS DRACULA
# ────────────────────────────────────────────────────────────────

# Color escapes
export C_RESET="\[\e[0m\]"
export C_PURPLE="\[\e[38;2;189;147;249m\]"   # user@host
export C_PINK="\[\e[38;2;255;121;198m\]"      # path & $
export C_GREEN="\[\e[38;2;80;250;123m\]"
export C_COMMENT="\[\e[38;2;98;114;164m\]"    # git branch

# Set the prompt
if [ -f /run/.containerenv ]; then
    # If in a box, add the green [name] tag
    PS1="${C_GREEN}[${DISTROBOX_NAME:-box}] ${C_RESET}"
else
    # If on host, start clean
    PS1=""
fi

# Add the Dracula Identity
PS1+="${C_PURPLE}\u@\h${C_RESET}:${C_PINK}\w${C_RESET}"
PS1+="${C_COMMENT}\$(__git_ps1 ' (%s)' 2>/dev/null)${C_RESET}"
PS1+=" ${C_PINK}\$${C_RESET} "


# Alternative two-line (uncomment if preferred):
# PS1="\n${C_PURPLE}\u@\h ${C_PINK}\w${C_RESET}\n${C_PINK}→ ${C_RESET}"
export PATH="$HOME/.local/bin:$PATH"

# -----------------------------
# Warn if SELinux is permissive
# -----------------------------
command -v getenforce >/dev/null && \
[[ "$(getenforce)" != "Enforcing" ]] && \
echo "⚠️  SELinux is not enforcing"

# Check my current Digital Mask (Replace wlpXXX with your device name)
alias mask='ip link show YOUR_DEVICE_NAME | grep link/ether'

# The Vault "Key"
alias vault-open='sudo cryptsetup open ~/.secret-vault.img my_ghost_drive && sudo mount /dev/mapper/my_ghost_drive ~/Vault && sudo chown $USER:$USER ~/Vault && notify-send "Vault Opened"'

# The Vault "Lock"
alias vault-close='sudo umount ~/Vault && sudo cryptsetup close my_ghost_drive && notify-send "Vault Locked"'
