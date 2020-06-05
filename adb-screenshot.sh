#!/bin/bash

# Help and error handling
function help {
    echo " adb-screenshot"; echo""
    echo "This program makes a screenshot of an android device via adb." ; echo""
    echo "Options:"
    echo "  -h      Show this screen."
    echo "  -d      Specify the adb device name. Get via adb devices -l."
    echo "  -f      The filename where the file should be saved [default: 'Screenshot (date) at (time)']."
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

# The actual script

while getopts :hd:f: option
do
case "${option}"
in
    h) help;;
    d) device=${OPTARG};;
    f) filename=${OPTARG};;
    ?) input_error $OPTARG;;
esac
done

#Check the file name for error, if empty set default
now=$(date +'%Y-%m-%d at %H.%M.%S')

if [ "$filename" == '-d' ] || [ "$filename" == '-h' ]; then
    parameter_error $filename
elif [ -z "$filename" ]; then
    filename="Screenshot $now.png"
fi

#Check the device name for error
if [ "$device" == '-f' ] || [ "$device" == '-h' ]; then
    parameter_error $device
elif [ ! -z "$device" ]; then
    device="-s $device"
fi

#Make the screenshot, if adb throws an error remove the corrupt file and exit
#The file removal is necessary since the output is binary, and bash can't handly binary in variables
if ! $(adb $device exec-out screencap -p > "$filename"); then
    $(rm "$filename")
    exit 1
fi

#Check if the file is empty, this happens if the current app doesn't allow screenshots. If it is empty, remove it and print an error.
if ! [[ -s "$filename" ]]; then
    echo "Error: No data received. The current app might not allow screenshots."
    $(rm "$filename")
    exit 1
fi