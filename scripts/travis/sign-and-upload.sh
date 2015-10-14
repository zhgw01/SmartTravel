#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"
OUTPUTDIR="$PWD/build/Release-iphoneos"
DEBUG_OUTPUTDIR="$PWD/build/Debug-iphoneos"

if [ ! -d "$OUTPUTDIR/$APP_NAME.app" ]; then
   echo "cannot find app"
   exit 0
fi

xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/$APP_NAME.app" -o "$OUTPUTDIR/$APP_NAME.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"
xcrun -log -sdk iphoneos PackageApplication "$DEBUG_OUTPUTDIR/$APP_NAME.app" -o "$DEBUG_OUTPUTDIR/$APP_NAME.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"
