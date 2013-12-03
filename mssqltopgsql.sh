#!/bin/bash

#
# versi 2
#

# Usage: 
# versi 1: ./mssqltopgsql.sh <mssql script name> > <pgsql script name>
# versi 2: ./mssqltopgsql.sh

for f in `ls *.sql`;
do
    sed -e ':redo' -e 's/^\([^]]*\[[^] ]*\) /\1_/' -e 't redo' $f > "tmp_$f"
    sed 's/^[a-zA-Z0-9]/\_/g' "tmp_$f" > "tmp__$f"
done

for f in `ls tmp__*`;
do
    sed -f mssqltopgsqlsed.txt $f > "pgsql_$f"
done

rm tmp*
