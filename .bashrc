# My ~/.bashrc
# ------------

# -----------------------------------------
# Source global definitions (if they exist)
# -----------------------------------------
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# ------------------
# User-specific PATH
# ------------------
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# ---------------------------------------------
# History — large size, ignore/erase duplicates
# ---------------------------------------------
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
shopt -s cmdhist

# --------------------------
# Preferred editor and pager
# --------------------------
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

# -----------------------
# Less with color support
# -----------------------
export LESS='-R --use-color -Dd+r$Du+b'

# ----------------------
# Enable bash completion
# ----------------------
if [ -f /etc/profile.d/bash_completion.sh ]; then
  . /etc/profile.d/bash_completion.sh
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# -------------------------
# Dracula truecolor palette
# -------------------------
purple="#bd93f9"  # user@host
cyan="#8be9fd"    # path
pink="#ff79c6"    # $ prompt
green="#50fa7b"   # git clean ✓
red="#ff5555"     # git dirty *
yellow="#f1fa8c"  # optional warnings
fg="#f8f8f2"      # default text
comment="#6272a4" # muted

# --------------------------
# Dracula-inspired LS_COLORS
# --------------------------
export LS_COLORS="di=38;2;189;147;249:ln=38;2;139;233;253:ex=38;2;80;250;123:\
fi=38;2;248;248;242:pi=38;2;255;121;198:so=38;2;255;121;198:bd=38;2;241;250;140:\
cd=38;2;241;250;140:or=38;2;255;85;85:mi=38;2;255;85;85:su=38;2;255;85;85:\
sg=38;2;255;85;85:tw=38;2;80;250;123:ow=38;2;80;250;123"

# ---------------------------------
# Color support for common commands
# ---------------------------------
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'

if command -v dircolors >/dev/null; then
  eval "$(dircolors -b)"
fi
# -------------------
# Navigation & safety
# -------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -lah'
alias la='ls -A'
alias rm='rm -Iv'
alias cp='cp -iv'
alias mv='mv -iv'

# --------------
# System helpers
# --------------
alias df='df -h'
alias free='free -h'
alias ports='ss -tulpn'

# -------------
# Git shortcuts
# -------------
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'

# ------------
# Quick reload
# ------------
alias reload='source ~/.bashrc'

# ---------------------
# Fedora / Arch helpers
# ---------------------
alias dnfup='sudo dnf upgrade --refresh'
alias pacup='sudo pacman -Syu'

# ------------------------
# Simple archive extractor
# ------------------------
extract() {
  if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2 | *.tbz2) tar xjf "$1" ;;
    *.tar.gz | *.tgz) tar xzf "$1" ;;
    *.tar.xz) tar xJf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "Don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# ───────────────────────────────────────────────
# Git branch + dirty/clean indicator
# ───────────────────────────────────────────────
parse_git_branch() {
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
  if [ -n "$branch" ]; then
    if git diff --quiet --ignore-submodules HEAD 2>/dev/null &&
      git diff --cached --quiet 2>/dev/null; then
      echo -e "\[\e[38;2;80;250;123m\][$branch ✓]\[\e[0m\]"
    else
      echo -e "\[\e[38;2;255;85;85m\][$branch *]\[\e[0m\]"
    fi
  fi
}

# ───────────────────────────────────────────────
# Prompt (Dracula style)
# ───────────────────────────────────────────────
PS1="\[\e[38;2;189;147;249m\]\u@\h" # purple user@host
PS1+="\[\e[38;2;139;233;253m\] \w"  # cyan current directory
PS1+="\$(parse_git_branch)"         # git info (green ✓ or red *)
PS1+="\[\e[38;2;255;121;198m\]\$ "  # pink dollar sign
PS1+="\[\e[0m\]"     

# -----------------------------
# Warn if SELinux is permissive
# -----------------------------
command -v getenforce >/dev/null && \
[[ "$(getenforce)" != "Enforcing" ]] && \
echo "⚠️  SELinux is not enforcing"

