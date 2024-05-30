

# TODO: Write a comment for this function with expected arguments
function contains () {
    declare -n array="$1"
    local val="$2"

    for item in "${array[@]}"
    do
        if test "$val" = "$item"
        then
            # echo "match found"
            return 0
        fi
    done
    return 1
}
