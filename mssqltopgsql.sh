#!/bin/bash

#
# versi 2
#

# Usage: 
# versi 1: ./mssqltopgsql.sh <mssql script name> > <pgsql script name>
# versi 2: ./mssqltopgsql.sh

for f in `ls *.sql`;
do
    sed -f mssqltopgsqlsed.txt $f > "pgsql_$f"
done

