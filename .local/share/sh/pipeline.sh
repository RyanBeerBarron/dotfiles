{ sleep 1; echo "hello from one" >&2; sleep 2; echo -e "this\nis\nmy\nstring"; } |
{ echo "hello from two" >&2; sleep 1; echo "this is two after the sleep" >&2 ; read -d '' var; echo -e "this is from two: $var"; } |
{ echo "hello from three"; read -d '' var; echo -e "this is from three: $var"; }
