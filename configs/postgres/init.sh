#!/usr/bin/bash

set -e
set -u

function create_database_grant_privilege() {
        local database=$1
        echo "  Creating database '$database' and granting privileges to '$POSTGRESQL_USERNAME'"
        psql -v ON_ERROR_STOP=1 --username "$POSTGRESQL_USERNAME" <<-EOSQL
            CREATE DATABASE $database;
            GRANT ALL PRIVILEGES ON DATABASE $database TO $POSTGRESQL_USERNAME;
EOSQL
}

if [ -n "$POSTGRESQL_ADDITIONAL_DATABASES" ]; then
        echo "Multiple database creation requested: $POSTGRESQL_ADDITIONAL_DATABASES"
        for db in $(echo $POSTGRESQL_ADDITIONAL_DATABASES | tr ',' ' '); do
                create_database_grant_privilege $db
        done
        echo "Multiple databases created"
fi