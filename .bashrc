# Testing for PS1 to check if this is an interactive shell
# In case of a SSH connection, a non-login, non-interactive shell
# might still source .bashrc but not .bash_profile.
# But .bashrc needs .bash_profile to be sourced
if test "$PS1"; then

    # ENV VAR{{{
    unset EDITOR;
    if test -v XDG_CURRENT_DESKTOP; then
         EDITOR="neovide"
    fi
    # Linux stuff
    export EDITOR=${EDITOR:-nvim}
    export VISUAL=$EDITOR
    export SUDO_EDITOR=nvim
    export HISTFILE="$XDG_STATE_HOME/bash/history"
    export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
    export LESS="FgMrRS j.25 --mouse"
    export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonstartup.py"
    export FUNCTION_HOME=$XDG_DATA_HOME/bash
    export ALACRITTY_CONFIG="$XDG_CONFIG_HOME/alacritty/alacritty.yml"

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
    # }}}

    ### Setting up the PATH{{{
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

    # ALIASES{{{
    # creating aliases before sourcing functions, functions might depend on aliases
    alias ls='ls -FtX'
    alias la='ls -A'
    alias l='ls -CF'
    alias colo='colorscheme'
    alias info="info --vi-keys"
    alias gdb="gdb -q -tui"
    alias diff="colordiff"
    alias dotfiles="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME -c include.path=~/gitconfig"
    alias df="dotfiles"
    # }}}

    # Setting colors{{{
    DIRCOLORS="$XDG_CONFIG_HOME"/dircolors
    if [ -x "$DIRCOLORS" ]; then
        test -r "$DIRCOLORS" && eval "$(dircolors -b $DIRCOLORS)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto -FtX'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
    # }}}

    # Sourcing bash/sh functions and setting completions {{{
    for FILE in $FUNCTION_HOME/*; do source "$FILE"; done
    source /usr/share/bash-completion/completions/git
    __git_complete glca _git_log
    __git_complete gl_bb.bash _git_log
    complete -W "clean debug release install test" ./build
    if test -r /usr/share/bash-completion/bash_completion
        then source /usr/share/bash-completion/bash_completion
    fi
    # }}}

    # PS1 Prompt {{{
    function timer_now {
        date +%s%N # seconds and nanoseconds
    }

    function timer_start {
        if test -z "$timer_start"; then
            timer_start=$(timer_now)
            # echo "starting timer"
        fi
    }

    function timer_stop {
            local delta_us=$((($(timer_now) - $timer_start) / 1000))
            local us=$((delta_us % 1000))

            local delta_ms=$((delta_us / 1000))
            local ms=$((delta_ms % 1000))

            local delta_s=$((delta_ms / 1000))
            local s=$((delta_s % 60))

            local delta_m=$((delta_s / 60))
            local m=$((delta_m % 60))

            local h=$((delta_m / 60))
            # Goal: always show around 3 digits of accuracy
            if ((h > 0)); then timer_show=${h}h${m}m
            elif ((m > 0)); then timer_show=${m}m${s}s
            elif ((s >= 10)); then timer_show=${s}.$((ms / 100))s
            elif ((s > 0)); then timer_show=${s}.$(printf %03d $ms)s
            elif ((ms >= 100)); then timer_show=${ms}ms
            elif ((ms > 0)); then timer_show=${ms}.$((us / 100))ms
            else timer_show=${us}us
            fi
    }

    function echo_time {
        timer_stop
        local len=$(( COLUMNS - ${#timer_show} ))
        PS1="\[\e[s\e[${len}C\]$timer_show\[\e[u\]"
        PS1+='$(prompt $? \! "\W" )\n'
        # echo "stoping timer"
        unset timer_start
    }

    trap 'timer_start' DEBUG

    which prompt &> /dev/null && PROMPT_COMMAND='echo_time' || PROMPT_COMMAND=''
    PS1="[\u@\h] \W \$ "
    export PS1
    # }}}

    # Bind configuration {{{
    # It is better to use bash built-in bind instead of readline
    # even with conditional config inside readline '$if Bash'
    # because these command are executed when the keyseq is done
    # no matter whats already written in the current line
    # With readline, you'd have to resort to simply outputting the macro
    # to clear the line, type in the command, and enter
    bind -m vi -x '"\e\C-R": source $HOME/.bashrc'
    bind -m vi-insert -x '"\e\C-R": source $HOME/.bashrc'

    bind -m vi -x '":": tmux command-prompt'
    bind -m vi-insert -x '"\e:": tmux command-prompt'

    bind -m vi-insert -x '"\e\C-e": start-session-here'
    bind -m vi -x '"\e\C-e": start-session-here'

    bind -m vi -x '"\C-n": start-session'
    bind -m vi-insert -x '"\C-n": start-session'
    # }}}

    # Shell/Term options {{{
    shopt -s \
        cdable_vars \
        cdspell \
        checkhash \
        checkjobs \
        complete_fullquote \
        direxpand \
        dirspell \
        dotglob \
        globasciiranges \
        globstar \
        no_empty_cmd_completion \
        nocaseglob \
        progcomp_alias
    set -o ignoreeof
    # Prevents Ctrl-S from freezing the terminal...
    stty -ixon
    # }}}
fi
# vim: ft=bash foldmethod=marker
