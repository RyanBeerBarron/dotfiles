. $XDG_DATA_HOME/sh/man-pattern.sh
. $XDG_DATA_HOME/sh/ANSI.sh

ll () {
    {
        printf "PERMISSIONS,LINKS,OWNER,GROUP,SIZE,MONTH,DAY,HH:MM/YEAR,NAME\n";
        if test -z "$*"
        then set -- "."
        fi
        for ARGS do
            if test -f "$ARGS"
            then ls -l --color=always $ARGS
            elif test -d "$ARGS"
            then ls -l --color=always $ARGS | sed 1d
            fi
        done
     } |
        # Setting the separator to ',' to prevent files with a space in it to screw the 'column' command
        # Assuming that 'ls -l' won't output a comma ever
        # Could not use a ';' as a separator because the removes the color from ls, as escape code contain one
        awk 'BEGIN { OFS = "," } NF <= 9 { $1 = $1; print } NF > 9 { for(i = 10; i <= NF; i++) { $9 = $9 " " $i} NF = 9;  $9 = "\047" $9 "\047"; print $0 } '|
        column -t -s ","  
}

# Function to modify the color of alacritty
chcolor () {
    local FILE=${XDG_CONFIG_HOME:-$HOME/.config/}"/themes"
    if test "$1" = "list"; then
        cut -d';' -f1 $FILE;
        return 0;
    fi;
    if test -z "$1"; then
        sed -En 's/^([[:alnum:]]+);.*CURRENT/\1/p' $FILE;
        return 0;
    else
        sed -i.bak 's/;CURRENT.*//' $FILE;
        sed -i.bak "/$1/s/$/;CURRENT/" $FILE;
        # Can not use a pipe 'grep | mapfile' because with pipes, each part is a subprocess
        # and so mapfile will create an array in a subprocess which is useless in a bash function
        mapfile -td";" ARRAY < <(grep "$1" $FILE);
        sed -i.bak "s/^colors: .*/colors: *${ARRAY[0]}/" $XDG_CONFIG_HOME/alacritty/alacritty.yml
        return 0;
    fi
}
complete -W "list $(cut -d";" -f1 ${XDG_CONFIG_HOME:-$HOME/.config/}"/themes")" chcolor


start-session () {
    echo "starting session...";
    local TMPFILE=$(mktemp /tmp/start-session.script.XXXXXX);
    local DIR=""
    for DIR in $HOME/Work/* ; do
        for REPO in $(find $DIR -maxdepth 1 -type d); do
            if git -C "$REPO" rev-parse 2> /dev/null; then
                git -C "$REPO" worktree list | cut -d" " -f1 >> $TMPFILE 2> /dev/null;
            else
                echo "$REPO" >> $TMPFILE 2> /dev/null
            fi
        done;
    done;
    echo $HOME >> $TMPFILE;
    TMUX_DIR=$(sort $TMPFILE | uniq | fzf );
    if test -z "$TMUX_DIR"; then
        printf "No directory chosen, creating no session. Exiting...\n";
        return;
    fi;
    SESSION_NAME=$(basename $TMUX_DIR 2> /dev/null );
    create-session $SESSION_NAME $TMUX_DIR
}

create-session () {
    if test -z "$1"; then
        >2& printf "error, missing arguments, need session name and directory\n";
        return 1;
    fi
    if [ '' = "$TMUX" ]; then
        tmux new -A -s $1 -c $2;
    else
        tmux new -A -s $1 -c $2 -d &> /dev/null;
        tmux switch-client -t $1 &> /dev/null;
    fi
}

start-session-here () {
    echo "starting session here";
    create-session $(basename $PWD) $PWD;
}

glca () {
    if [ $# -eq 1 ]
    then
        branch=HEAD;
    else
        branch=$2;
    fi
    git log --graph --oneline $1 $branch ^$(git merge-base $1 $branch)^
        # lca = "!f(){ if [ $# -eq 1 ]; then branch=HEAD; else branch=$2; fi; git log --graph --oneline $1 $branch ^$(git merge-base $1 $branch)^; }; f"
}


git-find-parent-branch () {
    git show-branch 2> /dev/null |
        sed "s/].*//" |
        grep "\*" |
        grep -v "$(git rev-parse --abbrev-ref HEAD)" |
        head -n1 |
        sed "s/^.*\[//"
}

