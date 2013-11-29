#!/bin/bash

# Usage: ./mssqltopgsql.sh <mssql script name> > <pgsql script name>

for f in `ls *.sql`;
do
    sed -f mssqltopgsqlsed.txt $f > "pgsql_$f"
done

