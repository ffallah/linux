#!/bin/bash

# Directory containing log files
log_dir="/data/video/recordings/log"

# Check if there are any .log files containing 'nvidia-smi'
if grep -q "nvidia-smi" "$log_dir"/*.log; then
    echo "Found 'nvidia-smi' in one or more log files."

    sudo -u tno /home/tno/bin/boot_ssa.sh
    /usr/bin/curl -s "https://api.telegram.org/bot308096639:AAESsT1NbR1mRJT3s7zjjYPw-Hndy7LrdHM/sendMessage?chat_id=177295964&text=$HOSTNAME" > /dev/null

else
    echo "No logs contain 'nvidia-smi'."
fi
