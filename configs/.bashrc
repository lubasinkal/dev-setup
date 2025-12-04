# Minimal Bashrc - Fast Loading

case $- in
    *i*) ;;
      *) return;;
esac

shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# Essential eza aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -alF --icons --group-directories-first'
alias la='eza -A --icons --group-directories-first'
alias l='eza --icons --group-directories-first'
alias lt='eza -T --icons --group-directories-first'

# Essential aliases
alias c='clear'
alias reload='source ~/.bashrc'
alias grep='grep --color=auto'

# Essential functions
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }
y() { local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd; yazi "$@" --cwd-file="$tmp"; if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then builtin cd -- "$cwd"; fi; rm -f -- "$tmp"; }

# Environment
export EDITOR=nvim
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export YAZI_CONFIG_HOME=~/.config/yazi

# Fast tool initialization
eval "$(starship init bash)"
eval "$(fnm env --use-on-cd --shell bash)"
eval "$(zoxide init bash)"
