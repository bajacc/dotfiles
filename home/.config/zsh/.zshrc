# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments
setopt prompt_subst

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Load aliases and shortcuts if existent.
[ -f "$XDG_CONFIG_HOME/aliasrc" ] && source "$XDG_CONFIG_HOME/aliasrc"

# cursor
precmd() { echo -ne "\e[6 q" }

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^[o' 'lfcd\n'

bindkey -s '^[a' 'bc -l\n'

bindkey -s '^[f' 'cd "$(dirname "$(fzf)")"\n'
bindkey -s '^[n' 'rax2 -r "$(xclip -o)"\n'

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey "^R" history-incremental-search-backward

bindkey '^[[H' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^H' backward-delete-word

bindkey '^[[P' delete-char

setopt histignoredups

# Load syntax highlighting; should be last.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null

# command alias reminder
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh 2>/dev/null

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null

bindkey '^[	' autosuggest-accept

# find repos for program
source /usr/share/doc/pkgfile/command-not-found.zsh 2>/dev/null
