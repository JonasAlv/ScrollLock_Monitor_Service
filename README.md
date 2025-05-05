# Scroll Lock Monitor Service
A systemd service that monitors the brightness of the Scroll Lock LED and ensures it remains turned on by setting the value inside the file `/sys/class/leds/inputX::scrolllock/brightness` to 1 whenever it changes back to 0. This is designed to work with any inputX::scrolllock device.
<br/><br/>
This is made mainly to turn on the RGB backlight of cheap keyboards that use the `ScrollLock` key to turn the RGB leds on(note: this is for Wayland, if you are using x11 you can just use `xset led on/off` to control leds).
On many Linux distributions, the Scroll Lock is disabled by default, and since there is no `xset led` alternative for Wayland, I use this script. While you could manually edit the file, it resets to 0 whenever you press NumLock or Caps Lock.

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

## Notes
- Adjusting the Script: The script monitors all /sys/class/leds/inputX::scrolllock/brightness files and sets them to 1 if they change to 0. Adjustments to monitoring frequency can be made by changing the `sleep` interval in the script.
