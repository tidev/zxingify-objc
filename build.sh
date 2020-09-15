#!/bin/bash

CONFIG="Release"
LIB="ZXingObjC-iOS"
FINALNAME="zxing"
SCHEME="iOS Framework"

BUILD_DIR=build
UNIVERSAL_OUTPUTFOLDER=$BUILD_DIR/${FINALNAME}-universal

mkdir -p "$UNIVERSAL_OUTPUTFOLDER"


if (( $# > 0 )); then
	CONFIG=$1
fi

if [ "$CONFIG" = "Debug" ]; then
	defines=("${defines[@]}" "DEBUG=1")
fi

if [ -d build ]; then
	rm -rf build
fi

# clean the project
xcodebuild clean \
-sdk iphonesimulator \
-configuration $CONFIG \
-scheme "$SCHEME"

xcodebuild clean \
-sdk iphoneos \
-configuration $CONFIG \
-scheme "$SCHEME"

xcodebuild clean \
-sdk macosx \
-configuration $CONFIG \
-scheme "$SCHEME"

buildArchive() {
	ARCHIVE_PATH=$BUILD_DIR/$1.xcarchive
	xcodebuild archive \
	-sdk $1 \
	-scheme "$SCHEME" \
	-archivePath $ARCHIVE_PATH \
	SKIP_INSTALL=NO \
	BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
	$2
}

buildArchive iphonesimulator
buildArchive iphoneos
buildArchive macosx SUPPORTS_MACCATALYST=YES

#----- Make XCFramework
xcodebuild -create-xcframework \
-framework $BUILD_DIR/iphonesimulator.xcarchive/Products/Library/Frameworks/ZXingObjC.framework \
-framework $BUILD_DIR/iphoneos.xcarchive/Products/Library/Frameworks/ZXingObjC.framework \
-framework $BUILD_DIR/macosx.xcarchive/Products/Library/Frameworks/ZXingObjC.framework \
-output $UNIVERSAL_OUTPUTFOLDER/ZXingObjC.xcframework
