. $XDG_DATA_HOME/sh/man-pattern.sh
. $XDG_DATA_HOME/sh/ANSI.sh

# Should probably be a script instead of a function
# so I can use it with Perl / Python
# But only useful for WSL, so I will soon ditch this(?)
create_alacritty_link () {
    pushd "$WHOME"/AppData/Roaming/alacritty > /dev/null
    cp -f $XDG_CONFIG_HOME/alacritty/alacritty.yml alacritty.yml
    popd > /dev/null
}

# terminal config
tconf () {
    nvim ~/.config/alacritty/alacritty.yml
    create_alacritty_link
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
        # Can not use a pipe 'grep | mapfile' because pipe run each part in a subprocess
        # and so mapfile will create an array in a subprocess which is useless in a bash function
        mapfile -td";" ARRAY < <(grep "$1" $FILE);
        sed -i.bak "s/^colors: .*/colors: *${ARRAY[0]}/" $XDG_CONFIG_HOME/alacritty/alacritty.yml
        create_alacritty_link;
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


git_find_parent_branch () {
    git show-branch 2> /dev/null |
        sed "s/].*//" |
        grep "\*" |
        grep -v "$(git rev-parse --abbrev-ref HEAD)" |
        head -n1 |
        sed "s/^.*\[//" 
}

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
            create_alacritty_link
        done
    else
        sed -i "s/\([ \t]\)opacity: .*/\1opacity: $1/" $ALACRITTY_CONFIG;
        create_alacritty_link
    fi
}

# dotfiles () {
#     if [ "$1" == "status" ]; then
#         cd $HOME/dotfiles;
#         git status;
#         cd -;
#         return 0;
#     fi
#     # TODO: Try for a rebase still approach
#     # instead of removing '/home/ryan' and concatenating paths
#     # rebase given pathname onto $HOME/dotfiles
#     #
#     # /----home/-----ryan/-----dotfiles/
#     #                    \
#     #                     path/----to/----file/
#     if [ "$1" == "add" ] && [ -e $2 ]; then
#         abs_path=$(get_absolute_path "$2")
#         # cut -d/ -f4- is to remove '/home/#username/...' from the absolute path
#         # 1st field is empty '^' just the start of the line
#         # 2nd field is 'home'
#         # 3rd field is '#username' 
#         # Also append a '/' at the end of the dirname, useful for consistency
#         dirname=$(echo "$(dirname $(readlink -f $2 | cut -d/ -f4-))/");
#         # If the file is in home directory, i.e. dirname is "." after removing /home/#username/
#         # replace it by the empty string, otherwise leave as is //TODO check for a better way to do this?
#         # Since we appended a forward slash, we check for "./" 
#         dirname=$( [ "$dirname" == "./" ] && echo "" || echo $dirname );
#         basename=$(basename $(readlink -f $2 | cut -d/ -f4-));
#         echo "dirname is: $dirname"
#         echo "basename is: $basename"
#         if [ -n "$dirname" ];
#         then
#             echo "mkdir -p $HOME/dotfiles/$dirname"
#             mkdir -p $HOME/dotfiles/$dirname
#         fi
#         echo "cp $2 $HOME/dotfiles/$dirname"
#         cp -f $2 $HOME/dotfiles/$dirname
#         echo "rm $2"
#         rm -f $2
#         echo "ln -s $HOME/dotfiles/${dirname}$basename $2"
#         ln -fs $HOME/dotfiles/${dirname}$basename $2
#         unset basename
#         unset dirname
#         return 0
#     fi
#     echo "1st arg is: $1"
#     echo "2nd arg is: $2"
#     if [ "$1" == "remove" ] && [ -h $2 ]; then
#         echo "hello"
#         dirname=$(echo "$(dirname $(readlink -f $2 | cut -d/ -f4-))/");
#         dirname=$( [ "$dirname" == "./" ] && echo "" || echo $dirname );
#         basename=$(basename $(readlink -f $2 | cut -d/ -f4-));
#         echo "dirname is: $dirname"
#         echo "basename is: $basename"
#         echo "testing for $HOME/dotfiles/$dirname$basename" 
#         if [ -e $HOME/dotfiles/$dirname$basename ]; then
#             rm $2
#             mv $HOME/dotfiles/$dirname$basename $(dirname $2)
#         fi
#         return 0
#     fi
# }

