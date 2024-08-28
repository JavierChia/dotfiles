#!/bin/bash

# Get the current brightness level
brightness=$(brightnessctl get)

echo "Brightness: $brightness"

# Check if brightness level is available
if [[ -n $brightness ]]; then
    echo "Brightness: $brightness"
else
    echo "Brightness: Not available"
fi