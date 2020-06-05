#!/bin/bash

# Help and error handling
function help {
    echo " adb-statusbar"; echo""
    echo "This program cleans the statusbar of an android device via adb."
    echo "It needs to be called on start and on end and might reset on configuration change, for example when the language changes." ; echo""
    echo "Options:"
    echo "  -h      Show this screen."
    echo "  -d      Specify the adb device name. Get via adb devices -l."
    echo "  -c      Clean up the statusbar."
    echo "  -e      Exit demo mode, reset to normal."
    exit
}

function input_error {
    case "$1"
    in
    d | f) 
        echo "Error: The parameter '$1' needs an argument to function, it cannot be used on it's own."
        echo "See -h for more infos"
        ;;
    *) echo "Error: unrecognised parameter '$1'. See -h for syntax.";;
    esac

    exit 1
}

function parameter_error {
    echo "Error: Expected argument, found next parameter '$1'"
    exit 1
}

# Statusbar cleanup
function format_device_name {
    #Check the device name for error
    if [ "$device" == '-f' ] || [ "$device" == '-h' ]; then
        parameter_error $device
    elif [ ! -z "$device" ]; then
        device="-s $device"
    fi
}

function cleanup {
    # Start demo mode
    adb $device shell settings put global sysui_demo_allowed 1

    # Display time of 12:00
    adb $device shell am broadcast -a com.android.systemui.demo -e command clock -e hhmm 1200
    
    # Display full wifi and mobile data without type
    adb shell am broadcast -a com.android.systemui.demo -e command network -e wifi show -e level 4
    adb $device shell am broadcast -a com.android.systemui.demo -e command network -e mobile show -e level 4 -e datatype false
    
    # Hide notifications
    adb $device shell am broadcast -a com.android.systemui.demo -e command notifications -e visible false
    
    # Show full battery, but not in charging state
    adb $device shell am broadcast -a com.android.systemui.demo -e command battery -e plugged false -e level 100
}

function exit_demo_mode {
    adb $device shell am broadcast -a com.android.systemui.demo -e command exit
}

# The actual script
while getopts :hced: option
do
case "${option}"
in
    h) help;;
    d) device=${OPTARG}; format_device_name;;
    c) cleanup;;
    e) exit_demo_mode;;
    ?) input_error $OPTARG;;
esac
done