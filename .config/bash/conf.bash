### ENV VAR
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export HISTFILE="$XDG_STATE_HOME/bash/history"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export ALACRITTY_CONFIG="$XDG_CONFIG_HOME/alacritty/alacritty.yml"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/pythonstartup.py
export M2_HOME="$HOME/.local/apache-maven-3.9.0"
export JAVA_HOME=$HOME/.local/jdks/jdk-17
export M2=$M2_HOME/bin
export POWER="/sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0004:00/PNP0C0A:00/power_supply/BAT1/capacity"
export FUNCTION_HOME=$XDG_DATA_HOME/bash

export LESS="FgMrRS j.25 --mouse"

export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"

DB_SBOFF="-h localhost -p 63333 -U shippingbof shippingbof"
PATH=""
PATH=$PATH:"/usr/local/bin:/usr/bin:/bin"
PATH=$PATH:"/usr/local/sbin:/usr/sbin:/sbin"
PATH="$CARGO_HOME/bin":$PATH
PATH="$HOME/.local/bin":$PATH
PATH="$HOME/.local/scripts":$PATH
PATH=$M2:$PATH
PATH=$JAVA_HOME/bin:$PATH
PATH=$PATH:/usr/games
export PATH

if test -n "$TMUX"; then
    export NVIM_LISTEN_ADDRESS=/tmp/nvim_${USER}_$(tmux display -p "#{window_id}")
fi

### ALIASES
alias ls='ls -tX'
alias ll=' { printf "PERM LINKS OWNER GROUP SIZE MONTH DAY HH:MM/YEAR NAME\n" ; ls -l --color=always -tX | sed 1d; } | column -t '
alias la='ls -A'
alias l='ls -CF'
alias colo='colorscheme'
alias info="info --vi-keys"
alias gdb="gdb -q -tui"
alias inix="ssh -N gate_eu -f "
alias diff="colordiff"
alias welcome="echo hello world"

DIRCOLORS="$XDG_CONFIG_HOME"/dircolors
if [ -x "$DIRCOLORS" ]; then
    test -r "$DIRCOLORS" && eval "$(dircolors -b $DIRCOLORS)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -tX'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

### bind configuration 
# It is better to use bash built-in bind instead of readline
# even with conditional config inside readline '$if Bash'
# because these command are executed when the keyseq is done
# no matter whats already written in the current line
# With readline, you'd have to resort to simply outputting the macro 
# to clear the line, type in the command, and enter
bind -m vi -x '"\C-a": source $HOME/.bashrc'
bind -m vi-insert -x '"\C-a": source $HOME/.bashrc'

bind -m vi -x '":": tmux command-prompt'

bind -m vi-insert -x '"\C-e": start-session-here'
bind -m vi -x '"\C-e": start-session-here'

bind -m vi -x '"\C-n": start-session'
bind -m vi-insert -x '"\C-n": start-session'


### Shell options
shopt -s \
    autocd \
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
    progcomp_alias \

set -o ignoreeof
     
### WSL specific config
if grep -i Microsoft /proc/version > /dev/null && test -z "$WHOME"; then
	export WHOME=$(wslpath "$(wslvar USERPROFILE)")
	alias cdw='cd "$WHOME"'
    export DISPLAY=$(ip route list default | awk '{print $3}'):0
    export LIBGL_ALWAYS_INDIRECT=0
fi
