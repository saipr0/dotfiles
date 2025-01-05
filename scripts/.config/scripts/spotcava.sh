
#!/bin/bash

gtk-launch spotify &

hyprctl dispatch layoutmsg preselect t
kitty --class kitty-cava -e cava &
# Wait until Spotify is running
while ! pgrep -x "spotify" > /dev/null; do
    echo "Waiting for Spotify to launch..."
    sleep 1
done
hyprctl dispatch resizewindowpixel exact 100% 70%, title:cava


