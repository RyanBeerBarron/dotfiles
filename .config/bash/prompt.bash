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
    PS1+="\$(prompt \$? \\! \\W )\n"
    # echo "stoping timer" 
    unset timer_start
}

trap 'timer_start' DEBUG

PROMPT_COMMAND='echo_time'

export PS1
