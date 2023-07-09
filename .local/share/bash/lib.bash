. $XDG_DATA_HOME/sh/man-pattern.sh
# . git-pattern.sh
. $XDG_DATA_HOME/sh/ANSI.sh

create_alacritty_link () {
    cd "$WHOME"/AppData/Roaming/alacritty
    # cmd.exe /c "del alacritty.yml & mklink alacritty.yml $(wslpath -w ~/.config/alacritty/alacritty.yml)" > /dev/null
    cp -f $HOME/.config/alacritty/alacritty.yml alacritty.yml
    cd - > /dev/null
}
export -f create_alacritty_link

colorscheme () {
    if [ "$1" == "list" ]; then
        awk 'BEGIN {FS=";"} {print $1}' ~/.config/themes;
        return;
    fi;
    if [ -z "$1" ]; then
        grep --color=auto ";CURRENT_COLORSCHEME" ~/.config/themes | cut --delimiter=";" --fields=1;
    else
        sed -i 's/;CURRENT_COLORSCHEME//' ~/.config/themes;
        sed -i "/$1/s/$/;CURRENT_COLORSCHEME/" ~/.config/themes;
        a=$(grep "$1" ~/.config/themes);
        b=$(echo $a | cut --delimiter=";" --fields=1);
        c=$(echo $a | cut --delimiter=";" --fields=2);
        d=$(echo $a | cut --delimiter=";" --fields=3);
        if [ ! -z "$c" ]; then
            sed -Ei "s/background = .*/background = '$c'/" ~/.config/nvim/after/plugin/colors.lua;
        fi;
        sed -i "s/colorscheme .*\(\")\|\]\]\)/colorscheme $b\1/" ~/.config/nvim/after/plugin/colors.lua;
        sed -i "s/^colors: \*.*/colors: *$b/" ~/.config/alacritty/alacritty.yml;
        BAT_THEME=$d;
        export BAT_THEME;
        create_alacritty_link;
    fi
}

start-session () {
    echo "starting session...";
    tmpfile=$(mktemp /tmp/start-session.script.XXXXXX);
    local dir=""
    for dir in $HOME/Work/* ; do
        for repo in $(find $dir -maxdepth 1 -type d); do
            if git -C "$repo" rev-parse 2> /dev/null; then
                git -C "$repo" worktree list | cut -d" " -f1 >> $tmpfile 2> /dev/null;
            else 
                echo "$repo" >> $tmpfile 2> /dev/null
            fi
        done;
    done;
    echo $HOME >> $tmpfile;
    TMUX_DIR=$(fzf <$tmpfile);
    if [ -z "$TMUX_DIR" ]; then
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

dotfiles () {
    if [ "$1" == "status" ]; then
        cd $HOME/dotfiles;
        git status;
        cd -;
        return 0;
    fi
    # TODO: Try for a rebase still approach
    # instead of removing '/home/ryan' and concatenating paths
    # rebase given pathname onto $HOME/dotfiles
    #
    # /----home/-----ryan/-----dotfiles/
    #                    \
    #                     path/----to/----file/
    if [ "$1" == "add" ] && [ -e $2 ]; then
        abs_path=$(get_absolute_path "$2")
        # cut -d/ -f4- is to remove '/home/#username/...' from the absolute path
        # 1st field is empty '^' just the start of the line
        # 2nd field is 'home'
        # 3rd field is '#username' 
        # Also append a '/' at the end of the dirname, useful for consistency
        dirname=$(echo "$(dirname $(readlink -f $2 | cut -d/ -f4-))/");
        # If the file is in home directory, i.e. dirname is "." after removing /home/#username/
        # replace it by the empty string, otherwise leave as is //TODO check for a better way to do this?
        # Since we appended a forward slash, we check for "./" 
        dirname=$( [ "$dirname" == "./" ] && echo "" || echo $dirname );
        basename=$(basename $(readlink -f $2 | cut -d/ -f4-));
        echo "dirname is: $dirname"
        echo "basename is: $basename"
        if [ -n "$dirname" ];
        then
            echo "mkdir -p $HOME/dotfiles/$dirname"
            mkdir -p $HOME/dotfiles/$dirname
        fi
        echo "cp $2 $HOME/dotfiles/$dirname"
        cp -f $2 $HOME/dotfiles/$dirname
        echo "rm $2"
        rm -f $2
        echo "ln -s $HOME/dotfiles/${dirname}$basename $2"
        ln -fs $HOME/dotfiles/${dirname}$basename $2
        unset basename
        unset dirname
        return 0
    fi
    echo "1st arg is: $1"
    echo "2nd arg is: $2"
    if [ "$1" == "remove" ] && [ -h $2 ]; then
        echo "hello"
        dirname=$(echo "$(dirname $(readlink -f $2 | cut -d/ -f4-))/");
        dirname=$( [ "$dirname" == "./" ] && echo "" || echo $dirname );
        basename=$(basename $(readlink -f $2 | cut -d/ -f4-));
        echo "dirname is: $dirname"
        echo "basename is: $basename"
        echo "testing for $HOME/dotfiles/$dirname$basename" 
        if [ -e $HOME/dotfiles/$dirname$basename ]; then
            rm $2
            mv $HOME/dotfiles/$dirname$basename $(dirname $2)
        fi
        return 0
    fi
}
get_absolute_path () {
    echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}
export -f __git_ps1

lf () {
    local USAGE="   
    lf - Last field
    File input needs to come from stdin, usually from a pipe
    Usage: 
        lf <delimiter>
"
    if test ${#1} -ne 1; then
        printf "$USAGE"
        return 1;
    fi
    rev | cut -d"$1" -f1 | rev
}
conf () {
    # echo "$XDG_CONFIG_HOME/$1/"*
    if test "$1" == "ssh"; then
        $EDITOR $HOME/.ssh/config
    else
        find "$XDG_CONFIG_HOME/$1/" -type f  | xargs $EDITOR
    fi
}
# auto complete for directories ("^d") and using last field which is the directory itself

_conf_comp () {
    local conf_dirs=$(ls -l "$XDG_CONFIG_HOME/" | grep "^d" | lf " ")
    conf_dirs+=" ssh"
    COMPREPLY=($(compgen -W "${conf_dirs[*]}" -- $2))
}
complete -F _conf_comp conf

fn () {
    if test -z $1; then
        nvim $HOME/scripts
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
    local fn_list=$(declare -F | cut -d" " -f3 | grep -v "^_.\+$" | lf " " )
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

tmux-help () {
    if test -z "$1"; then
        echo -e "usage: tmux-help ${STRIKETHROUGH}COMMAND${RESET}" >&2
        return 1;
    fi
     MANWIDTH=160 man tmux |
     sed -n "/^[[:space:]]\+$1\( \[-[[:alnum:]]\+\]\)/,/^[[:space:]]\+[[:alnum:]-]\+\( \[-[[:alnum:]]\+\]\)\+/p" |
     head -n -1 
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
