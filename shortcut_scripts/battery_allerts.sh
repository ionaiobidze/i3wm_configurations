#!/bin/bash
# Check battery level every 30 seconds
while true; do
    # Get battery percentage
    BATTERY_LEVEL=$(acpi -b | grep -P -o '[0-9]+(?=%)')
    BATTERY_STATE=$(acpi -b | grep -o 'Discharging\|Charging')
    if [[ "$BATTERY_STATE" == "Discharging" ]]; then
        if [[ "$BATTERY_LEVEL" -le 15 ]]; then
            # Show a notification at 15% (temporary notification)
            zenity --warning --text="Battery is low. Please plug in your charger!" --timeout=10
        elif [[ "$BATTERY_LEVEL" -le 10 ]]; then
            # Show a persistent notification at 10% (won't disappear)
            zenity --error --text="Critical Battery Level! Plug in your charger now!"
        fi
    elif [[ "$BATTERY_STATE" == "Charging" ]]; then
        if [[ "$BATTERY_LEVEL" -ge 90 ]]; then
            # Notify to unplug the charger at 90% or above
            zenity --info --text="Battery charged to $BATTERY_LEVEL%. Please unplug the charger!" --timeout=10
        fi
    fi
    sleep 30  # Wait 30 seconds before checking again
done