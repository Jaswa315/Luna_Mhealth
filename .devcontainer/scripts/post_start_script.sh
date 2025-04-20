#Post Start Script 
#This script runs everytime the dev container starts.
#It starts the vnc and novnc servers for remote desktop connections.
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

echo "#### Setup done, you can close this terminal. ######"

