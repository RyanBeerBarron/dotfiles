# Set up XDG environment variables based on XDG directory specifications
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]
    then source "$HOME/.bashrc" 
fi
if test "$SHLVL" -eq 1
    # TODO :In case of an error on `pull` should send a motd
    then git --git-dir=$HOME/dotfiles --work-tree=$HOME pull -q 2> /dev/null
fi
