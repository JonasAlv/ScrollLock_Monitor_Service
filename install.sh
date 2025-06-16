#!/bin/bash
echo "setting directories for script and service"
SCRIPT_PATH="/usr/local/bin/scrolllock_monitor.sh"
SERVICE_PATH="/etc/systemd/system/scrolllock-monitor.service"

echo "Creating scrolllock monitor script at $SCRIPT_PATH..."
cat << 'EOF' > $SCRIPT_PATH
#!/bin/bash

monitor_brightness() {
    while true; do
        for brightness_file in /sys/class/leds/input*::scrolllock/brightness; do
            # If the brightness is 0, set it to 1
            if [[ $(cat "$brightness_file") -eq 0 ]]; then
                echo 1 | sudo tee "$brightness_file" > /dev/null
            fi
        done
        sleep 2  #adjust sleep time for cpu usage
    done
}


monitor_brightness
EOF

chmod +x $SCRIPT_PATH
echo "Script created and set as executable."

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

systemctl daemon-reload
echo "Systemd daemon reloaded."

systemctl enable scrolllock-monitor.service
systemctl start scrolllock-monitor.service
echo "Scrolllock monitor service enabled and started."

echo "Installation complete."
