#!/bin/bash

# ASCII Art Message for EMUCACHE v0
echo "============================================"
echo " Welcome to EMUCACHE v0 Optimization "
echo "============================================"

# Set timer to 3 seconds
echo "Initializing EMUCACHE v0..."
sleep 3

# Detect RAM size in MB
if [[ "$OSTYPE" == "darwin"* ]]; then
    RAM_SIZE_MB=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024)}')
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    RAM_SIZE_MB=$(free -m | awk '/^Mem:/{print $2}')
else
    echo "Unsupported operating system."
    exit 1
fi

# Set RAM disk size to half of RAM size
RAM_DISK_SIZE_MB=$((RAM_SIZE_MB/2))

# Define RAM disk mount point
RAM_DISK_MOUNT_POINT="/mnt/ramdisk"

# Function to create and mount RAM disk
create_ram_disk() {
    echo "Creating RAM disk..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        diskutil erasevolume HFS+ 'RAMDisk' $(hdiutil attach -nomount ram://$(($RAM_DISK_SIZE_MB*2048)))
        echo "RAM disk created and mounted at $RAM_DISK_MOUNT_POINT."
    else
        echo "RAM disk creation not supported on this OS."
    fi
}

# Function to clear system and user caches
clear_caches() {
    echo "Clearing system and user caches..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        find / -name ".DS_Store" -or -name "._*" -exec rm -f {} \;
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        rm -rf ~/.cache/*
    fi
    echo "Cache clearing complete."
}

# Function to free up memory
free_up_memory() {
    echo "Freeing up memory..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        purge
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sync && echo 3 > /proc/sys/vm/drop_caches
    fi
    echo "Memory freed."
}

# Function to optimize disk usage
optimize_disk_usage() {
    echo "Optimizing disk usage..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        diskutil verifyVolume /
        diskutil repairVolume /
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo fsck -Af
    fi
    echo "Disk optimization complete."
}

# Function for dynamic prompt
dynamic_prompt() {
    echo "Would you like to perform additional optimizations? (yes/no)"
    read response
    if [[ "$response" == "yes" ]]; then
        echo "Proceeding with extra optimization tasks..."
        # Add more custom optimization commands here
    else
        echo "Skipping additional optimizations."
    fi
}

# Main function to run all tasks
main() {
    create_ram_disk
    clear_caches
    free_up_memory
    optimize_disk_usage
    dynamic_prompt
    echo "EMUCACHE v0 optimization tasks completed."
    echo "============================================"
    echo "[C] Flames Co. 20XX - Have a nice day/night. Sayonara."
}

# Run main
main
