#Post Start Script 
#This script runs everytime the dev container starts.
#It starts the vnc and novnc servers for remote desktop connections.
#This script also copies over the desktop icons for quick starting the Luna apps
#run in the background
# https://code.visualstudio.com/remote/advancedcontainers/start-processes
echo "Starting VNC server..." 
vncserver :1 -geometry 1280x720 \
 -depth 16 -SecurityTypes None > /var/log/vncserver.log

sleep 1
echo "Starting noVNC server..." 
nohup bash -c "/opt/noVNC/utils/websockify/run \
  --web=/opt/noVNC \
  6080 \
  localhost:5901"\
  > /var/log/websockify.log 2>&1 &

sleep 1

#Copy over the desktop icons
#These steps are idempontent
echo "Copy over desktop icons"

LUNA_DESKTOP_DIR="/workspaces/Luna_mHealth_Mobile/.devcontainer/scripts/"

cp "$LUNA_DESKTOP_DIR/desktop_icons/luna_authoring.desktop" "$HOME/Desktop/"
chmod +x "$LUNA_DESKTOP_DIR/desktop_icons/run_luna_authoring.sh"
chmod +x "$HOME/Desktop/luna_authoring.desktop"
cp "$LUNA_DESKTOP_DIR/desktop_icons/luna_mobile.desktop" "$HOME/Desktop/"
chmod +x "$LUNA_DESKTOP_DIR/desktop_icons/run_luna_mobile.sh"
chmod +x "$HOME/Desktop/luna_mobile.desktop"

echo "#### Setup done, you can close this terminal. ######"

