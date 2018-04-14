#!/bin/bash
# Copyright (C) 2018 Mohd Faraz <mohd.faraz.abc@gmail.com>
# Copyright (C) 2018 PitchBlackTWRP <pitchblacktwrp@gmail.com>
# Copyright (C) 2018 Darkstar085 <sipunkumar85@gmail.com>  
# Copyright (C) 2018 ATG Droid 
#
# Custom build script
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
green='\e[0;32m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
purple='\e[0;35m'
white='\e[0;37m'
DATE=$(date -u +%Y%m%d-%H%M)
DR_VENDOR=vendor/dr
DR_WORK=$OUT
DR_WORK_DIR=$OUT/zip
DEVICE=$(cut -d'_' -f2 <<<$TARGET_PRODUCT)
RECOVERY_IMG=$OUT/recovery.img
DR_DEVICE=$TARGET_VENDOR_DEVICE_NAME-$(cut -d'_' -f2 <<<$TARGET_PRODUCT)
ZIP_NAME=DarkRecovery-$DEVICE-$VERSION-$DATE
DRTWRP_BUILD_TYPE=UNOFFICIAL
wget https://raw.githubusercontent.com/DarkRecovery/dr_vendor/dr/dr.devices -O dr.devices

if [ "$DRTWRP_BUILD_TYPE" ]; then
   CURRENT_DEVICE=$(cut -d'_' -f2 <<<$TARGET_PRODUCT)
   LIST=dr.devices
   FOUND_DEVICE=$(grep -Fx "$CURRENT_DEVICE" "$LIST")
    if [ "$FOUND_DEVICE" == "$CURRENT_DEVICE" ]; then
      IS_OFFICIAL=true
      DRTWRP_BUILD_TYPE=OFFICIAL
    fi
    if [ ! "$IS_OFFICIAL" == "true" ]; then
       DRTWRP_BUILD_TYPE=UNOFFICIAL
       echo "Error Device is not OFFICIAL"
    fi
fi

if [ "$DRTWRP_BUILD_TYPE" == "OFFICIAL" ]; then
	ZIP_NAME=DarkRecovery-$DEVICE-$VERSION-$DATE-OFFICIAL
else
	ZIP_NAME=DarkRecovery-$DEVICE-$VERSION-$DATE-UNOFFICIAL
fi

echo -e "${red}**** Making Zip ****${nocol}"
if [ -d "$DR_WORK_DIR" ]; then
        rm -rf "$DR_WORK_DIR"
	rm -rf "$DR_WORK"/*.zip
fi

if [ ! -d "DR_WORK_DIR" ]; then
        mkdir "$DR_WORK_DIR"
fi

echo -e "${blue}**** Copying Tools ****${nocol}"
cp -R "$DR_VENDOR/Darkstar" "$DR_WORK_DIR"

echo -e "${green}**** Copying Updater Scripts ****${nocol}"
mkdir -p "$DR_WORK_DIR/META-INF/com/google/android"
cp -R "$DR_VENDOR/updater/"* "$DR_WORK_DIR/META-INF/com/google/android/"

echo -e "${cyan}**** Copying Recovery Image ****${nocol}"
mkdir -p "$DR_WORK_DIR/TWRP"
cp "$RECOVERY_IMG" "$DR_WORK_DIR/TWRP/"

echo -e "${green}**** Compressing Files into ZIP ****${nocol}"
cd $PB_WORK_DIR
zip -r ${ZIP_NAME}.zip *
BUILD_RESULT_STRING="BUILD SUCCESSFUL"

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
if [[ "${BUILD_RESULT_STRING}" = "BUILD SUCCESSFUL" ]]; then
mv ${PB_WORK_DIR}/${ZIP_NAME}.zip ${DR_WORK_DIR}/../${ZIP_NAME}.zip
echo -e "$cyan****************************************************************************************$nocol"
echo -e "$cyan*$nocol${green} ${BUILD_RESULT_STRING}$nocol"
echo -e "$cyan*$nocol${yellow} Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
echo -e "$cyan*$nocol${green} RECOVERY LOCATION: ${OUT}/recovery.img$nocol"
echo -e "$purple*$nocol${green} RECOVERY SIZE: $( du -h ${OUT}/recovery.img | awk '{print $1}' )$nocol"
echo -e "$cyan*$nocol${green} ZIP LOCATION: ${PB_WORK}/${ZIP_NAME}.zip$nocol"
echo -e "$purple*$nocol${green} ZIP SIZE: $( du -h ${PB_WORK}/${ZIP_NAME}.zip | awk '{print $1}' )$nocol"
echo -e "$cyan****************************************************************************************$nocol"
fi
