#!/bin/bash
export VENDOR=xiaomi
export DEVICE_VENDOR=xiaomi
export DEVICE=libra
OUTDIR=vendor/$VENDOR/$DEVICE
MAKEFILE=../../../$OUTDIR/$DEVICE-vendor-blobs.mk
VENDOR_MAKEFILE=../../../$OUTDIR/device-vendor.mk
YEAR=`date +"%Y"`

(cat << EOF) > $MAKEFILE
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$DEVICE_VENDOR/$DEVICE/setup-makefiles.sh

PRODUCT_COPY_FILES += \\
EOF

LINEEND=" \\"
COUNT=`wc -l proprietary-blobs.txt | awk {'print $1'}`
DISM=`egrep -c '(^#|^$)' proprietary-blobs.txt`
COUNT=`expr $COUNT - $DISM`
for FILE in `egrep -v '(^#|^$)' proprietary-blobs.txt`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
  # Split the file from the destination (format is "file[:destination]")
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  if [[ ! "$FILE" =~ ^-.* ]]; then
    FILE=`echo ${PARSING_ARRAY[0]} | sed -e "s/^-//g"`
    DEST=${PARSING_ARRAY[1]}
    if [ -n "$DEST" ]; then
        FILE=$DEST
    fi
    echo "    $OUTDIR/proprietary/$FILE:system/$FILE$LINEEND" >> $MAKEFILE
  fi
done

(cat << EOF) > $VENDOR_MAKEFILE
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$DEVICE_VENDOR/$DEVICE/setup-makefiles.sh

\$(call inherit-product, vendor/$VENDOR/$DEVICE/$DEVICE-vendor-blobs.mk)

EOF

(cat << EOF) > ../../../$OUTDIR/BoardConfigVendor.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$DEVICE_VENDOR/$DEVICE/setup-makefiles.sh
EOF

if [ -d ../../../$OUTDIR/proprietary/app ]; then
(cat << EOF) > ../../../$OUTDIR/proprietary/app/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$DEVICE_VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

echo "ifeq (\$(TARGET_DEVICE),$DEVICE)" >> ../../../$OUTDIR/proprietary/app/Android.mk
echo ""  >> ../../../$OUTDIR/proprietary/app/Android.mk
echo "# Prebuilt APKs" >> $VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`ls -1 ../../../$OUTDIR/proprietary/app/*/*.apk | wc -l`
for APK in `ls ../../../$OUTDIR/proprietary/app/*/*apk`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    apkname=`basename $APK`
    apkmodulename=`echo $apkname|sed -e 's/\.apk$//gi'`
    (cat << EOF) >> ../../../$OUTDIR/proprietary/app/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $apkmodulename
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $apkmodulename/$apkname
LOCAL_CERTIFICATE := platform
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := \$(COMMON_ANDROID_PACKAGE_SUFFIX)
include \$(BUILD_PREBUILT)

EOF

echo "    $apkmodulename$LINEEND" >> $VENDOR_MAKEFILE
done
echo "" >> $VENDOR_MAKEFILE
echo "endif" >> ../../../$OUTDIR/proprietary/app/Android.mk
fi

if [ -d ../../../$OUTDIR/proprietary/framework ]; then
(cat << EOF) > ../../../$OUTDIR/proprietary/framework/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$DEVICE_VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

echo "ifeq (\$(TARGET_DEVICE),$DEVICE)" >> ../../../$OUTDIR/proprietary/framework/Android.mk
echo ""  >> ../../../$OUTDIR/proprietary/framework/Android.mk
echo "# Prebuilt jars" >> $VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`ls -1 ../../../$OUTDIR/proprietary/framework/*.jar | wc -l`
for JAR in `ls ../../../$OUTDIR/proprietary/framework/*jar`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    jarname=`basename $JAR`
    jarmodulename=`echo $jarname|sed -e 's/\.jar$//gi'`
    (cat << EOF) >> ../../../$OUTDIR/proprietary/framework/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $jarmodulename
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $jarname
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := \$(COMMON_JAVA_PACKAGE_SUFFIX)
include \$(BUILD_PREBUILT)

EOF

echo "    $jarmodulename$LINEEND" >> $VENDOR_MAKEFILE
done
echo "" >> $VENDOR_MAKEFILE
echo "endif" >> ../../../$OUTDIR/proprietary/framework/Android.mk
fi

if [ -d ../../../$OUTDIR/proprietary/priv-app ]; then
(cat << EOF) > ../../../$OUTDIR/proprietary/priv-app/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$DEVICE_VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

