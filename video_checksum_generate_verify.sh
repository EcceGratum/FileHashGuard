#!/bin/bash

SEARCH_DIR=$1

# Check if the directory exists
if [ ! -d "$SEARCH_DIR" ]; then
    echo "Directory $SEARCH_DIR does not exist."
    exit 1
fi

# Specify the file extensions you want to search for
FILE_EXTENSIONS=("avi" "mp4" "m4v" "mkv" "webm" "flv" "ogg")

# verify of generate ?
while true; do
    echo "(v)erify or (g)enerate ?"
    read mode

    if [[ "$mode" == "v" || "$mode" == "g" ]]; then
        break
    fi
done

generate_sha512() {
    local filepath="$1"

    # check presence of sha512 file
    sha_dir=$(dirname "$filepath")
    sha_file=$(basename "$filepath")
    if [ -f "$sha_dir/$sha_file.sha512" ]; then
        echo "Already exists $sha_file.sha512"
    else
        echo "Hashing $filepath ..."
        checksum=$(sha512sum "$filepath")
        sha_num_char=${#checksum}

        if [ $sha_num_char -gt 128 ]; then
            checksum=${checksum:0:128}
            echo "SHA512 $checksum"
            echo "Creating $sha_dir/$sha_file.sha512 ..."
            echo $checksum > "$sha_dir/$sha_file.sha512"
        fi
    fi
}

verify_sha512() {
    local filepath="$1"

    # check presence of original file
    ori_file="${filepath%.*}"
    if [ -f "$ori_file" ]; then
        # load sha512 from file
        sha512=$(< "$filepath")
        checksum=$(sha512sum "$ori_file")
        sha_num_char=${#checksum}
        if [ $sha_num_char -gt 128 ]; then
            checksum=${checksum:0:128}
            if [[ $sha512 == $checksum ]]; then
                echo "OK $ori_file"
            else
                echo "FAIL $ori_file $sha512 vs $checksum"
            fi
        else
            echo "ERROR while hashing $ori_file -> Hash: $checksum"
        fi
    else
        echo "A sha512 checksum file exists for $ori_file but that file  missing from disk !"
    fi
}


if [[ "$mode" == "g" ]]; then
    for ext in "${FILE_EXTENSIONS[@]}"; do
        # Use find to locate all files and iterate over them
        find "$SEARCH_DIR" -type f -name "*.$ext" | while read -r filepath; do
            generate_sha512 "$filepath"
        done
    done
fi


if [[ "$mode" == "v" ]]; then
    for ext in "sha512"; do
        # Use find to locate all files and iterate over them
        find "$SEARCH_DIR" -type f -name "*.$ext" | while read -r filepath; do
            verify_sha512 "$filepath"
        done
    done
fi