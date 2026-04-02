#!/bin/bash
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/islam-2412/FuryBissPro/main/fury/installer.sh -O - | /bin/sh
#
echo "------------------------------------------------------------------------"
echo "                     Installing FuryBiss                           "
echo "------------------------------------------------------------------------"

# 1. فحص إصدار البايثون الموجود على الرسيفر
echo "Checking Python version..."
PY_VER=$(python -c 'import sys; print(str(sys.version_info[0])+"."+str(sys.version_info[1]))' 2>/dev/null)
if [ -z "$PY_VER" ]; then
    PY_VER=$(python3 -c 'import sys; print(str(sys.version_info[0])+"."+str(sys.version_info[1]))' 2>/dev/null)
fi

if [ -z "$PY_VER" ]; then
    echo "Error: Python is not installed or detected on this device!"
    exit 1
fi

echo "Detected Python Version: $PY_VER"

case $PY_VER in
    3.9|3.10|3.11|3.12|3.13|3.14)
        echo "Python $PY_VER is supported. Proceeding..."
        ;;
    *)
        echo "Error: Python $PY_VER is not supported by this plugin version."
        exit 1
        ;;
esac
echo ""

# 2. إزالة النسخة القديمة نهائياً من الجذور
echo "Removing old versions of FuryBiss completely... "
sleep 1

# حذف الحزمة من النظام (حطيت الاسمين تحسباً لأي إصدار قديم)
opkg remove enigma2-plugin-extensions-furybiss > /dev/null 2>&1
opkg remove enigma2-plugin-extensions-furybis > /dev/null 2>&1

# الحذف الإجباري للفولدر بكل محتوياته (عشان نضمن نضافة الرسيفر تماماً)
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/FuryBiss ] ; then
    rm -rf /usr/lib/enigma2/python/Plugins/Extensions/FuryBiss
    echo "Old folder /FuryBiss deleted permanently."
else
    echo "No old folder found. System is clean."
fi
echo ""

# 3. التأكد من وجود curl
echo "Checking if curl is installed... "
if ! command -v curl >/dev/null 2>&1; then
    opkg install curl
fi
sleep 1

# 4. تحميل الملف المناسب لنسخة البايثون وتثبيته
cd /tmp

FILE_NAME="furybiss_${PY_VER}.ipk"
DOWNLOAD_URL="https://raw.githubusercontent.com/islam-2412/FuryBissPro/main/fury/${FILE_NAME}"

echo "Downloading FuryBiss package for Python ${PY_VER}..."
curl -s -k -L "${DOWNLOAD_URL}" -o /tmp/${FILE_NAME}

if [ $? -ne 0 ] || [ ! -f /tmp/${FILE_NAME} ]; then
    echo "Error: Failed to download ${FILE_NAME}. Please check if the file exists on GitHub."
    exit 1
fi
sleep 1

echo "Installing new version...."
opkg install --force-overwrite /tmp/${FILE_NAME}
if [ $? -ne 0 ]; then
    echo "Error installing FuryBiss"
    exit 1
fi

echo ""
sleep 1

echo "Cleaning up temporary files..."
rm -f /tmp/${FILE_NAME}

echo "Done"
#
echo "------------------------------------------------------------------------"
echo "        This work is exclusive to Islam Salama (( Skin Fury-FHD ))      "
echo "------------------------------------------------------------------------"
echo "                              Abou Yassin                               "
echo "                   FuryBiss Installed Successfully                    "
echo "------------------------------------------------------------------------"
echo "   "
exit 0
