#!/bin/sh

IPA_FILE="$PWD/build/Debug-iphoneos/$APP_NAME.ipa"
PGY_UKEY="d53cbab4252ad5baeb6deb540a6fa9fd"
PGY_APIKEY="18c5a1fa54f90beb4682c1820583549f"

if [ -f $IPA_FILE ]
then
   echo "start to upload ipa file: $IPA_FILE"
   curl -F "file=@$IPA_FILE" -F "uKey=$PGY_UKEY" -F "_api_key=$PGY_APIKEY" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload
else
   echo "$IPA_FILE doesn't exist"
fi
