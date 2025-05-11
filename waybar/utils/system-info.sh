#!/bin/bash

# Create a temporary string to build our output
output=""

# Retrieve CPU details
cpu_name=$(lscpu | grep "Model name" | sed 's/Model name: *//' | grep -oE '[0-9]{4}[A-Z]')
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
cpu_temp=$(sensors | grep "CPU" | awk '{print $2}' | sed 's/+//; s/°C//')

# Remove decimal from CPU temperature (optional step if you want integers)
cpu_temp=$(echo $cpu_temp | sed 's/\.[0-9]//g')

# Add CPU details to output
output+=$(printf "AMD %-10s | %5.1f%% | %3s°C" "$cpu_name" "$cpu_usage" "$cpu_temp")

# Retrieve GPU details
gpus=$(nvidia-smi --query-gpu=gpu_name,utilization.gpu,temperature.gpu --format=csv,noheader,nounits)

# Process GPU details
while IFS=',' read -r gpu_name gpu_util gpu_temp; do
    formatted_name=$(echo "$gpu_name" | grep -oE '[0-9]{4} SUPER?')
    
    # Trim whitespace from values
    gpu_util=$(echo "$gpu_util" | xargs)
    gpu_temp=$(echo "$gpu_temp" | xargs)

    # Add GPU information to output with proper newline
    output+=$(printf "\n%-14s | %5s%% | %3s°C" "$formatted_name" "$gpu_util" "$gpu_temp")
done <<< "$gpus"

# Output as JSON for waybar
tooltip_text=$(echo "$output" | sed ':a;N;$!ba;s/\n/\\n/g')
echo "{\"text\":\"\", \"tooltip\":\"$tooltip_text\"}"