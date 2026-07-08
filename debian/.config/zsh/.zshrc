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

# Set up LS_COLORS: use dircolors if it produces something, otherwise fall back
# to GNU ls's default type-based colors (dircolors -b needs /etc/DIR_COLORS or a
# compiled-in default, neither of which is guaranteed to be present).
command -v dircolors &>/dev/null && eval "$(dircolors -b)"
[[ -z "$LS_COLORS" ]] && export LS_COLORS='di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32'

# Fancy prompt, styled after the default Debian bashrc:
PROMPT='${debian_chroot:+($debian_chroot)}%B%F{green}%n@%m%f%b:%B%F{blue}%~ %(#.#.$)%f%b '

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
mkdir -p "$ZDOTDIR"
HISTFILE="$ZDOTDIR/history"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select

if command -v fzf &>/dev/null; then
    if fzf --zsh &>/dev/null; then
        source <(fzf --zsh)
    else
        # older fzf packages (e.g. Debian's apt package) don't support `fzf --zsh`
        [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
        [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
    fi
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