abs_path () {
    echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}
export -f __git_ps1

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
    if test "$1" == "ssh"; then
        $EDITOR $HOME/.ssh/config
    else
        find "$XDG_CONFIG_HOME/$1/" -type f  | xargs $EDITOR
    fi
}

_conf_comp () {
    # auto complete for directories ("^d") and using last field which is the directory itself
    local conf_dirs=$(ls -l "$XDG_CONFIG_HOME/" | grep "^d" | lf " ")
    conf_dirs+=" ssh"
    COMPREPLY=($(compgen -W "${conf_dirs[*]}" -- $2))
}
complete -F _conf_comp conf

fn () {
    if test -z $1; then
        nvim $FUNCTION_HOME
    elif test -x "$HOME/.local/scripts/$1"; then
        nvim "$HOME/.local/scripts/$1"
    else
        # Using grep with '-n' to find the line number of the bash function
        # Then using Bash parameter expansion with '%' to extract the line number
        # and passing it to neovim.
        # Neovim accepts a line number prefixed with '+' and will open the file at the line number
        # The parameter expansion uses '%' to remove a suffix, which matches the pattern ':*'
        local STRING=$(grep -n "$1 ()" $FUNCTION_HOME/lib.bash);
        nvim $FUNCTION_HOME/lib.bash  +${STRING%:*}
    fi
}

_fn_comp () {
    local fn_list=$(declare -F | cut -d" " -f3 | grep -v "^_.\+$" )
    local script_list=$(find $HOME/.local/scripts/ -executable -type f -exec basename {} \;) 
    fn_list+=("${script_list[@]}")
    COMPREPLY=($(compgen -W "${fn_list[*]}" -- $2))
}
complete -F _fn_comp fn

idea () {
    local IDEA_PATH=$HOME/.local/share/JetBrains/Toolbox/scripts
    if test -z $IDEA_PID || ! ps -p $IDEA_PID > /dev/null; then
        nohup $IDEA_PATH/idea &> $IDEA_PATH/log.out &
        IDEA_PID=$!
        echo "starting IntelliJ..."
    else
        echo "already running with pid:" $IDEA_PID
    fi
}

curljson () {
    curl -s -w "\n%{http_code}" -H 'Content-type: application/json' $@ | jq
}

function opt () {
    man $1 | awk '{ print NR "\t" $0 }' | sed -n "/^[[:digit:]]\+\t[[:space:]]\+$2\($\|[[:space:]]\|,\)/,/^[[:digit:]]\+\t$/p"
}

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

function trim () {
    sed "s/^[[:space:]]*\([[:graph:]].*[[:graph:]]\)[[:space:]]*$/\1/"
}
export -f trim
 
 
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
    fi
}
 
# _fuzzy_cd () {
#     compopt -o filenames
#     if test -z "$2"; then
#         COMPREPLY=($(compgen -d -- ""));
#         return 0;
#     fi
#     local i=${#COMPREPLY[@]}
#     local prefix=$( dirname "$2" )
#     local suffix=$( basename "$2" ) 
#    local arr=$(compgen -d "$suffix")
#    local res=$?
#    echo -e "\nprefix and suffix are: $prefix / $suffix"
#    echo "the result is $res"
#    echo "arr is: ${arr[@]}"
#    echo "arr length is: ${#arr[@]}"
#    if test 1 -eq ${#arr[@]} && test $res -eq 0; then
#        echo "if succeed" 
#        COMPREPLY[i]="${arr[0]}"
#        return 0
#    fi
#     for path in $(compgen -d | fuzzy "$suffix"); do
#         echo "adding $path to reply"
#         COMPREPLY[i++]="$path"
#     done
# }
