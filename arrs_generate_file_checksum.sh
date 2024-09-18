#!/bin/bash

if [ "$radarr_eventtype" != "Test" ] && [ "$sonarr_eventtype" != "Test" ]; then
    dst_file_path=${sonarr_episodefile_path:-${radarr_moviefile_path:-${1}}}

    if [ -n "$dst_file_path" ]; then
        if [ -r "$dst_file_path" ]; then
            echo "Hashing $dst_file_path ..." >&2
            checksum=$(sha512sum "$dst_file_path")
            sha_num_char=${#checksum}

            if [ $sha_num_char -gt 128 ]; then
                checksum=${checksum:0:128}
                echo "SHA512 $checksum" >&2
                sha_dir=$(dirname "$dst_file_path")
                sha_file=$(basename "$dst_file_path")
                echo "Creating $sha_dir/$sha_file.sha512 ..." >&2
                echo $checksum > "$sha_dir/$sha_file.sha512"
            fi
        else
            echo "File doesn't exist or is not readable $dst_file_path !" >&2
        fi
    else
        echo "File path is empty $dst_file_path !" >&2
    fi
fi