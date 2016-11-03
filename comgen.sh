#!/bin/bash
if [ "$#" != 2 ]; then
  echo "Usage: ./comgen.sh input.c text.txt"
  echo "Also, please install figlet"
  echo "$#"
  exit
fi

echo "" > textdump.tmp
cat $2 | while read -n 1 i; do figlet $i' ' >> textdump.tmp; done

MAX=`awk 'length>max{max=length}END{print max}' textdump.tmp`

COLUMNAWK='
  { format = "/* %-" maxl "s */\n"
    while (getline line < "textdump.tmp")
      printf(format, line);
    close($1)
  }'

awk -v maxl="$MAX" "${COLUMNAWK}" textdump.tmp > textdump2.tmp

rm textdump.tmp
#awk 'BEGIN { while (getline < "textdump2.tmp") { f[$1] = $2; g[$1] = $3 } printf("/*%s*/UUUU %s WWW%s", $0, f[$1], g[$1]); }' "a.c"

AWK='
  {
   v = $1
   if (getline line < "textdump2.tmp") {
     printf("%s ", line);
   }
   printf("%s\n", v);}'

awk "${AWK}" $1 

rm textdump2.tmp
