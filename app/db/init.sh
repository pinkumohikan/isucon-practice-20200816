#!/bin/bash

ROOT_DIR=$(cd $(dirname $0)/..; pwd)
DB_DIR="$ROOT_DIR/db"
BENCH_DIR="$ROOT_DIR/bench"

export MYSQL_PWD=isucon

mysql -uisucon -h172.31.42.43 -e "DROP DATABASE IF EXISTS torb; CREATE DATABASE torb;"
mysql -uisucon -h172.31.42.43 torb < "$DB_DIR/schema.sql"

if [ ! -f "$DB_DIR/isucon8q-initial-dataset.sql.gz" ]; then
  echo "Run the following command beforehand." 1>&2
  echo "$ ( cd \"$BENCH_DIR\" && bin/gen-initial-dataset )" 1>&2
  exit 1
fi

mysql -uisucon -h172.31.42.43 torb -e 'ALTER TABLE reservations DROP KEY event_id_and_sheet_id_idx'
gzip -dc "$DB_DIR/isucon8q-initial-dataset.sql.gz" | mysql -uisucon -h172.31.42.43 torb
mysql -uisucon -h172.31.42.43 torb -e 'ALTER TABLE reservations ADD KEY event_id_and_sheet_id_idx (event_id, sheet_id)'
mysql -uisucon -h172.31.42.43 torb -e 'ALTER TABLE reservations ADD KEY (user_id)'
mysql -uisucon -h172.31.42.43 torb -e 'CREATE INDEX reservations_event_id_and_canceled_at_sheet_id_idx ON reservations (event_id,canceled_at,sheet_id)'
