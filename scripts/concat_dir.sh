#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

mkdir -p /data/video/backup
mkdir -p /data/video/tmp

dir="$1"

files=$(ls -1 $dir/results/videos/*unmuted*.mp4)

# Get the first filename as the output filename
output_file=$(echo "$files" | head -1)

# Create a temporary file list for FFmpeg input
temp_file_list=$(mktemp /data/video/tmpfile.XXXXXX)
temp_mp4=$(mktemp -p /data/video/tmp).mp4

while IFS= read -r line; do
  echo "file '$line'" >> "$temp_file_list"
done <<< "$files"

# Concatenate the files using FFmpeg
/usr/bin/ffmpeg -nostdin -f concat -safe 0 -i "$temp_file_list" -c copy $temp_mp4

# Check if FFmpeg succeeded
if [ $? -eq 0 ]; then
  # Delete the original input files
  while IFS= read -r line; do
    mv "$line" /data/video/backup
  done <<< "$files"

  mv $temp_mp4 $output_file
#  chown antmedia:antmedia $output_file
  echo "Concatenation complete. Output saved as $output_file."
else
  echo "FFmpeg failed to concatenate files."
fi

# Clean up temporary file list
rm -f "$temp_file_list"

exit 0
