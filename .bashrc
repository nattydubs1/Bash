# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s cmdhist

# Editors & pagers
export EDITOR=nvim
export VISUAL=nvim
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

# Your aliases (unchanged)
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

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ────────────────────────────────────────────────────────────────
# MISS DRACULA PROMPT – MUST BE AT THE VERY END
# ────────────────────────────────────────────────────────────────

# Color escapes
export C_RESET="\[\e[0m\]"
export C_PURPLE="\[\e[38;2;189;147;249m\]"   # user@host
export C_PINK="\[\e[38;2;255;121;198m\]"      # path & $
export C_GREEN="\[\e[38;2;80;250;123m\]"
export C_COMMENT="\[\e[38;2;98;114;164m\]"    # git branch

# Set the prompt (one-line version)
PS1="${C_PURPLE}\u@\h${C_RESET}:${C_PINK}\w${C_RESET}"
PS1+="${C_COMMENT}\$(__git_ps1 ' (%s)' 2>/dev/null)${C_RESET}"
PS1+=" ${C_PINK}\$${C_RESET} "

# Alternative two-line (uncomment if preferred):
# PS1="\n${C_PURPLE}\u@\h ${C_PINK}\w${C_RESET}\n${C_PINK}→ ${C_RESET}"
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion    

# -----------------------------
# Warn if SELinux is permissive
# -----------------------------
command -v getenforce >/dev/null && \
[[ "$(getenforce)" != "Enforcing" ]] && \
echo "⚠️  SELinux is not enforcing"

