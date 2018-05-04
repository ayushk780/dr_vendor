#!/bin/bash
# Copyright (C) 2018 Mohd Faraz <mohd.faraz.abc@gmail.com>
# Copyright (C) 2018 PitchBlackTWRP <pitchblacktwrp@gmail.com>
# Copyright (C) 2018 Darkstar085 <sipunkumar85@gmail.com>
# Copyright (C) 2015 Paranoid Android Project
# Copyright (C) 2018 Sweeto143
# Copyright (C) 2018 ATG Droid

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
# PA Colors
# red = errors, cyan = warnings, green = confirmations, blue = informational
# plain for generic text, bold for titles, reset flag at each end of line
# plain blue should not be used for readability reasons - use plain cyan instead
CLR_RST=$(tput sgr0)                        ## reset flag
CLR_RED=$CLR_RST$(tput setaf 1)             #  red, plain
CLR_GRN=$CLR_RST$(tput setaf 2)             #  green, plain
CLR_YLW=$CLR_RST$(tput setaf 3)             #  yellow, plain
CLR_BLU=$CLR_RST$(tput setaf 4)             #  blue, plain
CLR_PPL=$CLR_RST$(tput setaf 5)             #  purple,plain
CLR_CYA=$CLR_RST$(tput setaf 6)             #  cyan, plain
CLR_BLD=$(tput bold)                        ## bold flag
CLR_BLD_RED=$CLR_RST$CLR_BLD$(tput setaf 1) #  red, bold
CLR_BLD_GRN=$CLR_RST$CLR_BLD$(tput setaf 2) #  green, bold
CLR_BLD_YLW=$CLR_RST$CLR_BLD$(tput setaf 3) #  yellow, bold
CLR_BLD_BLU=$CLR_RST$CLR_BLD$(tput setaf 4) #  blue, bold
CLR_BLD_PPL=$CLR_RST$CLR_BLD$(tput setaf 5) #  purple, bold
CLR_BLD_CYA=$CLR_RST$CLR_BLD$(tput setaf 6) #  cyan, bold

BUILD_START=$(date +"%s")
DATE=$(date -u +%Y%m%d-%H%M)
DR_VENDOR=vendor/dark
DR_WORK=$OUT
DR_WORK_DIR=$OUT/zip
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

echo -e "${CLR_BLD_RED}**** Making Zip ****${CLR_RST}"
if [ -d "$DR_WORK_DIR" ]; then
        rm -rf "$DR_WORK_DIR"
	rm -rf "$DR_WORK"/*.zip
fi

if [ ! -d "DR_WORK_DIR" ]; then
        mkdir "$DR_WORK_DIR"
fi

echo -e "${CLR_BLD_BLU}**** Copying Tools ****${CLR_RST}"
cp -R "$DR_VENDOR/Darkstar" "$DR_WORK_DIR"
echo -e "${CLR_BLD_BLU}- Copying Tools Done...${CLR_RST}"
echo -e ""
echo -e "${CLR_BLD_GRN}**** Copying Updater Scripts ****${CLR_RST}"
mkdir -p "$DR_WORK_DIR/META-INF/com/google/android"
cp -R "$DR_VENDOR/updater/"* "$DR_WORK_DIR/META-INF/com/google/android/"
echo -e "${CLR_BLD_GRN}- Copying Updater Scripts Done...${CLR_RST}"
echo -e ""
echo -e "${CLR_BLD_CYA}**** Copying Recovery Image ****${CLR_RST}"
mkdir -p "$DR_WORK_DIR/TWRP"
cp "$RECOVERY_IMG" "$DR_WORK_DIR/TWRP/"
echo -e "${CLR_BLD_CYA}- Copying Recovery Image Done...${CLR_RST}"
echo -e ""
echo -e "${CLR_BLD_PPL}**** Compressing Files into ZIP ****${CLR_RST}"
cd $DR_WORK_DIR
zip -r ${ZIP_NAME}.zip *
BUILD_RESULT_STRING="BUILD SUCCESSFUL"
echo -e "${CLR_BLD_PPL}- Compressing Zip Done...${CLR_RST}"
echo -e ""
echo -e "${CLR_BLD_YLW}██████╗  █████╗ ██████╗ ██╗  ██╗${CLR_RST}"
echo -e "${CLR_BLD_CYA}██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝${CLR_RST}"
echo -e "${CLR_BLD_PPL}██║  ██║███████║██████╔╝█████╔╝ ${CLR_RST}"
echo -e "${CLR_BLD_GRN}██║  ██║██╔══██║██╔══██╗██╔═██╗ ${CLR_RST}"
echo -e "${CLR_BLD_BLU}██████╔╝██║  ██║██║  ██║██║  ██╗${CLR_RST}"
echo -e "${CLR_BLD_RED}╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝${CLR_RST}"
echo -e "${CLR_BLD_RED}██████╗ ███████╗ ██████╗ ██████╗ ██╗   ██╗███████╗██████╗ ██╗   ██╗${CLR_RST}"
echo -e "${CLR_BLD_BLU}██╔══██╗██╔════╝██╔════╝██╔═══██╗██║   ██║██╔════╝██╔══██╗╚██╗ ██╔╝${CLR_RST}"
echo -e "${CLR_BLD_GRN}██████╔╝█████╗  ██║     ██║   ██║██║   ██║█████╗  ██████╔╝ ╚████╔╝ ${CLR_RST}"
echo -e "${CLR_BLD_PPL}██╔══██╗██╔══╝  ██║     ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗  ╚██╔╝  ${CLR_RST}"
echo -e "${CLR_BLD_CYA}██║  ██║███████╗╚██████╗╚██████╔╝ ╚████╔╝ ███████╗██║  ██║   ██║   ${CLR_RST}"
echo -e "${CLR_BLD_YLW}╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   ${CLR_RST}"
echo -e ""
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
if [[ "${BUILD_RESULT_STRING}" = "BUILD SUCCESSFUL" ]]; then
mv ${DR_WORK_DIR}/${ZIP_NAME}.zip ${DR_WORK_DIR}/../${ZIP_NAME}.zip
echo -e "${CLR_BLD_CYA}****************************************************************************************${CLR_RST}"
echo -e "${CLR_BLD_RED}*${CLR_RST}${CLR_BLD_RED} ${BUILD_RESULT_STRING}${CLR_RST}"
echo -e "${CLR_BLD_BLU}*${CLR_RST}${CLR_BLD_BLU} Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.${CLR_RST}"
echo -e "${CLR_BLD_GRN}*${CLR_RST}${CLR_BLD_GRN} RECOVERY LOCATION: ${OUT}/recovery.img${CLR_RST}"
echo -e "${CLR_BLD_YLW}*${CLR_RST}${CLR_BLD_YLW} RECOVERY SIZE: $( du -h ${OUT}/recovery.img | awk '{print $1}' )${CLR_RST}"
echo -e "${CLR_BLD_PPL}*${CLR_RST}${CLR_BLD_PPL} ZIP LOCATION: ${DR_WORK}/${ZIP_NAME}.zip${CLR_RST}"
echo -e "${CLR_BLD_RED}*${CLR_RST}${CLR_BLD_RED} ZIP SIZE: $( du -h ${DR_WORK}/${ZIP_NAME}.zip | awk '{print $1}' )${CLR_RST}"
echo -e "${CLR_BLD_CYA}****************************************************************************************${CLR_RST}"
fi
