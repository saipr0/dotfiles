#!/bin/bash

# Launch Spotify
gtk-launch spotify &

# Launch Cava
hyprctl dispatch layoutmsg preselect t
kitty --class kitty-cava -e cava &

# Wait until Spotify is running
while ! pgrep -x "spotify" > /dev/null; do
    echo "Waiting for Spotify to launch..."
    sleep 1
done

# Resize the Cava window
hyprctl dispatch resizewindowpixel exact 100% 70%, title:cava

# Wait a bit to ensure windows have registered
sleep 1

# Get Spotify window ID
SPOTIFY_WIN=$(hyprctl clients | grep -A 10 "spotify" | grep "windowID" | head -n 1 | awk '{print $2}')

# Group the Spotify window
hyprctl dispatch focuswindow address:$SPOTIFY_WIN
hyprctl dispatch togglegroup

# Launch terminal with rmpc
kitty --class kitty-rmpc -e rmpc &

