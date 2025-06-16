#!/bin/bash

SCRIPT_PATH="/usr/local/bin/scrolllock_monitor.sh"
SERVICE_PATH="/etc/systemd/system/scrolllock-monitor.service"

echo "Stopping and disabling scrolllock-monitor service..."
systemctl stop scrolllock-monitor.service
systemctl disable scrolllock-monitor.service

echo "Removing script and service files..."
rm -f $SCRIPT_PATH
rm -f $SERVICE_PATH

systemctl daemon-reload
echo "Systemd daemon reloaded."

echo "Uninstallation complete."