# Change opacity of Alacritty
opacity () {
    if test -z "$1"; then
        echo "Press '+' to increase opacity, '-' to reduce or 'q' to quit."
        local OPACITY=""
        while true
        do
            # Read first characters without delimiter or newline, silently (does not echo back to terminal)
            read -sn 1 OPACITY
            local OPC_VAL=$(sed -n "/opacity/ s/.*:[ \t]*//p" $ALACRITTY_CONFIG)
            local NEX_VAL=""
            case "$OPACITY" in
                +)
                    NEX_VAL=$(echo "$OPC_VAL + 0.1" | bc)
                    ;;
                -)
                    NEX_VAL=$(echo "$OPC_VAL - 0.1" | bc)
                    ;;
                q)
                    return 0;
                    ;;
                *)
                    # keep next value the same as current
                    NEX_VAL=$OPC_VAL
                    ;;
            esac
            sed -i "s/\([ \t]\)opacity: .*/\1opacity: $NEX_VAL/" $ALACRITTY_CONFIG;
        done
    else
        sed -i "s/\([ \t]\)opacity: .*/\1opacity: $1/" $ALACRITTY_CONFIG;
    fi
}

abs_path () {
    echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

# Last field
lf () {
    local USAGE="  
    lf - Last field
    File input needs to come from stdin, usually from a pipe
    Usage:
        lf <delimiter>
"
    # First argument should be a single char since it is passed to `cut`
    if test ${#1} -ne 1; then
        printf "$USAGE"
        return 1;
    fi
    rev | cut -d"$1" -f1 | rev
}

conf () {
    if test "$1" == "bash"; then
        $EDITOR $HOME/.bashrc $HOME/.bash_profile $HOME/.bash_logout
    elif test "$1" == "ssh"; then
        $EDITOR $HOME/.ssh/config
    else
        $EDITOR $(find "$XDG_CONFIG_HOME/$1/" -type f)
    fi
}

_conf_comp () {
    # auto complete for directories ("^d") and using last field which is the directory itself
    local conf_dirs=$(ls -l "$XDG_CONFIG_HOME/" | grep "^d" | lf " ")
    conf_dirs+=" ssh"
    conf_dirs+=" bash"
    COMPREPLY=($(compgen -W "${conf_dirs[*]}" -- $2))
}
complete -F _conf_comp conf

fn () {
    if test -z $1; then
        $EDITOR $FUNCTION_HOME
    elif test -x "$HOME/.local/scripts/$1"; then
        $EDITOR "$HOME/.local/scripts/$1"
    else
        # Using grep with '-n' to find the line number of the bash function
        # Then using Bash parameter expansion with '%' to extract the line number
        # and passing it to neovim.
        # Neovim accepts a line number prefixed with '+' and will open the file at the line number
        # The parameter expansion uses '%' to remove a suffix, which matches the pattern ':*'
        local STRING=$(grep -n "^$1 ()" $FUNCTION_HOME/lib.bash);
        $EDITOR $FUNCTION_HOME/lib.bash  +${STRING%:*}
    fi
}

_fn_comp () {
    local fn_list=$(declare -F | cut -d" " -f3 | grep -v "^_.\+$" )
    local script_list=$(find $HOME/.local/scripts/ -executable -type f -exec basename {} \;)
    fn_list+=("${script_list[@]}")
    COMPREPLY=($(compgen -W "${fn_list[*]}" -- $2))
}
complete -F _fn_comp fn

vis () {
    sed -e "s/ /^S/g" -e "s/\t/^T/g" -e "s/\n/^N/g"
}


_tmux-help_completion () {
    if test -z "$TMUX_HELP_COMPLETION"; then
         TMUX_HELP_COMPLETION=$(MANWIDTH=160 man tmux |
                grep "^[[:space:]]\+[[:alnum:]-]\+\( \[-[[:alnum:]]\+\]\)\+" |
                trim |
                cut -d" " -f1)
    fi
    COMPREPLY=($(compgen -W "${TMUX_HELP_COMPLETION[*]}" -- "$2"))
}
complete -F _tmux-help_completion tmux-help


tmux-option () {
    if test -n "$1"; then
    MANWIDTH=160 man tmux |
        sed -n "/^OPTIONS$/,/$SECTIONS/p" |
        sed -n "/^     $1/,/^     [[:alnum:]]\+/p" |
        head -n -1 |
        LESS=F less
    fi
}

_tmux-option_completion () {
    if test -z "$TMUX_OPTION_COMPLETION"; then
         TMUX_OPTION_COMPLETION=$(
         MANWIDTH=160 man tmux |
                sed -n "/^     Available $1 options are:/,/$SECTIONS/p" |
                sed -n "/^     [[:alnum:]]\+/p" |
                trim |
                cut -d" " -f1 |
                sort
            )
    fi
    COMPREPLY=($(compgen -W "${TMUX_OPTION_COMPLETION[*]}" -- "$2"))
    }
complete -F _tmux-option_completion tmux-option

trim () {
    sed "s/^[[:space:]]*\([[:graph:]].*[[:graph:]]\)[[:space:]]*$/\1/"
}
export -f trim

# Java version manager
jvm () {
    local USAGE="
    java version manager
      usage: jvm [version_number]
      Print current versions available on the path if version_number is not specified
      Otherwise will replace current jdk on the path to the one specified
      "
    if test -z $1; then
        grep -o "jdk-.." <<< $PATH
    elif test "$1" = "-h"; then
        echo "$USAGE"
    elif test $1 -gt 0; then
        export PATH=${PATH/jdk-??/jdk-$1}
        export JAVA_HOME=${JAVA_HOME/jdk-??/jdk-$1}
    fi
}

dotfiles_sync () {
    # `diff HEAD` checks in worktree and index for any uncommitted changes
    # `diff @{u}...HEAD` checks for any difference between upstream/remote and HEAD,
    # i.e. if there is any unpushed commits
    # They return 0 if there are no differences
    if ! (dotfiles diff --quiet HEAD && dotfiles diff --quiet @{u}...HEAD); then
        echo "Dotfiles repository is not clean, do you still wish to logout? [y/n]"
        read -p "> " ANS
        case $ANS in
            y*)
                return 0
                ;;
            n*)
                return 1
                ;;
        esac
    fi
    return 0;
}

