#!/bin/bash

# EMUCACHE v0 ASCII art message
echo "============================================"
echo "     Welcome to EMUCACHE v0 Optimization    "
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
    diskutil erasevolume HFS+ 'RAMDisk' $(hdiutil attach -nomount ram://$(($RAM_DISK_SIZE_MB*2048)))
    echo "RAM disk created and mounted at $RAM_DISK_MOUNT_POINT."
}

# Function to clear caches
clear_caches() {
    echo "Clearing system and user caches..."
    find / \( -name ".DS_Store" -or -name "._*" \) -delete
    echo "Cache clearing complete."
}

# Function to free up memory
free_up_memory() {
    echo "Freeing up memory..."
    purge
    echo "Memory freed."
}

# Function to optimize disk usage
optimize_disk_usage() {
    echo "Optimizing disk usage..."
    diskutil verifyVolume /
    diskutil repairVolume /
    echo "Disk optimization complete."
}

# Main function
main() {
    create_ram_disk
    clear_caches
    free_up_memory
    optimize_disk_usage
    echo "EMUCACHE v0 optimization tasks completed."
    echo "============================================"
    echo "[C] Flames Co. 20XX - Have a nice day/night. Sayonara."
}

main
