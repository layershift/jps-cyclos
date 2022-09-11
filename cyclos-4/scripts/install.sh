#!/bin/bash

_USER="$1"
_DBNAME="$2"
_PASSWORD="$3"
_DUMP_URL="https://github.com/jelastic-jps/cyclos/raw/master/cyclos-4/dumps/dump.sql"
_HOME_DIRECTORY="/var/lib/jelastic/bin/"

wget=`which wget`
psql=`which psql`
sed=`which sed`

cd ${_HOME_DIRECTORY}

PGPASSWORD=$4;
export PGPASSWORD;

$psql postgres webadmin << EOF
     CREATE USER ${_USER} WITH PASSWORD '${_PASSWORD}';
     CREATE DATABASE ${_DBNAME} ENCODING 'UTF-8' TEMPLATE template0 OWNER ${_USER};
     \c cyclos4;
     create extension cube;
     create extension earthdistance;
     create extension postgis;
     create extension unaccent;
     create extension pgcrypto;
EOF
 
#$wget "${_DUMP_URL}" -O dump.sql;
#$psql ${_DBNAME} webadmin < dump.sql;
#$psql ${_DBNAME} webadmin << EOF
#     update id_cipher_rounds set
#	mask = (random() * 9999999999999)::bigint * case when random() < 0.5 then 1 else -1 end,
#        rotate_bits = (random() * 62)::int + 1;
#EOF


echo -e  "# IMPORTANT NOTE! \n# Please make sure there is a blank line after the last cronjob entry.\n\n" | crontab -;

unset PGPASSWORD;
