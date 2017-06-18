HOST=$1
LOGIN=$2
DIR=$3

echo 
echo "Check if [$DIR] exists"
if [ ! -d "$DIR" ]; then
   echo "Directory doesn't exists. Trying to create it."
   mkdir $DIR
else
   echo "Directory exists. Continuing..."
fi
echo 

echo 
echo "Connecting to host $HOST..."
echo 

for d in $(psql -U $LOGIN -h $HOST -c "select datname from pg_database where datname not in ('template0', 'template1', 'rdsadmin', 'postgres') order by datname" -t) 
do
   echo "=== Generating dump for database [$d] ==="
   filename="$DIR/dump_${d}_$(date +"%y%m%d_%H%M%S")"
   dumpfile="${filename}.dmp"
   logfile="${filename}.log"
   pg_dump -v -Ft -h $HOST -U $LOGIN -d $d -f $dumpfile  >> $logfile
   echo
   echo
done
