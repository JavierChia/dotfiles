#!/bin/bash

# Initialize necessary variables
NAME="wifi_status"
HOTSPOT="󰤨"  # Hotspot icon
WIFI_CONNECTED="󰤥"  # Connected Wi-Fi icon
WIFI_NO_INTERNET="󰤮"  # No internet/Wi-Fi off icon
WIFI_OFF="󰤭"  # Wi-Fi off icon

SSID="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}' | xargs networksetup -getairportnetwork | cut -d ':' -f 2- | xargs)"
CURR_TX="$(system_profiler SPAirPortDataType | awk '/Rate/ {print $3}')"
POPUP_OFF="sketchybar --set wifi.ssid popup.drawing=off && sketchybar --set wifi.speed popup.drawing=off"
WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
WIFI_POWER=$(networksetup -getairportpower $WIFI_INTERFACE | awk '{print $4}')
IP_ADDR=$(ipconfig getifaddr $WIFI_INTERFACE)

# Debug information
echo "[DEBUG] SSID: $SSID"
echo "[DEBUG] CURR_TX: $CURR_TX"
echo "[DEBUG] WIFI_POWER: $WIFI_POWER"
echo "[DEBUG] IP_ADDR: $IP_ADDR"
echo "[DEBUG] WIFI_INTERFACE: $WIFI_INTERFACE"

ssid=(
  label="$SSID"
  label.font="SF Pro:Bold:12.0"
  label.padding_left=10
  label.padding_right=10
  blur_radius=0
  update_freq=100
  click_script="open /System/Library/PreferencePanes/Network.prefPane/; $POPUP_OFF"
)

ip=(
  label="$IP_ADDR"
  label.font="SF Pro:Bold:12.0"
  label.padding_left=10
  label.padding_right=10
  blur_radius=0
  click_script="open /System/Library/PreferencePanes/Network.prefPane/; $POPUP_OFF"
)

# Ensure wifi_status item is added
if ! sketchybar --query "$NAME" &>/dev/null; then
  sketchybar --add item "$NAME" center
fi

# Check if items already exist and set or add them accordingly
if ! sketchybar --query wifi.ssid &>/dev/null; then
  sketchybar --add item wifi.ssid popup.wifi
fi
sketchybar --set wifi.ssid "${ssid[@]}"

if ! sketchybar --query wifi.ip &>/dev/null; then
  sketchybar --add item wifi.ip popup.wifi
fi
sketchybar --set wifi.ip "${ip[@]}"

if [ "$WIFI_POWER" == "Off" ]; then
  echo "[DEBUG] WIFI_POWER is off: $NAME"
  sketchybar --set "$NAME" icon="$WIFI_OFF" label="$WIFI_OFF"
  exit 0
fi

SSID_LOWER=$(echo "$SSID" | tr '[:upper:]' '[:lower:]')
echo "[DEBUG] SSID_LOWER: $SSID_LOWER"
if [[ "$SSID_LOWER" == *"iphone"* ]]; then
  echo "[DEBUG] Hotspot detected: $NAME and Hotspot: $HOTSPOT"
  sketchybar --set "$NAME" icon="$HOTSPOT" label="Hotspot Connected"
  exit 0
fi

if [ "$CURR_TX" = 0 ]; then
  echo "[DEBUG] No internet: $NAME"
  sketchybar --set "$NAME" icon="$WIFI_NO_INTERNET" label="$WIFI_NO_INTERNET"
  exit 0
fi

sketchybar --set "$NAME" icon="$WIFI_CONNECTED" label="Connected to $SSID"
