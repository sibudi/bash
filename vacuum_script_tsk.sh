###Change DBNAME to existing DB

#!/bin/bash
vDATE=`date '+%Y%m%d%H%M%s'`
vPGHBABCK="pg_hba.conf.${vDATE}"

echo "Backup file pg_hba.conf : ${vPGHBABCK}"

. /home/gpadmin/.bashrc
. /usr/local/greenplum-db/greenplum_path.sh
echo "Started at `date`"
echo "[INFO]: Go to MASTER_DATA_DIRECTORY"
cd /data/master/gpseg-1
echo " "
echo " "
echo "[INFO]: Backup current pg_hba.conf"
cp pg_hba.conf ${vPGHBABCK}
echo " "
echo " "
echo "[INFO]: Copying block pg_hba.conf as current"
cp pg_hba.conf.block pg_hba.conf
echo " "
echo " "
echo "[INFO]: Stopping database..."
gpstop -af
echo " "
echo " "
echo "[INFO]: Starting database...."
gpstart -a
echo " "
echo " "
echo "[INFO]: VACUUM Operation on system catalog tables"
echo "[INFO]: Check system tables size before vacuum"
psql -d pdwh -c "SELECT relname,pg_size_pretty(pg_relation_size(relname)) FROM pg_class a,pg_namespace b WHERE a.relnamespace=b.oid and b.nspname= 'pg_catalog' and a.relkind='r' ORDER BY pg_relation_size(relname) DESC;"
echo " "
echo " "
echo "[INFO]: Start Vacuum at `date`"
DBNAME="pdwh"
VCOMMAND="VACUUM FULL ANALYZE"
psql -tc "select '$VCOMMAND' || ' pg_catalog.' || relname || ';' from pg_class a,pg_namespace b where a.relnamespace=b.oid and b.nspname= 'pg_catalog' and a.relkind='r'" $DBNAME | psql -a $DBNAME
echo " "
echo " "
echo "[INFO]: Finished Vacuum at `date`"
echo "[INFO]: Check system tables size after vacuum"
echo " "
psql -d pdwh -c "SELECT relname,pg_size_pretty(pg_relation_size(relname)) FROM pg_class a,pg_namespace b WHERE a.relnamespace=b.oid and b.nspname= 'pg_catalog' and a.relkind='r' ORDER BY pg_relation_size(relname) DESC;"
echo " "
echo " "
echo "[INFO]: Reindex System Catalogs"
echo "[INFO]: Reindex started at `date`"
reindexdb -s
VCOMMAND="ANALYZE"
psql -tc "select '$VCOMMAND' || ' pg_catalog.' || relname || ';' from pg_class a,pg_namespace b where a.relnamespace=b.oid and b.nspname= 'pg_catalog' and a.relkind='r'" $DBNAME | psql -a $DBNAME
echo " "
echo " "
echo "[INFO]: Copy back current pg_hba.conf"
cp ${vPGHBABCK} pg_hba.conf
echo " "
echo " "
echo "[INFO]: Reload config...."
gpstop -u
echo "Ended at `date`"
