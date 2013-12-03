#!/bin/bash

#
# versi 2
#

# Usage: 
# versi 1: ./mssqltopgsql.sh <mssql script name> > <pgsql script name>
# versi 2: ./mssqltopgsql.sh

for f in `ls *.sql`;
do
    # hapus komentar dulu
    sed '/\/\*/d' $f > "tmp_$f"
    sed -e ':redo' -e 's/^\([^]]*\[[^] ]*\) /\1_/' -e 't redo' "tmp_$f" > "tmp__$f"
    sed 's/\//\_/g' "tmp__$f" > "tmp___$f"
    sed -f mssqltopgsqlsed.txt "tmp___$f" > "pgsql_$f"
done

rm tmp*
