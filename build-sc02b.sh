#!/bin/bash
echo "Restore twrp dummy files deleted after distclean"
git stash
echo "Remove and update both recovery ramdisk"
rm -rfv source/usr/galaxy_ramdisk2/twrp
rm -rfv source/usr/galaxy_ramdisk2/cwm
cp -vr usr/galaxy_ramdisk2/twrp source/usr/galaxy_ramdisk2/
cp -vr usr/galaxy_ramdisk2/cwm source/usr/galaxy_ramdisk2/

echo "Making JB-4.2/CM-10.1 kernel for GS1 NTT-Docomo SC-02B"
BUILDVERSION=mackay_sc02b-`date +%m%d`
DATE_START=$(date +"%s")

make "cyanogenmod_galaxys_sc02b_defconfig"

KERNEL_DIR=`pwd`
OUTPUT_DIR=../output
CWM_DIR=../ramdisk-sc02b/mackay/
MODULES_DIR=../ramdisk-sc02b/mackay/system/lib/modules/

echo "KERNEL_DIR="$KERNEL_DIR
echo "OUTPUT_DIR="$OUTPUT_DIR
echo "CWM_DIR="$CWM_DIR
echo "MODULES_DIR="$MODULES_DIR

make

rm `echo $MODULES_DIR"/*"`
find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
cp arch/arm/boot/zImage $CWM_DIR"boot.img"
cd $CWM_DIR
zip -r `echo $BUILDVERSION`.zip *
mv  `echo $BUILDVERSION`.zip ../$OUTPUT_DIR"/"

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
