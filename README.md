# FileHashGuard
Bash scripts that will generate and verify sha512 files for data integrity monitoring. Custom scripts for Radarr &amp; Sonarr available.

# Example
Before using the script you have a file like this :
`/media/backup/Youtube/Channel_Roger_vlog_52.mp4`

After using the script, you will have a new file next to the original one :
`/media/backup/Youtube/Channel_Roger_vlog_52.mp4.sha512`

Inside of it is the sha512 hash. You can also use the script to verify the original files against their sha512 hashes.

# How to use the general script
In a console :
`$ ./video_checksum_generate_verify.sh /path_to_a_folder/`

You will have to choose between "v" or "g" :
`(v)erify or (g)enerate ?`

if you choose verify, the script will iterate over all the files found recursively in the provided folder with an extension ".sha512". It will
hash the original file and compare the result to the hash stored in the ".sha512".

if you choose generate, the script will generate the missing files '.sha512' for all the video files found recursively in the provided folder.

# How to setup the custom script on Sonarr or Radarr
Copy file "arrs_generate_file_checksum.sh" into your arrs folder. Make sure the file permissions and owner are correct, needs to have 'execute' permission.

Open Sonarr or Radarr, goto to "Settings / Connect", add a new connection "Custom Script", choose the "On Import" & "On Upgrade" notification triggers.
For the "Path" use the file "arrs_generate_file_checksum.sh" you copied, use the "Test" button to validate the script and then "Save".
