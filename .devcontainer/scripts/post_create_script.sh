#Post create script is run after container is created
#This script is not run after container startup

#Ensure flutter dependencies are up to date
cd /workspaces/Luna_mHealth_Mobile/luna_core
flutter pub get
cd /workspaces/Luna_mHealth_Mobile/luna_mobile
flutter pub get
cd /workspaces/Luna_mHealth_Mobile/luna_authoring_system
flutter pub get

#install android sdk
SDK_MANAGER="/usr/local/lib/android/cmdline-tools/latest/bin/sdkmanager"
yes | "$SDK_MANAGER" --licenses

#ensure git is setup for user credential use
git config --global credential.useHttpPath true

#install novnc dependencies
sudo apt update
sudo pip install numpy
sudo apt install -y zenity
sudo mkdir -p /opt/novnc
cd /opt

#clone noVNC
sudo git clone https://github.com/novnc/noVNC.git

#clone websockify
cd /opt/noVNC/utils
sudo git clone https://github.com/novnc/websockify
cd /opt/noVNC/utils/websockify
python3 setup.py install

echo "Switch to the terminal tab if you are stuck seeing this message"
