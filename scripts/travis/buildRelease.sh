#!/bin/sh

xctool -workspace SmartTravel.xcworkspace -scheme SmartTravel -sdk iphoneos -configuration Release OBJROOT=$PWD/build SYMROOT=$PWD/build ONLY_ACTIVE_ARCH=NO clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
