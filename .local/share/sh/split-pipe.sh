{ echo -e "first line\nsecond line\nthird line\nfourth line\nfifth line\nsixth line\nseventh line\neigth line\nnineth line\ntenth line\neleventh line\ntwelveth line"; } |
{ . echo.sh "first echo" & . echo.sh "second echo" & } |
{ while read var; do echo "var from last pipe: $var"; done; }

