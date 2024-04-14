# vim: ft=bash fde=FoldBashFunction(v\:lnum)
#
# Ideas for improvement:
# *Can make the view prettier by formatting it a bit
#   - Shorten the path for long dirnames, by using the initials to the first few directory
#       /home/ryan/.local/share/Jetbrains/IntteliJIdea => /h/r/l/s/j/IntellijIdea
#   - Align the directories so that the scrolling looks smoother
#       (the current directory always appear at the same spot on the screen)
#
# * Allow for the user to configure this script
#   - Choose color when highlighting the current working directory
if ! test -v jumplist
then
    declare -ga jumplist
    declare -g jumplist_index=0 jumplist_view_leftboundary=0 jumplist_view_rightboundary=0
    jumplist[jumplist_index]="$PWD"
fi

function jumplist_push {
    local i
    let jumplist_index++
    jumplist[jumplist_index]="$PWD"
    let jumplist_view_rightboundary=jumplist_index
    jumplist_calculate_leftboundary
    for (( i = jumplist_index+1; i < ${#jumplist[@]}; i++ ))
    do
        unset jumplist[i]
    done
}

function jumplist_unset_vars {
    unset jumplist_view_active
}

function jumplist_print {
    if ! test -v "jumplist_view_active"
    then
        declare -g jumplist_view_active="on"
    else
        echo -ne "\x1b[1F"
        echo -ne "\x1b[2K"
    fi
    local i
    for ((  i = jumplist_view_leftboundary;
            i <= jumplist_view_rightboundary;
            i++ ))
    do
        if ((i == jumplist_index))
        then
            echo -ne "\x1b[30;46m${jumplist[i]}\x1b[39;49m"
        else
            echo -n "${jumplist[i]}"
        fi
        (( i < jumplist_view_rightboundary )) && echo -n "  "
    done
    echo ""
}

function jumplist_back {
    if (( jumplist_index <= 0 ))
    then
        echo "At bottom of jump history" >&2
        return
    fi
    let jumplist_index--
    if ((jumplist_index == jumplist_view_leftboundary  && jumplist_view_leftboundary != 0 ))
    then
        let jumplist_view_leftboundary--
        jumplist_calculate_rightboundary
    fi
    # FIXME: Handle case where directory was deleted
    command cd "${jumplist[jumplist_index]}" 2> /dev/null
    jumplist_print
}

function jumplist_forward {
    if (( jumplist_index >= ${#jumplist[@]}-1 ))
    then
        echo "At top of jump history" >&2
        return
    fi
    let jumplist_index++
    if ((jumplist_index == jumplist_view_rightboundary && jumplist_view_rightboundary != ${#jumplist[@]}-1 ))
    then
        let jumplist_view_rightboundary++
        jumplist_calculate_leftboundary
    fi
    # FIXME: Handle case where directory was deleted
    command cd "${jumplist[jumplist_index]}" 2> /dev/null
    jumplist_print
}

function jumplist_calculate_leftboundary {
    local i columns length len
    columns=$COLUMNS
    # echo "columns are $columns"
    # echo "right boundary at ${jumplist[$jumplist_view_rightboundary]} (${#jumplist[$jumplist_view_rightboundary]})"
    let length=${#jumplist[jumplist_view_rightboundary]}
    # echo "Length is $length and columns: $columns"
    (( i = jumplist_view_rightboundary - 1 ))
    (( len = ${#jumplist[i]} ))
    while (( length + len + 2 <= columns && i >= 0 ))
    do
        # echo "Adding $length + $len (${jumplist[i]}) + 2"
        let length+=len+2
        let i--
        (( len = ${#jumplist[i]} ))
    done
    let i++
    let jumplist_view_leftboundary=i
    # echo "length is $length new left boundary index is $jumplist_view_leftboundary"
}

function jumplist_calculate_rightboundary {
    local i columns length len
    columns=$COLUMNS
    # echo "columns are $columns"
    # echo "left boundary at ${jumplist[$jumplist_view_leftboundary]} (${#jumplist[$jumplist_view_leftboundary]})"
    let length=${#jumplist[jumplist_view_leftboundary]}
    (( i = jumplist_view_leftboundary + 1 ))
    (( len = ${#jumplist[i]} ))
    while (( length + len + 2 <= columns && i < ${#jumplist[@]} ))
    do
        # echo "Adding $length + ${#jumplist[i]} (${jumplist[i]}) + 2"
        let length+=len+2
        let i++
        (( len = ${#jumplist[i]} ))
    done
    let i--
    let jumplist_view_rightboundary=i
    # echo "length is $length new right boundary index is $jumplist_view_rightboundary"
}
