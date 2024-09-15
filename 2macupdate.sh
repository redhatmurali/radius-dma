#!/bin/bash

# Variables
NEW_MAC="00:00:5A:74:FD:29" # Replace with the desired new MAC address

# Automatically detect the active network interface
INTERFACE=$(ip -o link show | awk -F': ' '$2 !~ /lo/ {print $2}' | head -n 1)

# Check if an interface was found
if [ -z "$INTERFACE" ]; then
    echo "Error: No active network interface found."
    exit 1
fi

echo "Detected active network interface: $INTERFACE"

# Bring down the network interface
ip link set dev $INTERFACE down

# Set the new MAC address
ip link set dev $INTERFACE address $NEW_MAC

# Bring up the network interface
ip link set dev $INTERFACE up

# Restart the network service
systemctl restart network

# Show the new MAC address
ip addr show $INTERFACE | grep "link/ether"

echo "MAC address for $INTERFACE updated to $NEW_MAC."
