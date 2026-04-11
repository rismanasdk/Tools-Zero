#!/usr/bin/env bash
# Ultra-fast credential manager using sqlite3

set -euo pipefail

CRED_DB="${1:=./credentials.db}"

# Initialize database
init_db() {
    sqlite3 "$CRED_DB" << 'SQL'
CREATE TABLE IF NOT EXISTS credentials (
    id INTEGER PRIMARY KEY,
    protocol TEXT,
    target TEXT,
    username TEXT,
    password TEXT,
    port INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_protocol ON credentials(protocol);
CREATE INDEX IF NOT EXISTS idx_target ON credentials(target);
SQL
}

# Add credential
add_cred() {
    local proto="$1" target="$2" user="$3" pass="$4"
    sqlite3 "$CRED_DB" <<SQL
INSERT INTO credentials (protocol, target, username, password) 
VALUES ('$proto', '$target', '$user', '$pass');
SQL
    echo "✓ Credential added for $proto://$target"
}

# List credentials by protocol
list_by_proto() {
    local proto="$1"
    sqlite3 "$CRED_DB" ".mode column" "SELECT id, target, username FROM credentials WHERE protocol='$proto';"
}

# List all credentials
list_all() {
    sqlite3 "$CRED_DB" ".mode column" "SELECT id, protocol, target, username FROM credentials;"
}

# Delete credential
delete_cred() {
    local id="$1"
    sqlite3 "$CRED_DB" "DELETE FROM credentials WHERE id=$id;"
    echo "✓ Credential $id deleted"
}

# Export to CSV
export_csv() {
    local file="${1:=creds.csv}"
    sqlite3 "$CRED_DB" <<SQL
.headers on
.mode csv
.output $file
SELECT protocol, target, username FROM credentials;
.output stdout
SQL
    echo "✓ Exported to $file"
}

init_db

case "${1:-}" in
    add) add_cred "$2" "$3" "$4" "$5" ;;
    list) list_all ;;
    list_proto) list_by_proto "$2" ;;
    delete) delete_cred "$2" ;;
    export) export_csv "${2:=creds.csv}" ;;
    init) init_db ;;
    *) echo "Usage: manager.sh {add|list|list_proto|delete|export|init} [args]" ;;
esac
