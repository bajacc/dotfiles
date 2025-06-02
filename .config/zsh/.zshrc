# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments
setopt prompt_subst

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
mkdir -p "$XDG_DATA_HOME/zsh/"
HISTFILE="$XDG_DATA_HOME/zsh/history"

# Load aliases.
source "$XDG_CONFIG_HOME/aliasrc"

# cursor
precmd() { echo -ne "\e[6 q" }

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select

eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS="--layout=reverse --height 55%"
export FZF_CTRL_T_OPTS="--preview 'fzf-preview-file {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

bindkey -s '^[a' 'bc -l\n'
bindkey -s '^[n' 'rax2 -r "$(xclip -o)"\n'
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^H' backward-delete-word
bindkey '^[[P' delete-char
# Move cursor to the end of the line with Alt+Right
bindkey '^[^[[C' end-of-line
# Move cursor to the start of the line with Alt+Left
bindkey '^[^[[D' beginning-of-line
bindkey -s '^[f' 'cd "$(dirname "$(eval "fzf ${FZF_CTRL_T_OPTS}")")"\n'

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
