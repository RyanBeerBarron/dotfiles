set -eu

session="Dotfiles"
window0="Config"

if tmux has-session -t "${session}"
then
    exit 0
fi

tmux new-session -d -c "${HOME}" -n "${window0}" -s "${session}"


{
    sleep 1
    tmux send-keys -t "${session}:${window0}.0" 'nvim' Enter
} &