echo "ifeq (\$(TARGET_DEVICE),$DEVICE)" >> ../../../$OUTDIR/proprietary/priv-app/Android.mk
echo ""  >> ../../../$OUTDIR/proprietary/priv-app/Android.mk
echo "# Prebuilt privileged APKs" >> $VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`ls -1 ../../../$OUTDIR/proprietary/priv-app/*/*.apk | wc -l`
for PRIVAPK in `ls ../../../$OUTDIR/proprietary/priv-app/*/*apk`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    privapkname=`basename $PRIVAPK`
    privmodulename=`echo $privapkname|sed -e 's/\.apk$//gi'`
    (cat << EOF) >> ../../../$OUTDIR/proprietary/priv-app/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $privmodulename
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $privmodulename/$privapkname
LOCAL_CERTIFICATE := platform
LOCAL_MODULE_CLASS := APPS
LOCAL_PRIVILEGED_MODULE := true
LOCAL_MODULE_SUFFIX := \$(COMMON_ANDROID_PACKAGE_SUFFIX)
include \$(BUILD_PREBUILT)

EOF

echo "    $privmodulename$LINEEND" >> $VENDOR_MAKEFILE
done
echo "" >> $VENDOR_MAKEFILE
echo "endif" >> ../../../$OUTDIR/proprietary/priv-app/Android.mk
fi

LIBS=`cat proprietary-blobs.txt | grep '\-lib' | cut -d'-' -f2 | head -1`

if [ -f ../../../$OUTDIR/proprietary/$LIBS ]; then
(cat << EOF) > ../../../$OUTDIR/proprietary/lib/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$DEVICE_VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

echo "ifeq (\$(TARGET_DEVICE),$DEVICE)" >> ../../../$OUTDIR/proprietary/lib/Android.mk
echo ""  >> ../../../$OUTDIR/proprietary/lib/Android.mk
echo "# Prebuilt libs needed for compilation" >> $VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`cat proprietary-blobs.txt | grep '\-lib' | wc -l`
for LIB in `cat proprietary-blobs.txt | grep '\-lib' | cut -d'/' -f2`;do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    libname=`basename $LIB`
    libmodulename=`echo $libname|sed -e 's/\.so$//gi'`
    (cat << EOF) >> ../../../$OUTDIR/proprietary/lib/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $libmodulename
LOCAL_MODULE_OWNER := $DEVICE_VENDOR
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $libname
LOCAL_MODULE_PATH := \$(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
include \$(BUILD_PREBUILT)

EOF

echo "    $libmodulename$LINEEND" >> $VENDOR_MAKEFILE
done
echo "" >> $VENDOR_MAKEFILE
echo "endif" >> ../../../$OUTDIR/proprietary/lib/Android.mk
fi

VENDORLIBS=`cat proprietary-blobs.txt | grep '\-vendor\/lib' | cut -d'-' -f2 | head -1`

if [ -f ../../../$OUTDIR/proprietary/$VENDORLIBS ]; then
(cat << EOF) > ../../../$OUTDIR/proprietary/vendor/lib/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$DEVICE_VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

echo "ifeq (\$(TARGET_DEVICE),$DEVICE)" >> ../../../$OUTDIR/proprietary/vendor/lib/Android.mk
echo ""  >> ../../../$OUTDIR/proprietary/vendor/lib/Android.mk
echo "# Prebuilt vendor/libs needed for compilation" >> $VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`cat proprietary-blobs.txt | grep '\-vendor\/lib' | wc -l`
for VENDORLIB in `cat proprietary-blobs.txt | grep '\-vendor\/lib' | cut -d'/' -f3`;do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    vendorlibname=`basename $VENDORLIB`
    vendorlibmodulename=`echo $vendorlibname|sed -e 's/\.so$//gi'`
    (cat << EOF) >> ../../../$OUTDIR/proprietary/vendor/lib/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $vendorlibmodulename
LOCAL_MODULE_OWNER := $DEVICE_VENDOR
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $vendorlibname
LOCAL_MODULE_PATH := \$(TARGET_OUT_VENDOR_SHARED_LIBRARIES)
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
include \$(BUILD_PREBUILT)

EOF

echo "    $vendorlibmodulename$LINEEND" >> $VENDOR_MAKEFILE
done
echo "endif" >> ../../../$OUTDIR/proprietary/vendor/lib/Android.mk
fi

