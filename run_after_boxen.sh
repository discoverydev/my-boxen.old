#!/bin/sh

#USER=ga-mlsdiscovery
USER=admin
SERVER=192.168.8.31

echo "* adding $SERVER to known_hosts"
ssh-keyscan $SERVER > ~/.ssh/known_hosts

TARFILE=tailored_backup.tar
DEST=/opt/android-sdk
SRC=/Users/$USER/tailored_backup

echo "* copy $TARFILE from $SERVER ($SRC) to $DEST"
mkdir -p $DEST

pushd $DEST
echo "  user $USER"
rsync -ru --progress $USER@$SERVER:$SRC/$TARFILE $DEST/$TARFILE
tar xkvf $TARFILE
popd

echo "* run android HAXM install"
$DEST/extras/intel/Hardware_Accelerated_Execution_Manager/silent_install.sh

echo "* install more android components"
echo "y" | $DEST/tools/android update sdk --all --no-ui --filter sys-img-x86-android-21

echo "* create android virtual devices"
echo "n" | $DEST/tools/android create avd --force --name Nexus_5_API_21_x86 --target android-21 --skin WXGA720

echo "* run and configure android virtual devices"
$DEST/tools/emulator @Nexus_5_API_21_x86
