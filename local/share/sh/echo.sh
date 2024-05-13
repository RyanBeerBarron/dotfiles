while read var; do
    echo "$1: $var"
    sleep 0.0$(( RANDOM % 11 + 10 ))
done
