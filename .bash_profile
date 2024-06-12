# ENV VAR{{{
# Set up XDG environment variables based on XDG directory specifications
export XDG_CONFIG_HOME=$HOME/config
export XDG_STATE_HOME=$HOME/state
export XDG_DATA_HOME=$HOME/data
export XDG_CACHE_HOME=$HOME/cache

# Linux stuff
export EDITOR=neovide
export VISUAL=neovide
export SUDO_EDITOR="neovide --no-fork"
export HISTFILE="$XDG_STATE_HOME/bash/history"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export LESS="FgMrRS j.25 --mouse"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonstartup.py"
export BASH_LIBRARY_PATH=$XDG_DATA_HOME/bash
export ALACRITTY_CONFIG="$XDG_CONFIG_HOME/alacritty/alacritty.toml"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# Rust stuff
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
if test -r "$XDG_DATA_HOME/cargo/env"; then
    . "$XDG_DATA_HOME/cargo/env"
fi

# Java stuff
export JAVA_HOME=$HOME/local/jdks/current
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
# the value in a variable assignment does not undergo pathname expansion
# If I were to set the following variable: M2_HOME="$HOME/tools/apache-maven"-*
# the variable would still contain the glob '*' in it.
# Since this is later used inside the PATH variable, the glob would not work there because of the ':' delimiter
# We need to force the pathname expansion and use that result. We can use array in bash or `set -- ` in POSIX sh
declare -a array=("$HOME/tools/apache-maven"-*)
export M2_HOME="${array[0]}"
export M2=$M2_HOME/bin
unset array
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"

# Node stuff
export NODE_HOME=$HOME/local/node/current
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Postgres stuff
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"

# AWS stuff
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# Setting up the PATH
PATH="/usr/local/go/bin"
PATH=$PATH:"/usr/local/bin:/usr/bin:/bin"
PATH=$PATH:"/usr/local/sbin:/usr/sbin:/sbin"
PATH="$CARGO_HOME/bin":$PATH
PATH="$HOME/local/bin":$PATH
PATH="$HOME/local/scripts":$PATH
PATH=$PATH:${M2}
PATH=$JAVA_HOME/bin:$PATH
PATH=$NODE_HOME/bin:$PATH
PATH=$PATH:/usr/games
PATH=$PATH:/snap/bin
PATH=${PATH}:${HOME}/tools/maven-mvnd-1.0-m8-m40-windows-amd64/bin
export PATH
# }}}

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]
    then source "$HOME/.bashrc"
fi

# vim: foldmethod=marker
