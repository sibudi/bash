#!/bin/bash

#
# versi 2
#

#
# Usage: 
# versi 1: ./mssqltopgsql.sh <mssql script name> > <pgsql script name>
# versi 2: ./mssqltopgsql.sh
#

for f in `ls *.sql`;
do
    # hapus komentar
    sed '/\/\*/d' $f > "tmp_$f"

    # ganti spasi dengan underscore
    sed -e ':redo' -e 's/^\([^]]*\[[^] ]*\) /\1_/' -e 't redo' "tmp_$f" > "tmp__$f"
    
    # ganti garis miring dengan underscore
    sed 's/\//\_/g' "tmp__$f" > "tmp___$f"

    # jalankan operasi sed yang lain
    sed -f mssqltopgsqlsed.txt "tmp___$f" > "pgsql_$f"
done

rm tmp*
