#!/bin/bash

# Define paths
SCRIPT_PATH="/usr/local/bin/scrolllock_monitor.sh"
SERVICE_PATH="/etc/systemd/system/scrolllock-monitor.service"

# Stop and disable the service
echo "Stopping and disabling scrolllock-monitor service..."
systemctl stop scrolllock-monitor.service
systemctl disable scrolllock-monitor.service

# Remove the script and service files
echo "Removing script and service files..."
rm -f $SCRIPT_PATH
rm -f $SERVICE_PATH

# Reload systemd to apply changes
systemctl daemon-reload
echo "Systemd daemon reloaded."

echo "Uninstallation complete."
