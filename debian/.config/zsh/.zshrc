source ~/.config/aliasrc
source ~/.config/envrc

# set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" && -r /etc/debian_chroot ]]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
setopt interactive_comments
setopt prompt_subst

# Fancy prompt, styled after the default Debian bashrc:
PROMPT='${debian_chroot:+($debian_chroot)}%F{green}%n@%m%f:%F{blue}%~ %(#.#.$)%f '

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
mkdir -p "$ZDOTDIR"
HISTFILE="$ZDOTDIR/history"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select

if command -v fzf &>/dev/null; then
    eval "$(fzf --zsh)"
    FZF_CTRL_T_OPTS="--preview 'fzf-preview-file {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
fi

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' backward-kill-line

setopt histignoredups
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE     # Ignore commands that start with a space.
setopt HIST_REDUCE_BLANKS    # Remove unnecessary blank lines.
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

if command -v kubectl &>/dev/null; then
    source <(kubectl completion zsh)
fi

if command -v podman &>/dev/null; then
    source <(podman completion zsh)
fi

if command -v docker &>/dev/null; then
    source <(docker completion zsh)
fi

if [[ ! -f $XDG_CONFIG_HOME/zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma-continuum/zinit)…%f"
  command mkdir -p $XDG_CONFIG_HOME/zinit
  command git clone https://github.com/zdharma-continuum/zinit  $XDG_CONFIG_HOME/zinit/bin && \
  print -P "%F{33}▓▒░ %F{34}Installation successful.%F" || \
  print -P "%F{160}▓▒░ The clone has failed.%F"
fi
source "$XDG_CONFIG_HOME/zinit/bin/zinit.zsh"

# Fast Syntax Highlighting
zinit light zdharma-continuum/fast-syntax-highlighting

# Zsh You Should Use
zinit light MichaelAquilina/zsh-you-should-use

# Zsh Autosuggestions
zinit light zsh-users/zsh-autosuggestions

# Bindkey setup remains the same, as it's a Zsh builtin configuration, not plugin specific
bindkey '^[	' autosuggest-accept

# load private configuration
# This file is not tracked by git, so you can put your private settings here.
[[ ! -f "$ZDOTDIR/private.zsh" ]] || source "$ZDOTDIR/private.zsh"
