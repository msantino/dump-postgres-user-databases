HOST=$1
LOGIN=$2
DIR=$3

usage(){
    echo 
    echo "Script to dump all user databases on PostgreSQL instance."
    echo "Usage: $0 your-host login-name path-to-dumps"
    echo 
    echo "This script requires .pgpass configured. See https://www.postgresql.org/docs/9.6/static/libpq-pgpass.html for details."
    echo 
    exit 1
}

log() {
   echo $1 >> $2
}

debug() {
  echo $1
}

dump(){
  local db=$1 dumpfile=$2 logfile=$3
  pg_dump -v -Ft -h $HOST -U $LOGIN -d $db -f $dumpfile  >> $logfile 2>&1
}

# invoke  usage
# call usage() function if filename not supplied
[[ $# -eq 0 ]] && usage

# Start script actions
debug 
debug "Check if [$DIR] exists"
if [ ! -d "$DIR" ]; then
   debug "Directory doesn't exists. Trying to create it."
   mkdir $DIR
else
   debug "Directory exists. Continuing..."
fi
debug 

debug 
debug "Connecting to host $HOST..."
debug 

for d in $(psql -U $LOGIN -h $HOST -c "select datname from pg_database where datname not in ('template0', 'template1', 'rdsadmin', 'postgres') order by datname" -t) 
do
   # Database variables
   filename="$DIR/dump_${d}_$(date +"%y%m%d_%H%M%S")"
   dumpfile="${filename}.dmp"
   logfile="${filename}.log"

   log "=== Starting dump for database [$d] at $(date +"%y-%m-%d %H:%M:%S") ===" $logfile
   dump $d $dumpfile $logfile
   log "=== Finished dump for database [$d] at $(date +"%y-%m-%d %H:%M:%S") ===" $logfile

   debug "- ${d}: OK"
done

