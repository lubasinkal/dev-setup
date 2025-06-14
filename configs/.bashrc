#If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
# HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# eza aliases to replace ls
alias ls='eza --icons --group-directories-first --header'
alias ll='eza -alF --icons --group-directories-first --header'
alias la='eza -A --icons --group-directories-first --header'
alias l='eza -F --icons --group-directories-first --header'
alias lt='eza -T --icons --group-directories-first --header'
alias lg='eza --git --icons --group-directories-first --header'

# Safety and convenience aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color=auto'
alias c='clear'
alias reload='source ~/.bashrc'

# Make and cd into directory
mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

eval "$(starship init bash)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export EDITOR=nvim
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
export YAZI_CONFIG_HOME=~/.config/yazi
eval "$(zoxide init bash)"
eval "$(fnm env --use-on-cd --shell bash)"