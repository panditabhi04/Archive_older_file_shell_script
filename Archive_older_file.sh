#!/bin/bash

directory="/d/Predec/Notes/CPP"
max_size_mb=1
max_age_days=10

archive_folder="$directory/archive"
mkdir -p "$archive_folder"

current_date=$(date +"%Y-%m-%d")
for file in "$directory"/*; do
    if [ -f "$file" ]; then
        # Check file size
        file_size=$(du -m "$file" | awk '{print $1}')
        if [ "$file_size" -gt "$max_size_mb" ]; then
            # Compress and move the file to the archive folder
            gzip "$file"
            mv "$file.gz" "$archive_folder"
        fi

        # Check file age
        modified_date=$(stat -c %Y "$file")
        days_diff=$(( (current_date - modified_date) / 86400 ))
        if [ "$days_diff" -gt "$max_age_days" ]; then
            # Compress and move the file to the archive folder
            gzip "$file"
            mv "$file.gz" "$archive_folder"
        fi
    fi
done