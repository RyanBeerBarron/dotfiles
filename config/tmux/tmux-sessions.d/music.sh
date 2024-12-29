set -eu

session="Music"

window0="lf"

if tmux has-session -t "${session}"
then
    exit 0
fi

tmux new-session -d -n "${window0}" -s "${session}"

{
    sleep 1
    tmux send-keys -t "${session}:${window0}" 'lf' Enter
    tmux send-keys -t "${session}:${window0}" ':mu' Enter
} &
