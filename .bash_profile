# ENV VAR{{{
# Set up XDG environment variables based on XDG directory specifications
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

# Linux stuff
export EDITOR=nvim
export VISUAL=$EDITOR
export SUDO_EDITOR=nvim
export HISTFILE="$XDG_STATE_HOME/bash/history"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export LESS="FgMrRS j.25 --mouse"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonstartup.py"
export FUNCTION_HOME=$XDG_DATA_HOME/bash
export ALACRITTY_CONFIG="$XDG_CONFIG_HOME/alacritty/alacritty.yml"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# Rust stuff
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
if test -r "$XDG_DATA_HOME/cargo/env"; then
    . "$HOME/.local/share/cargo/env"
fi

# Java stuff
export JAVA_HOME=$HOME/.local/jdks/jdk-17
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export M2_HOME="$HOME/.local/apache-maven-3.9.0"
export M2=$M2_HOME/bin

# Postgres stuff
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"

# Setting up the PATH
PATH=""
PATH="/usr/local/bin:/usr/bin:/bin"
PATH=$PATH:"/usr/local/sbin:/usr/sbin:/sbin"
PATH="$CARGO_HOME/bin":$PATH
PATH="$HOME/.local/bin":$PATH
PATH="$HOME/.local/scripts":$PATH
PATH=$M2:$PATH
PATH=$JAVA_HOME/bin:$PATH
PATH=$PATH:/usr/games
PATH=$PATH:/snap/bin
export PATH
# }}}

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]
    then source "$HOME/.bashrc" 
fi
if test "$SHLVL" -eq 1
    # TODO :In case of an error on `pull` should send a motd
    then git --git-dir=$HOME/dotfiles --work-tree=$HOME pull -q 2> /dev/null
fi

# vim: foldmethod=marker
