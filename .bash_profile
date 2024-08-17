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
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export LESS="FgMrRS j.25 --mouse"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonstartup.py"
export BASH_LIBRARY_PATH=$XDG_DATA_HOME/bash
export ALACRITTY_CONFIG="$XDG_CONFIG_HOME/alacritty/alacritty.toml"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# Bash history
export HISTCONTROL="ignoreboth"
export HISTFILE="$XDG_STATE_HOME/bash/history"
export HISTIGNORE="clear:history:fg:bg:exit"
export HISTTIMEFORMAT="%F %T - "

# Rust stuff
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
if test -r "$XDG_DATA_HOME/cargo/env"; then
    . "$XDG_DATA_HOME/cargo/env"
fi

# Java stuff
export JAVA_HOME=$HOME/local/jdks/current
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export M2_HOME="/usr/local/share/maven"
export M2="$M2_HOME/bin"
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

export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

# Setting up the PATH
# default path
DEFAULT_PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
# language specific path
LANG_PATH="/usr/local/go/bin"
LANG_PATH="${CARGO_HOME}/bin:${LANG_PATH}"
LANG_PATH="${JAVA_HOME}/bin:${LANG_PATH}"
LANG_PATH="${NODE_HOME}/bin:${LANG_PATH}"
LANG_PATH="${LANG_PATH}:${M2}"
LANG_PATH="${LANG_PATH}:${HOME}/tools/maven-mvnd-1.0-m8-m40-windows-amd64/bin"

# home directory path
HOME_PATH="${HOME}/local/bin"
HOME_PATH="${HOME}/local/scripts:${HOME_PATH}"

# miscellaneous
DEFAULT_PATH="${DEFAULT_PATH}:/usr/games"
DEFAULT_PATH="${DEFAULT_PATH}:/snap/bin"

# Combining the path
PATH="${HOME_PATH}:${LANG_PATH}:${DEFAULT_PATH}"
export PATH
# }}}

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]
    then source "$HOME/.bashrc"
fi

# vim: foldmethod=marker
