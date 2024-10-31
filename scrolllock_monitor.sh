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
