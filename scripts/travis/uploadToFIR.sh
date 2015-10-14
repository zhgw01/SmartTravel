#!/bin/sh

IPA_FILE="$PWD/build/Debug-iphoneos/$APP_NAME.ipa"
FIR_TYPE="ios"
FIR_BUNDLE_ID="com.gongwei.SmartTravel"
FIR_API_TOKEN="6e37372f891d37f34134490192bef5cb"

gem install fir-cli --no-ri --no-rdoc

if [ -f $IPA_FILE ]
then
   echo "start to upload ipa file: $IPA_FILE"
   fir p $IPA_FILE -T $FIR_API_TOKEN
   #curl -X POST -F api_token=$FIR_API_TOKEN -F type=FIR_TYPE -F bundle_id=FIR_BUNDLE_ID http://api.fir.im/apps/553c6395d65ce362650000e9/releases
else
   echo "$IPA_FILE doesn't exist"
fi
