#!/bin/bash

# Define paths
SCRIPT_PATH="/usr/local/bin/scrolllock_monitor.sh"
SERVICE_PATH="/etc/systemd/system/scrolllock-monitor.service"

# Create the monitoring script
echo "Creating scrolllock monitor script at $SCRIPT_PATH..."
cat << 'EOF' > $SCRIPT_PATH
#!/bin/bash

# Function to monitor brightness and set it to 1 if it changes to 0
monitor_brightness() {
    while true; do
        for brightness_file in /sys/class/leds/input*::scrolllock/brightness; do
            # If the brightness is 0, set it to 1
            if [[ $(cat "$brightness_file") -eq 0 ]]; then
                echo 1 | sudo tee "$brightness_file" > /dev/null
            fi
        done
        sleep 2  # Adjust the sleep time to reduce CPU usage
    done
}

# Start monitoring
monitor_brightness
EOF

# Make the script executable
chmod +x $SCRIPT_PATH
echo "Script created and set as executable."

# Create the systemd service file
echo "Creating systemd service file at $SERVICE_PATH..."
cat << EOF > $SERVICE_PATH
[Unit]
Description=Scroll Lock Monitor Service
After=multi-user.target

[Service]
ExecStart=$SCRIPT_PATH
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to apply changes
systemctl daemon-reload
echo "Systemd daemon reloaded."

# Enable and start the service
systemctl enable scrolllock-monitor.service
systemctl start scrolllock-monitor.service
echo "Scrolllock monitor service enabled and started."

echo "Installation complete."
