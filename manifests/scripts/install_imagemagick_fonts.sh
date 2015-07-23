#! /bin/bash

FONT_DIRS="/System/Library/Fonts /Library/Fonts"

TYPE_GEN="/opt/boxen/repo/manifests/scripts/type_gen"

IMAGE_MAGICK_VERSION="6.9.1-9"
IMAGE_MAGICK_HOME="/opt/boxen/homebrew/Cellar/imagemagick/$IMAGE_MAGICK_VERSION"
IM_CONFIG="$IMAGE_MAGICK_HOME/etc/ImageMagick-6"
IM_SYSTEM_TYPE_XML="$IM_CONFIG/type.xml"
IM_LOCAL_TYPE_XML="$IM_CONFIG/local-type.xml"

find $FONT_DIRS -name "*.[to]tf" | "$TYPE_GEN" -f - > "$IM_LOCAL_TYPE_XML"

sed -i bak '\#</typemap>#i \
   <include file="type.xml"/>\
' "$IM_SYSTEM_TYPE_XML"
