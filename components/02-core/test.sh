DB_HOST_NAME="hello"
DB_USER="this is a"
DB_READER_USER="challenge"
DB_NAME="test test test test test"

echo "sql "sslmode=require host=${DB_HOST_NAME// /\ } port=5432 dbname=${DB_NAME// /\ } user=${DB_USER// /\ }" -c "${SQL_COMMAND}"
"