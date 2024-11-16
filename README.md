# ScrollLock  Service
A systemd service that monitors the brightness of the Scroll Lock LED and ensures it remains turned on by setting the value inside the file `/sys/class/leds/inputX::scrolllock/brightness` to 1 whenever it changes back to 0. This is designed to work with any inputX::scrolllock device.
<br/><br/>
This is made mainly to turn on the RGB backlight of cheap keyboards that use the `ScrollLock` key to turn the RGB leds on(note: this is for Wayland, if you are using x11 you can just use `xset led on/off` to control leds).
On many Linux distributions, the Scroll Lock is disabled by default, and since there is no `xset led` alternative for Wayland, I use this script. While you could manually edit the file, it resets to 0 whenever you press NumLock or Caps Lock.
## Files Included
- `install.sh`: Installs the scrolllock-monitor service.
- `uninstall.sh`: Uninstalls the scrolllock-monitor service.
## Requirements
- Linux-based system with systemd and running under wayland
- Sudo privileges to create files and manage system services
## Installation
1. Clone the repository and Run install.sh with sudo privileges:
```
git clone https://github.com/zero-stacks/ScrollLock_Monitor_Service.git
cd ScrollLock_Monitor_Service
sudo sh install.sh
```
This script performs the following actions:
- Creates a monitoring script (`/usr/local/bin/scrolllock_monitor.sh`) to keep the Scroll Lock LED brightness set to 1.
- Creates a systemd service (`/etc/systemd/system/scrolllock-monitor.service`) to run the script at startup.
- Enables and starts the service.
## Uninstallation
1. Run uninstall.sh with sudo privileges:
```
sudo sh uninstall.sh

```
This script will:
- Stop and disable the `scrolllock-monitor` service.
- Remove the service file (`/etc/systemd/system/scrolllock-monitor.service`).
- Remove the script file (`/usr/local/bin/scrolllock_monitor.sh`).
<br/><br/>
## Manual Installation (in case you don't trust the install script)
To install the scrolllock-monitor service:
1. Create the Monitoring Script:
```
sudo nano /usr/local/bin/scrolllock_monitor.sh
```
2. copy and past this inside the script:
```
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

```
3. Make the Script Executable:
```
sudo chmod +x /usr/local/bin/scrolllock_monitor.sh
```
4. Create the systemd Service:
```
sudo nano /etc/systemd/system/scrolllock-monitor.service
```
5. Copy and paste this inside the service file:
```
[Unit]
Description=Scroll Lock Monitor Service
After=multi-user.target

[Service]
ExecStart=/usr/local/bin/scrolllock_monitor.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
```
6. Enable and Start the Service:
```
sudo systemctl daemon-reload
sudo systemctl enable scrolllock-monitor.service
sudo systemctl start scrolllock-monitor.service
```
## Manual Uninstallation
To uninstall the service manually:
1. Stop and Disable the Service:
```
sudo systemctl stop scrolllock-monitor.service
sudo systemctl disable scrolllock-monitor.service
```
2. Remove the Script and Service Files:
```
sudo rm -f /usr/local/bin/scrolllock_monitor.sh
sudo rm -f /etc/systemd/system/scrolllock-monitor.service
```
3. Reload systemd:
```
sudo systemctl daemon-reload
```
## Notes
- Adjusting the Script: The script monitors all /sys/class/leds/inputX::scrolllock/brightness files and sets them to 1 if they change to 0. Adjustments to monitoring frequency can be made by changing the `sleep` interval in the script.
