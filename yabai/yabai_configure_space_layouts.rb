#!/usr/bin/env ruby

require 'json'

# Get the list of displays
displays = JSON.parse `yabai -m query --displays`

# My Macbook Pro's frame width
threshold_width = 1800

# Iterate over each display and set the padding based on the resolution
displays.each do |display|
  width = display['frame']['w']
  spaces = display['spaces']

  # Set padding based on the resolution
  padding = (width > threshold_width) ? 12 : 18

  # Apply padding to all spaces on the display
  spaces.each do |space|
    `yabai -m config --space #{space} top_padding #{padding}`
  end
end
