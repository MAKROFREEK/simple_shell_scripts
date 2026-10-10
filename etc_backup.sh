#!/bin/bash

# Configuration
SOURCE_ETC="/etc/"
SOURCE_DB="/var/lib/pve-cluster/config.db"
BACKUP_DIR="/mnt/usb-backups/etc-backups"
DEST="$BACKUP_DIR/$(date +%Y-%m-%d)"

# Ensure the backup directory exists and isn't root
if [ -d "$BACKUP_DIR" ] && [ "$BACKUP_DIR" != "/" ]; then
    echo "Clearing old backups in $BACKUP_DIR..."
    rm -rf "${BACKUP_DIR:?}"/*
else
    echo "Error: Backup directory not found or invalid!"
    exit 1
fi

# Create destination directory for today
mkdir -p "$DEST"

# Backup the Entire /etc folder)
rsync -av --delete "$SOURCE_ETC" "$DEST/etc-folder/"

# Backup the database)
cp "$SOURCE_DB" "$DEST/"

echo "Backup completed to $DEST"
