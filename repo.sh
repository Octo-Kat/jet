#!/bin/bash
## Build Automation Scripts
##
## Copywrite 2014 - Donald Hoskins <grommish@gmail.com>
## on behalf of Team Octos et al.
##
## This script automates device tree switching in the local_manifests
## directory.
##
## Usage: jet/repo.sh <branch>
## jet/repo.sh sam, jet/repo.sh nex, etc
##
## Defaults to master branch (all devices) unless specified.
CWD=$(pwd)
DEVICE_TREE=$1
MANI_REPO="vendor/oct/prebuilt/common/manifests"
VENDOR_REPO="vendor/oct"

cd $VENDOR_REPO
echo "Updating Repo"
git fetch
git pull
echo "Done Updating"
cd $CWD

if [[ $DEVICE_TREE = "" ]]
  then
  echo "Pick a repo:"
  for entry in "$MANI_REPO"/*
  do
    repname=$(basename $entry)
    if [[ $repname = "cm.xml" || $repname = "oct.xml" ]]
    then
      continue
    fi
    echo "${repname%.xml}"
  done
  exit
fi

cd $CWD
echo "CWD : $CWD"
if [ ! -d ".repo/local_manifests" ]; then
  mkdir -p ".repo/local_manifests"
fi
touch ".repo/local_manifests/OctOs.xml"
cat "$MANI_REPO/oct.xml" > ".repo/local_manifests/OctOs.xml"
cat "$MANI_REPO/cm.xml" >> ".repo/local_manifests/OctOs.xml"
for DEVICE_TREE in "$@"
do
cat "$MANI_REPO/$DEVICE_TREE.xml" >> ".repo/local_manifests/OctOs.xml"
done
echo "</manifest>" >> ".repo/local_manifests/OctOs.xml"

repo sync
