# Testing for PS1 to check if this is an interactive shell
# In case of a SSH connection, a non-login, non-interactive shell
# might still source .bashrc but not .bash_profile.
# But .bashrc needs .bash_profile to be sourced
if test "$PS1"
then
    # aliases {{{
    # creating aliases before sourcing functions, functions might depend on aliases
    alias ls='ls -FtX'
    alias la='ls -A'
    alias l='ls -CF'
    alias man='man --encoding=us-ascii'
    alias colo='colorscheme'
    alias info="info --vi-keys"
    alias gdb="gdb -q -tui"
    alias diff="colordiff"
    alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget_hsts"
    alias gpg="gpg --homedir $XDG_DATA_HOME/gnupg"
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
    if test -r /usr/share/bash-completion/bash_completion
        then source /usr/share/bash-completion/bash_completion
    fi
    source /usr/share/bash-completion/completions/git
    if test -r ~/submodules/alacritty/extra/completions/alacritty.bash
        then source ~/submodules/alacritty/extra/completions/alacritty.bash
    fi
    test -x /usr/local/bin/kubectl && eval "$(kubectl completion bash)"
    for file in $BASH_LIBRARY_PATH/*; do source "$FILE"; done
    # }}}

    # Timer functions {{{
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
    # }}}

    # PS1 Prompt {{{
    function generate_prompt {
        local exit_code=$?
        timer_stop
        local hist_num="\!"
        hist_num=${hist_num@P}
        hist_num=$(( hist_num + 1 ))
        local len=$(( ${#timer_show} -1 ))
        local git_branch=$(__git_ps1)
        declare -a PS1_pattern
        PS1_pattern+=("-d" "$distro")
        PS1_pattern+=("-u" "\u")
        PS1_pattern+=("-H" "\h")
        PS1_pattern+=("-w" "\W")
        PS1_pattern+=("-g" "$git_branch")
        if git rev-parse --is-inside-work-tree &> /dev/null
        then
          shortstat=$(set -eo pipefail; git diff --numstat HEAD 2> /dev/null | awk -f $XDG_DATA_HOME/awk/sum-gitstat.awk)
          PS1_pattern+=("-s" "$shortstat")
        fi
        # PS1_pattern+=("-n" "$hist_num")
        # PS1_pattern+=("-t" "$timer_show")
        PS1_pattern+=("-c" "$exit_code")
        export PS1=$(prompt "${PS1_pattern[@]@P}")
        # echo "stoping timer"
        unset timer_start
    }

    trap 'timer_start' DEBUG
    distro=$(sed -En 's/NAME="(\w+)"/\1/p' /etc/os-release)
    which prompt &> /dev/null && PROMPT_COMMAND='generate_prompt' || PROMPT_COMMAND=''
    # }}}

    # Bind configuration {{{
    # It is better to use bash built-in bind instead of readline
    # even with conditional config inside readline '$if Bash'
    # because these command are executed when the keyseq is done
    # no matter whats already written in the current line
    # With readline, you'd have to resort to simply outputting the macro
    # to clear the line, type in the command, and enter

    bind -m vi -x '"\er": source $HOME/.bashrc; echo reloaded!'
    bind -m vi-insert -x '"\er": source $HOME/.bashrc; echo reloaded!'


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
# vim: ft=bash foldmethod=marker foldlevel=0
