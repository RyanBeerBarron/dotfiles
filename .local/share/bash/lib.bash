function ll {
    ls -lh --color "$@" | pretty_ll
}

function pretty_ll {
  #
# Function to prettify the output of 'ls -lh'
# Setting the separator to '\\' to prevent files with a space in it to screw the 'column' command
# Assuming that 'ls -lh' won't output a backslash ever
# Could not use a ';' as a separator because the removes the color from ls, as escape code contain one
# Neither a ',' since the size value can contain one, e.g. "4,3M"
        awk '
        BEGIN {
            OFS = "\\"
            printf "PERMISSIONS\\LINKS\\OWNER\\GROUP\\SIZE\\MONTH\\DAY\\HH:MM/YEAR\\NAME\n"
        }
        /^total [0-9]+/ { next }
        NF <= 9 { $1 = $1; print }
        NF > 9 {
            for(i = 10; i <= NF; i++) {
                $9 = $9 " " $i
            }
            NF = 9;
            # \047 correspond to a single quote
            $9 = "\047" $9 "\047";
            print $0
        }' |
        column -t -s "\\"
}

function chcolor {
# TODO: Import the other themes for toml-style alacritty config
#       and change this to correctly change the colorscheme
# Function to modify the color of alacritty
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
        sed -i.bak "s/^colors: .*/colors: *${ARRAY[0]}/" $ALACRITTY_CONFIG
        return 0;
    fi
}

function glca {
    if [ $# -eq 1 ]
    then
        branch=HEAD;
    else
        branch=$2;
    fi
    git log --graph --oneline $1 $branch ^$(git merge-base $1 $branch)^
        # lca = "!f(){ if [ $# -eq 1 ]; then branch=HEAD; else branch=$2; fi; git log --graph --oneline $1 $branch ^$(git merge-base $1 $branch)^; }; f"
}

function git-find-parent-branch {
    git show-branch 2> /dev/null |
        sed "s/].*//" |
        grep "\*" |
        grep -v "$(git rev-parse --abbrev-ref HEAD)" |
        head -n1 |
        sed "s/^.*\[//"
}

function fn {
    if test -z $1; then
        nvim $BASH_LIBRARY_PATH
    elif test -x "$HOME/.local/scripts/$1"; then
        nvim "$HOME/.local/scripts/$1"
    else
        # Using grep with '-n' to find the line number of the bash function
        # Then using Bash parameter expansion with '%' to extract the line number
        # and passing it to neovim.
        # Neovim accepts a line number prefixed with '+' and will open the file at the line number
        # The parameter expansion uses '%' to remove a suffix, which matches the pattern ':*'
        local STRING=$(grep -n "^function $1" $BASH_LIBRARY_PATH/lib.bash);
        nvim $BASH_LIBRARY_PATH/lib.bash  +${STRING%:*} -c "foldopen" -c "normal zz"
    fi
}

function vis {
    sed -e "s/ /^S/g" -e "s/\t/^T/g" -e "s/\n/^N/g"
}

function _tmux-help_completion {
    if test -z "$TMUX_HELP_COMPLETION"; then
         TMUX_HELP_COMPLETION=$(MANWIDTH=160 man tmux |
                grep "^[[:space:]]\+[[:alnum:]-]\+\( \[-[[:alnum:]]\+\]\)\+" |
                trim |
                cut -d" " -f1)
    fi
    COMPREPLY=($(compgen -W "${TMUX_HELP_COMPLETION[*]}" -- "$2"))
}

function tmux-option {
    if test -n "$1"; then
    MANWIDTH=160 man tmux |
        sed -n "/^OPTIONS$/,/$SECTIONS/p" |
        sed -n "/^     $1/,/^     [[:alnum:]]\+/p" |
        head -n -1 |
        LESS=F less
    fi
}

function _tmux-option_completion {
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

function trim {
    sed "s/^[[:space:]]*\([[:graph:]].*[[:graph:]]\)[[:space:]]*$/\1/"
}

function dotfiles_sync {
    # `diff HEAD` checks in worktree and index for any uncommitted changes
    # `diff @{u}...HEAD` checks for any difference between upstream/remote and HEAD,
    # i.e. if there is any unpushed commits
    # They return 0 if there are no differences
    if ! (git -C $HOME diff --quiet HEAD && git -C $HOME diff --quiet @{u}...HEAD); then
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

function logout {
    # For 'logout' and 'exit', a function is required and this cannot be put inside '.bash_logout'
    # Once '.bash_logout' is executed by bash, we can not revert the end of process
    # Having a function is AFAIK the only known way to execute commands on bash's  exit
    # and potientally prevent or revert the exit process
    if test "$SHLVL" = 1 && shopt -q login_shell ; then
        if ! dotfiles_sync; then
            return 0
        fi
    fi
    unset -f logout
    logout
}

function exit {
    if test "$SHLVL" = 1 && shopt -q login_shell ; then
        if ! dotfiles_sync; then
            return 0
        fi
    fi
    unset -f exit
    exit
}

function shutdown {
    if test "$SHLVL" = 1; then
        if ! dotfiles_sync; then
            return 0
        fi
    fi
    command shutdown $@
}

comp_list_conf=$(find "$XDG_CONFIG_HOME" -maxdepth 1 -type d -exec basename {} \; ; echo "ssh bash dwm")
comp_list_fn=$(declare -F | cut -d" " -f3 | grep -v "^_.\+$"; find $HOME/.local/scripts/ -executable -type f -exec basename {} \;)
comp_list_setbackground=$(find $HOME/dotfiles/img -type f -exec basename {} \; ; echo "next"; echo "prev")

complete -W "$comp_list_conf" conf
complete -W "$comp_list_fn" fn
complete -W "$comp_list_setbackground" setbackground

function cd {
    command cd "$@";
    if test "$PWD" != "$OLDPWD"
    then
        jumplist_push
    fi
}
complete -W "list $(cut -d";" -f1 "${XDG_CONFIG_HOME:-$HOME/.config/}/themes")" chcolor

complete -F _tmux-help_completion tmux-help
complete -F _tmux-option_completion tmux-option

__git_complete glca _git_log
__git_complete gl_bb.bash _git_log
# vim: ft=bash foldexpr=FoldBashFunction(v\:lnum) foldlevel=0