# For 'logout' and 'exit', a function is required and this cannot be put inside '.bash_logout'
# Once '.bash_logout' is executed by bash, we can not revert the end of process
#
# Having a function is AFAIK the only known way to execute commands on bash's  exit
# and potientally prevent or revert the exit process
logout () {
    if test "$SHLVL" = 1 && shopt -q login_shell ; then
        if ! dotfiles_sync; then
            return 0
        fi
    fi
    unset -f logout
    logout
}

exit () {
    if test "$SHLVL" = 1 && shopt -q login_shell ; then
        if ! dotfiles_sync; then
            return 0
        fi
    fi
    unset -f exit
    exit
}

shutdown () {
    if test "$SHLVL" = 1; then
        if ! dotfiles_sync; then
            return 0
        fi
    fi
    command shutdown $@
}

environ () {
    cat /proc/$1/environ | tr '\0' '\n'
}

neovide () {
    if test -S /tmp/neovide; then
        # Removing the +[linenum] from the command arguments
        # and converting it to a 'remote-send' command
        for arg do
            shift
            if [[ "$arg" =~ \+([0-9]+) ]]; then
                local num=${BASH_REMATCH[1]}
                continue
            fi
            set -- "$@" "$arg"
        done
        nvim --server /tmp/neovide --remote $@
        nvim --server /tmp/neovide --remote-send "<Cmd>$num<CR>"
        wmctrl -xa neovide
    else
        command neovide --notabs -- --listen /tmp/neovide $@
    fi
}

# vim: ft=bash
