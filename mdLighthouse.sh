#!/bin/bash
# Multiple Device Lighthouse Tester - Ramon Valk
version="0.2"
testSite=$1

echo "Running Multiple Device Lighthouse Tester version $version, by Ramon Valk."

 #checking for correct use
    if [ -z "$1" ]; then
        echo "ERROR: No site argument given, try using 'mdLighthouse [website]'"
        exit 2
    fi

#searching for devices 
     echo "\nChecking for attached devices..."
     inputDevicesString=$(./data/adb devices | grep -v List | grep device | perl -p -e 's/(\w+)\s.*/\1/')
     inputDevicesArray=(`echo ${inputDevicesString}`);
     deviceNMR=$(echo ${#inputDevicesArray[@]})
     echo "\nFound $deviceNMR device(s)!"
     if [[ "$deviceNMR" -eq 0 ]]; then
         echo "ERROR: No devices found, exiting..."
         exit 3
     fi


     #gettting model number via getprop
     echo "Device name(s) : "
     for (( i = 0; i < $deviceNMR; i++ )); do
        ./data/adb -s ${inputDevicesArray[$i]} shell getprop ro.product.model
         
     done

     #install apk via adb
    echo "Running Lighthouse...\n"
    ##################old for loop#############
    for (( i = 0; i < $deviceNMR; i++ )); do
        ./data/adb -s ${inputDevicesArray[$i]} shell getprop ro.product.model
        ./data/adb -s ${inputDevicesArray[$i]} forward tcp:9222 localabstract:chrome_devtools_remote
        lOutput=$(lighthouse $testSite)
        echo "\n"  
    done
    ################################

    echo "It seems we are done here 👋🏼"

    exit 0